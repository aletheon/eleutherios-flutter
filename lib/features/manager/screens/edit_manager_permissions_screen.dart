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
import 'package:reddit_tutorial/models/manager.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class EditManagerPermissionsScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String managerId;
  const EditManagerPermissionsScreen(
      {super.key, required this.policyId, required this.managerId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditManagerPermissionsScreenState();
}

class _EditManagerPermissionsScreenState
    extends ConsumerState<EditManagerPermissionsScreen> {
  final GlobalKey _scaffold = GlobalKey();
  void save(Manager manager, List<String> permissions) {
    manager = manager.copyWith(permissions: permissions);
    ref
        .read(managerControllerProvider.notifier)
        .updateManager(manager: manager, context: _scaffold.currentContext!);
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
    final isLoading = ref.watch(managerControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    List<String> permissions = [];

    return ref.watch(getManagerByIdProvider(widget.managerId)).when(
          data: (manager) {
            permissions = manager!.permissions;
            return ref.watch(getServiceByIdProvider(manager.serviceId)).when(
                  data: (service) {
                    return Scaffold(
                      key: _scaffold,
                      appBar: AppBar(
                        title: Text(
                          'Edit Manager Permissions',
                          style: TextStyle(
                            color: currentTheme.textTheme.bodyMedium!.color!,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => {
                              save(manager, permissions),
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                      body: isLoading
                          ? const Loader()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      service!.image == Constants.avatarDefault
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  Image.asset(service.image)
                                                      .image,
                                              radius: 25,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(service.image),
                                              radius: 25,
                                            ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          service.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount:
                                          ManagerPermissions.values.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final permission =
                                            ManagerPermissions.values[index];
                                        List<Widget> _icons = [];

                                        switch (permission.name) {
                                          case 'editpolicy':
                                            _icons.add(
                                              const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'addmanager':
                                            _icons.add(
                                              const Icon(
                                                Icons.handyman,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'removemanager':
                                            _icons.add(
                                              const Icon(
                                                Icons.handyman,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'createrule':
                                            _icons.add(
                                              const Icon(
                                                Icons.account_balance,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'editrule':
                                            _icons.add(
                                              const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'removerule':
                                            _icons.add(
                                              const Icon(
                                                Icons.account_balance,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'addpotentialmember':
                                            _icons.add(
                                              const Icon(
                                                Icons.construction,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'removepotentialmember':
                                            _icons.add(
                                              const Icon(
                                                Icons.construction,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'editpotentialmemberpermissions':
                                            _icons.add(
                                              const Icon(
                                                Icons.auto_fix_high,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'addconsumer':
                                            _icons.add(
                                              const Icon(
                                                Icons.miscellaneous_services,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'removeconsumer':
                                            _icons.add(
                                              const Icon(
                                                Icons.miscellaneous_services,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            _icons.add(
                                              const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'editmanagerpermissions':
                                            _icons.add(
                                              const Icon(
                                                Icons.auto_fix_normal,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          default:
                                            _icons.add(
                                              const Icon(
                                                Icons.lock,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                        }

                                        final permissionIcon = CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Pallete.greyColor,
                                          child: CircleAvatar(
                                            radius: 13,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: _icons,
                                            ),
                                          ),
                                        );

                                        return CheckboxListTile(
                                          secondary: permissionIcon,
                                          title: Text(permission.value),
                                          value: permissions
                                                  .contains(permission.name)
                                              ? true
                                              : false,
                                          onChanged: (isChecked) {
                                            setState(() {
                                              if (isChecked!) {
                                                permissions
                                                    .add(permission.name);
                                              } else {
                                                permissions
                                                    .remove(permission.name);
                                              }
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          activeColor: Pallete.policyColor,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
