import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class ForumToolsScreen extends ConsumerWidget {
  final String forumId;
  const ForumToolsScreen({super.key, required this.forumId});

  void editForum(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void addForum(BuildContext context) {
    Routemaster.of(context).push('add-forum');
  }

  void viewForum(BuildContext context) {
    Routemaster.of(context).push('/forum/$forumId/view');
  }

  void removeForum(BuildContext context) {
    Routemaster.of(context).push('remove-forum');
  }

  void addService(BuildContext context) {
    Routemaster.of(context).push('register');
  }

  void removeService(BuildContext context) {
    Routemaster.of(context).push('deregister');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forum Tools',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
        actions: [
          ref
              .watch(getUserRegistrantCountProvider(Tuple2(forumId, user.uid)))
              .when(
                data: (count) {
                  if (count > 0) {
                    return TextButton(
                      onPressed: () => viewForum(context),
                      child: const Text(
                        'View',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
      body: ref.watch(getForumByIdProvider(forumId)).when(
            data: (forum) {
              if (forum!.uid == user.uid) {
                return Column(children: [
                  ListTile(
                    onTap: () => editForum(context),
                    leading: const Icon(Icons.edit_note_outlined),
                    title: const Text(
                      'Edit Forum',
                    ),
                  ),
                  ListTile(
                    onTap: () => addForum(context),
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Add Forum'),
                  ),
                  ListTile(
                    onTap: () => removeForum(context),
                    leading: const Icon(Icons.remove_circle_outline),
                    title: const Text('Remove Forum'),
                  ),
                  ListTile(
                    onTap: () => addService(context),
                    leading: const Icon(Icons.add_moderator_outlined),
                    title: const Text('Add Service'),
                  ),
                  ListTile(
                    onTap: () => removeService(context),
                    leading: const Icon(Icons.remove_moderator_outlined),
                    title: const Text('Remove Service'),
                  ),
                ]);
              } else {
                if (user.activities.contains(forumId)) {
                  return ref
                      .watch(getUserSelectedRegistrantProvider(
                          Tuple2(forumId, user.uid)))
                      .when(
                        data: (registrant) {
                          return Column(children: [
                            registrant!.permissions.contains(
                                    RegistrantPermissions.editforum.name)
                                ? ListTile(
                                    onTap: () => editForum(context),
                                    leading:
                                        const Icon(Icons.edit_note_outlined),
                                    title: const Text('Edit Forum'),
                                  )
                                : const SizedBox(),
                            registrant.permissions.contains(
                                    RegistrantPermissions.addforum.name)
                                ? ListTile(
                                    onTap: () => addForum(context),
                                    leading:
                                        const Icon(Icons.add_circle_outline),
                                    title: const Text('Add Forum'),
                                  )
                                : const SizedBox(),
                            registrant.permissions.contains(
                                    RegistrantPermissions.deleteforum.name)
                                ? ListTile(
                                    onTap: () => removeForum(context),
                                    leading:
                                        const Icon(Icons.remove_circle_outline),
                                    title: const Text('Remove Forum'),
                                  )
                                : const SizedBox(),
                            registrant.permissions.contains(
                                    RegistrantPermissions.addservice.name)
                                ? ListTile(
                                    onTap: () => addService(context),
                                    leading: const Icon(
                                        Icons.add_moderator_outlined),
                                    title: const Text('Add Service'),
                                  )
                                : const SizedBox(),
                            registrant.permissions.contains(
                                    RegistrantPermissions.removeservice.name)
                                ? ListTile(
                                    onTap: () => removeService(context),
                                    leading: const Icon(
                                        Icons.remove_moderator_outlined),
                                    title: const Text('Remove Service'),
                                  )
                                : const SizedBox(),
                          ]);
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                } else {
                  if (forum.public) {
                    return Column(children: [
                      ListTile(
                        onTap: () => addService(context),
                        leading: const Icon(Icons.add_moderator_outlined),
                        title: const Text('Add Services'),
                      ),
                    ]);
                  } else {
                    return const SizedBox();
                  }
                }
              }
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
