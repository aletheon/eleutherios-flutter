import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class ManagerPermissionsScreen extends ConsumerStatefulWidget {
  final String policyId;
  const ManagerPermissionsScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerPermissionsScreenState();
}

class _ManagerPermissionsScreenState
    extends ConsumerState<ManagerPermissionsScreen> {
  void editPermissions(BuildContext context, WidgetRef ref, String managerId) {
    Routemaster.of(context).push('edit/$managerId');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy!.uid != user.uid) {
      if (manager!.permissions
              .contains(ManagerPermissions.editmanagerpermissions.name) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to manager permissions');
          Routemaster.of(context).pop();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final managersProv = ref.watch(getManagersProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (policy) {
        return Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Manager Permissions',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: managersProv.when(
            data: (managers) {
              if (managers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'No managers',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: managers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final manager = managers[index];

                      return ref
                          .watch(getServiceByIdProvider(manager.serviceId))
                          .when(
                            data: (service) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(service!.title),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Wrap(
                                    children: [
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .editpolicy.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .addmanager.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.handyman,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .removemanager.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.handyman,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .createrule.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.account_balance,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .editrule.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .removerule.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.account_balance,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .addpotentialmember
                                                      .name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.construction,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .removepotentialmember
                                                      .name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.construction,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .editpotentialmemberpermissions
                                                      .name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.auto_fix_high,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .addconsumer.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .miscellaneous_services,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .removeconsumer.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .miscellaneous_services,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      manager.permissions.contains(
                                                  ManagerPermissions
                                                      .editmanagerpermissions
                                                      .name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.auto_fix_normal,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                leading: service.image ==
                                        Constants.avatarDefault
                                    ? CircleAvatar(
                                        backgroundImage:
                                            Image.asset(service.image).image,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(service.image),
                                      ),
                                trailing: TextButton(
                                  onPressed: () => editPermissions(
                                    context,
                                    ref,
                                    manager.managerId,
                                  ),
                                  child: const Text(
                                    'Edit',
                                  ),
                                ),
                                onTap: () => showServiceDetails(
                                    context, service.serviceId),
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    },
                  ),
                );
              }
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
