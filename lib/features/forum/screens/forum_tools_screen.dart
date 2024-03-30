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
import 'package:reddit_tutorial/core/utils.dart';

class ForumToolsScreen extends ConsumerStatefulWidget {
  final String forumId;

  const ForumToolsScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForumToolsScreenState();
}

class _ForumToolsScreenState extends ConsumerState<ForumToolsScreen> {
  void editForum(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void createForum(BuildContext context) {
    Routemaster.of(context).push('add-forum');
  }

  void viewForum(BuildContext context) {
    Routemaster.of(context).push('/forum/${widget.forumId}/view');
  }

  void removeForum(BuildContext context) {
    Routemaster.of(context).push('remove-forum');
  }

  void addMember(BuildContext context) {
    Routemaster.of(context).push('register');
  }

  void removeMember(BuildContext context) {
    Routemaster.of(context).push('deregister');
  }

  void memberPermissions(BuildContext context) {
    Routemaster.of(context).push('member-permissions');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final forum = await ref.read(getForumByIdProvider2(widget.forumId)).first;

    if (forum!.uid != user.uid) {
      if (user.activities.contains(widget.forumId) == false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to this forum');
          Routemaster.of(context).pop();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              .watch(getUserRegistrantCountProvider(
                  Tuple2(widget.forumId, user.uid)))
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
      body: ref.watch(getForumByIdProvider(widget.forumId)).when(
            data: (forum) {
              return ref
                  .watch(getUserSelectedRegistrantProvider(
                      Tuple2(widget.forumId, user.uid)))
                  .when(
                    data: (registrant) {
                      return Column(children: [
                        user.uid == forum!.uid ||
                                registrant!.permissions.contains(
                                    RegistrantPermissions.editforum.name)
                            ? ListTile(
                                onTap: () => editForum(context),
                                leading: const Icon(Icons.edit_note_outlined),
                                title: const Text('Edit Forum'),
                              )
                            : const SizedBox(),
                        user.uid == forum.uid ||
                                registrant!.permissions.contains(
                                    RegistrantPermissions.createforum.name)
                            ? ListTile(
                                onTap: () => createForum(context),
                                leading: const Icon(Icons.add_circle_outline),
                                title: const Text('Create Forum'),
                              )
                            : const SizedBox(),
                        user.uid == forum.uid ||
                                registrant!.permissions.contains(
                                    RegistrantPermissions.removeforum.name)
                            ? ListTile(
                                onTap: () => removeForum(context),
                                leading:
                                    const Icon(Icons.remove_circle_outline),
                                title: const Text('Remove Forum'),
                              )
                            : const SizedBox(),
                        user.uid == forum.uid ||
                                registrant!.permissions.contains(
                                    RegistrantPermissions.addservice.name)
                            ? ListTile(
                                onTap: () => addMember(context),
                                leading:
                                    const Icon(Icons.add_moderator_outlined),
                                title: const Text('Add Member'),
                              )
                            : const SizedBox(),
                        user.uid == forum.uid ||
                                registrant!.permissions.contains(
                                    RegistrantPermissions.removeservice.name)
                            ? ListTile(
                                onTap: () => removeMember(context),
                                leading:
                                    const Icon(Icons.remove_moderator_outlined),
                                title: const Text('Remove Member'),
                              )
                            : const SizedBox(),
                        user.uid == forum.uid ||
                                registrant!.permissions.contains(
                                    RegistrantPermissions.editpermissions.name)
                            ? ListTile(
                                onTap: () => memberPermissions(context),
                                leading: const Icon(Icons.list_alt_outlined),
                                title: const Text('Member Permissions'),
                              )
                            : const SizedBox(),
                      ]);
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
