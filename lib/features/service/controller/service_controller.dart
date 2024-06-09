import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/forum_activity/controller/forum_activity_controller.dart';
import 'package:reddit_tutorial/features/forum_activity/repository/forum_activity_repository.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/manager/repository/manager_repository.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/member/repository/member_repository.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/policy_activity/controller/policy_activity_controller.dart';
import 'package:reddit_tutorial/features/policy_activity/repository/policy_activity_repository.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule/repository/rule_repository.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/rule_member/repository/rule_member_repository.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/manager.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/policy_activity.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/rule_member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getServiceByIdProvider = StreamProvider.family.autoDispose(
  (ref, String serviceId) {
    return ref
        .watch(serviceControllerProvider.notifier)
        .getServiceById(serviceId);
  },
);

final getServiceByIdProvider2 =
    Provider.family.autoDispose((ref, String stringId) {
  try {
    return ref
        .watch(serviceControllerProvider.notifier)
        .getServiceById(stringId);
  } catch (e) {
    rethrow;
  }
});

final userServicesProvider = StreamProvider.autoDispose<List<Service>>(
  (ref) {
    return ref.watch(serviceControllerProvider.notifier).getUserServices();
  },
);

final servicesProvider = StreamProvider.autoDispose<List<Service>>(
  (ref) {
    return ref.watch(serviceControllerProvider.notifier).getServices();
  },
);

final searchPrivateServicesProvider = StreamProvider.family.autoDispose(
  (ref, Tuple2 params) {
    return ref
        .watch(serviceControllerProvider.notifier)
        .searchPrivateServices(params.item1, params.item2);
  },
);

final searchPublicServicesProvider = StreamProvider.family.autoDispose(
  (ref, String query) {
    return ref
        .watch(serviceControllerProvider.notifier)
        .searchPublicServices(query);
  },
);

