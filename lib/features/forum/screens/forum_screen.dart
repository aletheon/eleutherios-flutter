import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

class ForumScreen extends ConsumerWidget {
  final String forumId;
  const ForumScreen({super.key, required this.forumId});

  void navigateToForumTools(BuildContext context) {
    Routemaster.of(context).push('forum-tools');
  }

  void joinForum(BuildContext context) {
    Routemaster.of(context).push('register');
  }

  void viewForum(BuildContext context) {
    Routemaster.of(context).push('view');
  }

  void leaveForum(BuildContext context) {
    Routemaster.of(context).push('leave');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final registrantsProv = ref.watch(getRegistrantsProvider(forumId));

    return Scaffold(
      body: ref.watch(getForumByIdProvider(forumId)).when(
          data: (forum) {
            return ref
                .watch(getUserSelectedRegistrantProvider(
                    Tuple2(forumId, user.uid)))
                .when(
                    data: (registrant) {
                      return NestedScrollView(
                        headerSliverBuilder: ((context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              expandedHeight: 150,
                              flexibleSpace: Stack(
                                children: [
                                  Positioned.fill(
                                    child: forum.banner ==
                                            Constants.forumBannerDefault
                                        ? Image.asset(
                                            forum.banner,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            forum.banner,
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
                                            forum.image ==
                                                    Constants.avatarDefault
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        Image.asset(forum.image)
                                                            .image,
                                                    radius: 35,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        Image.network(
                                                      forum.image,
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
                                                  child: Text(
                                                    forum.title,
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
                                                forum.public
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
                                            forum.description.isNotEmpty
                                                ? Wrap(
                                                    children: [
                                                      Text(forum.description),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            Text(
                                                '${forum.registrants.length} members'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            registrantsProv.when(
                                              data: (registrants) {
                                                if (registrants.isNotEmpty) {
                                                  return SizedBox(
                                                    height: 70,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          registrants.length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        final registrant =
                                                            registrants[index];
                                                        return ref
                                                            .watch(getServiceByIdProvider(
                                                                registrant
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
                                            // view button
                                            user.activities.contains(forumId)
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          viewForum(context),
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
                                                      child: const Text('View'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // forum tools button
                                            user.uid == forum.uid ||
                                                    (registrant != null &&
                                                        (registrant.permissions
                                                                .contains(
                                                                    RegistrantPermissions
                                                                        .createforum
                                                                        .name) ||
                                                            registrant.permissions.contains(
                                                                RegistrantPermissions
                                                                    .addservice
                                                                    .name) ||
                                                            registrant.permissions.contains(
                                                                RegistrantPermissions
                                                                    .removeservice
                                                                    .name) ||
                                                            registrant.permissions.contains(
                                                                RegistrantPermissions
                                                                    .removeforum
                                                                    .name) ||
                                                            registrant.permissions
                                                                .contains(RegistrantPermissions.editforum.name)))
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          navigateToForumTools(
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
                                                          'Forum Tools'),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // join button
                                            user.uid == forum.uid ||
                                                    forum.public
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          joinForum(context),
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
                                                    getUserRegistrantCountProvider(
                                                        Tuple2(
                                                            forumId, user.uid)))
                                                .when(
                                                  data: (count) {
                                                    if (count > 0) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child: OutlinedButton(
                                                          onPressed: () =>
                                                              leaveForum(
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        }),
                        body: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: forum!.recentPostId.isNotEmpty
                              ? ref
                                  .watch(
                                      getPostByIdProvider(forum.recentPostId))
                                  .when(
                                    data: (post) {
                                      return ref
                                          .watch(getServiceByIdProvider(
                                              post.serviceId))
                                          .when(
                                            data: (service) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              service!.image ==
                                                                      Constants
                                                                          .avatarDefault
                                                                  ? CircleAvatar(
                                                                      radius:
                                                                          12,
                                                                      backgroundImage:
                                                                          Image.asset(service.image)
                                                                              .image,
                                                                    )
                                                                  : CircleAvatar(
                                                                      radius:
                                                                          12,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              service.image),
                                                                    ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              service.title
                                                                          .length >
                                                                      20
                                                                  ? Text(
                                                                      '${service.title.substring(0, 20)}...',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  : Text(
                                                                      service
                                                                          .title,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                              Text(
                                                                ' - ${timeago.format(post.creationDate)}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            11),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                              child: Text(post
                                                                  .message)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                            error: (error, stackTrace) =>
                                                ErrorText(
                                                    error: error.toString()),
                                            loading: () => const Loader(),
                                          );
                                    },
                                    error: (error, stackTrace) =>
                                        ErrorText(error: error.toString()),
                                    loading: () => const Loader(),
                                  )
                              : const SizedBox(),
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
