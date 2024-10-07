import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/controller/shopping_cart_forum_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/repository/shopping_cart_forum_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/repository/shopping_cart_member_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/controller/shopping_cart_user_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/repository/shopping_cart_user_repository.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_member.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartMemberByIdProvider =
    Provider.family.autoDispose((ref, String shoppingCartMemberId) {
  final shoppingCartMemberRepository =
      ref.watch(shoppingCartMemberRepositoryProvider);
  return shoppingCartMemberRepository
      .getShoppingCartMemberById(shoppingCartMemberId);
});

final getShoppingCartMemberByMemberIdProvider =
    StreamProvider.family.autoDispose((ref, String memberId) {
  try {
    return ref
        .watch(shoppingCartMemberControllerProvider.notifier)
        .getShoppingCartMemberByMemberId(memberId);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartMemberByMemberIdProvider2 =
    Provider.family.autoDispose((ref, String memberId) {
  try {
    return ref
        .watch(shoppingCartMemberControllerProvider.notifier)
        .getShoppingCartMemberByMemberId(memberId);
  } catch (e) {
    rethrow;
  }
});

final shoppingCartMembersProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(shoppingCartMemberControllerProvider.notifier)
      .getShoppingCartMembers(params.item1, params.item2);
});

final shoppingCartMemberControllerProvider =
    StateNotifierProvider<ShoppingCartMemberController, bool>((ref) {
  final shoppingCartMemberRepository =
      ref.watch(shoppingCartMemberRepositoryProvider);
  final shoppingCartForumRepository =
      ref.watch(shoppingCartForumRepositoryProvider);
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  return ShoppingCartMemberController(
    shoppingCartMemberRepository: shoppingCartMemberRepository,
    shoppingCartForumRepository: shoppingCartForumRepository,
    shoppingCartUserRepository: shoppingCartUserRepository,
    ref: ref,
  );
});

class ShoppingCartMemberController extends StateNotifier<bool> {
  final ShoppingCartMemberRepository _shoppingCartMemberRepository;
  final ShoppingCartForumRepository _shoppingCartForumRepository;
  final ShoppingCartUserRepository _shoppingCartUserRepository;
  final Ref _ref;
  ShoppingCartMemberController(
      {required ShoppingCartMemberRepository shoppingCartMemberRepository,
      required ShoppingCartForumRepository shoppingCartForumRepository,
      required ShoppingCartUserRepository shoppingCartUserRepository,
      required Ref ref})
      : _shoppingCartMemberRepository = shoppingCartMemberRepository,
        _shoppingCartForumRepository = shoppingCartForumRepository,
        _shoppingCartUserRepository = shoppingCartUserRepository,
        _ref = ref,
        super(false);

  void createShoppingCartMember(
      String shoppingCartForumId, String memberId) async {
    state = true;
    int shoppingCartMemberCount = 0;

    // get member
    final member = await _ref
        .read(memberControllerProvider.notifier)
        .getMemberById(memberId)
        .first;

    // get this users shopping cart member count
    if (member != null) {
      shoppingCartMemberCount = await _ref
          .read(shoppingCartMemberControllerProvider.notifier)
          .getShoppingCartMemberCount(member.forumId, member.serviceUid)
          .first;
    }
    String shoppingCartMemberId = const Uuid().v1().replaceAll('-', '');

    ShoppingCartMember shoppingCartMember = ShoppingCartMember(
      shoppingCartMemberId: shoppingCartMemberId,
      shoppingCartForumId: shoppingCartForumId,
      memberId: memberId,
      forumId: member != null ? member.forumId : '',
      serviceId: member != null ? member.serviceId : '',
      serviceUid: member != null ? member.serviceUid : '',
      selected: shoppingCartMemberCount == 0 ? true : false,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );

    final res = await _shoppingCartMemberRepository
        .createShoppingCartMember(shoppingCartMember);
    state = false;
  }

  void updateShoppingCartMember(
      {required ShoppingCartMember shoppingCartMember,
      required BuildContext context}) async {
    state = true;
    final shoppingCartMemberRes = await _shoppingCartMemberRepository
        .updateShoppingCartMember(shoppingCartMember);
    state = false;
    shoppingCartMemberRes.fold((l) => showSnackBar(context, l.message, true),
        (r) {
      showSnackBar(
          context, 'Shopping cart member updated successfully!', false);
    });
  }

  void changedSelected(String forumId, String shoppingCartMemberId) async {
    // get selected shopping cart member
    ShoppingCartMember? selectedShoppingCartMember = await _ref
        .read(shoppingCartMemberControllerProvider.notifier)
        .getSelectedShoppingCartMember(forumId)
        .first;

    if (selectedShoppingCartMember != null) {
      selectedShoppingCartMember =
          selectedShoppingCartMember.copyWith(selected: false);
      await _shoppingCartMemberRepository
          .updateShoppingCartMember(selectedShoppingCartMember);

      // update new shopping cart member
      ShoppingCartMember? shoppingCartMember = await _ref
          .read(shoppingCartMemberControllerProvider.notifier)
          .getShoppingCartMemberByMemberId(shoppingCartMemberId)
          .first;

      if (shoppingCartMember != null) {
        shoppingCartMember = shoppingCartMember.copyWith(selected: true);
        await _shoppingCartMemberRepository
            .updateShoppingCartMember(shoppingCartMember);
      }
    }
  }

  void deleteShoppingCartMember(String shoppingCartForumId,
      String shoppingCartMemberId, BuildContext context) async {
    state = true;

    // get shopping cart forum
    ShoppingCartForum? shoppingCartForum = await _ref
        .watch(shoppingCartForumControllerProvider.notifier)
        .getShoppingCartForumById(shoppingCartForumId)
        .first;

    // get shopping cart member
    final shoppingCartMember = await _ref
        .read(shoppingCartMemberControllerProvider.notifier)
        .getShoppingCartMemberById(shoppingCartMemberId)
        .first;

    if (shoppingCartForum != null && shoppingCartMember != null) {
      // delete shopping cart member
      final res = await _shoppingCartMemberRepository
          .deleteShoppingCartMember(shoppingCartMemberId);

      // update shopping cart forum
      shoppingCartForum.members.remove(shoppingCartMember.memberId);
      shoppingCartForum.services.remove(shoppingCartMember.serviceId);
      await _shoppingCartForumRepository
          .updateShoppingCartForum(shoppingCartForum);

      // get this users member count
      final shoppingCartMemberCount = await _ref
          .read(shoppingCartMemberControllerProvider.notifier)
          .getShoppingCartMemberCount(
              shoppingCartForumId, shoppingCartMember.serviceUid)
          .first;

      if (shoppingCartMemberCount > 0) {
        // set next available shopping cart member as default
        if (shoppingCartMember.selected == true) {
          // get the rest of the users shopping cart members
          final userShoppingCartMembers = await _ref
              .read(shoppingCartMemberControllerProvider.notifier)
              .getShoppingCartMembers(
                  shoppingCartMember.forumId, shoppingCartMember.serviceUid)
              .first;

          if (userShoppingCartMembers.isNotEmpty) {
            userShoppingCartMembers[0] =
                userShoppingCartMembers[0].copyWith(selected: true);
            await _shoppingCartMemberRepository
                .updateShoppingCartMember(userShoppingCartMembers[0]);
          }
        }
      } else {
        // delete shopping cart forum
        await _shoppingCartForumRepository
            .deleteShoppingCartForum(shoppingCartForum.shoppingCartForumId);

        // get shopping cart user
        final shoppingCartUser = await _ref
            .read(shoppingCartUserControllerProvider.notifier)
            .getShoppingCartUserById(shoppingCartForum.shoppingCartUserId)
            .first;

        if (shoppingCartUser != null) {
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
        }
      }
      state = false;
      res.fold((l) => showSnackBar(context, l.message, true), (r) {
        if (context.mounted) {
          showSnackBar(
              context, 'Shopping cart member deleted successfully!', false);
        }
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context,
            'Shopping cart forum or shopping cart member does not exist', true);
      }
    }
  }

  Future<void> deleteShoppingCartMembersByShoppingCartForumId(
      String shoppingCartForumId) {
    return _shoppingCartMemberRepository
        .deleteShoppingCartMembersByShoppingCartForumId(shoppingCartForumId);
  }

  Stream<List<ShoppingCartMember>> getShoppingCartMembers(
      String forumId, String uid) {
    return _shoppingCartMemberRepository.getShoppingCartMembers(forumId, uid);
  }

  Stream<ShoppingCartMember?> getShoppingCartMemberById(
      String shoppingCartMemberId) {
    return _shoppingCartMemberRepository
        .getShoppingCartMemberById(shoppingCartMemberId);
  }

  Stream<ShoppingCartMember?> getSelectedShoppingCartMember(String forumId) {
    return _shoppingCartMemberRepository.getSelectedShoppingCartMember(forumId);
  }

  Stream<int> getShoppingCartMemberCount(String forumId, String uid) {
    return _shoppingCartMemberRepository.getShoppingCartMemberCount(
        forumId, uid);
  }

  Stream<ShoppingCartMember?> getShoppingCartMemberByMemberId(String memberId) {
    return _shoppingCartMemberRepository
        .getShoppingCartMemberByMemberId(memberId);
  }
}
