import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final GlobalKey _scaffold = GlobalKey();

class ListUserForumScreen extends ConsumerWidget {
  const ListUserForumScreen({super.key});

  void deleteForum(
      BuildContext context, WidgetRef ref, String uid, String forumId) async {
    final int memberCount = await ref
        .read(memberControllerProvider.notifier)
        .getMemberCount(forumId);

    if (memberCount > 0) {
      showDialog(
        context: _scaffold.currentContext!,
        barrierDismissible: true,
        builder: (context) {
          String message =
              "This forum has $memberCount member(s) serving in it.  Are you sure you want to delete it?";

          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(forumControllerProvider.notifier).deleteForum(
                        uid,
                        forumId,
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
      ref.read(forumControllerProvider.notifier).deleteForum(
            uid,
            forumId,
            _scaffold.currentContext!,
          );
    }
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push(forumId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(forumControllerProvider);
    final bool memberIsLoading = ref.watch(memberControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userForumsProvider).when(
          data: (forums) => Scaffold(
            key: _scaffold,
            appBar: AppBar(
              title: Text(
                'Forums(${forums.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                forums.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            "No forums",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: forums.length,
                          itemBuilder: (BuildContext context, int index) {
                            final forum = forums[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(forum.title),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      forum.public
                                          ? const Icon(
                                              Icons.lock_open_outlined,
                                              size: 18,
                                            )
                                          : const Icon(Icons.lock_outlined,
                                              size: 18,
                                              color: Pallete.greyColor),
                                    ],
                                  ),
                                  leading: forum.image ==
                                          Constants.avatarDefault
                                      ? CircleAvatar(
                                          backgroundImage:
                                              Image.asset(forum.image).image,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(forum.image),
                                        ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => deleteForum(
                                        context, ref, forum.uid, forum.forumId),
                                  ),
                                  onTap: () =>
                                      showForumDetails(context, forum.forumId),
                                ),
                                forum.tags.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 20, left: 10),
                                        child: Wrap(
                                          alignment: WrapAlignment.end,
                                          direction: Axis.horizontal,
                                          children: forum.tags.map((e) {
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
                                                    Pallete.forumTagColor,
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
                          },
                        ),
                      ),
                Container(
                  child: isLoading || memberIsLoading
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
