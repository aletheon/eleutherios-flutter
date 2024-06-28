import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class SearchRuleMemberDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final String ruleId;
  final String searchType;
  SearchRuleMemberDelegate(this.ref, this.user, this.ruleId, this.searchType);

  final searchRadioProvider = StateProvider<String>((ref) => '');
  bool initializedSearch = false;

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
  }

  void addRuleMemberService(
      BuildContext context, WidgetRef ref, String serviceId) {
    ref
        .read(ruleMemberControllerProvider.notifier)
        .createRuleMember(ruleId, serviceId, context);
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
    final ruleProv = ref.watch(getRuleByIdProvider(ruleId));

    // set the search type [Private, Public]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initializedSearch == false) {
        ref.watch(searchRadioProvider.notifier).state = searchType;
        initializedSearch = true;
      }
    });

    return ruleProv.when(
      data: (rule) {
        if (ref.watch(searchRadioProvider.notifier).state == "Private") {
          return ref
              .watch(searchPrivateServicesProvider(
                  Tuple2(user.uid, query.toLowerCase())))
              .when(
                data: (services) {
                  if (services.isNotEmpty) {
                    List<Service> servicesNotInRule = [];
                    for (var service in services) {
                      bool foundService = false;
                      for (String serviceId in rule!.services) {
                        if (service.serviceId == serviceId) {
                          foundService = true;
                          break;
                        }
                      }

                      if (foundService == false) {
                        servicesNotInRule.add(service);
                      }
                    }

                    if (servicesNotInRule.isNotEmpty) {
                      return showServiceList(ref, servicesNotInRule);
                    } else {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('All of your services are in the rule'),
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
                  searchPublicServicesProvider(Tuple2(query.toLowerCase(), [])))
              .when(
                data: (services) {
                  if (services.isNotEmpty) {
                    List<Service> servicesNotInRule = [];
                    for (var service in services) {
                      bool foundService = false;
                      for (String serviceId in rule!.services) {
                        if (service.serviceId == serviceId) {
                          foundService = true;
                          break;
                        }
                      }

                      if (foundService == false) {
                        servicesNotInRule.add(service);
                      }
                    }

                    if (servicesNotInRule.isNotEmpty) {
                      return showServiceList(ref, servicesNotInRule);
                    } else {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('All pulic services are in the rule'),
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

  Widget showServiceList(WidgetRef ref, List<Service> services) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          final service = services[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(service.title),
                    const SizedBox(
                      width: 5,
                    ),
                    service.public
                        ? const Icon(
                            Icons.lock_open_outlined,
                            size: 18,
                          )
                        : const Icon(Icons.lock_outlined,
                            size: 18, color: Pallete.greyColor),
                  ],
                ),
                leading: service.image == Constants.avatarDefault
                    ? CircleAvatar(
                        backgroundImage: Image.asset(service.image).image,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(service.image),
                      ),
                trailing: TextButton(
                  onPressed: () =>
                      addRuleMemberService(context, ref, service.serviceId),
                  child: const Text(
                    'Add',
                  ),
                ),
                onTap: () => showServiceDetails(context, service.serviceId),
              ),
              service.tags.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 0, right: 20, left: 10),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        children: service.tags.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: FilterChip(
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              onSelected: (value) {},
                              backgroundColor: Pallete.freeServiceTagColor,
                              label: Text(
                                '#$e',
                                style: const TextStyle(
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
      ),
    );
  }
}
