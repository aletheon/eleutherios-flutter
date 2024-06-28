import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final GlobalKey _scaffold = GlobalKey();

class ServiceRemoveForumScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceRemoveForumScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void removeServiceForum(WidgetRef ref, String forumId) async {
    Member? member = await ref
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
    final isLoading = ref.watch(memberControllerProvider);
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
              'Remove Forum',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading
              ? const Loader()
              : serviceForumsProv.when(
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          forum!.title,
                                          textWidthBasis:
                                              TextWidthBasis.longestLine,
                                        ),
                                      ),
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
                                  trailing: TextButton(
                                    onPressed: () =>
                                        removeServiceForum(ref, forum.forumId),
                                    child: const Text(
                                      'Remove',
                                    ),
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
                      );
                    }
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
