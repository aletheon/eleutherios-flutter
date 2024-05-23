import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/features/member/repository/member_repository.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/policy.dart';
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

final searchPublicServicesProvider = StreamProvider.family(
  (ref, String query) {
    return ref
        .watch(serviceControllerProvider.notifier)
        .searchPublicServices(query);
  },
);

final serviceControllerProvider =
    StateNotifierProvider<ServiceController, bool>((ref) {
  final policyRepository = ref.watch(policyRepositoryProvider);
  final forumRepository = ref.watch(forumRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  final memberRepository = ref.watch(memberRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ServiceController(
      policyRepository: policyRepository,
      forumRepository: forumRepository,
      serviceRepository: serviceRepository,
      memberRepository: memberRepository,
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class ServiceController extends StateNotifier<bool> {
  final PolicyRepository _policyRepository;
  final ForumRepository _forumRepository;
  final ServiceRepository _serviceRepository;
  final MemberRepository _memberRepository;
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ServiceController(
      {required PolicyRepository policyRepository,
      required ForumRepository forumRepository,
      required ServiceRepository serviceRepository,
      required MemberRepository memberRepository,
      required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _policyRepository = policyRepository,
        _forumRepository = forumRepository,
        _serviceRepository = serviceRepository,
        _memberRepository = memberRepository,
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
    final resUser = await _userProfileRepository.updateUser(user);
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

  void addServiceToPolicy(
      String policyId, String serviceId, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider);
    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    Policy? policy = await _ref
        .read(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    if (service != null && policy != null) {
      policy.consumers.add(serviceId);
      final resPolicy = await _policyRepository.updatePolicy(policy);

      service.policies.add(policyId);
      final resService = await _serviceRepository.updateService(service);

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
                final resMember = await _memberRepository.createMember(member);

                // add member to forums member list
                forum.members.add(memberId);
              }
            }
            final resForum = await _forumRepository.createForum(forum);
            user.forums.add(forumId);
          }
        }
        final resUser = await _userProfileRepository.updateUser(user!);
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
