import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final GlobalKey _scaffold = GlobalKey();

class ServiceRemoveForumScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceRemoveForumScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void removeServiceForum(WidgetRef ref, String forumId) async {
    final member = await ref
        .read(getMemberByServiceIdProvider2(Tuple2(forumId, _serviceId)))
        .first;

    if (member != null) {
      ref
          .read(memberControllerProvider.notifier)
          .deleteMember(forumId, member.memberId, _scaffold.currentContext!);
    }
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('forum/$forumId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceProv = ref.watch(getForumByIdProvider(_serviceId));
    final serviceForumsProv = ref.watch(getServiceForumsProvider(_serviceId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return serviceProv.when(
      data: (service) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Member',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: serviceForumsProv.when(
            data: (serviceForums) {
              if (serviceForums.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'No forums',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: serviceForums.length,
                    itemBuilder: (BuildContext context, int index) {
                      final forum = serviceForums[index];

                      return ListTile(
                        title: Text(
                          forum!.title,
                          textWidthBasis: TextWidthBasis.longestLine,
                        ),
                        leading: forum.image == Constants.avatarDefault
                            ? CircleAvatar(
                                backgroundImage: Image.asset(forum.image).image,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(forum.image),
                              ),
                        trailing: TextButton(
                          onPressed: () => removeServiceForum(
                            ref,
                            forum.forumId,
                          ),
                          child: const Text(
                            'Remove',
                          ),
                        ),
                        onTap: () => showForumDetails(context, forum.forumId),
                      );
                    },
                  ),
                );
              }
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
