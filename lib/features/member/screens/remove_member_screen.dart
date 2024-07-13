import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class RemoveMemberScreen extends ConsumerStatefulWidget {
  final String forumId;
  const RemoveMemberScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveMemberScreenState();
}

class _RemoveMemberScreenState extends ConsumerState<RemoveMemberScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void removeMemberService(WidgetRef ref, String forumId, String memberId) {
    ref
        .read(memberControllerProvider.notifier)
        .deleteMember(forumId, memberId, _scaffold.currentContext!);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final forum = await ref.read(getForumByIdProvider2(widget.forumId)).first;
    final member = await ref
        .read(getUserSelectedMemberProvider2(Tuple2(widget.forumId, user.uid)))
        .first;

    if (forum!.uid != user.uid) {
      if (member!.permissions.contains(MemberPermissions.removemember.value) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(
              context,
              'You do not have permission to remove a member from this forum',
              true);
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
    final isLoading = ref.watch(memberControllerProvider);
    final forumProv = ref.watch(getForumByIdProvider(widget.forumId));
    final membersProv = ref.watch(getMembersProvider(widget.forumId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return forumProv.when(
      data: (forum) {
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
          body: isLoading
              ? const Loader()
              : membersProv.when(
                  data: (members) {
                    if (members.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'No members',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (BuildContext context, int index) {
                            final member = members[index];

                            return ref
                                .watch(getServiceByIdProvider(member.serviceId))
                                .when(
                                  data: (service) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  service!.title,
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              service.public
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
                                          leading: service.image ==
                                                  Constants.avatarDefault
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      Image.asset(service.image)
                                                          .image,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      service.image),
                                                ),
                                          trailing: TextButton(
                                            onPressed: () =>
                                                removeMemberService(
                                              ref,
                                              forum!.forumId,
                                              member.memberId,
                                            ),
                                            child: const Text(
                                              'Remove',
                                            ),
                                          ),
                                          onTap: () => showServiceDetails(
                                              context, service.serviceId),
                                        ),
                                        service.tags.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    right: 20,
                                                    left: 10),
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  direction: Axis.horizontal,
                                                  children:
                                                      service.tags.map((e) {
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
                                                        backgroundColor: service
                                                                    .price ==
                                                                -1
                                                            ? Pallete
                                                                .freeServiceTagColor
                                                            : Pallete
                                                                .paidServiceTagColor,
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
