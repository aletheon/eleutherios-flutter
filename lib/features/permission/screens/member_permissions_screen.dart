import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class MemberPermissionsScreen extends ConsumerWidget {
  final String _forumId;
  const MemberPermissionsScreen({super.key, required String forumId})
      : _forumId = forumId;

  void editPermissions(
      BuildContext context, WidgetRef ref, String registrantId) {
    Routemaster.of(context).push('edit/$registrantId');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final forumProv = ref.watch(getForumByIdProvider(_forumId));
    final registrantsProv = ref.watch(getRegistrantsProvider(_forumId));
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
          body: registrantsProv.when(
            data: (registrants) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: registrants.length,
                  itemBuilder: (BuildContext context, int index) {
                    final registrant = registrants[index];

                    return ref
                        .watch(getServiceByIdProvider(registrant.serviceId))
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                    registrant.permissions.contains(
                                                RegistrantPermissions
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
                                  registrant.registrantId,
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
