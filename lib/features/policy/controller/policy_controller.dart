import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final getPolicyByIdProvider =
    StreamProvider.family.autoDispose((ref, String policyId) {
  return ref.watch(policyControllerProvider.notifier).getPolicyById(policyId);
});

final getPolicyByIdProvider2 = Provider.family((ref, String policyId) {
  try {
    return ref.watch(policyControllerProvider.notifier).getPolicyById(policyId);
  } catch (e) {
    rethrow;
  }
});

final userPoliciesProvider = StreamProvider.autoDispose<List<Policy>>((ref) {
  return ref.watch(policyControllerProvider.notifier).getUserPolicies();
});

final policiesProvider = StreamProvider.autoDispose<List<Policy>>((ref) {
  return ref.watch(policyControllerProvider.notifier).getPolicies();
});

final searchPoliciesProvider = StreamProvider.family((ref, String query) {
  return ref.watch(policyControllerProvider.notifier).searchPolicies(query);
});

final policyControllerProvider =
    StateNotifierProvider<PolicyController, bool>((ref) {
  final policyRepository = ref.watch(policyRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PolicyController(
      policyRepository: policyRepository,
      userProfileRepository: userProfileRepository,
      serviceRepository: serviceRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class PolicyController extends StateNotifier<bool> {
  final PolicyRepository _policyRepository;
  final UserProfileRepository _userProfileRepository;
  final ServiceRepository _serviceRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  PolicyController(
      {required PolicyRepository policyRepository,
      required UserProfileRepository userProfileRepository,
      required ServiceRepository serviceRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _policyRepository = policyRepository,
        _userProfileRepository = userProfileRepository,
        _serviceRepository = serviceRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createPolicy(String title, String description, bool public,
      BuildContext context) async {
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
      banner: Constants.policyBannerDefault,
      public: public,
      tags: [],
      managers: [],
      consumers: [],
      rules: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _policyRepository.createPolicy(policy);
    user!.policies.add(policyId);
    final resUser = await _userProfileRepository.updateUser(user);
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
      // Routemaster.of(context).popUntil((routeData) {
      //   if (routeData.toString().split("/").last ==
      //       routeData.pathParameters['id']) {
      //     return true;
      //   }
      //   return false;
      // });
    });
  }

  void addPolicyToService(
      String serviceId, String policyId, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider);
    // String policyId = const Uuid().v1().replaceAll('-', '');

    // 1) add policy to service
    // 2) add service to policy (consumers list)
    // 3) get rules for policy
    // 4) create forum rules based on instantionType

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
      final resService = await _serviceRepository.updateService(service);

      policy.consumers.add(serviceId);
      final resPolicy = await _policyRepository.updatePolicy(policy);

      List<Rule>? rules = await _ref.read(getRulesProvider2(policyId)).first;

      if (rules.isNotEmpty) {
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

    // Policy policy = Policy(
    //   policyId: policyId,
    //   uid: uid,
    //   title: title,
    //   titleLowercase: title.toLowerCase(),
    //   description: description,
    //   image: Constants.avatarDefault,
    //   banner: Constants.policyBannerDefault,
    //   public: public,
    //   tags: [],
    //   managers: [],
    //   consumers: [],
    //   rules: [],
    //   lastUpdateDate: DateTime.now(),
    //   creationDate: DateTime.now(),
    // );
    // final res = await _policyRepository.createPolicy(policy);
    // user!.policies.add(policyId);
    // final resUser = await _userProfileRepository.updateUser(user);
    // state = false;
    // res.fold((l) => showSnackBar(context, l.message), (r) {
    //   showSnackBar(context, 'Policy created successfully!');
    //   Routemaster.of(context).replace('/user/policy/list');
    // });
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

  Stream<List<Policy>> searchPolicies(String query) {
    return _policyRepository.searchPolicies(query);
  }
}
