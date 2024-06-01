import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class RemoveForumScreen extends ConsumerStatefulWidget {
  final String forumId;
  const RemoveForumScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveForumScreenState();
}

class _RemoveForumScreenState extends ConsumerState<RemoveForumScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void removeChildForum(WidgetRef ref, String childForumId) {
    ref.read(forumControllerProvider.notifier).removeChildForum(
        widget.forumId, childForumId, _scaffold.currentContext!);
  }

  void showForumDetails(BuildContext context, String childForumId) {
    Routemaster.of(context).push('/forum/$childForumId');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forumControllerProvider);
    final forumProv = ref.watch(getForumByIdProvider(widget.forumId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return forumProv.when(
      data: (forum) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Forum',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading
              ? const Loader()
              : forum!.forums.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'No forums',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                        itemCount: forum.forums.length,
                        itemBuilder: (BuildContext context, int index) {
                          final childForumId = forum.forums[index];

                          return ref
                              .watch(getForumByIdProvider(childForumId))
                              .when(
                                data: (childForum) {
                                  return ListTile(
                                    title: Text(
                                      childForum!.title,
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                    ),
                                    leading: childForum.image ==
                                            Constants.avatarDefault
                                        ? CircleAvatar(
                                            backgroundImage:
                                                Image.asset(childForum.image)
                                                    .image,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(childForum.image),
                                          ),
                                    trailing: TextButton(
                                      onPressed: () => removeChildForum(
                                        ref,
                                        childForumId,
                                      ),
                                      child: const Text(
                                        'Remove',
                                      ),
                                    ),
                                    onTap: () =>
                                        showForumDetails(context, childForumId),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              );
                        },
                      ),
                    ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
