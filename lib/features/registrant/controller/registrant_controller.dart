import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/activity/controller/activity_controller.dart';
import 'package:reddit_tutorial/features/activity/repository/activity_repository.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/registrant/repository/registrant_repository.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/registrant.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getRegistrantByIdProvider =
    StreamProvider.family.autoDispose((ref, String registrantId) {
  return ref
      .watch(registrantControllerProvider.notifier)
      .getRegistrantById(registrantId);
});

final serviceIsRegisteredInForumProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(registrantControllerProvider.notifier)
      .serviceIsRegisteredInForum(params.item1, params.item2);
});

final getRegistrantsProvider =
    StreamProvider.family.autoDispose((ref, String forumId) {
  return ref
      .watch(registrantControllerProvider.notifier)
      .getRegistrants(forumId);
});

final getUserRegistrantsProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(registrantControllerProvider.notifier)
      .getUserRegistrants(params.item1, params.item2);
});

final getUserRegistrantCountProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(registrantControllerProvider.notifier)
      .getUserRegistrantCount(params.item1, params.item2);
});

final getUserSelectedRegistrantProvider =
    StreamProvider.family((ref, Tuple2 params) {
  try {
    return ref
        .watch(registrantControllerProvider.notifier)
        .getUserSelectedRegistrant(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getUserSelectedRegistrantProvider2 =
    Provider.family((ref, Tuple2 params) {
  try {
    return ref
        .watch(registrantControllerProvider.notifier)
        .getUserSelectedRegistrant(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final registrantControllerProvider =
    StateNotifierProvider<RegistrantController, bool>((ref) {
  final registrantRepository = ref.watch(registrantRepositoryProvider);
  final forumRepository = ref.watch(forumRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final activityRepository = ref.watch(activityRepositoryProvider);
  return RegistrantController(
      registrantRepository: registrantRepository,
      forumRepository: forumRepository,
      userProfileRepository: userProfileRepository,
      activityRepository: activityRepository,
      ref: ref);
});

class RegistrantController extends StateNotifier<bool> {
  final RegistrantRepository _registrantRepository;
  final ForumRepository _forumRepository;
  final UserProfileRepository _userProfileRepository;
  final ActivityRepository _activityRepository;
  final Ref _ref;
  RegistrantController(
      {required RegistrantRepository registrantRepository,
      required ForumRepository forumRepository,
      required UserProfileRepository userProfileRepository,
      required ActivityRepository activityRepository,
      required Ref ref})
      : _forumRepository = forumRepository,
        _registrantRepository = registrantRepository,
        _userProfileRepository = userProfileRepository,
        _activityRepository = activityRepository,
        _ref = ref,
        super(false);

  void createRegistrant(
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
      final user = await _ref.read(getUserByIdProvider(service.uid)).first;
      final registrantCount = await _ref
          .read(registrantControllerProvider.notifier)
          .getUserRegistrantCount(forum.forumId, service.uid)
          .first;
      String registrantId = const Uuid().v1().replaceAll('-', '');
      List<String> defaultPermissions = [RegistrantPermissions.createpost.name];

      if (forum.uid == service.uid) {
        defaultPermissions.add(RegistrantPermissions.editforum.name);
        defaultPermissions.add(RegistrantPermissions.addservice.name);
        defaultPermissions.add(RegistrantPermissions.removeservice.name);
        defaultPermissions.add(RegistrantPermissions.createforum.name);
        defaultPermissions.add(RegistrantPermissions.removeforum.name);
        defaultPermissions.add(RegistrantPermissions.removepost.name);
        defaultPermissions.add(RegistrantPermissions.editpermissions.name);
      }

      // create registrant
      Registrant registrant = Registrant(
        registrantId: registrantId,
        forumId: forumId,
        forumUid: forum.uid,
        serviceId: serviceId,
        serviceUid: service.uid,
        selected: registrantCount == 0 ? true : false,
        permissions: defaultPermissions,
        lastUpdateDate: DateTime.now(),
        creationDate: DateTime.now(),
      );
      final res = await _registrantRepository.createRegistrant(registrant);

      // update forum
      forum.registrants.add(registrantId);
      final resForum = await _forumRepository.updateForum(forum);

      // create new forum activity
      if (user.activities.contains(forumId) == false) {
        final activityController =
            _ref.read(activityControllerProvider.notifier);
        activityController.createActivity(
            ActivityType.forum.name, user.uid, forumId, forum.uid);

        // add activity to users acitivity list
        user.activities.add(forumId);
        final resUser = await _userProfileRepository.updateUser(user);

        state = false;
        res.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Registrant added successfully!');
        });
      } else {
        state = false;
        res.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Registrant added successfully!');
        });
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Forum or service does not exist');
      }
    }
  }

  void updateRegistrant(
      {required Registrant registrant, required BuildContext context}) async {
    state = true;
    final registrantRes =
        await _registrantRepository.updateRegistrant(registrant);
    state = false;
    registrantRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Registrant updated successfully!');
    });
  }

  void changedSelected(String registrantId) async {
    // get registrant
    Registrant registrant = await _ref
        .read(registrantControllerProvider.notifier)
        .getRegistrantById(registrantId)
        .first;

    // get old registrant and unselect it
    Registrant? selectedRegistrant = await _ref
        .read(registrantControllerProvider.notifier)
        .getUserSelectedRegistrant(registrant.forumId, registrant.serviceUid)
        .first;

    selectedRegistrant = selectedRegistrant!.copyWith(selected: false);
    await _registrantRepository.updateRegistrant(selectedRegistrant);

    registrant = registrant.copyWith(selected: true);
    await _registrantRepository.updateRegistrant(registrant);
  }

  void deleteRegistrant(
      String forumId, String registrantId, BuildContext context) async {
    state = true;

    // get user
    final user = _ref.read(userProvider)!;

    // get registrant
    final registrant = await _ref
        .read(registrantControllerProvider.notifier)
        .getRegistrantById(registrantId)
        .first;

    // get forum
    final forum = await _ref
        .watch(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;

    // delete registrant
    final res = await _registrantRepository.deleteRegistrant(registrantId);

    // update forum
    forum!.registrants.remove(registrantId);
    await _forumRepository.updateForum(forum);

    // get this users registrant count
    final registrantCount = await _ref
        .read(registrantControllerProvider.notifier)
        .getUserRegistrantCount(forumId, user.uid)
        .first;

    // remove activity if no user registrants are left
    if (registrantCount == 0) {
      // get activity
      final activity = await _ref
          .read(activityControllerProvider.notifier)
          .getUserActivityByPolicyForumId(forumId, registrant.serviceUid)
          .first;

      // now remove it
      await _activityRepository.deleteActivity(activity.activityId);

      // remove the activity from the users activity list
      user.activities.remove(forumId);
      await _userProfileRepository.updateUser(user);
    } else {
      // set next available registrant as default
      if (registrant.selected) {
        // get the rest of the users registrants
        final userRegistrants = await _ref
            .read(registrantControllerProvider.notifier)
            .getUserRegistrants(forumId, user.uid)
            .first;

        userRegistrants[0] = userRegistrants[0].copyWith(selected: true);
        await _registrantRepository.updateRegistrant(userRegistrants[0]);
      }
    }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Registrant removed successfully!');
    });
  }

  Stream<List<Registrant>> getRegistrants(String forumId) {
    return _registrantRepository.getRegistrants(forumId);
  }

  Stream<List<Registrant>> getUserRegistrants(String forumId, String uid) {
    return _registrantRepository.getUserRegistrants(forumId, uid);
  }

  Stream<bool> serviceIsRegisteredInForum(String forumId, String serviceId) {
    return _registrantRepository.serviceIsRegisteredInForum(forumId, serviceId);
  }

  Stream<int> getUserRegistrantCount(String forumId, String uid) {
    return _registrantRepository.getUserRegistrantCount(forumId, uid);
  }

  Stream<Registrant?> getUserSelectedRegistrant(String forumId, String uid) {
    return _registrantRepository.getUserSelectedRegistrant(forumId, uid);
  }

  Stream<Registrant> getRegistrantById(String registrantId) {
    return _registrantRepository.getRegistrantById(registrantId);
  }
}
