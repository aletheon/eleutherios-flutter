import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;

class ViewForumScreen extends ConsumerStatefulWidget {
  final String forumId;

  const ViewForumScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewForumScreenState();
}

class _ViewForumScreenState extends ConsumerState<ViewForumScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final messageController = TextEditingController();
  Member? selectedMember;
  String? dropdownValue;
  var tapPosition;

  getSelectedMember() async {
    final user = ref.read(userProvider)!;

    Member? selectedMember = await ref
        .read(getUserSelectedMemberProvider2(Tuple2(widget.forumId, user.uid)))
        .first;

    if (selectedMember != null) {
      setState(() {
        dropdownValue = selectedMember!.memberId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSelectedMember();
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    void storePosition(TapDownDetails details) {
      tapPosition = details.globalPosition;
    }

    void createPost(BuildContext context) {
      if (messageController.text.trim().isNotEmpty && dropdownValue != null) {
        ref.read(postControllerProvider.notifier).createPost(widget.forumId,
            dropdownValue!, messageController.text.trim(), null, context);
        messageController.text = '';
      }
    }

    void deletePost(String postId, BuildContext context) {
      ref.read(postControllerProvider.notifier).deletePost(
          forumId: widget.forumId, postId: postId, context: context);
    }

    void showDetails(String forumId, BuildContext context) {
      Routemaster.of(context).push('/forum/$forumId');
    }

    void viewForum(String forumId, BuildContext context) async {
      Member? selectedMember = await ref
          .read(getUserSelectedMemberProvider2(Tuple2(forumId, user.uid)))
          .first;

      if (selectedMember != null) {
        setState(() {
          dropdownValue = selectedMember.memberId;
          Routemaster.of(context).push('/forum/$forumId/view');
        });
      } else {
        if (context.mounted) {
          Routemaster.of(context).push('/forum/$forumId');
        }
      }
    }

    void showMemberDetails(String memberId, BuildContext context) {
      Routemaster.of(context).push('member/$memberId');
    }

    void changeSelectedMember(String memberId) async {
      ref.read(memberControllerProvider.notifier).changedSelected(memberId);

      setState(() {
        dropdownValue = memberId;
      });
    }

    return ref.watch(getForumByIdProvider(widget.forumId)).when(
          data: (forum) {
            return Scaffold(
              key: _scaffold,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Column(
                  children: [
                    Text(
                      forum!.title,
                      style: TextStyle(
                        color: currentTheme.textTheme.bodyMedium!.color!,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => showDetails(forum.forumId, context),
                    child: const Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  forum.breadcrumbs.isNotEmpty
                      ? SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: forum.breadcrumbs.length,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              final forumId = forum.breadcrumbs[index];

                              if (forumId == forum.forumId) {
                                return const SizedBox();
                              } else {
                                return ref
                                    .watch(getForumByIdProvider(forumId))
                                    .when(
                                      data: (tempForum) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              tempForum!.image ==
                                                      Constants.avatarDefault
                                                  ? CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage:
                                                          Image.asset(tempForum
                                                                  .image)
                                                              .image,
                                                    )
                                                  : CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              tempForum.image),
                                                    ),
                                              TextButton(
                                                onPressed: () => viewForum(
                                                    tempForum.forumId, context),
                                                child: Text(
                                                  tempForum.title.length > 20
                                                      ? '${tempForum.title.substring(0, 20)}...'
                                                      : tempForum.title,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader(),
                                    );
                              }
                            },
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ref
                            .watch(forumPostsProvider(widget.forumId))
                            .when(
                              data: (posts) {
                                posts.reversed.toList();
                                return ListView.separated(
                                  shrinkWrap: true,
                                  reverse: true,
                                  padding: const EdgeInsets.only(
                                          top: 12, bottom: 20) +
                                      const EdgeInsets.symmetric(
                                          horizontal: 12),
                                  separatorBuilder: (_, __) => const SizedBox(
                                    height: 12,
                                  ),
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return ref
                                        .watch(getServiceByIdProvider(
                                            posts[index].serviceId))
                                        .when(
                                            data: (service) {
                                              if (service != null) {
                                                return GestureDetector(
                                                  onTapDown: storePosition,
                                                  onLongPress: () async {
                                                    if (user.uid == forum.uid ||
                                                        user.uid ==
                                                            posts[index]
                                                                .serviceUid ||
                                                        selectedMember!
                                                            .permissions
                                                            .contains(
                                                                MemberPermissions
                                                                    .removepost
                                                                    .name)) {
                                                      final RenderBox overlay =
                                                          Overlay.of(context)
                                                                  .context
                                                                  .findRenderObject()
                                                              as RenderBox;

                                                      await showMenu(
                                                        context: context,
                                                        items: <PopupMenuEntry>[
                                                          PopupMenuItem(
                                                            child: const Row(
                                                              children: <Widget>[
                                                                Icon(Icons
                                                                    .delete),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text("Delete"),
                                                              ],
                                                            ),
                                                            onTap: () =>
                                                                deletePost(
                                                                    posts[index]
                                                                        .postId,
                                                                    context),
                                                          )
                                                        ],
                                                        position: RelativeRect
                                                            .fromRect(
                                                                tapPosition &
                                                                    const Size(
                                                                        40,
                                                                        40), // smaller rect, the touch area
                                                                Offset.zero &
                                                                    overlay
                                                                        .size // Bigger rect, the entire screen
                                                                ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            right: 12,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Align(
                                                      alignment: (posts[index]
                                                                  .serviceUid !=
                                                              user.uid
                                                          ? Alignment.topLeft
                                                          : Alignment.topRight),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: (posts[index]
                                                                      .serviceUid !=
                                                                  user.uid
                                                              ? Pallete
                                                                  .blueColor
                                                              : Pallete
                                                                  .greenColor),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10, 10, 10, 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    service.image ==
                                                                            Constants.avatarDefault
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
                                                                    service.title.length >
                                                                            20
                                                                        ? Text(
                                                                            '${service.title.substring(0, 20)}...',
                                                                            style:
                                                                                const TextStyle(fontSize: 11),
                                                                          )
                                                                        : Text(
                                                                            service.title,
                                                                            style:
                                                                                const TextStyle(fontSize: 11),
                                                                          ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  ' ${timeago.format(posts[index].creationDate)}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          11),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(posts[index]
                                                                .message),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return GestureDetector(
                                                  onTapDown: storePosition,
                                                  onLongPress: () async {
                                                    if (user.uid == forum.uid ||
                                                        user.uid ==
                                                            posts[index]
                                                                .serviceUid ||
                                                        selectedMember!
                                                            .permissions
                                                            .contains(
                                                                MemberPermissions
                                                                    .removepost
                                                                    .name)) {
                                                      final RenderBox overlay =
                                                          Overlay.of(context)
                                                                  .context
                                                                  .findRenderObject()
                                                              as RenderBox;

                                                      await showMenu(
                                                        context: context,
                                                        items: <PopupMenuEntry>[
                                                          PopupMenuItem(
                                                            child: const Row(
                                                              children: <Widget>[
                                                                Icon(Icons
                                                                    .delete),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text("Delete"),
                                                              ],
                                                            ),
                                                            onTap: () =>
                                                                deletePost(
                                                                    posts[index]
                                                                        .postId,
                                                                    context),
                                                          )
                                                        ],
                                                        position: RelativeRect
                                                            .fromRect(
                                                                tapPosition &
                                                                    const Size(
                                                                        40,
                                                                        40), // smaller rect, the touch area
                                                                Offset.zero &
                                                                    overlay
                                                                        .size // Bigger rect, the entire screen
                                                                ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            right: 12,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Align(
                                                      alignment: (posts[index]
                                                                  .serviceUid !=
                                                              user.uid
                                                          ? Alignment.topLeft
                                                          : Alignment.topRight),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: (posts[index]
                                                                      .serviceUid !=
                                                                  user.uid
                                                              ? Pallete
                                                                  .blueColor
                                                              : Pallete
                                                                  .greenColor),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10, 10, 10, 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          12,
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
                                                                              11),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  ' ${timeago.format(posts[index].creationDate)}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          11),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(posts[index]
                                                                .message),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            error: (error, stackTrace) =>
                                                ErrorText(
                                                    error: error.toString()),
                                            loading: () => const Loader());
                                  },
                                );
                              },
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            ),
                      ),
                    ),
                  ),
                  // ************************************************************
                  // Forums
                  // ************************************************************
                  ExpansionTile(
                    title: Text(
                      'Forums(${forum.forums.length})',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    children: [
                      ref.watch(getForumChildrenProvider(widget.forumId)).when(
                            data: (forums) {
                              if (forums.isNotEmpty) {
                                return SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: forums.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      final forum = forums[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          child: Column(
                                            children: [
                                              forum.image ==
                                                      Constants.avatarDefault
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          Image.asset(
                                                                  forum.image)
                                                              .image,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              forum.image),
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              forum.title.length > 20
                                                  ? Text(
                                                      '${forum.title.substring(0, 20)}...')
                                                  : Text(forum.title),
                                            ],
                                          ),
                                          onTap: () async {
                                            Member? tempSelectedMember = await ref
                                                .read(
                                                    getUserSelectedMemberProvider2(
                                                        Tuple2(forum.forumId,
                                                            user.uid)))
                                                .first;

                                            if (tempSelectedMember != null) {
                                              viewForum(forum.forumId,
                                                  _scaffold.currentContext!);
                                            } else {
                                              showDetails(forum.forumId,
                                                  _scaffold.currentContext!);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                  // ************************************************************
                  // Services / members
                  // ************************************************************
                  ExpansionTile(
                    title: Text(
                      'Services(${forum.members.length})',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    children: [
                      ref.watch(getMembersProvider(widget.forumId)).when(
                            data: (members) {
                              if (members.isNotEmpty) {
                                return SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: members.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      final member = members[index];
                                      return ref
                                          .watch(getServiceByIdProvider(
                                              member.serviceId))
                                          .when(
                                            data: (service) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: GestureDetector(
                                                  child: Column(
                                                    children: [
                                                      service!.image ==
                                                              Constants
                                                                  .avatarDefault
                                                          ? CircleAvatar(
                                                              backgroundImage:
                                                                  Image.asset(service
                                                                          .image)
                                                                      .image,
                                                            )
                                                          : CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      service
                                                                          .image),
                                                            ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      service.title.length > 20
                                                          ? Text(
                                                              '${service.title.substring(0, 20)}...')
                                                          : Text(service.title),
                                                    ],
                                                  ),
                                                  onTap: () =>
                                                      showMemberDetails(
                                                          member.memberId,
                                                          context),
                                                ),
                                              );
                                            },
                                            error: (error, stackTrace) =>
                                                ErrorText(
                                                    error: error.toString()),
                                            loading: () => const Loader(),
                                          );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                  // *******************************************************
                  // bottom button
                  // *******************************************************
                  SafeArea(
                    bottom: true,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 48),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFE5E5EA),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 45,
                            child: TextField(
                              autofocus: true,
                              controller: messageController,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // contentPadding: const EdgeInsets.only(
                                //   right: 42,
                                //   left: 16,
                                //   top: 18,
                                // ),
                                hintText: 'message',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 41,
                            child: ref
                                .watch(getUserMembersProvider(
                                    Tuple2(widget.forumId, user.uid)))
                                .when(
                                  data: (members) {
                                    return DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          isDense: true,
                                          value: dropdownValue,
                                          onChanged: (String? memberId) {
                                            if (memberId is String) {
                                              changeSelectedMember(memberId);
                                            }
                                          },
                                          // *********************************
                                          // items
                                          // *********************************
                                          items: members
                                              .map<DropdownMenuItem<String>>(
                                                  (Member member) {
                                            return DropdownMenuItem<String>(
                                              value: member.memberId,
                                              child: ref
                                                  .watch(getServiceByIdProvider(
                                                      member.serviceId))
                                                  .when(data: (service) {
                                                return Row(children: [
                                                  service!.image ==
                                                          Constants
                                                              .avatarDefault
                                                      ? CircleAvatar(
                                                          backgroundImage: Image
                                                                  .asset(service
                                                                      .image)
                                                              .image,
                                                          radius: 11,
                                                        )
                                                      : CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  service
                                                                      .image),
                                                          radius: 11,
                                                        ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  service.title.length > 12
                                                      ? Text(
                                                          '${service.title.substring(0, 12)}...',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      : Text(
                                                          service.title,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                ]);
                                              }, error: (error, stackTrace) {
                                                return Text(error.toString());
                                              }, loading: () {
                                                return const Loader();
                                              }),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader(),
                                ),
                          ),
                          Expanded(
                            flex: 13,
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () => createPost(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
