import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final GlobalKey _scaffold = GlobalKey();

class PolicyScreen extends ConsumerWidget {
  final String policyId;
  const PolicyScreen({super.key, required this.policyId});

  void deleteRule(
      BuildContext context, WidgetRef ref, String uid, String ruleId) async {
    final int ruleMemberCount = await ref
        .read(ruleMemberControllerProvider.notifier)
        .getRuleMemberCount(ruleId);

    if (ruleMemberCount > 0) {
      showDialog(
        context: _scaffold.currentContext!,
        barrierDismissible: true,
        builder: (context) {
          String message =
              "This Rule has $ruleMemberCount potential member(s) serving in it.  ";
          message += "Are you sure you want to delete it?";

          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(ruleControllerProvider.notifier).deleteRule(
                        uid,
                        ruleId,
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
      ref.read(ruleControllerProvider.notifier).deleteRule(
            uid,
            ruleId,
            _scaffold.currentContext!,
          );
    }
  }

  void navigateToPolicyTools(BuildContext context) {
    Routemaster.of(context).push('policy-tools');
  }

  void navigateToRule(BuildContext context, String ruleId) {
    Routemaster.of(context).push('rule/$ruleId');
  }

  void joinPolicy(BuildContext context) {
    Routemaster.of(context).push('add-manager');
  }

  void consume(BuildContext context) {
    Routemaster.of(context).push('add-consumer');
  }

  void leavePolicy(BuildContext context) {
    Routemaster.of(context).push('leave-policy');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final bool isLoading = ref.watch(policyControllerProvider);
    final bool ruleMemberIsLoading = ref.watch(ruleMemberControllerProvider);
    final managersProv = ref.watch(getManagersProvider(policyId));

    return Scaffold(
      key: _scaffold,
      body: ref
          .watch(getUserSelectedManagerProvider(Tuple2(policyId, user.uid)))
          .when(
            data: (userSelectedManager) {
              return ref.watch(getPolicyByIdProvider(policyId)).when(
                  data: (policy) => NestedScrollView(
                        headerSliverBuilder: ((context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              expandedHeight: 150,
                              flexibleSpace: Stack(
                                children: [
                                  Positioned.fill(
                                    child: policy!.banner ==
                                            Constants.policyBannerDefault
                                        ? Image.asset(
                                            policy.banner,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            policy.banner,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              return loadingProgress
                                                          ?.cumulativeBytesLoaded ==
                                                      loadingProgress
                                                          ?.expectedTotalBytes
                                                  ? child
                                                  : const CircularProgressIndicator();
                                            },
                                          ),
                                  )
                                ],
                              ),
                              floating: true,
                              snap: true,
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate.fixed(
                                  [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            policy.image ==
                                                    Constants.avatarDefault
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        Image.asset(
                                                                policy.image)
                                                            .image,
                                                    radius: 35,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            policy.image),
                                                    radius: 35,
                                                  ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    policy.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                policy.public
                                                    ? const Icon(Icons
                                                        .lock_open_outlined)
                                                    : const Icon(
                                                        Icons.lock_outlined,
                                                        color:
                                                            Pallete.greyColor),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            policy.description.isNotEmpty
                                                ? Wrap(
                                                    children: [
                                                      Text(policy.description),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            Text(
                                                '${policy.managers.length} managers'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            managersProv.when(
                                              data: (managers) {
                                                if (managers.isNotEmpty) {
                                                  return SizedBox(
                                                    height: 70,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          managers.length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        final manager =
                                                            managers[index];
                                                        return ref
                                                            .watch(getServiceByIdProvider(
                                                                manager
                                                                    .serviceId))
                                                            .when(
                                                              data: (service) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child: Column(
                                                                    children: [
                                                                      service!.image ==
                                                                              Constants.avatarDefault
                                                                          ? CircleAvatar(
                                                                              backgroundImage: Image.asset(service.image).image,
                                                                            )
                                                                          : CircleAvatar(
                                                                              backgroundImage: NetworkImage(service.image),
                                                                            ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      service.title.length >
                                                                              20
                                                                          ? Text(
                                                                              '${service.title.substring(0, 20)}...')
                                                                          : Text(
                                                                              service.title),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              error: (error,
                                                                      stackTrace) =>
                                                                  ErrorText(
                                                                      error: error
                                                                          .toString()),
                                                              loading: () =>
                                                                  const Loader(),
                                                            );
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                              error: (error, stackTrace) =>
                                                  ErrorText(
                                                      error: error.toString()),
                                              loading: () => const Loader(),
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            // policy tools button
                                            policy.uid == user.uid ||
                                                    user.policyActivities
                                                        .contains(policyId)
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          navigateToPolicyTools(
                                                              context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25)),
                                                      child: const Text(
                                                          'Policy Tools'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // consume button
                                            policy.public
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          consume(context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 25),
                                                      ),
                                                      child:
                                                          const Text('Consume'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // join button
                                            user.uid == policy.uid ||
                                                    (userSelectedManager !=
                                                            null &&
                                                        userSelectedManager
                                                                .permissions
                                                                .contains(
                                                                    ManagerPermissions
                                                                        .addmanager
                                                                        .name) ==
                                                            true)
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          joinPolicy(context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25)),
                                                      child: const Text('Join'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // leave button
                                            ref
                                                .watch(
                                                    getUserManagerCountProvider(
                                                        Tuple2(policyId,
                                                            user.uid)))
                                                .when(
                                                  data: (count) {
                                                    if (count > 0) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child: OutlinedButton(
                                                          onPressed: () =>
                                                              leavePolicy(
                                                                  context),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25)),
                                                          child: const Text(
                                                              'Leave'),
                                                        ),
                                                      );
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  },
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                          error:
                                                              error.toString()),
                                                  loading: () => const Loader(),
                                                ),
                                          ],
                                        ),
                                        ref
                                            .watch(getRulesProvider(policyId))
                                            .when(
                                              data: (rules) {
                                                if (rules.isEmpty) {
                                                  return const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                          "There are no rules"),
                                                    ),
                                                  );
                                                } else {
                                                  return MediaQuery
                                                      .removePadding(
                                                    context: context,
                                                    removeTop: true,
                                                    child: Stack(
                                                      children: [
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              rules.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final rule =
                                                                rules[index];

                                                            return ListTile(
                                                              title: Row(
                                                                // ignore: sort_child_properties_last
                                                                children: [
                                                                  Text(rule
                                                                      .title),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  rule.public
                                                                      ? const Icon(
                                                                          Icons
                                                                              .lock_open_outlined,
                                                                          size:
                                                                              18,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .lock_outlined,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              Pallete.greyColor),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  rule.instantiationType ==
                                                                          InstantiationType
                                                                              .consume
                                                                              .value
                                                                      ? const Icon(
                                                                          Icons
                                                                              .build_outlined,
                                                                          size:
                                                                              19,
                                                                        )
                                                                      : rule.instantiationType ==
                                                                              InstantiationType.order.value
                                                                          ? const Icon(
                                                                              Icons.attach_money,
                                                                              size: 21,
                                                                            )
                                                                          : const SizedBox(),
                                                                ],
                                                              ),
                                                              leading: rule
                                                                          .image ==
                                                                      Constants
                                                                          .avatarDefault
                                                                  ? CircleAvatar(
                                                                      backgroundImage:
                                                                          Image.asset(rule.image)
                                                                              .image,
                                                                    )
                                                                  : CircleAvatar(
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              rule.image),
                                                                    ),
                                                              trailing:
                                                                  IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete),
                                                                onPressed: () =>
                                                                    deleteRule(
                                                                        context,
                                                                        ref,
                                                                        rule.uid,
                                                                        rule.ruleId),
                                                              ),
                                                              onTap: () =>
                                                                  navigateToRule(
                                                                      context,
                                                                      rule.ruleId),
                                                            );
                                                          },
                                                        ),
                                                        Container(
                                                          child: isLoading ||
                                                                  ruleMemberIsLoading
                                                              ? const Loader()
                                                              : Container(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                              error: (error, stackTrace) =>
                                                  ErrorText(
                                                      error: error.toString()),
                                              loading: () => const Loader(),
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        }),
                        body: const SizedBox(),
                      ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader());
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
