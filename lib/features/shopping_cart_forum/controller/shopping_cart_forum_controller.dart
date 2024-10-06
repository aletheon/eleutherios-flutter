import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/repository/shopping_cart_forum_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/controller/shopping_cart_member_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/controller/shopping_cart_user_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/repository/shopping_cart_user_repository.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_user.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartForumByIdProvider =
    Provider.family.autoDispose((ref, String shoppingCartForumId) {
  final shoppingCartForumRepository =
      ref.watch(shoppingCartForumRepositoryProvider);
  return shoppingCartForumRepository
      .getShoppingCartForumById(shoppingCartForumId);
});

final getShoppingCartForumByUserIdProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(shoppingCartForumControllerProvider.notifier)
        .getShoppingCartForumByUserId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartForumByUserIdProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(shoppingCartForumControllerProvider.notifier)
        .getShoppingCartForumByUserId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final shoppingCartForumsProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(shoppingCartForumControllerProvider.notifier)
      .getShoppingCartForums(uid);
});

final shoppingCartForumControllerProvider =
    StateNotifierProvider<ShoppingCartForumController, bool>((ref) {
  final shoppingCartForumRepository =
      ref.watch(shoppingCartForumRepositoryProvider);
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  return ShoppingCartForumController(
    shoppingCartForumRepository: shoppingCartForumRepository,
    shoppingCartUserRepository: shoppingCartUserRepository,
    ref: ref,
  );
});

class ShoppingCartForumController extends StateNotifier<bool> {
  final ShoppingCartForumRepository _shoppingCartForumRepository;
  final ShoppingCartUserRepository _shoppingCartUserRepository;
  final Ref _ref;
  ShoppingCartForumController(
      {required ShoppingCartForumRepository shoppingCartForumRepository,
      required ShoppingCartUserRepository shoppingCartUserRepository,
      required Ref ref})
      : _shoppingCartForumRepository = shoppingCartForumRepository,
        _shoppingCartUserRepository = shoppingCartUserRepository,
        _ref = ref,
        super(false);

  void createShoppingCartForum(String shoppingCartUserId, String uid,
      String cartUid, String forumId) async {
    state = true;
    String shoppingCartForumId = const Uuid().v1().replaceAll('-', '');

    ShoppingCartForum shoppingCartForum = ShoppingCartForum(
      shoppingCartForumId: shoppingCartForumId,
      shoppingCartUserId: shoppingCartUserId,
      uid: uid,
      cartUid: cartUid,
      forumId: forumId,
      members: [],
      services: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _shoppingCartForumRepository
        .createShoppingCartForum(shoppingCartForum);
    state = false;
  }

  void updateShoppingCartForum(
      {required ShoppingCartForum shoppingCartForum,
      required BuildContext context}) async {
    state = true;
    final shoppingCartForumRes = await _shoppingCartForumRepository
        .updateShoppingCartForum(shoppingCartForum);
    state = false;
    shoppingCartForumRes.fold((l) => showSnackBar(context, l.message, true),
        (r) {
      showSnackBar(context, 'Shopping cart forum updated successfully!', false);
    });
  }

  void deleteShoppingCartForum(String shoppingCartUserId,
      String shoppingCartForumId, BuildContext context) async {
    state = true;

    // get shopping cart user
    ShoppingCartUser? shoppingCartUser = await _ref
        .read(shoppingCartUserControllerProvider.notifier)
        .getShoppingCartUserById(shoppingCartUserId)
        .first;

    // get shopping cart forum
    final shoppingCartForum = await _ref
        .watch(shoppingCartForumControllerProvider.notifier)
        .getShoppingCartForumById(shoppingCartForumId)
        .first;

    if (shoppingCartUser != null && shoppingCartForum != null) {
      // delete shopping cart forum
      final res = await _shoppingCartForumRepository
          .deleteShoppingCartForum(shoppingCartForumId);

      // update shopping cart user
      shoppingCartUser.forums.remove(shoppingCartForum.forumId);

      if (shoppingCartUser.forums.isEmpty) {
        // remove shopping cart user
        await _shoppingCartUserRepository
            .deleteShoppingCartUser(shoppingCartUser.shoppingCartUserId);
      } else {
        // update shopping cart user
        await _shoppingCartUserRepository
            .updateShoppingCartUser(shoppingCartUser);
      }

      // remove shopping cart members from shopping cart forum
      if (shoppingCartForum.members.isNotEmpty) {
        await _ref
            .read(shoppingCartMemberControllerProvider.notifier)
            .deleteShoppingCartMembersByShoppingCartForumId(
                shoppingCartForumId);
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
        showSnackBar(context,
            'Shopping cart user or shopping cart forum does not exist', true);
      }
    }
  }

  Future<void> deleteShoppingCartForumsByShoppingCartUserId(
      String shoppingCartUserId) {
    return _shoppingCartForumRepository
        .deleteShoppingCartForumsByShoppingCartUserId(shoppingCartUserId);
  }

  Stream<List<ShoppingCartForum>> getShoppingCartForums(String uid) {
    return _shoppingCartForumRepository.getShoppingCartForums(uid);
  }

  Stream<ShoppingCartForum?> getShoppingCartForumById(
      String shoppingCartForumId) {
    return _shoppingCartForumRepository
        .getShoppingCartForumById(shoppingCartForumId);
  }

  Stream<ShoppingCartForum?> getShoppingCartForumByUserId(
      String uid, String forumId) {
    return _shoppingCartForumRepository.getShoppingCartForumByUserId(
        uid, forumId);
  }

  Stream<ShoppingCartForum?> getShoppingCartForumByForumMemberId(
      String forumId, String memberId) {
    return _shoppingCartForumRepository.getShoppingCartForumByForumMemberId(
        forumId, memberId);
  }
}
