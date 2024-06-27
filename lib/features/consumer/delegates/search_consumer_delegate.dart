import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class SearchConsumerDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final Policy policy;
  final String searchType;
  SearchConsumerDelegate(this.ref, this.user, this.policy, this.searchType);

  final searchRadioProvider = StateProvider<String>((ref) => '');
  bool initializedSearch = false;

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
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
    // set the search type [Private, Public]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initializedSearch == false) {
        ref.watch(searchRadioProvider.notifier).state = searchType;
        initializedSearch = true;
      }
    });

    if (ref.watch(searchRadioProvider.notifier).state == "Private") {
      return ref
          .watch(searchPrivateServicesProvider(
              Tuple2(user.uid, query.toLowerCase())))
          .when(
            data: (services) {
              if (services.isNotEmpty) {
                List<Service> servicesNotInPolicy = [];
                for (Service s in services) {
                  bool result = false;
                  for (String p in s.policies) {
                    if (p == policy.policyId) {
                      result = true;
                      break;
                    }
                  }
                  if (result == false) {
                    servicesNotInPolicy.add(s);
                  }
                }

                if (servicesNotInPolicy.isNotEmpty) {
                  return showServiceList(ref, servicesNotInPolicy);
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('All of your services are in the policy'),
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
          .watch(searchPublicServicesProvider(Tuple2(query.toLowerCase(), [])))
          .when(
            data: (services) {
              if (services.isNotEmpty) {
                List<Service> servicesNotInPolicy = [];
                for (Service s in services) {
                  bool result = false;
                  for (String p in s.policies) {
                    if (p == policy.policyId) {
                      result = true;
                      break;
                    }
                  }
                  if (result == false) {
                    servicesNotInPolicy.add(s);
                  }
                }

                if (servicesNotInPolicy.isNotEmpty) {
                  return showServiceList(ref, servicesNotInPolicy);
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('All public services are in the policy'),
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
  }

  Widget showServiceList(WidgetRef ref, List<Service> services) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          final service = services[index];
          return ListTile(
            leading: service.image == Constants.avatarDefault
                ? CircleAvatar(
                    backgroundImage: Image.asset(service.image).image,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(service.image),
                  ),
            title: Text(service.title),
            onTap: () => showServiceDetails(context, service.serviceId),
          );
        },
      ),
    );
  }
}
