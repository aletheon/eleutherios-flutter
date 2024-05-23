import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/rule_member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class SearchRuleMemberDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final Rule rule;
  final AsyncValue<List<RuleMember>> ruleMembersProv;
  final String searchType;
  SearchRuleMemberDelegate(
      this.ref, this.user, this.rule, this.ruleMembersProv, this.searchType);

  final searchRadioProvider = StateProvider<String>((ref) => '');
  bool initializedSearch = false;

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
  }

  void addRuleMemberService(
      BuildContext context, WidgetRef ref, String serviceId) {
    ref
        .read(ruleMemberControllerProvider.notifier)
        .createRuleMember(rule.ruleId, serviceId, context);
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
                return ruleMembersProv.when(
                  data: (ruleMembers) {
                    List<Service> servicesNotInRule = [];
                    for (var service in services) {
                      List<RuleMember> result = ruleMembers
                          .where((r) => r.serviceId == service.serviceId)
                          .toList();
                      if (result.isEmpty) {
                        servicesNotInRule.add(service);
                      }
                    }

                    if (servicesNotInRule.isNotEmpty) {
                      return showServiceList(ref, servicesNotInRule);
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('All of your services are in the rule'),
                        ),
                      );
                    }
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
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
      return ref.watch(searchPublicServicesProvider(query.toLowerCase())).when(
            data: (services) {
              if (services.isNotEmpty) {
                return ruleMembersProv.when(
                  data: (ruleMembers) {
                    List<Service> servicesNotInRule = [];
                    for (var service in services) {
                      List<RuleMember> result = ruleMembers
                          .where((r) => r.serviceId == service.serviceId)
                          .toList();
                      if (result.isEmpty) {
                        servicesNotInRule.add(service);
                      }
                    }

                    if (servicesNotInRule.isNotEmpty) {
                      return showServiceList(ref, servicesNotInRule);
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('All public services are in the rule'),
                        ),
                      );
                    }
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
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
            trailing: TextButton(
              onPressed: () =>
                  addRuleMemberService(context, ref, service.serviceId),
              child: const Text(
                'Add',
              ),
            ),
            onTap: () => showServiceDetails(context, service.serviceId),
          );
        },
      ),
    );
  }
}
