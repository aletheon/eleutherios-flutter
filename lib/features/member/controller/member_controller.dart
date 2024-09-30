import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/forum_activity/controller/forum_activity_controller.dart';
import 'package:reddit_tutorial/features/forum_activity/repository/forum_activity_repository.dart';
import 'package:reddit_tutorial/features/member/repository/member_repository.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/controller/shopping_cart_forum_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/repository/shopping_cart_forum_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/controller/shopping_cart_member_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/repository/shopping_cart_member_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/controller/shopping_cart_user_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_user/repository/shopping_cart_user_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_member.dart';
import 'package:reddit_tutorial/models/shopping_cart_user.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getMemberByIdProvider =
    StreamProvider.family.autoDispose((ref, String memberId) {
  return ref.watch(memberControllerProvider.notifier).getMemberById(memberId);
});

final getMemberByServiceIdProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(memberControllerProvider.notifier)
        .getMemberByServiceId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getMemberByServiceIdProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(memberControllerProvider.notifier)
        .getMemberByServiceId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final serviceIsRegisteredInForumProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .serviceIsRegisteredInForum(params.item1, params.item2);
});

final serviceIsRegisteredInForumProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(memberControllerProvider.notifier)
        .serviceIsRegisteredInForum(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getMembersProvider =
    StreamProvider.family.autoDispose((ref, String forumId) {
  return ref.watch(memberControllerProvider.notifier).getMembers(forumId);
});

final getMembersProvider2 = Provider.family.autoDispose((ref, String forumId) {
  return ref.watch(memberControllerProvider.notifier).getMembers(forumId);
});

final getUserMembersProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getUserMembers(params.item1, params.item2);
});

final getUserMembersProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getUserMembers(params.item1, params.item2);
});

final getMembersByServiceIdProvider =
    StreamProvider.family.autoDispose((ref, String stringId) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getMembersByServiceId(stringId);
});

final getMembersByServiceIdProvider2 =
    Provider.family.autoDispose((ref, String stringId) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getMembersByServiceId(stringId);
});

final getUserMemberCountProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getUserMemberCount(params.item1, params.item2);
});

final getUserSelectedMemberProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(memberControllerProvider.notifier)
        .getUserSelectedMember(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getUserSelectedMemberProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(memberControllerProvider.notifier)
        .getUserSelectedMember(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final memberControllerProvider =
    StateNotifierProvider<MemberController, bool>((ref) {
  final memberRepository = ref.watch(memberRepositoryProvider);
  final forumRepository = ref.watch(forumRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final forumActivityRepository = ref.watch(forumActivityRepositoryProvider);
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  final shoppingCartForumRepository =
      ref.watch(shoppingCartForumRepositoryProvider);
  final shoppingCartMemberRepository =
      ref.watch(shoppingCartMemberRepositoryProvider);

  return MemberController(
      memberRepository: memberRepository,
      forumRepository: forumRepository,
      userProfileRepository: userProfileRepository,
      forumActivityRepository: forumActivityRepository,
      shoppingCartUserRepository: shoppingCartUserRepository,
      shoppingCartForumRepository: shoppingCartForumRepository,
      shoppingCartMemberRepository: shoppingCartMemberRepository,
      ref: ref);
});

class MemberController extends StateNotifier<bool> {
  final MemberRepository _memberRepository;
  final ForumRepository _forumRepository;
  final UserProfileRepository _userProfileRepository;
  final ForumActivityRepository _forumActivityRepository;
  final ShoppingCartUserRepository _shoppingCartUserRepository;
  final ShoppingCartForumRepository _shoppingCartForumRepository;
  final ShoppingCartMemberRepository _shoppingCartMemberRepository;
  final Ref _ref;
  MemberController(
      {required MemberRepository memberRepository,
      required ForumRepository forumRepository,
      required UserProfileRepository userProfileRepository,
      required ForumActivityRepository forumActivityRepository,
      required ShoppingCartUserRepository shoppingCartUserRepository,
      required ShoppingCartForumRepository shoppingCartForumRepository,
      required ShoppingCartMemberRepository shoppingCartMemberRepository,
      required Ref ref})
      : _forumRepository = forumRepository,
        _memberRepository = memberRepository,
        _userProfileRepository = userProfileRepository,
        _forumActivityRepository = forumActivityRepository,
        _shoppingCartUserRepository = shoppingCartUserRepository,
        _shoppingCartForumRepository = shoppingCartForumRepository,
        _shoppingCartMemberRepository = shoppingCartMemberRepository,
        _ref = ref,
        super(false);

  void createMember(
      String forumId, String serviceId, BuildContext context) async {
    state = true;
    Forum? forum = await _ref
        .read(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (forum != null && service != null) {
      // ensure service is not already a member
      if (forum.services.contains(serviceId) == false) {
        final user = await _ref
            .read(authControllerProvider.notifier)
            .getUserData(service.uid)
            .first;

        final memberCount = await _ref
            .read(memberControllerProvider.notifier)
            .getUserMemberCount(forum.forumId, service.uid)
            .first;

        String memberId = const Uuid().v1().replaceAll('-', '');
        List<String> defaultPermissions = [MemberPermissions.createpost.value];

        if (forum.uid == service.uid) {
          defaultPermissions.add(MemberPermissions.editforum.value);
          defaultPermissions.add(MemberPermissions.addmember.value);
          defaultPermissions.add(MemberPermissions.removemember.value);
          defaultPermissions.add(MemberPermissions.createforum.value);
          defaultPermissions.add(MemberPermissions.removeforum.value);
          defaultPermissions.add(MemberPermissions.removepost.value);
          defaultPermissions.add(MemberPermissions.addtocart.value);
          defaultPermissions.add(MemberPermissions.removefromcart.value);
          defaultPermissions.add(MemberPermissions.editpermissions.value);
        }

        // create member
        Member member = Member(
          memberId: memberId,
          forumId: forumId,
          forumUid: forum.uid,
          serviceId: serviceId,
          serviceUid: service.uid,
          selected: memberCount == 0 ? true : false,
          permissions: defaultPermissions,
          lastUpdateDate: DateTime.now(),
          creationDate: DateTime.now(),
        );
        final res = await _memberRepository.createMember(member);

        // update forum
        forum.members.add(memberId);
        forum.services.add(serviceId);
        await _forumRepository.updateForum(forum);

        // create new forum activity for this member
        if (user!.forumActivities.contains(forumId) == false) {
          final forumActivityController =
              _ref.read(forumActivityControllerProvider.notifier);
          forumActivityController.createForumActivity(
              user.uid, forumId, forum.uid);

          // add activity to users forum activity list
          user.forumActivities.add(forumId);
          await _userProfileRepository.updateUser(user);
        }

        // create member shopping cart references
        if (member.serviceUid != member.forumUid) {
          if (member.permissions.contains(MemberPermissions.addtocart.value) ||
              member.permissions
                  .contains(MemberPermissions.removefromcart.value)) {
            String shoppingCartUserId = const Uuid().v1().replaceAll('-', '');
            String shoppingCartForumId = const Uuid().v1().replaceAll('-', '');
            String shoppingCartMemberId = const Uuid().v1().replaceAll('-', '');

            // create shopping cart user
            ShoppingCartUser newShoppingCartUser = ShoppingCartUser(
              shoppingCartUserId: shoppingCartUserId,
              uid: member.serviceUid,
              cartUid: member.forumUid,
              forums: [member.forumId],
              selectedForumId: member.forumId,
              lastUpdateDate: DateTime.now(),
              creationDate: DateTime.now(),
            );

            // create shopping cart forum
            ShoppingCartForum newShoppingCartForum = ShoppingCartForum(
              shoppingCartForumId: shoppingCartForumId,
              shoppingCartUserId: shoppingCartUserId,
              uid: member.serviceUid,
              cartUid: member.forumUid,
              forumId: member.forumId,
              members: [member.memberId],
              services: [member.serviceId],
              selectedMemberId: member.memberId,
              lastUpdateDate: DateTime.now(),
              creationDate: DateTime.now(),
            );

            // create shopping cart member
            ShoppingCartMember newShoppingCartMember = ShoppingCartMember(
              shoppingCartMemberId: shoppingCartMemberId,
              shoppingCartForumId: shoppingCartForumId,
              forumId: member.forumId,
              memberId: member.memberId,
              serviceId: member.serviceId,
              serviceUid: member.serviceUid,
              lastUpdateDate: DateTime.now(),
              creationDate: DateTime.now(),
            );

            // get service user
            final memberUser = await _ref
                .read(authControllerProvider.notifier)
                .getUserData(member.serviceUid)
                .first;

            // get shopping cart user
            final shoppingCartUser = await _ref
                .read(shoppingCartUserControllerProvider.notifier)
                .getShoppingCartUserByUserId(member.serviceUid, member.forumUid)
                .first;

            // get shopping cart forum
            final shoppingCartForum = await _ref
                .read(shoppingCartForumControllerProvider.notifier)
                .getShoppingCartForumByUserId(member.serviceUid, member.forumId)
                .first;

            // create shopping cart user
            if (shoppingCartUser == null) {
              await _shoppingCartUserRepository
                  .createShoppingCartUser(newShoppingCartUser);

              // add uid to users shopping cart user ids list
              memberUser!.shoppingCartUserIds.add(newShoppingCartUser.cartUid);
              await _userProfileRepository.updateUser(memberUser);
            } else {
              // update shopping cart user
              if (shoppingCartUser.forums.contains(member.forumId) == false) {
                shoppingCartUser.forums.add(member.forumId);
                await _shoppingCartUserRepository
                    .updateShoppingCartUser(shoppingCartUser);
              }
            }

            // create shopping cart forum
            if (shoppingCartForum == null) {
              await _shoppingCartForumRepository
                  .createShoppingCartForum(newShoppingCartForum);
            } else {
              // set shopping cart member - shopping cart forum id to existing id
              newShoppingCartMember = newShoppingCartMember.copyWith(
                  shoppingCartForumId: shoppingCartForum.shoppingCartForumId);

              // update shopping cart forum
              shoppingCartForum.members.add(newShoppingCartMember.memberId);
              shoppingCartForum.services.add(newShoppingCartMember.serviceId);
              await _shoppingCartForumRepository
                  .updateShoppingCartForum(shoppingCartForum);
            }
            // create shopping cart member
            await _shoppingCartMemberRepository
                .createShoppingCartMember(newShoppingCartMember);
          }
        }
        state = false;
        res.fold((l) => showSnackBar(context, l.message, true), (r) {
          showSnackBar(context, 'Member added successfully!', false);
        });
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(
              context, 'Service is already a member of this forum', true);
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Forum or service does not exist', true);
      }
    }
  }

  void updateMember(
      {required Member member, required BuildContext context}) async {
    state = true;

    // get service user
    final memberUser = await _ref
        .read(authControllerProvider.notifier)
        .getUserData(member.serviceUid)
        .first;

    // get shopping cart user
    final shoppingCartUser = await _ref
        .read(shoppingCartUserControllerProvider.notifier)
        .getShoppingCartUserByUserId(member.serviceUid, member.forumUid)
        .first;

    // get shopping cart forum
    ShoppingCartForum? shoppingCartForum = await _ref
        .read(shoppingCartForumControllerProvider.notifier)
        .getShoppingCartForumByUserId(member.serviceUid, member.forumId)
        .first;

    // get shopping cart member
    final shoppingCartMember = await _ref
        .read(shoppingCartMemberControllerProvider.notifier)
        .getShoppingCartMemberByMemberId(member.memberId)
        .first;

    String shoppingCartUserId = const Uuid().v1().replaceAll('-', '');
    String shoppingCartForumId = const Uuid().v1().replaceAll('-', '');
    String shoppingCartMemberId = const Uuid().v1().replaceAll('-', '');

    // create shopping cart user
    ShoppingCartUser newShoppingCartUser = ShoppingCartUser(
      shoppingCartUserId: shoppingCartUserId,
      uid: member.serviceUid,
      cartUid: member.forumUid,
      forums: [member.forumId],
      selectedForumId: member.forumId,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );

    // create shopping cart forum
    ShoppingCartForum newShoppingCartForum = ShoppingCartForum(
      shoppingCartForumId: shoppingCartForumId,
      shoppingCartUserId: shoppingCartUserId,
      uid: member.serviceUid,
      cartUid: member.forumUid,
      forumId: member.forumId,
      members: [member.memberId],
      services: [member.serviceId],
      selectedMemberId: member.memberId,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );

    // create shopping cart member
    ShoppingCartMember newShoppingCartMember = ShoppingCartMember(
      shoppingCartMemberId: shoppingCartMemberId,
      shoppingCartForumId: shoppingCartForumId,
      forumId: member.forumId,
      memberId: member.memberId,
      serviceId: member.serviceId,
      serviceUid: member.serviceUid,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );

    // update any shopping cart references
    if (member.serviceUid != member.forumUid) {
      if (member.permissions.contains(MemberPermissions.addtocart.value) ||
          member.permissions.contains(MemberPermissions.removefromcart.value)) {
        if (shoppingCartMember == null) {
          // create shopping cart user
          if (shoppingCartUser == null) {
            await _shoppingCartUserRepository
                .createShoppingCartUser(newShoppingCartUser);

            // add uid to users shopping cart user ids list
            memberUser!.shoppingCartUserIds.add(newShoppingCartUser.cartUid);
            await _userProfileRepository.updateUser(memberUser);
          } else {
            // update shopping cart user
            if (shoppingCartUser.forums.contains(member.forumId) == false) {
              shoppingCartUser.forums.add(member.forumId);
              await _shoppingCartUserRepository
                  .updateShoppingCartUser(shoppingCartUser);
            }
          }

          // create shopping cart forum
          if (shoppingCartForum == null) {
            await _shoppingCartForumRepository
                .createShoppingCartForum(newShoppingCartForum);
          } else {
            // set shopping cart member - shopping cart forum id to existing id
            newShoppingCartMember = newShoppingCartMember.copyWith(
                shoppingCartForumId: shoppingCartForum.shoppingCartForumId);

            // update shopping cart forum
            shoppingCartForum.members.add(newShoppingCartMember.memberId);
            shoppingCartForum.services.add(newShoppingCartMember.serviceId);
            await _shoppingCartForumRepository
                .updateShoppingCartForum(shoppingCartForum);
          }

          // create shopping cart member
          await _shoppingCartMemberRepository
              .createShoppingCartMember(newShoppingCartMember);
        }
      } else {
        // delete shopping cart member
        if (shoppingCartForum != null && shoppingCartMember != null) {
          await _shoppingCartMemberRepository.deleteShoppingCartMember(
              shoppingCartMember.shoppingCartMemberId);

          // update shopping cart forum
          shoppingCartForum.members.remove(shoppingCartMember.memberId);
          shoppingCartForum.services.remove(shoppingCartMember.serviceId);
          await _shoppingCartForumRepository
              .updateShoppingCartForum(shoppingCartForum);

          // get this users shopping cart member count
          final shoppingCartMemberCount = await _ref
              .read(shoppingCartMemberControllerProvider.notifier)
              .getShoppingCartMemberCount(
                  shoppingCartMember.forumId, shoppingCartMember.serviceUid)
              .first;

          if (shoppingCartMemberCount > 0) {
            // set next available shopping cart member as default
            if (shoppingCartForum.selectedMemberId ==
                shoppingCartMember.memberId) {
              // get the rest of the users shopping cart members
              final userShoppingCartMembers = await _ref
                  .read(shoppingCartMemberControllerProvider.notifier)
                  .getShoppingCartMembers(
                      shoppingCartMember.forumId, shoppingCartMember.serviceUid)
                  .first;

              if (userShoppingCartMembers.isNotEmpty) {
                shoppingCartForum = shoppingCartForum.copyWith(
                    selectedMemberId: userShoppingCartMembers[0].memberId);
                await _shoppingCartForumRepository
                    .updateShoppingCartForum(shoppingCartForum);
              }
            }
          } else {
            // delete shopping cart forum
            await _shoppingCartForumRepository
                .deleteShoppingCartForum(shoppingCartForum.shoppingCartForumId);

            if (shoppingCartUser != null) {
              shoppingCartUser.forums.remove(shoppingCartForum.forumId);

              if (shoppingCartUser.forums.isEmpty) {
                // remove shopping cart user
                await _shoppingCartUserRepository.deleteShoppingCartUser(
                    shoppingCartUser.shoppingCartUserId);

                // add uid to users shopping cart user ids list
                memberUser!.shoppingCartUserIds
                    .remove(shoppingCartUser.cartUid);
                await _userProfileRepository.updateUser(memberUser);
              } else {
                // update shopping cart user
                await _shoppingCartUserRepository
                    .updateShoppingCartUser(shoppingCartUser);
              }
            }
          }
        }
      }
    }
    final memberRes = await _memberRepository.updateMember(member);
    state = false;
    memberRes.fold((l) => showSnackBar(context, l.message, true), (r) {
      showSnackBar(context, 'Member updated successfully!', false);
    });
  }

  void changedSelected(String memberId) async {
    // get member
    Member? member = await _ref
        .read(memberControllerProvider.notifier)
        .getMemberById(memberId)
        .first;

    // get old member and unselect it
    Member? selectedMember = await _ref
        .read(memberControllerProvider.notifier)
        .getUserSelectedMember(member!.forumId, member.serviceUid)
        .first;

    selectedMember = selectedMember!.copyWith(selected: false);
    await _memberRepository.updateMember(selectedMember);

    member = member.copyWith(selected: true);
    await _memberRepository.updateMember(member);
  }

  void deleteMember(
      String forumId, String memberId, BuildContext context) async {
    state = true;

    // get member
    final member = await _ref
        .read(memberControllerProvider.notifier)
        .getMemberById(memberId)
        .first;

    // get forum
    final forum = await _ref
        .watch(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;

    if (forum != null && member != null) {
      // delete member
      final res = await _memberRepository.deleteMember(memberId);

      // get user
      final memberUser = await _ref
          .read(authControllerProvider.notifier)
          .getUserData(member.serviceUid)
          .first;

      // update forum
      forum.members.remove(memberId);
      forum.services.remove(member.serviceId);
      await _forumRepository.updateForum(forum);

      // get this users member count
      final memberCount = await _ref
          .read(memberControllerProvider.notifier)
          .getUserMemberCount(forumId, memberUser!.uid)
          .first;

      // remove forum activity if no user members are left
      if (memberCount == 0) {
        // get forum activity
        final forumActivity = await _ref
            .read(forumActivityControllerProvider.notifier)
            .getUserForumActivityByForumId(forumId, memberUser.uid)
            .first;

        // now remove it
        await _forumActivityRepository
            .deleteForumActivity(forumActivity!.forumActivityId);

        // remove the activity from the users forum activity list
        memberUser.forumActivities.remove(forumId);
        await _userProfileRepository.updateUser(memberUser);
      } else {
        // set next available member as default
        if (member.selected) {
          // get the rest of the users members
          final userMembers = await _ref
              .read(memberControllerProvider.notifier)
              .getUserMembers(forumId, memberUser.uid)
              .first;

          userMembers[0] = userMembers[0].copyWith(selected: true);
          await _memberRepository.updateMember(userMembers[0]);
        }
      }

      // remove member shopping cart references
      if (member.serviceUid != member.forumUid) {
        if (member.permissions.contains(MemberPermissions.addtocart.value) ||
            member.permissions
                .contains(MemberPermissions.removefromcart.value)) {
          // get shopping cart user
          final shoppingCartUser = await _ref
              .read(shoppingCartUserControllerProvider.notifier)
              .getShoppingCartUserByUserId(member.serviceUid, member.forumUid)
              .first;

          // get shopping cart forum
          ShoppingCartForum? shoppingCartForum = await _ref
              .read(shoppingCartForumControllerProvider.notifier)
              .getShoppingCartForumByUserId(member.serviceUid, member.forumId)
              .first;

          // get shopping cart member
          final shoppingCartMember = await _ref
              .read(shoppingCartMemberControllerProvider.notifier)
              .getShoppingCartMemberByMemberId(member.memberId)
              .first;

          // delete shopping cart member
          if (shoppingCartForum != null && shoppingCartMember != null) {
            await _shoppingCartMemberRepository.deleteShoppingCartMember(
                shoppingCartMember.shoppingCartMemberId);

            // update shopping cart forum
            shoppingCartForum.members.remove(shoppingCartMember.memberId);
            shoppingCartForum.services.remove(shoppingCartMember.serviceId);
            await _shoppingCartForumRepository
                .updateShoppingCartForum(shoppingCartForum);

            // get this users shopping cart member count
            final shoppingCartMemberCount = await _ref
                .read(shoppingCartMemberControllerProvider.notifier)
                .getShoppingCartMemberCount(
                    shoppingCartMember.forumId, shoppingCartMember.serviceUid)
                .first;

            if (shoppingCartMemberCount > 0) {
              // set next available shopping cart member as default
              if (shoppingCartForum.selectedMemberId ==
                  shoppingCartMember.memberId) {
                // get the rest of the users shopping cart members
                final userShoppingCartMembers = await _ref
                    .read(shoppingCartMemberControllerProvider.notifier)
                    .getShoppingCartMembers(shoppingCartMember.forumId,
                        shoppingCartMember.serviceUid)
                    .first;

                if (userShoppingCartMembers.isNotEmpty) {
                  shoppingCartForum = shoppingCartForum.copyWith(
                      selectedMemberId: userShoppingCartMembers[0].memberId);
                  await _shoppingCartForumRepository
                      .updateShoppingCartForum(shoppingCartForum);
                }
              }
            } else {
              // delete shopping cart forum
              await _shoppingCartForumRepository.deleteShoppingCartForum(
                  shoppingCartForum.shoppingCartForumId);

              if (shoppingCartUser != null) {
                shoppingCartUser.forums.remove(shoppingCartForum.forumId);

                if (shoppingCartUser.forums.isEmpty) {
                  // remove shopping cart user
                  await _shoppingCartUserRepository.deleteShoppingCartUser(
                      shoppingCartUser.shoppingCartUserId);

                  // add uid to users shopping cart user ids list
                  memberUser.shoppingCartUserIds
                      .remove(shoppingCartUser.cartUid);
                  await _userProfileRepository.updateUser(memberUser);
                } else {
                  // update shopping cart user
                  await _shoppingCartUserRepository
                      .updateShoppingCartUser(shoppingCartUser);
                }
              }
            }
          }
        }
      }
      state = false;
      res.fold((l) => showSnackBar(context, l.message, true), (r) {
        if (context.mounted) {
          showSnackBar(context, 'Member deleted successfully!', false);
        }
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Forum or member does not exist', true);
      }
    }
  }

  Future<int?> getMembersByServiceIdCount(String serviceId) {
    state = true;
    return _memberRepository.getMembersByServiceIdCount(serviceId).then(
      (value) {
        state = false;
        return value;
      },
    );
  }

  Future<int?> getMemberCount(String forumId) {
    state = true;
    return _memberRepository.getMemberCount(forumId).then(
      (value) {
        state = false;
        return value;
      },
    );
  }

  Future<void> deleteMembersByForumId(String forumId) {
    return _memberRepository.deleteMembersByForumId(forumId);
  }

  Stream<List<Member>> getMembers(String forumId) {
    return _memberRepository.getMembers(forumId);
  }

  Stream<List<Member>> getUserMembers(String forumId, String uid) {
    return _memberRepository.getUserMembers(forumId, uid);
  }

  Stream<List<Member>> getMembersByServiceId(String serviceId) {
    return _memberRepository.getMembersByServiceId(serviceId);
  }

  Stream<bool> serviceIsRegisteredInForum(String forumId, String serviceId) {
    return _memberRepository.serviceIsRegisteredInForum(forumId, serviceId);
  }

  Stream<int> getUserMemberCount(String forumId, String uid) {
    return _memberRepository.getUserMemberCount(forumId, uid);
  }

  Stream<Member?> getUserSelectedMember(String forumId, String uid) {
    return _memberRepository.getUserSelectedMember(forumId, uid);
  }

  Stream<Member?> getMemberById(String memberId) {
    return _memberRepository.getMemberById(memberId);
  }

  Stream<Member?> getMemberByServiceId(String forumId, String serviceId) {
    return _memberRepository.getMemberByServiceId(forumId, serviceId);
  }
}
