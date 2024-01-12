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
import 'package:routemaster/routemaster.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('/$forumId');
  }

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('/$policyId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return ref.watch(activitiesProvider(user.uid)).when(
          data: (activities) => Scaffold(
            appBar: AppBar(
              title: Text('Activity(${activities.length})'),
            ),
            body: activities.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("There is no activity"),
                    ),
                  )
                : ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final activity = activities[index];

                      if (activity.activityType == ActivityType.forum.name) {
                        return ref
                            .watch(getForumByIdProvider(activity.policyForumId))
                            .when(
                              data: (forum) {
                                return ListTile(
                                  leading: forum!.image ==
                                          Constants.avatarDefault
                                      ? CircleAvatar(
                                          backgroundImage:
                                              Image.asset(forum.image).image,
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(forum.image),
                                          radius: 32,
                                        ),
                                  title: Text(forum.title),
                                  onTap: () =>
                                      showForumDetails(context, forum.forumId),
                                );
                              },
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      } else {
                        return ref
                            .watch(
                                getPolicyByIdProvider(activity.policyForumId))
                            .when(
                              data: (policy) {
                                return ListTile(
                                  leading: policy!.image ==
                                          Constants.avatarDefault
                                      ? CircleAvatar(
                                          backgroundImage:
                                              Image.asset(policy.image).image,
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(policy.image),
                                          radius: 32,
                                        ),
                                  title: Text(policy.title),
                                  onTap: () => showPolicyDetails(
                                      context, policy.policyId),
                                );
                              },
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      }
                    },
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
