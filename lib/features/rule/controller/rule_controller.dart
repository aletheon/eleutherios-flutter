import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/rule/repository/rule_repository.dart';
import 'package:reddit_tutorial/models/manager.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getRuleByIdProvider = Provider.family.autoDispose((ref, String ruleId) {
  return ref.watch(ruleControllerProvider.notifier).getRuleById(ruleId);
});

final getRulesProvider =
    StreamProvider.family.autoDispose((ref, String policyId) {
  return ref.watch(ruleControllerProvider.notifier).getRules(policyId);
});

final getManagerRulesProvider =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(ruleControllerProvider.notifier)
        .getManagerRules(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final ruleControllerProvider =
    StateNotifierProvider<RuleController, bool>((ref) {
  final ruleRepository = ref.watch(ruleRepositoryProvider);
  final policyRepository = ref.watch(policyRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return RuleController(
      ruleRepository: ruleRepository,
      policyRepository: policyRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class RuleController extends StateNotifier<bool> {
  final RuleRepository _ruleRepository;
  final PolicyRepository _policyRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  RuleController(
      {required RuleRepository ruleRepository,
      required PolicyRepository policyRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _ruleRepository = ruleRepository,
        _policyRepository = policyRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createRule(
      String policyId,
      String managerId,
      String title,
      String description,
      bool public,
      String instantiationType,
      DateTime instantiationDate,
      BuildContext context) async {
    state = true;

    Policy? policy = await _ref
        .read(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    Manager? manager = await _ref
        .read(managerControllerProvider.notifier)
        .getManagerById(managerId)
        .first;

    if (policy != null) {
      String ruleId = const Uuid().v1().replaceAll('-', '');

      Rule rule = Rule(
        ruleId: ruleId,
        policyId: policyId,
        policyUid: policy.uid,
        managerId: managerId,
        managerUid: manager != null ? manager.serviceUid : '',
        title: title,
        titleLowercase: title.toLowerCase(),
        description: description,
        image: Constants.avatarDefault,
        banner: Constants.ruleBannerDefault,
        public: public,
        instantiationType: instantiationType,
        instantiationDate: instantiationDate,
        services: [],
        tags: [],
        lastUpdateDate: DateTime.now(),
        creationDate: DateTime.now(),
      );
      final res = await _ruleRepository.createRule(rule);

      // update policy
      policy.rules.add(ruleId);
      final resPolicy = await _policyRepository.updatePolicy(policy);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Rule added successfully!');
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy does not exist');
      }
    }
  }

  void updateRule({
    required File? profileFile,
    required File? bannerFile,
    required Rule rule,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      // rules/profile/123456
      final profileRes = await _storageRepository.storeFile(
          path: 'rules/profile', id: rule.ruleId, file: profileFile);

      profileRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => rule = rule.copyWith(image: r),
      );
    }

    if (bannerFile != null) {
      // rules/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'rules/banner', id: rule.ruleId, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => rule = rule.copyWith(banner: r),
      );
    }
    final ruleRes = await _ruleRepository.updateRule(rule);
    state = false;
    ruleRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Rule updated successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Rule>> getRules(String policyId) {
    return _ruleRepository.getRules(policyId);
  }

  Stream<List<Rule>> getManagerRules(String policyId, String managerId) {
    return _ruleRepository.getManagerRules(policyId, managerId);
  }

  Stream<Rule> getRuleById(String ruleId) {
    return _ruleRepository.getRuleById(ruleId);
  }

  Stream<List<Rule>> searchRules(String query) {
    return _ruleRepository.searchRules(query);
  }
}
