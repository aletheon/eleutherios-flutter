import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule/repository/rule_repository.dart';
import 'package:reddit_tutorial/features/rule_member/repository/rule_member_repository.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/rule_member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getRuleMemberByIdProvider =
    StreamProvider.family.autoDispose((ref, String ruleMemberId) {
  return ref
      .watch(ruleMemberControllerProvider.notifier)
      .getRuleMemberById(ruleMemberId);
});

final serviceIsRegisteredInRuleProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(ruleMemberControllerProvider.notifier)
      .serviceIsRegisteredInRule(params.item1, params.item2);
});

final getRuleMembersProvider =
    StreamProvider.family.autoDispose((ref, String ruleId) {
  return ref
      .watch(ruleMemberControllerProvider.notifier)
      .getRuleMembers(ruleId);
});

final getRuleMembersProvider2 = Provider.family((ref, String ruleId) {
  try {
    return ref
        .watch(ruleMemberControllerProvider.notifier)
        .getRuleMembers(ruleId);
  } catch (e) {
    rethrow;
  }
});

final getUserRuleMembersProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(ruleMemberControllerProvider.notifier)
      .getUserRuleMembers(params.item1, params.item2);
});

final getUserRuleMemberCountProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(ruleMemberControllerProvider.notifier)
      .getUserRuleMemberCount(params.item1, params.item2);
});

