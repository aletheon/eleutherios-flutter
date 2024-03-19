import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class PolicyToolsScreen extends ConsumerWidget {
  final String policyId;
  const PolicyToolsScreen({super.key, required this.policyId});

  void editPolicy(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void addConsumer(BuildContext context) {
    Routemaster.of(context).push('add-consumer');
  }

  void removeConsumer(BuildContext context) {
    Routemaster.of(context).push('remove-consumer');
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ),
      body: ref.watch(getPolicyByIdProvider(policyId)).when(
            data: (policy) {
              if (policy!.uid == user.uid) {
                return Column(children: [
                  ListTile(
                    onTap: () => editPolicy(context),
                    leading: const Icon(Icons.edit_note_outlined),
                    title: const Text('Edit Policy'),
                  ),
                  ListTile(
                    onTap: () => createRule(context),
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Create Rule'),
                  ),
                  ListTile(
                    onTap: () => removeRule(context),
                    leading: const Icon(Icons.remove_circle_outline),
                    title: const Text('Remove Rule'),
                  ),
                  ListTile(
                    onTap: () => addManager(context),
                    leading: const Icon(Icons.add_moderator_outlined),
                    title: const Text('Add Manager'),
                  ),
                  ListTile(
                    onTap: () => removeManager(context),
                    leading: const Icon(Icons.remove_moderator_outlined),
                    title: const Text('Remove Manager'),
                  ),
                  ListTile(
                    onTap: () => addConsumer(context),
                    leading: const Icon(Icons.add_moderator_outlined),
                    title: const Text('Add Consumer'),
                  ),
                  ListTile(
                    onTap: () => removeConsumer(context),
                    leading: const Icon(Icons.remove_moderator_outlined),
                    title: const Text('Remove Consumer'),
                  ),
                ]);
              } else {
                if (user.activities.contains(policyId)) {
                  return ref
                      .watch(getUserSelectedManagerProvider(
                          Tuple2(policyId, user.uid)))
                      .when(
                        data: (manager) {
                          return Column(children: [
                            manager.permissions.contains(
                                    ManagerPermissions.editpolicy.name)
                                ? ListTile(
                                    onTap: () => editPolicy(context),
                                    leading:
                                        const Icon(Icons.edit_note_outlined),
                                    title: const Text('Edit Policy'),
                                  )
                                : const SizedBox(),
                            manager.permissions
                                    .contains(ManagerPermissions.addrule.name)
                                ? ListTile(
                                    onTap: () => createRule(context),
                                    leading:
                                        const Icon(Icons.add_circle_outline),
                                    title: const Text('Create Rule'),
                                  )
                                : const SizedBox(),
                            manager.permissions
                                    .contains(ManagerPermissions.addrule.name)
                                ? ListTile(
                                    onTap: () => removeRule(context),
                                    leading:
                                        const Icon(Icons.remove_circle_outline),
                                    title: const Text('Remove Rule'),
                                  )
                                : const SizedBox(),
                            manager.permissions.contains(
                                    ManagerPermissions.addmanager.name)
                                ? ListTile(
                                    onTap: () => addManager(context),
                                    leading: const Icon(
                                        Icons.add_moderator_outlined),
                                    title: const Text('Add Manager'),
                                  )
                                : const SizedBox(),
                            manager.permissions.contains(
                                    ManagerPermissions.removemanager.name)
                                ? ListTile(
                                    onTap: () => removeManager(context),
                                    leading: const Icon(
                                        Icons.remove_moderator_outlined),
                                    title: const Text('Remove Manager'),
                                  )
                                : const SizedBox(),
                            manager.permissions.contains(
                                    ManagerPermissions.addconsumer.name)
                                ? ListTile(
                                    onTap: () => addConsumer(context),
                                    leading: const Icon(
                                        Icons.add_moderator_outlined),
                                    title: const Text('Add Consumer'),
                                  )
                                : const SizedBox(),
                            manager.permissions.contains(
                                    ManagerPermissions.removeconsumer.name)
                                ? ListTile(
                                    onTap: () => removeConsumer(context),
                                    leading: const Icon(
                                        Icons.remove_moderator_outlined),
                                    title: const Text('Remove Consumer'),
                                  )
                                : const SizedBox(),
                          ]);
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                } else {
                  if (policy.public) {
                    return Column(children: [
                      ListTile(
                        onTap: () => addManager(context),
                        leading: const Icon(Icons.add_moderator_outlined),
                        title: const Text('Add Manager'),
                      ),
                    ]);
                  } else {
                    return const SizedBox();
                  }
                }
              }
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
