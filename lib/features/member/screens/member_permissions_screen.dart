import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final forumProv = ref.watch(getForumByIdProvider(widget.forumId));
    final membersProv = ref.watch(getMembersProvider(widget.forumId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return forumProv.when(
      data: (forum) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
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
                                child: Row(
                                  children: [
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .editforum.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .addservice.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .removeservice.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .createforum.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .removeforum.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .createpost.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .removepost.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    member.permissions.contains(
                                                MemberPermissions
                                                    .editpermissions.name) ==
                                            true
                                        ? const Row(
                                            children: [
                                              CircleAvatar(
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
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              leading: service.image == Constants.avatarDefault
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
