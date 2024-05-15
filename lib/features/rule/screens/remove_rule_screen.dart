import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class RemoveRuleScreen extends ConsumerStatefulWidget {
  final String policyId;
  const RemoveRuleScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveRuleScreenState();
}

class _RemoveRuleScreenState extends ConsumerState<RemoveRuleScreen> {
  void removeRule(BuildContext context, WidgetRef ref, String ruleId) {
    ref
        .read(ruleControllerProvider.notifier)
        .deleteRule(widget.policyId, ruleId, context);
  }

  void showRuleDetails(BuildContext context, String ruleId) {
    Routemaster.of(context).push(ruleId);
  }

  @override
  Widget build(BuildContext context) {
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final rulesProv = ref.watch(getRulesProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (forum) {
        return Scaffold(
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

                      return ListTile(
                        title: Text(
                          rule!.title,
                          textWidthBasis: TextWidthBasis.longestLine,
                        ),
                        leading: rule.image == Constants.avatarDefault
                            ? CircleAvatar(
                                backgroundImage: Image.asset(rule.image).image,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(rule.image),
                              ),
                        trailing: TextButton(
                          onPressed: () => removeRule(
                            context,
                            ref,
                            rule.ruleId,
                          ),
                          child: const Text(
                            'Remove',
                          ),
                        ),
                        onTap: () => showRuleDetails(context, rule.ruleId),
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
