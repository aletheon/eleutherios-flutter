import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/activity/controller/activity_controller.dart';
import 'package:reddit_tutorial/features/activity/repository/activity_repository.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/member/repository/member_repository.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getMemberByIdProvider =
    StreamProvider.family.autoDispose((ref, String memberId) {
  return ref.watch(memberControllerProvider.notifier).getMemberById(memberId);
});

final serviceIsRegisteredInForumProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .serviceIsRegisteredInForum(params.item1, params.item2);
});

final getMembersProvider =
    StreamProvider.family.autoDispose((ref, String forumId) {
  return ref.watch(memberControllerProvider.notifier).getMembers(forumId);
});

final getUserMembersProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getUserMembers(params.item1, params.item2);
});

final getUserMemberCountProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(memberControllerProvider.notifier)
      .getUserMemberCount(params.item1, params.item2);
});

final getUserSelectedMemberProvider =
    StreamProvider.family((ref, Tuple2 params) {
  try {
    return ref
        .watch(memberControllerProvider.notifier)
        .getUserSelectedMember(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getUserSelectedMemberProvider2 = Provider.family((ref, Tuple2 params) {
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
  final activityRepository = ref.watch(activityRepositoryProvider);
  return MemberController(
      memberRepository: memberRepository,
      forumRepository: forumRepository,
      userProfileRepository: userProfileRepository,
      activityRepository: activityRepository,
      ref: ref);
});

class MemberController extends StateNotifier<bool> {
  final MemberRepository _memberRepository;
  final ForumRepository _forumRepository;
  final UserProfileRepository _userProfileRepository;
  final ActivityRepository _activityRepository;
  final Ref _ref;
  MemberController(
      {required MemberRepository memberRepository,
      required ForumRepository forumRepository,
      required UserProfileRepository userProfileRepository,
      required ActivityRepository activityRepository,
      required Ref ref})
      : _forumRepository = forumRepository,
        _memberRepository = memberRepository,
        _userProfileRepository = userProfileRepository,
        _activityRepository = activityRepository,
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
      if (forum.members.contains(serviceId) == false) {
        final user = await _ref.read(getUserByIdProvider(service.uid)).first;
        final memberCount = await _ref
            .read(memberControllerProvider.notifier)
            .getUserMemberCount(forum.forumId, service.uid)
            .first;
        String memberId = const Uuid().v1().replaceAll('-', '');
        List<String> defaultPermissions = [MemberPermissions.createpost.name];

        if (forum.uid == service.uid) {
          defaultPermissions.add(MemberPermissions.editforum.name);
          defaultPermissions.add(MemberPermissions.addservice.name);
          defaultPermissions.add(MemberPermissions.removeservice.name);
          defaultPermissions.add(MemberPermissions.createforum.name);
          defaultPermissions.add(MemberPermissions.removeforum.name);
          defaultPermissions.add(MemberPermissions.removepost.name);
          defaultPermissions.add(MemberPermissions.editpermissions.name);
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
        final resForum = await _forumRepository.updateForum(forum);

        // create new forum activity
        if (user!.activities.contains(forumId) == false) {
          final activityController =
              _ref.read(activityControllerProvider.notifier);
          activityController.createActivity(
              ActivityType.forum.name, user.uid, forumId, forum.uid);

          // add activity to users acitivity list
          user.activities.add(forumId);
          final resUser = await _userProfileRepository.updateUser(user);

          state = false;
          res.fold((l) => showSnackBar(context, l.message), (r) {
            showSnackBar(context, 'Member added successfully!');
          });
        } else {
          state = false;
          res.fold((l) => showSnackBar(context, l.message), (r) {
            showSnackBar(context, 'Member added successfully!');
          });
        }
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(context, 'Service is already a member of this forum');
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Forum or service does not exist');
      }
    }
  }

  void updateMember(
      {required Member member, required BuildContext context}) async {
    state = true;
    final memberRes = await _memberRepository.updateMember(member);
    state = false;
    memberRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Member updated successfully!');
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

    // get user
    final user = _ref.read(userProvider)!;

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

    // delete member
    final res = await _memberRepository.deleteMember(memberId);

    // update forum
    forum!.members.remove(memberId);
    await _forumRepository.updateForum(forum);

    // get this users member count
    final memberCount = await _ref
        .read(memberControllerProvider.notifier)
        .getUserMemberCount(forumId, user.uid)
        .first;

    // remove activity if no user members are left
    if (memberCount == 0) {
      // get activity
      final activity = await _ref
          .read(activityControllerProvider.notifier)
          .getUserActivityByPolicyForumId(forumId, member!.serviceUid)
          .first;

      // now remove it
      await _activityRepository.deleteActivity(activity.activityId);

      // remove the activity from the users activity list
      user.activities.remove(forumId);
      await _userProfileRepository.updateUser(user);
    } else {
      // set next available member as default
      if (member!.selected) {
        // get the rest of the users members
        final userMembers = await _ref
            .read(memberControllerProvider.notifier)
            .getUserMembers(forumId, user.uid)
            .first;

        userMembers[0] = userMembers[0].copyWith(selected: true);
        await _memberRepository.updateMember(userMembers[0]);
      }
    }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Member removed successfully!');
    });
  }

  Stream<List<Member>> getMembers(String forumId) {
    return _memberRepository.getMembers(forumId);
  }

  Stream<List<Member>> getUserMembers(String forumId, String uid) {
    return _memberRepository.getUserMembers(forumId, uid);
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
}