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
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class RemoveRuleScreen extends ConsumerStatefulWidget {
  final String policyId;
  const RemoveRuleScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveRuleScreenState();
}

class _RemoveRuleScreenState extends ConsumerState<RemoveRuleScreen> {
  final GlobalKey _scaffold = GlobalKey();
  void removeRule(WidgetRef ref, String ruleId) {
    ref
        .read(ruleControllerProvider.notifier)
        .deleteRule(widget.policyId, ruleId, _scaffold.currentContext!);
  }

  void showRuleDetails(BuildContext context, String ruleId) {
    Routemaster.of(context).push(ruleId);
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy != null) {
      if (policy.uid != user.uid) {
        if (manager != null) {
          if (manager.permissions
                  .contains(ManagerPermissions.removerule.value) ==
              false) {
            Future.delayed(Duration.zero, () {
              showSnackBar(
                  context,
                  'You do not have permission to remove a rule from this policy',
                  true);
              Routemaster.of(context).pop();
            });
          }
        } else {
          Future.delayed(Duration.zero, () {
            showSnackBar(context, 'Manager does not exist', true);
            Routemaster.of(context).pop();
          });
        }
      }
    } else {
      Future.delayed(Duration.zero, () {
        showSnackBar(context, 'Policy does not exist', true);
        Routemaster.of(context).pop();
      });
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
    final rulesProv = ref.watch(getRulesProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (forum) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Rule',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: rulesProv.when(
            data: (rules) {
              if (rules.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'No rules',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: rules.length,
                    itemBuilder: (BuildContext context, int index) {
                      final rule = rules[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    rule.title,
                                    textWidthBasis: TextWidthBasis.longestLine,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                rule.public
                                    ? const Icon(
                                        Icons.lock_open_outlined,
                                        size: 18,
                                      )
                                    : const Icon(Icons.lock_outlined,
                                        size: 18, color: Pallete.greyColor),
                              ],
                            ),
                            leading: rule.image == Constants.avatarDefault
                                ? CircleAvatar(
                                    backgroundImage:
                                        Image.asset(rule.image).image,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(rule.image),
                                  ),
                            trailing: TextButton(
                              onPressed: () => removeRule(ref, rule.ruleId),
                              child: const Text(
                                'Remove',
                              ),
                            ),
                            onTap: () => showRuleDetails(context, rule.ruleId),
                          ),
                          rule.tags.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, right: 20, left: 10),
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    direction: Axis.horizontal,
                                    children: rule.tags.map((e) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: FilterChip(
                                          visualDensity: const VisualDensity(
                                              vertical: -4, horizontal: -4),
                                          onSelected: (value) {},
                                          backgroundColor:
                                              Pallete.forumTagColor,
                                          label: Text(
                                            '#$e',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(),
                        ],
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
