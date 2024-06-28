import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/home/dialogs/search_tag_dialog.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class SearchHomeDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchHomeDelegate(
    this.ref,
  );

  List<Icon> searchIcons = [
    const Icon(
      Icons.construction_outlined,
    ),
    const Icon(
      Icons.sms_outlined,
    ),
    const Icon(
      Icons.account_balance_outlined,
    )
  ];
  List<String> searchValues = [
    SearchType.service.value,
    SearchType.forum.value,
    SearchType.policy.value
  ];
  List<String> searchTags = [];
  String _searchType = SearchType.service.value;
  int searchIconsCount = 0;

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('/forum/$forumId');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
  }

  void changeSearchType(String searchType) {
    _searchType = searchType;
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
                value: _searchType,
                onChanged: (String? value) {
                  if (value is String) {
                    changeSearchType(value);
                  }
                },
                // *********************************
                // items
                // *********************************
                items: searchValues.mapWithIndex<DropdownMenuItem<String>>(
                    (String value, int index) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        searchIcons[index],
                        const SizedBox(
                          width: 10,
                        ),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
              IconButton(
                onPressed: () async {
                  List<String> tags = await showDialog(
                    context: context,
                    builder: (context) => SearchTagDialog(
                      searchType: _searchType,
                      initialTags: searchTags,
                    ),
                  );
                  searchTags = tags;
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
    if (_searchType == SearchType.policy.value) {
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
            ref
                .watch(searchPublicPoliciesProvider(Tuple2(query, searchTags)))
                .when(
                  data: (policies) {
                    return ListView.builder(
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
                                      backgroundImage:
                                          Image.asset(policy.image).image,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(policy.image),
                                    ),
                              onTap: () =>
                                  showForumDetails(context, policy.policyId),
                            ),
                            policy.tags.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, right: 0, left: 10),
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      direction: Axis.horizontal,
                                      children: policy.tags.map((e) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: FilterChip(
                                            visualDensity: const VisualDensity(
                                                vertical: -4, horizontal: -4),
                                            onSelected: (value) {},
                                            backgroundColor:
                                                Pallete.policyTagColor,
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
                    );
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
    } else if (_searchType == SearchType.forum.value) {
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
                          backgroundColor: Pallete.forumTagColor,
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
            ref
                .watch(searchPublicForumsProvider(Tuple2(query, searchTags)))
                .when(
                  data: (forums) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: forums.length,
                      itemBuilder: (BuildContext context, int index) {
                        final forum = forums[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Text(forum.title),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  forum.public
                                      ? const Icon(
                                          Icons.lock_open_outlined,
                                          size: 18,
                                        )
                                      : const Icon(Icons.lock_outlined,
                                          size: 18, color: Pallete.greyColor),
                                ],
                              ),
                              leading: forum.image == Constants.avatarDefault
                                  ? CircleAvatar(
                                      backgroundImage:
                                          Image.asset(forum.image).image,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(forum.image),
                                    ),
                              onTap: () =>
                                  showForumDetails(context, forum.forumId),
                            ),
                            forum.tags.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, right: 0, left: 10),
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      direction: Axis.horizontal,
                                      children: forum.tags.map((e) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: FilterChip(
                                            visualDensity: const VisualDensity(
                                                vertical: -4, horizontal: -4),
                                            onSelected: (value) {},
                                            backgroundColor:
                                                Pallete.forumTagColor,
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
                    );
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
            ref
                .watch(searchPublicServicesProvider(Tuple2(query, searchTags)))
                .when(
                  data: (services) {
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
                                leading: service.image ==
                                        Constants.avatarDefault
                                    ? CircleAvatar(
                                        backgroundImage:
                                            Image.asset(service.image).image,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(service.image),
                                      ),
                                onTap: () => showServiceDetails(
                                    context, service.serviceId),
                              ),
                              service.tags.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, right: 0, left: 10),
                                      child: Wrap(
                                        alignment: WrapAlignment.end,
                                        direction: Axis.horizontal,
                                        children: service.tags.map((e) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: FilterChip(
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -4,
                                                      horizontal: -4),
                                              onSelected: (value) {},
                                              backgroundColor:
                                                  Pallete.freeServiceTagColor,
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
}
