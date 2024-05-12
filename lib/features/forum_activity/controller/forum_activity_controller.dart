import 'package:reddit_tutorial/features/forum_activity/repository/forum_activity_repository.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final getForumActivityByIdProvider =
    Provider.family((ref, String forumActivityId) {
  final forumActivityRepository = ref.watch(forumActivityRepositoryProvider);
  return forumActivityRepository.getForumActivityById(forumActivityId);
});

final forumActivitiesProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(forumActivityControllerProvider.notifier)
      .getForumActivities(uid);
});

final forumActivityControllerProvider =
    StateNotifierProvider<ForumActivityController, bool>((ref) {
  final forumActivityRepository = ref.watch(forumActivityRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return ForumActivityController(
      forumActivityRepository: forumActivityRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class ForumActivityController extends StateNotifier<bool> {
  final ForumActivityRepository _forumActivityRepository;
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  ForumActivityController(
      {required ForumActivityRepository forumActivityRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _forumActivityRepository = forumActivityRepository,
        _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void createForumActivity(String uid, String forumId, String forumUid) async {
    state = true;
    final user = await _ref.watch(getUserByIdProvider(uid)).first;
    String forumActivityId = const Uuid().v1().replaceAll('-', '');

    ForumActivity forumActivity = ForumActivity(
      forumActivityId: forumActivityId,
      uid: uid,
      forumId: forumId,
      forumUid: forumUid,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res =
        await _forumActivityRepository.createForumActivity(forumActivity);

    // create a forumActivity for this user
    List result = user!.forumActivities.where((a) => a == forumId).toList();
    if (result.isEmpty) {
      // add the forumId not the activityId as it makes it easier to find out if a particular user is serving in a forum or not
      user.forumActivities.add(forumId);
      final resUser = await _userProfileRepository.updateUser(user);
    }
    state = false;
  }

  Stream<ForumActivity?> getUserForumActivityByForumId(
      String forumId, String uid) {
    return _forumActivityRepository.getUserActivityByForumId(forumId, uid);
  }

  Stream<List<ForumActivity>> getForumActivities(String uid) {
    return _forumActivityRepository.getForumActivities(uid);
  }

  Stream<ForumActivity> getForumActivityById(String forumActivityId) {
    return _forumActivityRepository.getForumActivityById(forumActivityId);
  }
}
