import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/member/repository/member_repository.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/rule_member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getPolicyByIdProvider =
    StreamProvider.family.autoDispose((ref, String policyId) {
  return ref.watch(policyControllerProvider.notifier).getPolicyById(policyId);
});

final getPolicyByIdProvider2 =
    Provider.family.autoDispose((ref, String policyId) {
  try {
    return ref.watch(policyControllerProvider.notifier).getPolicyById(policyId);
  } catch (e) {
    rethrow;
  }
});

final getServiceManagerPoliciesProvider =
    StreamProvider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(policyControllerProvider.notifier)
      .getServiceManagerPolicies(serviceId);
});

final getServiceConsumerPoliciesProvider =
    StreamProvider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(policyControllerProvider.notifier)
      .getServiceConsumerPolicies(serviceId);
});

final getServiceConsumerPoliciesProvider2 =
    Provider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(policyControllerProvider.notifier)
      .getServiceConsumerPolicies(serviceId);
});

final userPoliciesProvider = StreamProvider.autoDispose<List<Policy>>((ref) {
  return ref.watch(policyControllerProvider.notifier).getUserPolicies();
});

final policiesProvider = StreamProvider.autoDispose<List<Policy>>((ref) {
  return ref.watch(policyControllerProvider.notifier).getPolicies();
});

final searchPrivatePoliciesProvider = StreamProvider.family.autoDispose(
  (ref, Tuple2 params) {
    return ref
        .watch(policyControllerProvider.notifier)
        .searchPrivatePolicies(params.item1, params.item2);
  },
);

final searchPublicPoliciesProvider =
    StreamProvider.family((ref, Tuple2 params) {
  return ref
      .watch(policyControllerProvider.notifier)
      .searchPublicPolicies(params.item1, params.item2);
});

