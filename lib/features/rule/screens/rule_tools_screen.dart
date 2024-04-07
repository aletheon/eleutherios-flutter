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

class RuleToolsScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  const RuleToolsScreen(
      {super.key, required this.policyId, required this.ruleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RuleToolsScreenState();
}

class _RuleToolsScreenState extends ConsumerState<RuleToolsScreen> {
  void editRule(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void viewPolicy(BuildContext context) {
    Routemaster.of(context).push('/policy/${widget.policyId}/view');
  }

  void addMember(BuildContext context) {
    Routemaster.of(context).push('add-member');
  }

  void removeMember(BuildContext context) {
    Routemaster.of(context).push('remove-member');
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
          'Rule Tools',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
        actions: [
          ref
              .watch(getUserManagerCountProvider(
                  Tuple2(widget.policyId, user.uid)))
              .when(
                data: (count) {
                  if (count > 0) {
                    return TextButton(
                      onPressed: () => viewPolicy(context),
                      child: const Text(
                        'View',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
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
                                manager!.permissions
                                    .contains(ManagerPermissions.editrule.name)
                            ? ListTile(
                                onTap: () => editRule(context),
                                leading: const Icon(Icons.edit_note_outlined),
                                title: const Text('Edit Rule'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.createrule.name)
                            ? ListTile(
                                onTap: () => addMember(context),
                                leading: const Icon(Icons.add_circle_outline),
                                title: const Text('Add Member'),
                              )
                            : const SizedBox(),
                        user.uid == policy.uid ||
                                manager!.permissions.contains(
                                    ManagerPermissions.removerule.name)
                            ? ListTile(
                                onTap: () => removeMember(context),
                                leading:
                                    const Icon(Icons.remove_circle_outline),
                                title: const Text('Remove Member'),
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
