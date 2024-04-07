import 'package:reddit_tutorial/features/activity/repository/activity_repository.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final getActivityByIdProvider = Provider.family((ref, String activityId) {
  final activityRepository = ref.watch(activityRepositoryProvider);
  return activityRepository.getActivityById(activityId);
});

final activitiesProvider = StreamProvider.family.autoDispose((ref, String uid) {
  return ref.watch(activityControllerProvider.notifier).getActivities(uid);
});

final policyActivitiesProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(activityControllerProvider.notifier)
      .getPolicyActivities(uid);
});

final activityControllerProvider =
    StateNotifierProvider<ActivityController, bool>((ref) {
  final activityRepository = ref.watch(activityRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return ActivityController(
      activityRepository: activityRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class ActivityController extends StateNotifier<bool> {
  final ActivityRepository _activityRepository;
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  ActivityController(
      {required ActivityRepository activityRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _activityRepository = activityRepository,
        _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void createActivity(String activityType, String uid, String policyForumId,
      String policyForumUid) async {
    state = true;
    final user = await _ref.watch(getUserByIdProvider(uid)).first;
    String activityId = const Uuid().v1().replaceAll('-', '');

    Activity activity = Activity(
      activityId: activityId,
      activityType: activityType,
      uid: uid,
      policyForumId: policyForumId,
      policyForumUid: policyForumUid,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _activityRepository.createActivity(activity);

    // create an activity for this user
    List result = user!.activities.where((a) => a == policyForumId).toList();
    if (result.isEmpty) {
      // add the policyId or forumId not the activityId as the two are essentially the same and it
      // makes it easier to find out if a particular user is serving in a forum or not
      user.activities.add(policyForumId);
      final resUser = await _userProfileRepository.updateUser(user);
    }
    state = false;
  }

  Stream<Activity?> getUserActivityByPolicyForumId(
      String policyForumId, String uid) {
    return _activityRepository.getUserActivityByPolicyForumId(
        policyForumId, uid);
  }

  Stream<List<Activity>> getActivities(String uid) {
    return _activityRepository.getActivities(uid);
  }

  Stream<List<Activity>> getForumActivities(String uid) {
    return _activityRepository.getForumActivities(uid);
  }

  Stream<List<Activity>> getPolicyActivities(String uid) {
    return _activityRepository.getPolicyActivities(uid);
  }

  Stream<Activity> getActivityById(String activityId) {
    return _activityRepository.getActivityById(activityId);
  }
}
