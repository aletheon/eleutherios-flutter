import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/dialogs/search_tag_dialog.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/search.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class SearchPolicyDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final Service service;
  String searchType;
  SearchPolicyDelegate(this.ref, this.user, this.service, this.searchType);

  List<String> searchValues = ['Private', 'Public'];
  List<String> searchTags = [];
  bool firstTimeThrough = true;

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  void addPolicyToService(
      BuildContext context, WidgetRef ref, String policyId) {
    ref
        .read(policyControllerProvider.notifier)
        .addPolicyToService(service.serviceId, policyId, context);
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
                      searchType: SearchType.policy.value,
                      initialTags: searchTags,
                      user: user,
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

      if (firstTimeThrough == true) {
        searchTags = user.searchTags;
        searchPrivate = searchPrivate.copyWith(tags: user.searchTags);
        firstTimeThrough = false;
      }

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
                          backgroundColor: Pallete.policyTagColor,
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
            ref.watch(searchPrivatePoliciesProvider(searchPrivate)).when(
                  data: (policies) {
                    if (policies.isNotEmpty) {
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
                            child:
                                Text('All of your policies are in the service'),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('No policies found'),
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

      if (firstTimeThrough == true) {
        searchTags = user.searchTags;
        searchPublic = searchPublic.copyWith(tags: user.searchTags);
        firstTimeThrough = false;
      }

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
                          backgroundColor: Pallete.policyTagColor,
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
            ref.watch(searchPublicPoliciesProvider(searchPublic)).when(
                  data: (policies) {
                    if (policies.isNotEmpty) {
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
                            child:
                                Text('All public policies are in the service'),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('No policies found'),
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

  Widget showPolicyList(WidgetRef ref, List<Policy> policies) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: policies.length,
        itemBuilder: (BuildContext context, int index) {
          final policy = policies[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(policy.title),
                    const SizedBox(
                      width: 5,
                    ),
                    policy.public
                        ? const Icon(
                            Icons.lock_open_outlined,
                            size: 18,
                          )
                        : const Icon(Icons.lock_outlined,
                            size: 18, color: Pallete.greyColor),
                  ],
                ),
                leading: policy.image == Constants.avatarDefault
                    ? CircleAvatar(
                        backgroundImage: Image.asset(policy.image).image,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(policy.image),
                      ),
                trailing: TextButton(
                  onPressed: () =>
                      addPolicyToService(context, ref, policy.policyId),
                  child: const Text(
                    'Add',
                  ),
                ),
                onTap: () => showPolicyDetails(context, policy.policyId),
              ),
              policy.tags.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 0, right: 0, left: 10),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        children: policy.tags.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: FilterChip(
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              onSelected: (value) {},
                              backgroundColor: Pallete.policyTagColor,
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