final policyControllerProvider =
    StateNotifierProvider<PolicyController, bool>((ref) {
  final policyRepository = ref.watch(policyRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final forumRepository = ref.watch(forumRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  final memberRepository = ref.watch(memberRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PolicyController(
      policyRepository: policyRepository,
      userProfileRepository: userProfileRepository,
      forumRepository: forumRepository,
      serviceRepository: serviceRepository,
      memberRepository: memberRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class PolicyController extends StateNotifier<bool> {
  final PolicyRepository _policyRepository;
  final UserProfileRepository _userProfileRepository;
  final ForumRepository _forumRepository;
  final ServiceRepository _serviceRepository;
  final MemberRepository _memberRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  PolicyController(
      {required PolicyRepository policyRepository,
      required UserProfileRepository userProfileRepository,
      required ForumRepository forumRepository,
      required ServiceRepository serviceRepository,
      required MemberRepository memberRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _policyRepository = policyRepository,
        _userProfileRepository = userProfileRepository,
        _forumRepository = forumRepository,
        _serviceRepository = serviceRepository,
        _memberRepository = memberRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createPolicy(String title, String description, bool public,
      List<String>? tags, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    final user = _ref.read(userProvider);
    String policyId = const Uuid().v1().replaceAll('-', '');

    Policy policy = Policy(
      policyId: policyId,
      uid: uid,
      title: title,
      titleLowercase: title.toLowerCase(),
      description: description,
      image: Constants.avatarDefault,
      imageFileType: 'image/jpeg',
      imageFileName: Constants.avatarDefault.split('/').last,
      banner: Constants.policyBannerDefault,
      bannerFileType: 'image/jpeg',
      bannerFileName: Constants.policyBannerDefault.split('/').last,
      public: public,
      tags: tags != null && tags.isNotEmpty ? tags : [],
      services: [],
      managers: [],
      consumers: [],
      rules: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _policyRepository.createPolicy(policy);
    user!.policies.add(policyId);
    await _userProfileRepository.updateUser(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Policy created successfully!');
      Routemaster.of(context).replace('/user/policy/list');
    });
  }

  void updatePolicy({
    required File? profileFile,
    required File? bannerFile,
    required Policy policy,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      // policies/profile/123456
      final profileRes = await _storageRepository.storeFile(
          path: 'policies/profile', id: policy.policyId, file: profileFile);

      profileRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => policy = policy.copyWith(image: r),
      );
    }

    if (bannerFile != null) {
      // policies/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'policies/banner', id: policy.policyId, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => policy = policy.copyWith(banner: r),
      );
    }
    final policyRes = await _policyRepository.updatePolicy(policy);
    state = false;
    policyRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Policy updated successfully!');
    });
  }

  void deletePolicy(
      String userId, String policyId, BuildContext context) async {
    state = true;
    UserModel? user = await _ref
        .read(authControllerProvider.notifier)
        .getUserData(userId)
        .first;

    Policy? policy = await _ref
        .read(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    if (user != null && policy != null) {
      // remove managers from policy
      if (policy.managers.isNotEmpty) {
        await _ref
            .read(managerControllerProvider.notifier)
            .deleteManagersByPolicId(policyId);
      }

      // remove rules from policy
      if (policy.rules.isNotEmpty) {
        await _ref
            .read(ruleControllerProvider.notifier)
            .deleteRulesByPolicyId(policyId);
      }

      // remove consumers from policy
      if (policy.consumers.isNotEmpty) {
        for (String serviceId in policy.consumers) {
          Service? service = await _ref
              .read(serviceControllerProvider.notifier)
              .getServiceById(serviceId)
              .first;

          if (service != null) {
            service.policies.remove(policy.policyId);
            await _serviceRepository.updateService(service);
          }
        }
      }

      // remove policy from user policy list
      user.policies.remove(policyId);
      await _userProfileRepository.updateUser(user);

      // delete policy
      final resDeletePolicy = await _policyRepository.deletePolicy(policyId);
      state = false;
      resDeletePolicy.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Policy deleted successfully!');
        },
      );
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'User or policy does not exist');
      }
    }
  }

  void addPolicyToService(
      String serviceId, String policyId, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider);
    Policy? policy = await _ref
        .read(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (policy != null && service != null) {
      service.policies.add(policyId);
      await _serviceRepository.updateService(service);

      policy.consumers.add(serviceId);
      await _policyRepository.updatePolicy(policy);

      List<Rule>? rules = await _ref.read(getRulesProvider2(policyId)).first;

      if (rules.isNotEmpty) {
        for (Rule rule in rules) {
          if (rule.instantiationType == InstantiationType.consume.value) {
            String forumId = const Uuid().v1().replaceAll('-', '');

            Forum forum = Forum(
              forumId: forumId,
              uid: user!.uid,
              parentId: '',
              parentUid: '',
              policyId: policy.policyId,
              policyUid: policy.uid,
              ruleId: rule.ruleId,
              title: rule.title,
              titleLowercase: rule.title.toLowerCase(),
              description: rule.description,
              image: Constants.avatarDefault,
              imageFileType: 'image/jpeg',
              imageFileName: Constants.avatarDefault.split('/').last,
              banner: Constants.forumBannerDefault,
              bannerFileType: 'image/jpeg',
              bannerFileName: Constants.forumBannerDefault.split('/').last,
              public: rule.public,
              tags: [],
              services: [],
              members: [],
              posts: [],
              forums: [],
              breadcrumbs: [],
              breadcrumbReferences: [],
              recentPostId: '',
              lastUpdateDate: DateTime.now(),
              creationDate: DateTime.now(),
            );

            if (rule.image != Constants.avatarDefault) {
              final profileGetResponse = await http.get(Uri.parse(rule.image));
              Directory profileTempDir = await getTemporaryDirectory();
              final profileFile = File(join(profileTempDir.path,
                  const Uuid().v1().replaceAll('-', '') + rule.imageFileName));
              profileFile.writeAsBytesSync(profileGetResponse.bodyBytes);

              // forums/profile/123456
              final profileStorageResponse = await _storageRepository.storeFile(
                  path: 'forums/profile', id: forum.forumId, file: profileFile);

              profileStorageResponse.fold(
                (l) => showSnackBar(context, l.message),
                (r) => forum = forum.copyWith(
                  image: r,
                  imageFileName: rule.imageFileName,
                  imageFileType: rule.imageFileType,
                ),
              );
            }

            if (rule.banner != Constants.ruleBannerDefault) {
              final bannerGetResponse = await http.get(Uri.parse(rule.banner));
              Directory bannerTempDir = await getTemporaryDirectory();
              final bannerFile = File(join(bannerTempDir.path,
                  const Uuid().v1().replaceAll('-', '') + rule.bannerFileName));
              bannerFile.writeAsBytesSync(bannerGetResponse.bodyBytes);

              // forums/banner/123456
              final bannerStorageResponse = await _storageRepository.storeFile(
                  path: 'forums/banner', id: forum.forumId, file: bannerFile);

              bannerStorageResponse.fold(
                (l) => showSnackBar(context, l.message),
                (r) => forum = forum.copyWith(
                  banner: r,
                  bannerFileName: rule.bannerFileName,
                  bannerFileType: rule.bannerFileType,
                ),
              );
            }

            // Convert rule members into actual members for this forum
            if (rule.members.isNotEmpty) {
              List<RuleMember>? ruleMembers =
                  await _ref.read(getRuleMembersProvider2(rule.ruleId)).first;

              for (RuleMember ruleMember in ruleMembers) {
                String memberId = const Uuid().v1().replaceAll('-', '');

                // create member
                Member member = Member(
                  memberId: memberId,
                  forumId: forum.forumId,
                  forumUid: forum.uid,
                  serviceId: ruleMember.serviceId,
                  serviceUid: ruleMember.serviceUid,
                  selected: ruleMember.selected,
                  permissions: ruleMember.permissions,
                  lastUpdateDate: DateTime.now(),
                  creationDate: DateTime.now(),
                );
                await _memberRepository.createMember(member);

                // add member to forums member list
                forum.members.add(memberId);
              }
            }
            await _forumRepository.createForum(forum);
            user.forums.add(forumId);
          }
        }
        await _userProfileRepository.updateUser(user!);
        state = false;
        if (context.mounted) {
          showSnackBar(context, 'Policy added successfully');
        }
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(context, 'Policy added successfully');
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy or service does not exist');
      }
    }
  }

  void removePolicyFromService(
      String serviceId, String policyId, BuildContext context) async {
    state = true;
    Policy? policy = await _ref
        .read(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (policy != null && service != null) {
      service.policies.remove(policyId);
      await _serviceRepository.updateService(service);

      policy.consumers.remove(serviceId);
      final resPolicy = await _policyRepository.updatePolicy(policy);

      state = false;
      resPolicy.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Policy removed successfully!');
        },
      );
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy or service does not exist');
      }
    }
  }

  Stream<List<Policy>> getUserPolicies() {
    final uid = _ref.read(userProvider)!.uid;
    return _policyRepository.getUserPolicies(uid);
  }

  Stream<List<Policy>> getPolicies() {
    return _policyRepository.getPolicies();
  }

  Stream<Policy?> getPolicyById(String policyId) {
    return _policyRepository.getPolicyById(policyId);
  }

  Stream<List<Policy>> getServiceConsumerPolicies(String serviceId) {
    return _policyRepository.getServiceConsumerPolicies(serviceId);
  }

  Stream<List<Policy>> getServiceManagerPolicies(String serviceId) {
    return _policyRepository.getServiceManagerPolicies(serviceId);
  }

  Stream<List<Policy>> searchPrivatePolicies(String uid, String query) {
    return _policyRepository.searchPrivatePolicies(uid, query);
  }

  Stream<List<Policy>> searchPublicPolicies(String query, List<String> tags) {
    return _policyRepository.searchPublicPolicies(query, tags);
  }
}
