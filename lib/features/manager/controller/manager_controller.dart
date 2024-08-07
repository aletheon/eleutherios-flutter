import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/repository/manager_repository.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/policy/repository/policy_repository.dart';
import 'package:reddit_tutorial/features/policy_activity/controller/policy_activity_controller.dart';
import 'package:reddit_tutorial/features/policy_activity/repository/policy_activity_repository.dart';
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

final getManagerByServiceIdProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(managerControllerProvider.notifier)
        .getManagerByServiceId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getManagerByServiceIdProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(managerControllerProvider.notifier)
        .getManagerByServiceId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
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

final getManagersByServiceIdProvider =
    StreamProvider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(managerControllerProvider.notifier)
      .getManagersByServiceId(serviceId);
});

final getManangersByServiceIdProvider2 =
    Provider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(managerControllerProvider.notifier)
      .getManagersByServiceId(serviceId);
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

final getUserSelectedManagerProvider2 = Provider.family((ref, Tuple2 params) {
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
  final policyActivityRepository = ref.watch(policyActivityRepositoryProvider);
  return ManagerController(
      managerRepository: managerRepository,
      policyRepository: policyRepository,
      userProfileRepository: userProfileRepository,
      policyActivityRepository: policyActivityRepository,
      ref: ref);
});

