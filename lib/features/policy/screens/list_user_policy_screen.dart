import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final GlobalKey _scaffold = GlobalKey();

class ListUserPolicyScreen extends ConsumerWidget {
  const ListUserPolicyScreen({super.key});

  void deletePolicy(BuildContext context, WidgetRef ref, Policy policy) async {
    final int? managerCount = await ref
        .read(managerControllerProvider.notifier)
        .getManagerCount(policy.policyId);

    if (policy.consumers.isNotEmpty || managerCount! > 0) {
      showDialog(
        context: _scaffold.currentContext!,
        barrierDismissible: true,
        builder: (context) {
          String message = "";

          if (policy.consumers.isNotEmpty && managerCount! > 0) {
            message +=
                "This policy has ${policy.consumers.length} service(s) consuming it and ";
            message += "$managerCount manager(s) serving in it.";
          } else if (policy.consumers.isNotEmpty) {
            message +=
                "This policy has ${policy.consumers.length} service(s) consuming it.";
          } else {
            message +=
                "This policy has $managerCount manager(s) serving in it.";
          }
          message += "  Are you sure you want to delete it?";

          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(policyControllerProvider.notifier).deletePolicy(
                        policy.uid,
                        policy.policyId,
                        _scaffold.currentContext!,
                      );

                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              )
            ],
          );
        },
      );
    } else {
      ref.read(policyControllerProvider.notifier).deletePolicy(
            policy.uid,
            policy.policyId,
            _scaffold.currentContext!,
          );
    }
  }

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push(policyId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(policyControllerProvider);
    final bool managerIsLoading = ref.watch(managerControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userPoliciesProvider).when(
          data: (policies) => Scaffold(
            key: _scaffold,
            appBar: AppBar(
              title: Text(
                'Policies(${policies.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                policies.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            "No policies",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: policies.length,
                          itemBuilder: (BuildContext context, int index) {
                            final policy = policies[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(policy.title),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      policy.public
                                          ? const Icon(
                                              Icons.lock_open_outlined,
                                              size: 18,
                                            )
                                          : const Icon(Icons.lock_outlined,
                                              size: 18,
                                              color: Pallete.greyColor),
                                    ],
                                  ),
                                  leading: policy.image ==
                                          Constants.avatarDefault
                                      ? CircleAvatar(
                                          backgroundImage:
                                              Image.asset(policy.image).image,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(policy.image),
                                        ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        deletePolicy(context, ref, policy),
                                  ),
                                  onTap: () => showPolicyDetails(
                                      context, policy.policyId),
                                ),
                                policy.tags.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 20, left: 10),
                                        child: Wrap(
                                          alignment: WrapAlignment.end,
                                          direction: Axis.horizontal,
                                          children: policy.tags.map((e) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: FilterChip(
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -4,
                                                        horizontal: -4),
                                                onSelected: (value) {},
                                                backgroundColor:
                                                    Pallete.policyTagColor,
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

                            // return ListTile(
                            //   leading: policy.image == Constants.avatarDefault
                            //       ? CircleAvatar(
                            //           backgroundImage:
                            //               Image.asset(policy.image).image,
                            //         )
                            //       : CircleAvatar(
                            //           backgroundImage:
                            //               NetworkImage(policy.image),
                            //         ),
                            //   title: Row(
                            //     children: [
                            //       Text(policy.title),
                            //       const SizedBox(
                            //         width: 5,
                            //       ),
                            //       policy.public
                            //           ? const Icon(
                            //               Icons.lock_open_outlined,
                            //               size: 18,
                            //             )
                            //           : const Icon(Icons.lock_outlined,
                            //               size: 18, color: Pallete.greyColor),
                            //     ],
                            //   ),
                            //   trailing: IconButton(
                            //     icon: const Icon(Icons.delete),
                            //     onPressed: () =>
                            //         deletePolicy(context, ref, policy),
                            //   ),
                            //   onTap: () =>
                            //       showPolicyDetails(context, policy.policyId),
                            // );
                          },
                        ),
                      ),
                Container(
                  child: isLoading || managerIsLoading
                      ? const Loader()
                      : Container(),
                )
              ],
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
