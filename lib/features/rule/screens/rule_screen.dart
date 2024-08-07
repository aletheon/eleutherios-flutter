import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final GlobalKey _scaffold = GlobalKey();

class RuleScreen extends ConsumerWidget {
  final String policyId;
  final String ruleId;
  const RuleScreen({super.key, required this.policyId, required this.ruleId});

  void editRule(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void navigateToRuleTools(BuildContext context) {
    Routemaster.of(context).push('rule-tools');
  }

  void joinRule(BuildContext context) {
    Routemaster.of(context).push('add-rule-member');
  }

  void viewRule(BuildContext context) {
    Routemaster.of(context).push('view');
  }

  void leaveRule(BuildContext context) {
    Routemaster.of(context).push('leave-rule');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final ruleMembersProv = ref.watch(getRuleMembersProvider(ruleId));

    return Scaffold(
      key: _scaffold,
      body: ref.watch(getRuleByIdProvider(ruleId)).when(
          data: (rule) {
            return ref
                .watch(
                    getUserSelectedManagerProvider(Tuple2(policyId, user.uid)))
                .when(
                    data: (userSelectedManager) {
                      return NestedScrollView(
                        headerSliverBuilder: ((context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              expandedHeight: 150,
                              flexibleSpace: Stack(
                                children: [
                                  Positioned.fill(
                                    child: rule!.banner ==
                                            Constants.ruleBannerDefault
                                        ? Image.asset(
                                            rule.banner,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            rule.banner,
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
                                            rule.image ==
                                                    Constants.avatarDefault
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        Image.asset(rule.image)
                                                            .image,
                                                    radius: 35,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        Image.network(
                                                      rule.image,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        return loadingProgress
                                                                    ?.cumulativeBytesLoaded ==
                                                                loadingProgress
                                                                    ?.expectedTotalBytes
                                                            ? child
                                                            : const CircularProgressIndicator();
                                                      },
                                                    ).image,
                                                    radius: 35,
                                                  ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(rule.title,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                            textWidthBasis:
                                                                TextWidthBasis
                                                                    .longestLine),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      rule.public
                                                          ? const Icon(
                                                              Icons
                                                                  .lock_open_outlined,
                                                              size: 18,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .lock_outlined,
                                                              color: Pallete
                                                                  .greyColor,
                                                              size: 18,
                                                            ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      rule.instantiationType ==
                                                              InstantiationType
                                                                  .consume.value
                                                          ? const Icon(
                                                              Icons
                                                                  .build_outlined,
                                                              size: 19,
                                                            )
                                                          : rule.instantiationType ==
                                                                  InstantiationType
                                                                      .order
                                                                      .value
                                                              ? const Icon(
                                                                  Icons
                                                                      .attach_money_outlined,
                                                                  size: 21,
                                                                )
                                                              : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            rule.description.isNotEmpty
                                                ? Wrap(
                                                    children: [
                                                      Text(rule.description),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Chip(
                                              label: Text(
                                                  '${rule.members.length} members'),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ruleMembersProv.when(
                                              data: (ruleMembers) {
                                                if (ruleMembers.isNotEmpty) {
                                                  return SizedBox(
                                                    height: 70,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          ruleMembers.length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        final ruleMember =
                                                            ruleMembers[index];
                                                        return ref
                                                            .watch(getServiceByIdProvider(
                                                                ruleMember
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
                                            // rule tools button
                                            (user.uid == rule.policyUid) ||
                                                    (user.uid == rule.uid)
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          navigateToRuleTools(
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
                                                          'Rule Tools'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // edit policy button
                                            (user.uid == rule.policyUid) ||
                                                    (user.uid == rule.uid) ||
                                                    (userSelectedManager !=
                                                            null &&
                                                        userSelectedManager
                                                            .permissions
                                                            .contains(
                                                                ManagerPermissions
                                                                    .editpolicy
                                                                    .value))
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          editRule(context),
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
                                                      child: const Text('Edit'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        }),
                        body: const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: SizedBox(),
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      print('got error $error');
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader());
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