class ManagerController extends StateNotifier<bool> {
  final ManagerRepository _managerRepository;
  final PolicyRepository _policyRepository;
  final UserProfileRepository _userProfileRepository;
  final PolicyActivityRepository _policyActivityRepository;
  final Ref _ref;
  ManagerController(
      {required ManagerRepository managerRepository,
      required PolicyRepository policyRepository,
      required UserProfileRepository userProfileRepository,
      required PolicyActivityRepository policyActivityRepository,
      required Ref ref})
      : _policyRepository = policyRepository,
        _managerRepository = managerRepository,
        _userProfileRepository = userProfileRepository,
        _policyActivityRepository = policyActivityRepository,
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
      if (policy.services.contains(serviceId) == false) {
        final user = await _ref
            .read(authControllerProvider.notifier)
            .getUserData(service.uid)
            .first;
        final managerCount = await _ref
            .read(managerControllerProvider.notifier)
            .getUserManagerCount(policy.policyId, service.uid)
            .first;
        String managerId = const Uuid().v1().replaceAll('-', '');
        List<String> defaultPermissions = [
          ManagerPermissions.createrule.value,
          ManagerPermissions.removerule.value,
          ManagerPermissions.editrule.value
        ];

        if (policy.uid == service.uid) {
          defaultPermissions = [];
          defaultPermissions.add(ManagerPermissions.editpolicy.value);
          defaultPermissions.add(ManagerPermissions.createrule.value);
          defaultPermissions.add(ManagerPermissions.removerule.value);
          defaultPermissions.add(ManagerPermissions.editrule.value);
          defaultPermissions.add(ManagerPermissions.addmanager.value);
          defaultPermissions.add(ManagerPermissions.removemanager.value);
          defaultPermissions.add(ManagerPermissions.addconsumer.value);
          defaultPermissions.add(ManagerPermissions.removeconsumer.value);
          defaultPermissions
              .add(ManagerPermissions.editmanagerpermissions.value);
        }

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

        // add service to policy managers and service list
        policy.managers.add(managerId);
        policy.services.add(serviceId);
        await _policyRepository.updatePolicy(policy);

        // create new policy activity
        if (user!.policyActivities.contains(policyId) == false) {
          final policyActivityController =
              _ref.read(policyActivityControllerProvider.notifier);
          policyActivityController.createPolicyActivity(
              user.uid, policyId, policy.uid);

          // add activity to users policy activity list
          user.policyActivities.add(policyId);
          await _userProfileRepository.updateUser(user);

          state = false;
          res.fold((l) => showSnackBar(context, l.message, true), (r) {
            showSnackBar(context, 'Manager added successfully!', false);
          });
        } else {
          state = false;
          res.fold((l) => showSnackBar(context, l.message, true), (r) {
            showSnackBar(context, 'Manager added successfully!', false);
          });
        }
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(
              context, 'Service is already managing this policy', true);
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy or service does not exist', true);
      }
    }
  }

  void updateManager(
      {required Manager manager, required BuildContext context}) async {
    state = true;
    final managerRes = await _managerRepository.updateManager(manager);
    state = false;
    managerRes.fold((l) => showSnackBar(context, l.message, true), (r) {
      showSnackBar(context, 'Manager updated successfully!', false);
    });
  }

  void changedSelected(String managerId) async {
    // get manager
    Manager? manager = await _ref
        .read(managerControllerProvider.notifier)
        .getManagerById(managerId)
        .first;

    // get old manager and unselect it
    Manager? selectedManager = await _ref
        .read(managerControllerProvider.notifier)
        .getUserSelectedManager(manager!.policyId, manager.serviceUid)
        .first;

    selectedManager = selectedManager!.copyWith(selected: false);
    await _managerRepository.updateManager(selectedManager);

    manager = manager.copyWith(selected: true);
    await _managerRepository.updateManager(manager);
  }

  void deleteManager(
      String policyId, String managerId, BuildContext context) async {
    state = true;

    // get manager
    final manager = await _ref
        .read(managerControllerProvider.notifier)
        .getManagerById(managerId)
        .first;

    // get policy
    final policy = await _ref
        .watch(policyControllerProvider.notifier)
        .getPolicyById(policyId)
        .first;

    if (policy != null && manager != null) {
      // delete mananger
      final res = await _managerRepository.deleteManager(managerId);

      // get user
      final managerUser = await _ref
          .read(authControllerProvider.notifier)
          .getUserData(manager.serviceUid)
          .first;

      // update policy
      policy.managers.remove(managerId);
      policy.services.remove(manager.serviceId);
      await _policyRepository.updatePolicy(policy);

      // get this users manager count
      final managerCount = await _ref
          .read(managerControllerProvider.notifier)
          .getUserManagerCount(policyId, managerUser!.uid)
          .first;

      // remove policy activity if no user managers are left
      if (managerCount == 0) {
        // get policy activity
        final policyActivity = await _ref
            .read(policyActivityControllerProvider.notifier)
            .getPolicyActivityByUserId(policyId, manager.serviceUid)
            .first;

        if (policyActivity != null) {
          // now remove it
          await _policyActivityRepository
              .deletePolicyActivity(policyActivity.policyActivityId);

          // remove the activity from the users policy activity list
          managerUser.policyActivities.remove(policyId);
          await _userProfileRepository.updateUser(managerUser);
        }
      } else {
        // set next available manager as default
        if (manager.selected) {
          // get the rest of the users managers
          final userManagers = await _ref
              .read(managerControllerProvider.notifier)
              .getUserManagers(policyId, managerUser.uid)
              .first;

          userManagers[0] = userManagers[0].copyWith(selected: true);
          await _managerRepository.updateManager(userManagers[0]);
        }
      }
      state = false;
      res.fold((l) => showSnackBar(context, l.message, true), (r) {
        if (context.mounted) {
          showSnackBar(context, 'Manager deleted successfully!', false);
        }
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy or manager does not exist', true);
      }
    }
  }

  Future<int?> getManagersByServiceIdCount(String serviceId) {
    state = true;
    return _managerRepository.getManagersByServiceIdCount(serviceId).then(
      (value) {
        state = false;
        return value;
      },
    );
  }

  Future<int?> getManagerCount(String policyId) {
    state = true;
    return _managerRepository.getManagerCount(policyId).then(
      (value) {
        state = false;
        return value;
      },
    );
  }

  Future<void> deleteManagersByPoliceId(String policyId) {
    return _managerRepository.deleteManagersByPoliceId(policyId);
  }

  Stream<List<Manager>> getManagers(String policyId) {
    return _managerRepository.getManagers(policyId);
  }

  Stream<List<Manager>> getUserManagers(String policyId, String uid) {
    return _managerRepository.getUserManagers(policyId, uid);
  }

  Stream<List<Manager>> getManagersByServiceId(String serviceId) {
    return _managerRepository.getManagersByServiceId(serviceId);
  }

  Stream<int> getUserManagerCount(String policyId, String uid) {
    return _managerRepository.getUserManagerCount(policyId, uid);
  }

  Stream<Manager?> getUserSelectedManager(String policyId, String uid) {
    return _managerRepository.getUserSelectedManager(policyId, uid);
  }

  Stream<Manager?> getManagerById(String managerId) {
    return _managerRepository.getManagerById(managerId);
  }

  Stream<Manager?> getManagerByServiceId(String policyId, String serviceId) {
    return _managerRepository.getManagerByServiceId(policyId, serviceId);
  }
}
