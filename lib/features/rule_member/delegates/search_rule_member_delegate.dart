import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/dialogs/search_tag_dialog.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/search.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class SearchRuleMemberDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final Rule rule;
  String searchType;
  SearchRuleMemberDelegate(this.ref, this.user, this.rule, this.searchType);

  List<String> searchValues = ['Private', 'Public'];
  List<String> searchTags = [];

  void addRuleMemberService(
      BuildContext context, WidgetRef ref, String serviceId) {
    ref
        .read(ruleMemberControllerProvider.notifier)
        .createRuleMember(rule.ruleId, serviceId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
  }

  void changeSearchType(String selectedType) {
    searchType = selectedType;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              DropdownButton(
                isDense: true,
                value: searchType,
                onChanged: (String? selectedType) {
                  if (selectedType is String) {
                    changeSearchType(selectedType);
                  }
                },
                items:
                    searchValues.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => SearchTagDialog(
                      searchType: SearchType.service.value,
                      initialTags: searchTags,
                    ),
                  ).then((tags) {
                    if (tags != null) {
                      searchTags = tags;
                    }
                  });
                },
                icon: const Icon(Icons.tag),
              ),
              IconButton(
                onPressed: () {
                  query = '';
                },
                icon: const Icon(Icons.close),
              )
            ],
          )
        ],
      )
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
    if (searchType == "Private") {
      Search searchPrivate =
          Search(uid: user.uid, query: query.toLowerCase(), tags: searchTags);

      return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            searchTags.isNotEmpty
                ? Wrap(
                    alignment: WrapAlignment.end,
                    direction: Axis.horizontal,
                    children: searchTags.map((e) {
                      return Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: Chip(
                          visualDensity:
                              const VisualDensity(vertical: -4, horizontal: -4),
                          backgroundColor: Pallete.freeServiceTagColor,
                          label: Text(
                            '#$e',
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          onDeleted: () {
                            searchTags.remove(e);
                            searchTags =
                                searchTags.isNotEmpty ? searchTags : [];
                            query = query;
                          },
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox(),
            ref.watch(searchPrivateServicesProvider(searchPrivate)).when(
                  data: (services) {
                    if (services.isNotEmpty) {
                      List<Service> servicesNotInRule = [];
                      for (Service service in services) {
                        bool foundService = false;
                        for (String serviceId in rule.services) {
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
                      return Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('No services found'),
                        ),
                      );
                    }
                  },
                  error: (error, stackTrace) {
                    print(error.toString());
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                )
          ],
        ),
      );
    } else {
      Search searchPublic =
          Search(uid: '', query: query.toLowerCase(), tags: searchTags);

      return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            searchTags.isNotEmpty
                ? Wrap(
                    alignment: WrapAlignment.end,
                    direction: Axis.horizontal,
                    children: searchTags.map((e) {
                      return Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: Chip(
                          visualDensity:
                              const VisualDensity(vertical: -4, horizontal: -4),
                          backgroundColor: Pallete.freeServiceTagColor,
                          label: Text(
                            '#$e',
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          onDeleted: () {
                            searchTags.remove(e);
                            searchTags =
                                searchTags.isNotEmpty ? searchTags : [];
                            query = query;
                          },
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox(),
            ref.watch(searchPublicServicesProvider(searchPublic)).when(
                  data: (services) {
                    if (services.isNotEmpty) {
                      List<Service> servicesNotInRule = [];
                      for (Service service in services) {
                        bool foundService = false;
                        for (String serviceId in rule.services) {
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
                            child: Text('All public services are in the rule'),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('No services found'),
                        ),
                      );
                    }
                  },
                  error: (error, stackTrace) {
                    print(error.toString());
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                )
          ],
        ),
      );
    }
  }

  Widget showServiceList(WidgetRef ref, List<Service> services) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
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
                          const EdgeInsets.only(top: 0, right: 0, left: 10),
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
