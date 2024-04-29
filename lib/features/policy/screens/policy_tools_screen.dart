import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class PolicyToolsScreen extends ConsumerStatefulWidget {
  final String policyId;
  const PolicyToolsScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PolicyToolsScreenState();
}

class _PolicyToolsScreenState extends ConsumerState<PolicyToolsScreen> {
  void editPolicy(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  // void viewPolicy(BuildContext context) {
  //   Routemaster.of(context).push('/policy/${widget.policyId}/view');
  // }

  void addManager(BuildContext context) {
    Routemaster.of(context).push('add-manager');
  }

  void removeManager(BuildContext context) {
    Routemaster.of(context).push('remove-manager');
  }

  void createRule(BuildContext context) {
    Routemaster.of(context).push('create-rule');
  }

  void removeRule(BuildContext context) {
    Routemaster.of(context).push('remove-rule');
  }

  void addConsumer(BuildContext context) {
    Routemaster.of(context).push('add-consumer');
  }

  void removeConsumer(BuildContext context) {
    Routemaster.of(context).push('remove-consumer');
  }

  void managerPermissions(BuildContext context) {
    Routemaster.of(context).push('manager-permissions');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;

    if (policy!.uid != user.uid) {
      if (user.activities.contains(widget.policyId) == false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to this policy');
          Routemaster.of(context).pop();
        });
      }
    }
  }

  // ************************************************************************
  // ************************************************************************
  // HERE ROB HAVE TO ENABLE PERSON WHO CREATED POLICY THE ABILITY TO
  // JOIN THE POLICY AS A MANAGER - I.E. ADD A JOIN BUTTON, LEAVE BUTTON
  // ************************************************************************
  // ************************************************************************

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Policy Tools',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
        // actions: [
        //   ref
        //       .watch(getUserManagerCountProvider(
        //           Tuple2(widget.policyId, user.uid)))
        //       .when(
        //         data: (count) {
        //           if (count > 0) {
        //             return TextButton(
        //               onPressed: () => viewPolicy(context),
        //               child: const Text(
        //                 'View',
        //                 style: TextStyle(
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //             );
        //           } else {
        //             return const SizedBox();
        //           }
        //         },
        //         error: (error, stackTrace) =>
        //             ErrorText(error: error.toString()),
        //         loading: () => const Loader(),
        //       ),
        // ],
      ),
      body: ref.watch(getPolicyByIdProvider(widget.policyId)).when(
            data: (policy) {
              return ref
                  .watch(getUserSelectedManagerProvider(
                      Tuple2(widget.policyId, user.uid)))
                  .when(
                    data: (manager) {
                      return Column(children: [
                        user.uid == policy!.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.editpolicy.name)
                            ? ListTile(
                                onTap: () => editPolicy(context),
                                leading: const Icon(Icons.edit_note_outlined),
                                title: const Text('Edit Policy'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.createrule.name)
                            ? ListTile(
                                onTap: () => createRule(context),
                                leading: const Icon(Icons.add_circle_outline),
                                title: const Text('Create Rule'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.removerule.name)
                            ? ListTile(
                                onTap: () => removeRule(context),
                                leading:
                                    const Icon(Icons.remove_circle_outline),
                                title: const Text('Remove Rule'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.addmanager.name)
                            ? ListTile(
                                onTap: () => addManager(context),
                                leading:
                                    const Icon(Icons.add_moderator_outlined),
                                title: const Text('Add Manager'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.removemanager.name)
                            ? ListTile(
                                onTap: () => removeManager(context),
                                leading:
                                    const Icon(Icons.remove_moderator_outlined),
                                title: const Text('Remove Manager'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.addconsumer.name)
                            ? ListTile(
                                onTap: () => addConsumer(context),
                                leading:
                                    const Icon(Icons.add_moderator_outlined),
                                title: const Text('Add Consumer'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.removeconsumer.name)
                            ? ListTile(
                                onTap: () => removeConsumer(context),
                                leading:
                                    const Icon(Icons.remove_moderator_outlined),
                                title: const Text('Remove Consumer'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.editpermissions.name)
                            ? ListTile(
                                onTap: () => managerPermissions(context),
                                leading: const Icon(Icons.list_alt_outlined),
                                title: const Text('Manager Permissions'),
                              )
                            : const SizedBox(),
                      ]);
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
