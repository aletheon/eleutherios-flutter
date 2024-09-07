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
          body: Stack(
            children: <Widget>[
              forum!.forums.isEmpty
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
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                childForum!.title,
                                                textWidthBasis:
                                                    TextWidthBasis.longestLine,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            childForum.public
                                                ? const Icon(
                                                    Icons.lock_open_outlined,
                                                    size: 18,
                                                  )
                                                : const Icon(
                                                    Icons.lock_outlined,
                                                    size: 18,
                                                    color: Pallete.greyColor),
                                          ],
                                        ),
                                        leading: childForum.image ==
                                                Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage: Image.asset(
                                                        childForum.image)
                                                    .image,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    childForum.image),
                                              ),
                                        trailing: TextButton(
                                          onPressed: () => removeChildForum(
                                              ref, childForum.forumId),
                                          child: const Text(
                                            'Remove',
                                          ),
                                        ),
                                        onTap: () => showForumDetails(
                                            context, childForum.forumId),
                                      ),
                                      childForum.tags.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0, right: 20, left: 10),
                                              child: Wrap(
                                                alignment: WrapAlignment.end,
                                                direction: Axis.horizontal,
                                                children:
                                                    childForum.tags.map((e) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              );
                        },
                      ),
                    ),
              Container(
                child: isLoading ? const Loader() : Container(),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
