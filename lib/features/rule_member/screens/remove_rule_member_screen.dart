import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class RemoveRuleMemberScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  const RemoveRuleMemberScreen(
      {super.key, required this.policyId, required this.ruleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveRuleMemberScreenState();
}

class _RemoveRuleMemberScreenState
    extends ConsumerState<RemoveRuleMemberScreen> {
  void removeRuleMemberService(
      BuildContext context, WidgetRef ref, String ruleId, String ruleMemberId) {
    ref
        .read(ruleMemberControllerProvider.notifier)
        .deleteRuleMember(ruleId, ruleMemberId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  @override
  Widget build(BuildContext context) {
    final ruleProv = ref.watch(getRuleByIdProvider(widget.ruleId));
    final ruleMembersProv = ref.watch(getRuleMembersProvider(widget.ruleId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return ruleProv.when(
      data: (rule) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Member',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: ruleMembersProv.when(
            data: (ruleMembers) {
              if (ruleMembers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'No members',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: ruleMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ruleMember = ruleMembers[index];

                      return ref
                          .watch(getServiceByIdProvider(ruleMember.serviceId))
                          .when(
                            data: (service) {
                              return ListTile(
                                title: Text(
                                  service!.title,
                                  textWidthBasis: TextWidthBasis.longestLine,
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
                                  onPressed: () => removeRuleMemberService(
                                    context,
                                    ref,
                                    rule!.ruleId,
                                    ruleMember.ruleMemberId,
                                  ),
                                  child: const Text(
                                    'Remove',
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
