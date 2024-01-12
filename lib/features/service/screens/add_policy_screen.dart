import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class AddPolicyScreen extends ConsumerWidget {
  final String _serviceId;
  const AddPolicyScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void addPolicy(BuildContext context, WidgetRef ref, String policyId) {
    ref
        .read(serviceControllerProvider.notifier)
        .addPolicy(_serviceId, policyId, context);
  }

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('policy/$policyId');
  }

  Widget showPolicyList(WidgetRef ref, List<Policy> policies) {
    return Expanded(
      child: ListView.builder(
        itemCount: policies.length,
        itemBuilder: (BuildContext context, int index) {
          final policy = policies[index];

          return ref
              .watch(policyIsRegisteredInServiceProvider(Tuple2(
                _serviceId,
                policy.policyId,
              )))
              .when(
                data: (isRegistered) {
                  if (isRegistered == false) {
                    return ListTile(
                      title: Text(policy.title),
                      leading: policy.image == Constants.avatarDefault
                          ? CircleAvatar(
                              backgroundImage: Image.asset(policy.image).image,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(policy.image),
                            ),
                      trailing: TextButton(
                        onPressed: () =>
                            addPolicy(context, ref, policy.policyId),
                        child: const Text(
                          'Add',
                        ),
                      ),
                      onTap: () => showPolicyDetails(context, policy.policyId),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              );
        },
      ),
    );
  }

  Widget showPolicies(WidgetRef ref, Service service, String searchType) {
    final userPoliciesProv = ref.watch(userPoliciesProvider);
    final policiesProv = ref.watch(policiesProvider);
    final user = ref.watch(userProvider)!;

    if (searchType == "Private") {
      if (user.policies.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("You haven't created any policies"),
          ),
        );
      } else {
        return userPoliciesProv.when(
          data: (policies) {
            return showPolicyList(ref, policies);
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
      }
    } else {
      return policiesProv.when(
        data: (policies) {
          if (policies.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("There are no public policies"),
              ),
            );
          } else {
            return showPolicyList(ref, policies);
          }
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceProv = ref.watch(getServiceByIdProvider(_serviceId));
    final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;
    final currentTheme = ref.watch(themeNotifierProvider);

    return serviceProv.when(
      data: (service) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Policy',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Private"),
                  Radio(
                      value: "Private",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  const Text("Public"),
                  Radio(
                      value: "Public",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              showPolicies(ref, service!, searchRadioProv)
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
