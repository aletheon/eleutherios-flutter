import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final managersProv = ref.watch(getManagersProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (policy) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                    .editpermissions.name) ==
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.lock,
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
                              leading: service.image == Constants.avatarDefault
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
