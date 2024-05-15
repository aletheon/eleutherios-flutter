import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class MemberPermissionsScreen extends ConsumerStatefulWidget {
  final String forumId;
  const MemberPermissionsScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MemberPermissionsScreenState();
}

class _MemberPermissionsScreenState
    extends ConsumerState<MemberPermissionsScreen> {
  void editPermissions(BuildContext context, WidgetRef ref, String memberId) {
    Routemaster.of(context).push('edit/$memberId');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final forum = await ref.read(getForumByIdProvider2(widget.forumId)).first;
    final member = await ref
        .read(getUserSelectedMemberProvider2(Tuple2(widget.forumId, user.uid)))
        .first;

    if (forum!.uid != user.uid) {
      if (member!.permissions
              .contains(MemberPermissions.editmemberpermissions.name) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to member permissions');
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
    final forumProv = ref.watch(getForumByIdProvider(widget.forumId));
    final membersProv = ref.watch(getMembersProvider(widget.forumId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return forumProv.when(
      data: (forum) {
        return Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Member Permissions',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: membersProv.when(
            data: (members) {
              if (members.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'No members',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (BuildContext context, int index) {
                      final member = members[index];

                      return ref
                          .watch(getServiceByIdProvider(member.serviceId))
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
                                      member.permissions.contains(
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
                                      member.permissions.contains(
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
                                      member.permissions.contains(
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
                                      member.permissions.contains(
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
                                      member.permissions.contains(
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
                                      member.permissions.contains(
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
                                      member.permissions.contains(
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
                                                        color: Color.fromARGB(
                                                            255, 237, 86, 86),
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      member.permissions.contains(
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
                                                        Icons.auto_fix_normal,
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
                                    member.memberId,
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
