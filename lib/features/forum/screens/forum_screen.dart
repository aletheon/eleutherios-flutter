import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

final GlobalKey _scaffold = GlobalKey();

class ForumScreen extends ConsumerWidget {
  final String forumId;
  const ForumScreen({super.key, required this.forumId});

  void editForum(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void navigateToForumTools(BuildContext context) {
    Routemaster.of(context).push('forum-tools');
  }

  void joinForum(BuildContext context) {
    Routemaster.of(context).push('add-member');
  }

  void viewForum(BuildContext context) {
    Routemaster.of(context).push('view');
  }

  void leaveForum(BuildContext context) {
    Routemaster.of(context).push('leave-forum');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final membersProv = ref.watch(getMembersProvider(forumId));

    return Scaffold(
      key: _scaffold,
      body: ref.watch(getForumByIdProvider(forumId)).when(
          data: (forum) {
            return ref
                .watch(getUserSelectedMemberProvider(Tuple2(forumId, user.uid)))
                .when(
                    data: (userSelectedMember) {
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
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(forum.title,
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
                                                      forum.public
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            forum.tags.isNotEmpty
                                                ? Wrap(
                                                    alignment:
                                                        WrapAlignment.end,
                                                    direction: Axis.horizontal,
                                                    children:
                                                        forum.tags.map((e) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child: FilterChip(
                                                          visualDensity:
                                                              const VisualDensity(
                                                                  vertical: -4,
                                                                  horizontal:
                                                                      -4),
                                                          onSelected:
                                                              (value) {},
                                                          backgroundColor:
                                                              Pallete
                                                                  .forumTagColor,
                                                          label: Text(
                                                            '#$e',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )
                                                : const SizedBox(),
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
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Chip(
                                              label: Text(
                                                  '${forum.members.length} members'),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            membersProv.when(
                                              data: (members) {
                                                if (members.isNotEmpty) {
                                                  return SizedBox(
                                                    height: 70,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: members.length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        final member =
                                                            members[index];
                                                        return ref
                                                            .watch(getServiceByIdProvider(
                                                                member
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
                                            user.forumActivities
                                                    .contains(forumId)
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
                                                    user.forumActivities
                                                        .contains(forumId)
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
                                            // edit policy button
                                            (user.uid == forum.uid) ||
                                                    (userSelectedMember !=
                                                            null &&
                                                        userSelectedMember
                                                            .permissions
                                                            .contains(
                                                                MemberPermissions
                                                                    .editforum
                                                                    .value))
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          editForum(context),
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
                                            // join button
                                            user.uid == forum.uid ||
                                                    forum.public ||
                                                    (userSelectedMember !=
                                                            null &&
                                                        userSelectedMember
                                                            .permissions
                                                            .contains(
                                                                MemberPermissions
                                                                    .addmember
                                                                    .value))
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
                                                    getUserMemberCountProvider(
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
                                      if (post != null) {
                                        return ref
                                            .watch(getServiceByIdProvider(
                                                post.serviceId))
                                            .when(
                                              data: (service) {
                                                if (service != null) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                  service.image ==
                                                                          Constants
                                                                              .avatarDefault
                                                                      ? CircleAvatar(
                                                                          radius:
                                                                              12,
                                                                          backgroundImage:
                                                                              Image.asset(service.image).image,
                                                                        )
                                                                      : CircleAvatar(
                                                                          radius:
                                                                              12,
                                                                          backgroundImage:
                                                                              NetworkImage(service.image),
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  service.title
                                                                              .length >
                                                                          20
                                                                      ? Text(
                                                                          '${service.title.substring(0, 20)}...',
                                                                          style:
                                                                              const TextStyle(fontSize: 14),
                                                                        )
                                                                      : Text(
                                                                          service
                                                                              .title,
                                                                          style:
                                                                              const TextStyle(fontSize: 14),
                                                                        ),
                                                                  Text(
                                                                    ' - ${timeago.format(post.creationDate)}',
                                                                    style: const TextStyle(
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
                                                } else {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                  CircleAvatar(
                                                                    radius: 12,
                                                                    backgroundImage:
                                                                        Image.asset(Constants.avatarDefault)
                                                                            .image,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  const Text(
                                                                    'Unknown service',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  Text(
                                                                    ' - ${timeago.format(post.creationDate)}',
                                                                    style: const TextStyle(
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
                                                }
                                              },
                                              error: (error, stackTrace) =>
                                                  ErrorText(
                                                      error: error.toString()),
                                              loading: () => const Loader(),
                                            );
                                      } else {
                                        return const SizedBox();
                                      }
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
