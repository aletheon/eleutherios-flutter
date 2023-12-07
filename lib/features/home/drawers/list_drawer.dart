import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/activity/controller/activity_controller.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ListDrawer extends ConsumerWidget {
  const ListDrawer({super.key});

  void navigateToCreateService(BuildContext context) {
    Routemaster.of(context).push('create-service');
    Scaffold.of(context).closeDrawer();
  }

  void navigateToCreateForum(BuildContext context) {
    Routemaster.of(context).push('/create-forum');
    Scaffold.of(context).closeDrawer();
  }

  void navigateToCreatePolicy(BuildContext context) {
    Routemaster.of(context).push('/create-policy');
    Scaffold.of(context).closeDrawer();
  }

  void navigateToUserServices(BuildContext context) {
    Routemaster.of(context).push('/user/service/list');
    //Scaffold.of(context).closeDrawer();
  }

  void navigateToUserForums(BuildContext context) {
    Routemaster.of(context).push('/user/forum/list');
    //Scaffold.of(context).closeDrawer();
  }

  void navigateToUserPolicies(BuildContext context) {
    Routemaster.of(context).push('/user/policy/list');
    //Scaffold.of(context).closeDrawer();
  }

  void showViewForum(String forumId, BuildContext context) async {
    Routemaster.of(context).push('/viewforum/$forumId');
  }

  void showPolicyDetails(String policyId, BuildContext context) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create policy'),
              leading: const Icon(
                Icons.account_balance_outlined,
              ),
              trailing: TextButton(
                onPressed: () => navigateToUserPolicies(context),
                child: Text(
                  'Policies(${user.policies.length})',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () => navigateToCreatePolicy(context),
            ),
            ListTile(
              title: const Text('Create service'),
              leading: const Icon(
                Icons.construction_outlined,
              ),
              trailing: TextButton(
                onPressed: () => navigateToUserServices(context),
                child: Text(
                  'Services(${user.services.length})',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () => navigateToCreateService(context),
            ),
            ListTile(
              title: const Text('Create forum'),
              leading: const Icon(
                Icons.sms_outlined,
              ),
              trailing: TextButton(
                onPressed: () => navigateToUserForums(context),
                child: Text(
                  'Forums(${user.forums.length})',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () => navigateToCreateForum(context),
            ),
            user.activities.isNotEmpty
                ? ref.watch(activitiesProvider(user.uid)).when(
                      data: (activities) {
                        if (activities.isNotEmpty) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: activities.length,
                              itemBuilder: (BuildContext context, int index) {
                                final activity = activities[index];

                                if (activity.activityType ==
                                    ActivityType.forum.name) {
                                  return ref
                                      .watch(getForumByIdProvider(
                                          activity.policyForumId))
                                      .when(
                                        data: (forum) {
                                          return ListTile(
                                            leading: forum!.image ==
                                                    Constants.avatarDefault
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        Pallete.forumColor,
                                                    radius: 20,
                                                    child: CircleAvatar(
                                                        backgroundImage:
                                                            Image.asset(
                                                                    forum.image)
                                                                .image,
                                                        radius: 19),
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Pallete.forumColor,
                                                    radius: 20,
                                                    child: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                forum.image),
                                                        radius: 19),
                                                  ),
                                            title: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Text(forum.title)),
                                            trailing: forum.public
                                                ? const Icon(
                                                    Icons.lock_open_outlined)
                                                : const Icon(
                                                    Icons.lock_outlined,
                                                    color: Pallete.greyColor),
                                            onTap: () {
                                              showViewForum(
                                                  forum.forumId, context);
                                            },
                                          );
                                        },
                                        error: (error, stackTrace) =>
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader(),
                                      );
                                } else {
                                  return ref
                                      .watch(getPolicyByIdProvider(
                                          activity.policyForumId))
                                      .when(
                                        data: (policy) {
                                          return ListTile(
                                            leading: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                policy.image ==
                                                        Constants.avatarDefault
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Pallete.policyColor,
                                                        radius: 20,
                                                        child: CircleAvatar(
                                                            backgroundImage:
                                                                Image.asset(policy
                                                                        .image)
                                                                    .image,
                                                            radius: 19),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            Pallete.policyColor,
                                                        radius: 20,
                                                        child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    policy
                                                                        .image),
                                                            radius: 19),
                                                      ),
                                              ],
                                            ),
                                            title: Text(policy.title),
                                            trailing: policy.public
                                                ? const Icon(
                                                    Icons.lock_open_outlined)
                                                : const Icon(
                                                    Icons.lock_outlined,
                                                    color: Pallete.greyColor),
                                            onTap: () => showPolicyDetails(
                                                policy.policyId, context),
                                          );
                                        },
                                        error: (error, stackTrace) =>
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader(),
                                      );
                                }
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
