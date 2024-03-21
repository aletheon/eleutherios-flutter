import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ListUserForumScreen extends ConsumerWidget {
  const ListUserForumScreen({super.key});

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push(forumId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userForumsProvider).when(
          data: (forums) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Forums(${forums.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: forums.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("You haven't created any forums"),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: forums.length,
                      itemBuilder: (BuildContext context, int index) {
                        final forum = forums[index];
                        return ListTile(
                          leading: forum.image == Constants.avatarDefault
                              ? CircleAvatar(
                                  backgroundImage:
                                      Image.asset(forum.image).image,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(forum.image),
                                ),
                          title: Text(forum.title),
                          trailing: forum.public
                              ? const Icon(Icons.lock_open_outlined)
                              : const Icon(Icons.lock_outlined,
                                  color: Pallete.greyColor),
                          onTap: () => showForumDetails(context, forum.forumId),
                        );
                      },
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
