import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ListUserPolicyScreen extends ConsumerWidget {
  const ListUserPolicyScreen({super.key});

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push(policyId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userPoliciesProvider).when(
          data: (policies) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Policies(${policies.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: policies.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("You haven't created any policies"),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: policies.length,
                      itemBuilder: (BuildContext context, int index) {
                        final policy = policies[index];
                        return ListTile(
                          leading: policy.image == Constants.avatarDefault
                              ? CircleAvatar(
                                  backgroundImage:
                                      Image.asset(policy.image).image,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(policy.image),
                                ),
                          title: Text(policy.title),
                          trailing: policy.public
                              ? const Icon(Icons.lock_open_outlined)
                              : const Icon(Icons.lock_outlined,
                                  color: Pallete.greyColor),
                          onTap: () =>
                              showPolicyDetails(context, policy.policyId),
                        );
                      },
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
