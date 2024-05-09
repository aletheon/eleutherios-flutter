import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PotentialMemberPermissionsScreen extends ConsumerStatefulWidget {
  final String policyId;
  const PotentialMemberPermissionsScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PotentialMemberPermissionsScreenState();
}

class _PotentialMemberPermissionsScreenState
    extends ConsumerState<PotentialMemberPermissionsScreen> {
  void editPermissions(
      BuildContext context, WidgetRef ref, String ruleMemberId) {
    Routemaster.of(context).push('edit/$ruleMemberId');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final ruleMembersProv = ref.watch(getRuleMembersProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (forum) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Potential Member Permissions',
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
                      'No potential members',
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
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(service!.title),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Wrap(
                                    children: [
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .editforum.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .addmember.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.construction,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .removemember.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.construction,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .createforum.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.forum,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .removeforum.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.forum,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .createpost.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.article,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .removepost.name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.article,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      ruleMember.permissions.contains(
                                                  MemberPermissions
                                                      .editmemberpermissions
                                                      .name) ==
                                              true
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 3, bottom: 2),
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Pallete.greyColor,
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.lock,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
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
                                  onPressed: () => editPermissions(
                                    context,
                                    ref,
                                    ruleMember.ruleMemberId,
                                  ),
                                  child: const Text(
                                    'Edit',
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