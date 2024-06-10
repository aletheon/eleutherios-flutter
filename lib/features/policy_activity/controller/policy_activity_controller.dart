import 'package:reddit_tutorial/features/policy_activity/repository/policy_activity_repository.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/policy_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getPolicyActivityByIdProvider =
    Provider.family.autoDispose((ref, String policyActivityId) {
  final policyActivityRepository = ref.watch(policyActivityRepositoryProvider);
  return policyActivityRepository.getPolicyActivityById(policyActivityId);
});

final policyActivitiesProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(policyActivityControllerProvider.notifier)
      .getPolicyActivities(uid);
});

final getPolicyActivityByUserIdProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(policyActivityControllerProvider.notifier)
      .getPolicyActivityByUserId(params.item1, params.item2);
});

final getPolicyActivityByUserIdProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(policyActivityControllerProvider.notifier)
      .getPolicyActivityByUserId(params.item1, params.item2);
});

final policyActivityControllerProvider =
    StateNotifierProvider<PolicyActivityController, bool>((ref) {
  final policyActivityRepository = ref.watch(policyActivityRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return PolicyActivityController(
      policyActivityRepository: policyActivityRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class PolicyActivityController extends StateNotifier<bool> {
  final PolicyActivityRepository _policyActivityRepository;
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  PolicyActivityController(
      {required PolicyActivityRepository policyActivityRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _policyActivityRepository = policyActivityRepository,
        _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void createPolicyActivity(
      String uid, String policyId, String policyUid) async {
    state = true;
    final user =
        await _ref.read(authControllerProvider.notifier).getUserData(uid).first;
    String policyActivityId = const Uuid().v1().replaceAll('-', '');

    PolicyActivity policyActivity = PolicyActivity(
      policyActivityId: policyActivityId,
      uid: uid,
      policyId: policyId,
      policyUid: policyUid,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res =
        await _policyActivityRepository.createPolicyActivity(policyActivity);

    // create a policyActivity for this user
    List result = user!.policyActivities.where((a) => a == policyId).toList();
    if (result.isEmpty) {
      // add the policyId not the activityId as it makes it easier to find out if a particular user is serving in a forum or not
      user.policyActivities.add(policyId);
      final resUser = await _userProfileRepository.updateUser(user);
    }
    state = false;
  }

  Stream<List<PolicyActivity>> getPolicyActivities(String uid) {
    return _policyActivityRepository.getPolicyActivities(uid);
  }

  Stream<PolicyActivity> getPolicyActivityById(String policyActivityId) {
    return _policyActivityRepository.getPolicyActivityById(policyActivityId);
  }

  Stream<PolicyActivity?> getPolicyActivityByUserId(
      String policyId, String uid) {
    return _policyActivityRepository.getPolicyActivityByUserId(policyId, uid);
  }
}
