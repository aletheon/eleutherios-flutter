import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/activity/controller/activity_controller.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/repository/manager_repository.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/manager.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getManagerByIdProvider =
    StreamProvider.family.autoDispose((ref, String managerId) {
  return ref
      .watch(managerControllerProvider.notifier)
      .getManagerById(managerId);
});

final policyIsRegisteredInServiceProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(managerControllerProvider.notifier)
      .policyIsRegisteredInService(params.item1, params.item2);
});

final getManagersProvider =
    StreamProvider.family.autoDispose((ref, String policyId) {
  return ref.watch(managerControllerProvider.notifier).getManagers(policyId);
});

final getUserManagersProvider =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(managerControllerProvider.notifier)
        .getUserManagers(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getUserManagerCountProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(managerControllerProvider.notifier)
      .getUserManagerCount(params.item1, params.item2);
});

final getUserSelectedManagerProvider =
    StreamProvider.family((ref, Tuple2 params) {
  try {
    return ref
        .watch(managerControllerProvider.notifier)
        .getUserSelectedManager(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final managerControllerProvider =
    StateNotifierProvider<ManagerController, bool>((ref) {
  final managerRepository = ref.watch(managerRepositoryProvider);
  final policyRepository = ref.watch(policyRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return ManagerController(
      managerRepository: managerRepository,
      policyRepository: policyRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class ManagerController extends StateNotifier<bool> {
  final ManagerRepository _managerRepository;
  final PolicyRepository _policyRepository;
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  ManagerController(
      {required ManagerRepository managerRepository,
      required PolicyRepository policyRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _policyRepository = policyRepository,
        _managerRepository = managerRepository,
        _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void createManager(
    String policyId,
    String serviceId,
    BuildContext context,
  ) async {
    state = true;
    Policy? policy = await _ref
        .read(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    // ensure policy and service exist
    if (policy != null && service != null) {
      // ensure service is not already a manager
      if (policy.managers.contains(serviceId) == false) {
        final user = await _ref.read(getUserByIdProvider(service.uid)).first;
        final managerCount = await _ref
            .read(managerControllerProvider.notifier)
            .getUserManagerCount(policy.policyId, service.uid)
            .first;
        String managerId = const Uuid().v1().replaceAll('-', '');
        List<String> defaultPermissions = [
          ManagerPermissions.addmanager.name,
          ManagerPermissions.removemanager.name,
          ManagerPermissions.addconsumer.name,
          ManagerPermissions.removeconsumer.name,
          ManagerPermissions.addrule.name,
          ManagerPermissions.removerule.name,
        ];

        // create manager
        Manager manager = Manager(
          managerId: managerId,
          policyId: policyId,
          policyUid: policy.uid,
          serviceId: serviceId,
          serviceUid: service.uid,
          selected: managerCount == 0 ? true : false,
          permissions: defaultPermissions,
          lastUpdateDate: DateTime.now(),
          creationDate: DateTime.now(),
        );
        final res = await _managerRepository.createManager(manager);

        // add service to policy managers list
        policy.managers.add(serviceId);
        final resPolicy = await _policyRepository.updatePolicy(policy);

        // create new forum activity
        if (user.activities.contains(policyId) == false) {
          final activityController =
              _ref.read(activityControllerProvider.notifier);
          activityController.createActivity(
              ActivityType.policy.name, user.uid, policyId, policy.uid);

          // add activity to users acitivity list
          user.activities.add(policyId);
          final resUser = await _userProfileRepository.updateUser(user);
        }
        state = false;
        res.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Manager added successfully!');
        });
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(context, 'Service is already managing this policy');
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy or service does not exist');
      }
    }
  }

  void updateManager(Manager manager) async {
    await _managerRepository.updateManager(manager);
  }

  void deleteManager(
      String policyId, String managerId, BuildContext context) async {
    state = true;

    // get user
    final user = _ref.read(userProvider)!;

    // get policy
    final policy = await _ref
        .watch(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    // delete manager
    final res = await _managerRepository.deleteManager(managerId);

    // update policy
    policy!.managers.remove(policyId);
    await _policyRepository.updatePolicy(policy);

    // update user
    final managersProv = await _ref
        .read(getUserManagersProvider(Tuple2(policyId, user.uid)))
        .first;

    // remove activity if no user managers are serving in policy
    if (managersProv.isEmpty) {
      user.activities.remove(policyId);
      await _userProfileRepository.updateUser(user);
    }
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Manager removed successfully!');
    });
  }

  Stream<List<Manager>> getManagers(String policyId) {
    return _managerRepository.getManagers(policyId);
  }

  Stream<bool> policyIsRegisteredInService(String policyId, String serviceId) {
    return _managerRepository.policyIsRegisteredInService(policyId, serviceId);
  }

  Stream<List<Manager>> getUserManagers(String policyId, String uid) {
    return _managerRepository.getUserManagers(policyId, uid);
  }

  Stream<Manager> getManagerById(String managerId) {
    return _managerRepository.getManagerById(managerId);
  }

  Stream<int> getUserManagerCount(String policyId, String uid) {
    return _managerRepository.getUserManagerCount(policyId, uid);
  }

  Stream<Manager> getUserSelectedManager(String policyId, String uid) {
    return _managerRepository.getUserSelectedManager(policyId, uid);
  }
}
