import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/delegates/search_policy_delegate.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final GlobalKey _scaffold = GlobalKey();
final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class AddPolicyScreen extends ConsumerWidget {
  final String _serviceId;
  const AddPolicyScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void addPolicyToService(WidgetRef ref, String policyId) {
    ref
        .read(policyControllerProvider.notifier)
        .addPolicyToService(_serviceId, policyId, _scaffold.currentContext!);
  }

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  Widget showPolicyList(WidgetRef ref, List<Policy> policies) {
    return Expanded(
      child: ListView.builder(
        itemCount: policies.length,
        itemBuilder: (BuildContext context, int index) {
          final policy = policies[index];

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
              onPressed: () => addPolicyToService(ref, policy.policyId),
              child: const Text(
                'Add',
              ),
            ),
            onTap: () => showPolicyDetails(context, policy.policyId),
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
          data: (userPolicies) {
            if (service.policies.isEmpty) {
              return showPolicyList(ref, userPolicies);
            } else {
              List<Policy> policesNotInService = [];
              for (Policy p in userPolicies) {
                bool foundService = false;
                for (String serviceId in p.consumers) {
                  if (service.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }
                if (foundService == false) {
                  policesNotInService.add(p);
                }
              }

              if (policesNotInService.isNotEmpty) {
                return showPolicyList(ref, policesNotInService);
              } else {
                return Container(
                  alignment: Alignment.topCenter,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('All of your policies are in the service'),
                  ),
                );
              }
            }
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
            List<Policy> policesNotInService = [];
            for (Policy p in policies) {
              bool foundService = false;
              for (String serviceId in p.consumers) {
                if (service.serviceId == serviceId) {
                  foundService = true;
                  break;
                }
              }
              if (foundService == false) {
                policesNotInService.add(p);
              }
            }

            if (policesNotInService.isNotEmpty) {
              return showPolicyList(ref, policesNotInService);
            } else {
              return Container(
                alignment: Alignment.topCenter,
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('All public policies are in the service'),
                ),
              );
            }
          }
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(policyControllerProvider);
    final serviceProv = ref.watch(getServiceByIdProvider(_serviceId));
    final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return serviceProv.when(
      data: (service) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Policy',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Column(
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
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: SearchPolicyDelegate(ref, user, service!,
                                ref.read(searchRadioProvider.notifier).state),
                          );
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  showPolicies(ref, service!, searchRadioProv)
                ],
              ),
              Container(
                child: isLoading ? const Loader() : Container(),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
