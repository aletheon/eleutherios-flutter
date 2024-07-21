import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/controller/shopping_cart_forum_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/controller/shopping_cart_member_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/repository/shopping_cart_user_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_user.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartUserByIdProvider =
    Provider.family.autoDispose((ref, String shoppingCartUserId) {
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  return shoppingCartUserRepository.getShoppingCartUserById(shoppingCartUserId);
});

final shoppingCartUsersProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(shoppingCartUserControllerProvider.notifier)
      .getShoppingCartUsers();
});

final shoppingCartUserControllerProvider =
    StateNotifierProvider<ShoppingCartUserController, bool>((ref) {
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return ShoppingCartUserController(
      shoppingCartUserRepository: shoppingCartUserRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class ShoppingCartUserController extends StateNotifier<bool> {
  final ShoppingCartUserRepository _shoppingCartUserRepository;
  final Ref _ref;
  ShoppingCartUserController(
      {required ShoppingCartUserRepository shoppingCartUserRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _shoppingCartUserRepository = shoppingCartUserRepository,
        _ref = ref,
        super(false);

  void createShoppingCartUser(String uid, String cartUid) async {
    state = true;
    String shoppingCartUserId = const Uuid().v1().replaceAll('-', '');

    ShoppingCartUser shoppingCartUser = ShoppingCartUser(
      shoppingCartUserId: shoppingCartUserId,
      uid: uid,
      cartUid: cartUid,
      forums: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _shoppingCartUserRepository
        .createShoppingCartUser(shoppingCartUser);
    state = false;
  }

  void updateShoppingCartUser(
      {required ShoppingCartUser shoppingCartUser,
      required BuildContext context}) async {
    state = true;
    final shoppingCartUserRes = await _shoppingCartUserRepository
        .updateShoppingCartUser(shoppingCartUser);
    state = false;
    shoppingCartUserRes.fold((l) => showSnackBar(context, l.message, true),
        (r) {
      showSnackBar(context, 'Shopping cart user updated successfully!', false);
    });
  }

  void deleteShoppingCartUser(
      String shoppingCartUserId, BuildContext context) async {
    state = true;

    // get shopping cart user
    ShoppingCartUser? shoppingCartUser = await _ref
        .read(shoppingCartUserControllerProvider.notifier)
        .getShoppingCartUserById(shoppingCartUserId)
        .first;

    if (shoppingCartUser != null) {
      // delete user
      final res = await _shoppingCartUserRepository
          .deleteShoppingCartUser(shoppingCartUserId);

      // remove shopping cart members from shopping cart forum
      if (shoppingCartUser.forums.isNotEmpty) {
        // get shopping cart forums by userId
        final shoppingCartForums = await _ref
            .read(shoppingCartForumControllerProvider.notifier)
            .getShoppingCartForums(shoppingCartUser.shoppingCartUserId)
            .first;

        if (shoppingCartForums.isNotEmpty) {
          for (ShoppingCartForum shoppingCartForum in shoppingCartForums) {
            // delete shopping cart members
            if (shoppingCartForum.members.isNotEmpty) {
              await _ref
                  .read(shoppingCartMemberControllerProvider.notifier)
                  .deleteShoppingCartMembersByShoppingCartForumId(
                      shoppingCartForum.shoppingCartForumId);
            }
          }
          // delete shopping cart forums
          await _ref
              .read(shoppingCartForumControllerProvider.notifier)
              .deleteShoppingCartForumsByShoppingCartUserId(
                  shoppingCartUser.shoppingCartUserId);
        }
      }
      state = false;
      res.fold((l) => showSnackBar(context, l.message, true), (r) {
        if (context.mounted) {
          showSnackBar(
              context, 'Shopping cart forum deleted successfully!', false);
        }
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Shopping cart user does not exist', true);
      }
    }
  }

  Stream<ShoppingCartUser?> getShoppingCartUserById(String shoppingCartUserId) {
    return _shoppingCartUserRepository
        .getShoppingCartUserById(shoppingCartUserId);
  }

  Stream<ShoppingCartUser?> getShoppingCartUserByUserId(String uid) {
    return _shoppingCartUserRepository.getShoppingCartUserByUserId(uid);
  }

  Stream<List<ShoppingCartUser>> getShoppingCartUsers() {
    return _shoppingCartUserRepository.getShoppingCartUsers();
  }
}