final getUserSelectedRuleMemberProvider =
    StreamProvider.family((ref, Tuple2 params) {
  try {
    return ref
        .watch(ruleMemberControllerProvider.notifier)
        .getUserSelectedRuleMember(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getUserSelectedRuleMemberProvider2 =
    Provider.family((ref, Tuple2 params) {
  try {
    return ref
        .watch(ruleMemberControllerProvider.notifier)
        .getUserSelectedRuleMember(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final ruleMemberControllerProvider =
    StateNotifierProvider<RuleMemberController, bool>((ref) {
  final ruleMemberRepository = ref.watch(ruleMemberRepositoryProvider);
  final ruleRepository = ref.watch(ruleRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return RuleMemberController(
      ruleMemberRepository: ruleMemberRepository,
      ruleRepository: ruleRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class RuleMemberController extends StateNotifier<bool> {
  final RuleMemberRepository _ruleMemberRepository;
  final RuleRepository _ruleRepository;
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  RuleMemberController(
      {required RuleMemberRepository ruleMemberRepository,
      required RuleRepository ruleRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _ruleMemberRepository = ruleMemberRepository,
        _ruleRepository = ruleRepository,
        _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void createRuleMember(
      String ruleId, String serviceId, BuildContext context) async {
    state = true;
    Rule? rule = await _ref
        .read(ruleControllerProvider.notifier)
        .getRuleById(ruleId)
        .first;
    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (rule != null && service != null) {
      // ensure service is not already a member
      if (rule.members.contains(serviceId) == false) {
        final user = await _ref.read(getUserByIdProvider(service.uid)).first;
        final ruleMemberCount = await _ref
            .read(ruleMemberControllerProvider.notifier)
            .getUserRuleMemberCount(rule.ruleId, service.uid)
            .first;
        String ruleMemberId = const Uuid().v1().replaceAll('-', '');
        List<String> defaultPermissions = [MemberPermissions.createpost.name];

        if (rule.uid == service.uid) {
          defaultPermissions.add(MemberPermissions.editforum.name);
          defaultPermissions.add(MemberPermissions.addmember.name);
          defaultPermissions.add(MemberPermissions.removemember.name);
          defaultPermissions.add(MemberPermissions.createforum.name);
          defaultPermissions.add(MemberPermissions.removeforum.name);
          defaultPermissions.add(MemberPermissions.removepost.name);
          defaultPermissions.add(MemberPermissions.editmemberpermissions.name);
        }

        // create rule member
        RuleMember ruleMember = RuleMember(
          ruleMemberId: ruleMemberId,
          ruleId: ruleId,
          ruleUid: rule.uid,
          serviceId: serviceId,
          serviceUid: service.uid,
          selected: ruleMemberCount == 0 ? true : false,
          permissions: defaultPermissions,
          lastUpdateDate: DateTime.now(),
          creationDate: DateTime.now(),
        );
        final res = await _ruleMemberRepository.createRuleMember(ruleMember);

        // update rule
        rule.members.add(ruleMemberId);
        rule.services.add(serviceId);
        final resRule = await _ruleRepository.updateRule(rule);

        // create new rule activity
        state = false;
        res.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Potential member added!');
        });
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(context, 'Service is already a member of this rule');
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Rule or service does not exist');
      }
    }
  }

  void updateRuleMember(
      {required RuleMember ruleMember, required BuildContext context}) async {
    state = true;
    final ruleMemberRes =
        await _ruleMemberRepository.updateRuleMember(ruleMember);
    state = false;
    ruleMemberRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Potential member updated successfully!');
    });
  }

  void changedSelected(String ruleMemberId) async {
    // get member
    RuleMember? ruleMember = await _ref
        .read(ruleMemberControllerProvider.notifier)
        .getRuleMemberById(ruleMemberId)
        .first;

    // get old rule member and unselect it
    RuleMember? selectedRuleMember = await _ref
        .read(ruleMemberControllerProvider.notifier)
        .getUserSelectedRuleMember(ruleMember!.ruleId, ruleMember.serviceUid)
        .first;

    selectedRuleMember = selectedRuleMember!.copyWith(selected: false);
    await _ruleMemberRepository.updateRuleMember(selectedRuleMember);

    ruleMember = ruleMember.copyWith(selected: true);
    await _ruleMemberRepository.updateRuleMember(ruleMember);
  }

  void deleteRuleMember(
      String ruleId, String ruleMemberId, BuildContext context) async {
    state = true;

    // get user
    final user = _ref.read(userProvider)!;

    // get ruleMember
    final ruleMember = await _ref
        .read(ruleMemberControllerProvider.notifier)
        .getRuleMemberById(ruleMemberId)
        .first;

    // get rule
    final rule = await _ref
        .watch(ruleControllerProvider.notifier)
        .getRuleById(ruleId)
        .first;

    // delete ruleMember
    final res = await _ruleMemberRepository.deleteRuleMember(ruleMemberId);

    // update rule
    rule!.members.remove(ruleMemberId);
    rule.services.remove(ruleMember!.serviceId);
    await _ruleRepository.updateRule(rule);

    // get this users member count
    final ruleMemberCount = await _ref
        .read(ruleMemberControllerProvider.notifier)
        .getUserRuleMemberCount(ruleId, user.uid)
        .first;

    if (ruleMemberCount > 0) {
      // set next available rule member as default
      if (ruleMember!.selected) {
        // get the rest of the users rule members
        final userRuleMembers = await _ref
            .read(ruleMemberControllerProvider.notifier)
            .getUserRuleMembers(ruleId, user.uid)
            .first;

        userRuleMembers[0] = userRuleMembers[0].copyWith(selected: true);
        await _ruleMemberRepository.updateRuleMember(userRuleMembers[0]);
      }
    }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Member removed successfully!');
    });
  }

  Stream<List<RuleMember>> getRuleMembers(String ruleId) {
    return _ruleMemberRepository.getRuleMembers(ruleId);
  }

  Stream<List<RuleMember>> getUserRuleMembers(String ruleId, String uid) {
    return _ruleMemberRepository.getUserRuleMembers(ruleId, uid);
  }

  Stream<bool> serviceIsRegisteredInRule(String ruleId, String serviceId) {
    return _ruleMemberRepository.serviceIsRegisteredInRule(ruleId, serviceId);
  }

  Stream<int> getUserRuleMemberCount(String ruleId, String uid) {
    return _ruleMemberRepository.getUserRuleMemberCount(ruleId, uid);
  }

  Stream<RuleMember?> getUserSelectedRuleMember(String ruleId, String uid) {
    return _ruleMemberRepository.getUserSelectedRuleMember(ruleId, uid);
  }

  Stream<RuleMember?> getRuleMemberById(String ruleMemberId) {
    return _ruleMemberRepository.getRuleMemberById(ruleMemberId);
  }
}
