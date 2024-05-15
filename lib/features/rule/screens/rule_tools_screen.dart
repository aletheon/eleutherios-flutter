import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
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

  void addMember(BuildContext context) {
    Routemaster.of(context).push('add-rule-member');
  }

  void removeMember(BuildContext context) {
    Routemaster.of(context).push('remove-rule-member');
  }

  void potentialMemberPermissions(BuildContext context) {
    Routemaster.of(context).push('potential-member-permissions');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;

    if (policy!.uid != user.uid) {
      if (user.policyActivities.contains(widget.policyId) == false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to this rule');
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

    return ref.watch(getRuleByIdProvider(widget.ruleId)).when(
          data: (rule) {
            return Scaffold(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Tools for ${rule!.title}',
                  softWrap: true,
                  maxLines: 5,
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
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
                                            ManagerPermissions.editrule.name)
                                    ? ListTile(
                                        onTap: () => editRule(context),
                                        leading: const Icon(
                                            Icons.edit_note_outlined),
                                        title: const Text('Edit Rule'),
                                      )
                                    : const SizedBox(),
                                user.uid == policy.uid ||
                                        manager!.permissions.contains(
                                            ManagerPermissions
                                                .addpotentialmember.name)
                                    ? ListTile(
                                        onTap: () => addMember(context),
                                        leading: const Icon(
                                            Icons.add_circle_outline),
                                        title:
                                            const Text('Add Potential Member'),
                                      )
                                    : const SizedBox(),
                                user.uid == policy.uid ||
                                        manager!.permissions.contains(
                                            ManagerPermissions
                                                .removepotentialmember.name)
                                    ? ListTile(
                                        onTap: () => removeMember(context),
                                        leading: const Icon(
                                            Icons.remove_circle_outline),
                                        title: const Text(
                                            'Remove Potential Member'),
                                      )
                                    : const SizedBox(),
                                user.uid == policy.uid ||
                                        manager!.permissions.contains(
                                            ManagerPermissions
                                                .editpotentialmemberpermissions
                                                .name)
                                    ? ListTile(
                                        onTap: () =>
                                            potentialMemberPermissions(context),
                                        leading:
                                            const Icon(Icons.list_alt_outlined),
                                        title: const Text(
                                            'Potential Member Permissions'),
                                      )
                                    : const SizedBox(),
                              ]);
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
