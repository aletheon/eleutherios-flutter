import 'package:flutter/material.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/controller/shopping_cart_forum_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/repository/shopping_cart_forum_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/repository/shopping_cart_member_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  return ShoppingCartMemberController(
    shoppingCartMemberRepository: shoppingCartMemberRepository,
    shoppingCartForumRepository: shoppingCartForumRepository,
    ref: ref,
  );
});

class ShoppingCartMemberController extends StateNotifier<bool> {
  final ShoppingCartMemberRepository _shoppingCartMemberRepository;
  final ShoppingCartForumRepository _shoppingCartForumRepository;
  final Ref _ref;
  ShoppingCartMemberController(
      {required ShoppingCartMemberRepository shoppingCartMemberRepository,
      required ShoppingCartForumRepository shoppingCartForumRepository,
      required Ref ref})
      : _shoppingCartMemberRepository = shoppingCartMemberRepository,
        _shoppingCartForumRepository = shoppingCartForumRepository,
        _ref = ref,
        super(false);

  void createShoppingCartMember(
      String shoppingCartForumId, String memberId) async {
    state = true;

    // get member
    final member = await _ref
        .read(memberControllerProvider.notifier)
        .getMemberById(memberId)
        .first;

    String shoppingCartMemberId = const Uuid().v1().replaceAll('-', '');

    ShoppingCartMember shoppingCartMember = ShoppingCartMember(
      shoppingCartMemberId: shoppingCartMemberId,
      shoppingCartForumId: shoppingCartForumId,
      memberId: memberId,
      serviceId: member != null ? member.serviceId : '',
      serviceUid: member != null ? member.serviceUid : '',
      selected: false,
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

  void changedSelected(String shoppingCartMemberId) async {
    // get member
    ShoppingCartMember? shoppingCartMember = await _ref
        .read(shoppingCartMemberControllerProvider.notifier)
        .getShoppingCartMemberById(shoppingCartMemberId)
        .first;

    // get old rule member and unselect it
    ShoppingCartMember? selectedShoppingCartMember = await _ref
        .read(shoppingCartMemberControllerProvider.notifier)
        .getSelectedShoppingCartMember(shoppingCartMember!.shoppingCartForumId,
            shoppingCartMember.serviceUid)
        .first;

    selectedShoppingCartMember =
        selectedShoppingCartMember!.copyWith(selected: false);
    await _shoppingCartMemberRepository
        .updateShoppingCartMember(selectedShoppingCartMember);

    shoppingCartMember = shoppingCartMember.copyWith(selected: true);
    await _shoppingCartMemberRepository
        .updateShoppingCartMember(shoppingCartMember);
  }

  void deleteShoppingCartMember(String shoppingCartMemberId,
      String shoppingCartForumId, BuildContext context) async {
    state = true;

    // get shopping cart member
    ShoppingCartMember? shoppingCartMember = await _ref
        .read(shoppingCartMemberControllerProvider.notifier)
        .getShoppingCartMemberById(shoppingCartMemberId)
        .first;

    // get shopping cart forum
    final shoppingCartForum = await _ref
        .watch(shoppingCartForumControllerProvider.notifier)
        .getShoppingCartForumById(shoppingCartForumId)
        .first;

    if (shoppingCartForum != null && shoppingCartMember != null) {
      // delete member
      final res = await _shoppingCartMemberRepository
          .deleteShoppingCartMember(shoppingCartMemberId);

      // get user
      final shoppingCartMemberUser = await _ref
          .read(authControllerProvider.notifier)
          .getUserData(shoppingCartMember.serviceUid)
          .first;

      // update shopping cart forum
      shoppingCartForum.members.remove(shoppingCartMemberId);
      shoppingCartForum.services.remove(shoppingCartMember.serviceId);
      await _shoppingCartForumRepository
          .updateShoppingCartForum(shoppingCartForum);

      // get this users member count
      final shoppingCartMemberCount = await _ref
          .read(shoppingCartMemberControllerProvider.notifier)
          .getShoppingCartMemberCount(
              shoppingCartForumId, shoppingCartMemberUser!.uid)
          .first;

      if (shoppingCartMemberCount > 0) {
        // set next available rule member as default
        if (shoppingCartMember.selected) {
          // get the rest of the users shopping cart members
          final userShoppingCartMembers = await _ref
              .read(shoppingCartMemberControllerProvider.notifier)
              .getShoppingCartMembers(
                  shoppingCartForumId, shoppingCartMemberUser.uid)
              .first;

          userShoppingCartMembers[0] =
              userShoppingCartMembers[0].copyWith(selected: true);
          await _shoppingCartMemberRepository
              .updateShoppingCartMember(userShoppingCartMembers[0]);
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
      String shoppingCartForumId, String uid) {
    return _shoppingCartMemberRepository.getShoppingCartMembers(
        shoppingCartForumId, uid);
  }

  Stream<ShoppingCartMember?> getShoppingCartMemberById(
      String shoppingCartMemberId) {
    return _shoppingCartMemberRepository
        .getShoppingCartMemberById(shoppingCartMemberId);
  }

  Stream<int> getShoppingCartMemberCount(
      String shoppingCartForumId, String uid) {
    return _shoppingCartMemberRepository.getShoppingCartMemberCount(
        shoppingCartForumId, uid);
  }

  Stream<ShoppingCartMember?> getSelectedShoppingCartMember(
      String shoppingCartForumId, String uid) {
    return _shoppingCartMemberRepository.getSelectedShoppingCartMember(
        shoppingCartForumId, uid);
  }
}