final serviceControllerProvider =
    StateNotifierProvider<ServiceController, bool>((ref) {
  final policyRepository = ref.watch(policyRepositoryProvider);
  final policyActivityRepository = ref.watch(policyActivityRepositoryProvider);
  final forumRepository = ref.watch(forumRepositoryProvider);
  final forumActivityRepository = ref.watch(forumActivityRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  final managerRepository = ref.watch(managerRepositoryProvider);
  final memberRepository = ref.watch(memberRepositoryProvider);
  final ruleRepository = ref.watch(ruleRepositoryProvider);
  final ruleMemberRepository = ref.watch(ruleMemberRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ServiceController(
      policyRepository: policyRepository,
      policyActivityRepository: policyActivityRepository,
      forumRepository: forumRepository,
      forumActivityRepository: forumActivityRepository,
      serviceRepository: serviceRepository,
      managerRepository: managerRepository,
      memberRepository: memberRepository,
      ruleRepository: ruleRepository,
      ruleMemberRepository: ruleMemberRepository,
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class ServiceController extends StateNotifier<bool> {
  final PolicyRepository _policyRepository;
  final PolicyActivityRepository _policyActivityRepository;
  final ForumRepository _forumRepository;
  final ForumActivityRepository _forumActivityRepository;
  final ServiceRepository _serviceRepository;
  final ManagerRepository _managerRepository;
  final MemberRepository _memberRepository;
  final RuleRepository _ruleRepository;
  final RuleMemberRepository _ruleMemberRepository;
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ServiceController(
      {required PolicyRepository policyRepository,
      required PolicyActivityRepository policyActivityRepository,
      required ForumRepository forumRepository,
      required ForumActivityRepository forumActivityRepository,
      required ServiceRepository serviceRepository,
      required ManagerRepository managerRepository,
      required MemberRepository memberRepository,
      required RuleRepository ruleRepository,
      required RuleMemberRepository ruleMemberRepository,
      required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _policyRepository = policyRepository,
        _policyActivityRepository = policyActivityRepository,
        _forumRepository = forumRepository,
        _forumActivityRepository = forumActivityRepository,
        _serviceRepository = serviceRepository,
        _managerRepository = managerRepository,
        _memberRepository = memberRepository,
        _ruleRepository = ruleRepository,
        _ruleMemberRepository = ruleMemberRepository,
        _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createService(String title, String description, bool public,
      BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    final user = _ref.read(userProvider);
    String serviceId = const Uuid().v1().replaceAll('-', '');

    Service service = Service(
      serviceId: serviceId,
      uid: uid,
      title: title,
      titleLowercase: title.toLowerCase(),
      description: description,
      image: Constants.avatarDefault,
      imageFileType: 'image/jpeg',
      imageFileName: Constants.avatarDefault.split('/').last,
      banner: Constants.serviceBannerDefault,
      bannerFileType: 'image/jpeg',
      bannerFileName: Constants.serviceBannerDefault.split('/').last,
      public: public,
      tags: [],
      likes: [],
      policies: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _serviceRepository.createService(service);
    user!.services.add(serviceId);
    await _userProfileRepository.updateUser(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Service created successfully!');
      Routemaster.of(context).replace('/user/service/list');
    });
  }

  void updateService({
    required File? profileFile,
    required File? bannerFile,
    required Service service,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      // services/profile/123456
      final profileRes = await _storageRepository.storeFile(
          path: 'services/profile', id: service.serviceId, file: profileFile);

      profileRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => service = service.copyWith(image: r),
      );
    }

    if (bannerFile != null) {
      // services/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'services/banner', id: service.serviceId, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => service = service.copyWith(banner: r),
      );
    }
    final serviceRes = await _serviceRepository.updateService(service);
    state = false;
    serviceRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Service updated successfully!');
      // Routemaster.of(context).popUntil((routeData) {
      //   if (routeData.toString().split("/").last ==
      //       routeData.pathParameters['id']) {
      //     return true;
      //   }
      //   return false;
      // });
    });
  }

  // *******************************************************************
  // *******************************************************************
  // *******************************************************************
  // *******************************************************************
  // HERE ROB HAVE TO REMOVE FROM forumActivities and policyActivities
  // *******************************************************************
  // *******************************************************************
  // *******************************************************************
  // *******************************************************************

  void deleteService(
    BuildContext context,
    String serviceId,
  ) async {
    state = true;
    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (service != null) {
      final user = await _ref.read(getUserByIdProvider(service.uid)).first;

      if (user != null) {
        final List<Manager> managers =
            await _ref.read(getManangersByServiceIdProvider2(serviceId)).first;
        final List<Member> members =
            await _ref.read(getMembersByServiceIdProvider2(serviceId)).first;
        final List<RuleMember> ruleMembers = await _ref
            .read(getRuleMembersByServiceIdProvider2(serviceId))
            .first;

        // remove managers
        if (managers.isNotEmpty) {
          for (var manager in managers) {
            await _managerRepository.deleteManager(manager.managerId);

            // get policy
            Policy? policy = await _ref
                .read(policyControllerProvider.notifier)
                .getPolicyById(manager.policyId)
                .first;

            // get user
            final policyActivityUser =
                await _ref.read(getUserByIdProvider(manager.serviceUid)).first;

            if (policy != null && policyActivityUser != null) {
              // remove manager from policy manager list
              policy.managers.remove(manager.managerId);
              policy.services.remove(manager.serviceId);
              await _policyRepository.updatePolicy(policy);

              // get this users manager count
              final managerCount = await _ref
                  .read(managerControllerProvider.notifier)
                  .getUserManagerCount(policy.policyId, policyActivityUser.uid)
                  .first;

              // remove policy activity if no user managers are left
              if (managerCount == 0) {
                // get policy activity
                final policyActivity = await _ref
                    .read(policyActivityControllerProvider.notifier)
                    .getPolicyActivityByUserId(
                        policy.policyId, policyActivityUser.uid)
                    .first;

                if (policyActivity != null) {
                  // now remove it
                  await _policyActivityRepository
                      .deletePolicyActivity(policyActivity.policyActivityId);

                  // remove the activity from the users policy activity list
                  policyActivityUser.policyActivities.remove(policy.policyId);
                  await _userProfileRepository.updateUser(policyActivityUser);
                }
              } else {
                // set next available manager as default
                if (manager.selected) {
                  // get the rest of the users managers
                  final userManagers = await _ref
                      .read(managerControllerProvider.notifier)
                      .getUserManagers(policy.policyId, policyActivityUser.uid)
                      .first;

                  userManagers[0] = userManagers[0].copyWith(selected: true);
                  await _managerRepository.updateManager(userManagers[0]);
                }
              }
            }
          }
        }

        // remove members
        if (members.isNotEmpty) {
          for (var member in members) {
            await _memberRepository.deleteMember(member.memberId);

            // remove member from forum member list
            Forum? forum = await _ref
                .read(forumControllerProvider.notifier)
                .getForumById(member.forumId)
                .first;

            // get user
            final forumActivityUser =
                await _ref.read(getUserByIdProvider(member.serviceUid)).first;

            if (forum != null && forumActivityUser != null) {
              forum.members.remove(member.memberId);
              forum.services.remove(serviceId);
              await _forumRepository.updateForum(forum);

              // get this users member count
              final memberCount = await _ref
                  .read(memberControllerProvider.notifier)
                  .getUserMemberCount(forum.forumId, forumActivityUser.uid)
                  .first;

              // remove forum activity if no user members are left
              if (memberCount == 0) {
                // get forum activity
                final forumActivity = await _ref
                    .read(forumActivityControllerProvider.notifier)
                    .getUserForumActivityByForumId(
                        forum.forumId, forumActivityUser.uid)
                    .first;

                if (forumActivity != null) {
                  // now remove it
                  await _forumActivityRepository
                      .deleteForumActivity(forumActivity.forumActivityId);

                  // remove the activity from the users forum activity list
                  forumActivityUser.policyActivities.remove(forum.forumId);
                  await _userProfileRepository.updateUser(forumActivityUser);
                }
              } else {
                // set next available member as default
                if (member.selected) {
                  // get the rest of the users members
                  final userMembers = await _ref
                      .read(memberControllerProvider.notifier)
                      .getUserMembers(forum.forumId, forumActivityUser.uid)
                      .first;

                  userMembers[0] = userMembers[0].copyWith(selected: true);
                  await _memberRepository.updateMember(userMembers[0]);
                }
              }
            }
          }
        }

        // remove rule members
        if (ruleMembers.isNotEmpty) {
          for (var ruleMember in ruleMembers) {
            await _ruleMemberRepository
                .deleteRuleMember(ruleMember.ruleMemberId);

            // remove rule member from rule member list
            Rule? rule = await _ref
                .read(ruleControllerProvider.notifier)
                .getRuleById(ruleMember.ruleId)
                .first;

            if (rule != null) {
              rule.members.remove(ruleMember.ruleMemberId);
              rule.services.remove(serviceId);
              await _ruleRepository.updateRule(rule);
            }
          }
        }

        // remove consumers
        if (service.policies.isNotEmpty) {
          final List<Policy?> policies = await _ref
              .read(getServiceConsumerPoliciesProvider2(serviceId))
              .first;

          if (policies.isNotEmpty) {
            for (var policy in policies) {
              // remove service from policy consumer list
              policy!.consumers.remove(serviceId);
              await _policyRepository.updatePolicy(policy);
            }
          }
        }

        // update user service list
        user.services.remove(serviceId);
        await _userProfileRepository.updateUser(user);

        // remove service
        final serviceRes = await _serviceRepository.deleteService(serviceId);
        state = false;
        serviceRes.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Service deleted successfully!');
        });
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(context, 'User does not exist');
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Service does not exist');
      }
    }
  }

  Stream<List<Service>> getUserServices() {
    final uid = _ref.read(userProvider)!.uid;
    return _serviceRepository.getUserServices(uid);
  }

  Stream<List<Service>> getServices() {
    return _serviceRepository.getServices();
  }

  Stream<Service?> getServiceById(String serviceId) {
    return _serviceRepository.getServiceById(serviceId);
  }

  Stream<List<Service>> searchPrivateServices(String uid, String query) {
    return _serviceRepository.searchPrivateServices(uid, query);
  }

  Stream<List<Service>> searchPublicServices(String query) {
    return _serviceRepository.searchPublicServices(query);
  }
}
