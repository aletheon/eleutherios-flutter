import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class MemberLeaveScreen extends ConsumerStatefulWidget {
  final String forumId;
  const MemberLeaveScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MemberLeaveScreenState();
}

class _MemberLeaveScreenState extends ConsumerState<MemberLeaveScreen> {
  void removeMemberService(
      BuildContext context, WidgetRef ref, String forumId, String memberId) {
    ref
        .read(memberControllerProvider.notifier)
        .deleteMember(forumId, memberId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  @override
  Widget build(BuildContext context) {
    final forumProv = ref.watch(getForumByIdProvider(widget.forumId));
    final membersProv = ref.watch(getMembersProvider(widget.forumId));
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return forumProv.when(
      data: (forum) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Services',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: membersProv.when(
            data: (members) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    final member = members[index];

                    if (member.serviceUid == user.uid) {
                      return ref
                          .watch(getServiceByIdProvider(member.serviceId))
                          .when(
                            data: (service) {
                              return ListTile(
                                title: member.selected == false
                                    ? Flexible(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            service!.title,
                                            textWidthBasis:
                                                TextWidthBasis.longestLine,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                service!.title,
                                                textWidthBasis:
                                                    TextWidthBasis.longestLine,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.check,
                                            color:
                                                Color.fromARGB(255, 3, 233, 33),
                                          )
                                        ],
                                      ),
                                leading: service.image ==
                                        Constants.avatarDefault
                                    ? CircleAvatar(
                                        backgroundImage:
                                            Image.asset(service.image).image,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(service.image),
                                      ),
                                trailing: TextButton(
                                  onPressed: () => removeMemberService(
                                    context,
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
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
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
