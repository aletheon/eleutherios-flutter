import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class SearchPolicyDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final String serviceId;
  final String searchType;
  SearchPolicyDelegate(this.ref, this.user, this.serviceId, this.searchType);

  final searchRadioProvider = StateProvider<String>((ref) => '');
  bool initializedSearch = false;

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  void addPolicyToService(
      BuildContext context, WidgetRef ref, String policyId) {
    ref
        .read(policyControllerProvider.notifier)
        .addPolicyToService(serviceId, policyId, context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;

    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Private",
          ),
          Radio(
            value: "Private",
            groupValue: searchRadioProv,
            onChanged: (newValue) {
              ref.read(searchRadioProvider.notifier).state =
                  newValue.toString();
            },
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Public",
          ),
          Radio(
            value: "Public",
            groupValue: searchRadioProv,
            onChanged: (newValue) {
              ref.read(searchRadioProvider.notifier).state =
                  newValue.toString();
            },
          ),
        ],
      ),
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final serviceProv = ref.watch(getServiceByIdProvider(serviceId));

    // set the search type [Private, Public]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initializedSearch == false) {
        ref.watch(searchRadioProvider.notifier).state = searchType;
        initializedSearch = true;
      }
    });

    return serviceProv.when(
      data: (service) {
        if (ref.watch(searchRadioProvider.notifier).state == "Private") {
          return ref
              .watch(searchPrivatePoliciesProvider(
                  Tuple2(user.uid, query.toLowerCase())))
              .when(
                data: (policies) {
                  if (policies.isNotEmpty) {
                    List<Policy> policesNotInService = [];
                    for (Policy p in policies) {
                      bool foundService = false;
                      for (String serviceId in p.consumers) {
                        if (service!.serviceId == serviceId) {
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
                          child:
                              Text('All of your policies are in the service'),
                        ),
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                },
                error: (error, stackTrace) {
                  print(error.toString());
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              );
        } else {
          return ref
              .watch(
                  searchPublicPoliciesProvider(Tuple2(query.toLowerCase(), [])))
              .when(
                data: (policies) {
                  if (policies.isNotEmpty) {
                    List<Policy> policesNotInService = [];
                    for (Policy p in policies) {
                      bool foundService = false;
                      for (String serviceId in p.consumers) {
                        if (service!.serviceId == serviceId) {
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
                  } else {
                    return const SizedBox();
                  }
                },
                error: (error, stackTrace) {
                  print(error.toString());
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              );
        }
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }

  Widget showPolicyList(WidgetRef ref, List<Policy> policies) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: policies.length,
        itemBuilder: (BuildContext context, int index) {
          final policy = policies[index];
          return ListTile(
            leading: policy.image == Constants.avatarDefault
                ? CircleAvatar(
                    backgroundImage: Image.asset(policy.image).image,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(policy.image),
                  ),
            title: Text(policy.title),
            trailing: TextButton(
              onPressed: () =>
                  addPolicyToService(context, ref, policy.policyId),
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
}
