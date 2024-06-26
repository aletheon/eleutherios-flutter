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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          searchTags.isNotEmpty
              ? Wrap(
                  alignment: WrapAlignment.end,
                  direction: Axis.horizontal,
                  children: searchTags.map((e) {
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: Chip(
                            backgroundColor:
                                _searchType == SearchType.policy.value
                                    ? Pallete.policyTagColor
                                    : _searchType == SearchType.forum.value
                                        ? Pallete.forumTagColor
                                        : Pallete.freeServiceTagColor,
                            label: Text('$e#'),
                            avatar: InkWell(
                              onTap: () {
                                print('tap');
                              },
                              child: const Icon(
                                Icons.cancel,
                              ),
                            ),
                          ),
                        ));
                  }).toList(),
                )
              : const SizedBox(),
          ref.watch(searchPublicPoliciesProvider(query.toLowerCase())).when(
                data: (policies) {
                  return ListView.builder(
                    shrinkWrap: true,
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
                        onTap: () =>
                            showPolicyDetails(context, policy.policyId),
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
      );
    } else if (_searchType == SearchType.forum.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          searchTags.isNotEmpty
              ? Wrap(
                  alignment: WrapAlignment.end,
                  direction: Axis.horizontal,
                  children: searchTags.map((e) {
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: Chip(
                            backgroundColor:
                                _searchType == SearchType.policy.value
                                    ? Pallete.policyTagColor
                                    : _searchType == SearchType.forum.value
                                        ? Pallete.forumTagColor
                                        : Pallete.freeServiceTagColor,
                            label: Text('$e#'),
                            avatar: InkWell(
                              onTap: () {
                                print('tap');
                              },
                              child: const Icon(
                                Icons.cancel,
                              ),
                            ),
                          ),
                        ));
                  }).toList(),
                )
              : const SizedBox(),
          ref.watch(searchPublicForumsProvider(query.toLowerCase())).when(
                data: (forums) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: forums.length,
                    itemBuilder: (BuildContext context, int index) {
                      final forum = forums[index];
                      return ListTile(
                        leading: forum.image == Constants.avatarDefault
                            ? CircleAvatar(
                                backgroundImage: Image.asset(forum.image).image,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(forum.image),
                              ),
                        title: Text(forum.title),
                        onTap: () => showForumDetails(context, forum.forumId),
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
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          searchTags.isNotEmpty
              ? Wrap(
                  alignment: WrapAlignment.end,
                  direction: Axis.horizontal,
                  children: searchTags.map((e) {
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: Chip(
                            backgroundColor:
                                _searchType == SearchType.policy.value
                                    ? Pallete.policyTagColor
                                    : _searchType == SearchType.forum.value
                                        ? Pallete.forumTagColor
                                        : Pallete.freeServiceTagColor,
                            label: Text('$e#'),
                            avatar: InkWell(
                              onTap: () {
                                print('tap');
                              },
                              child: const Icon(
                                Icons.cancel,
                              ),
                            ),
                          ),
                        ));
                  }).toList(),
                )
              : const SizedBox(),
          ref.watch(searchPublicServicesProvider(query.toLowerCase())).when(
                data: (services) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        final service = services[index];
                        return ListTile(
                          leading: service.image == Constants.avatarDefault
                              ? CircleAvatar(
                                  backgroundImage:
                                      Image.asset(service.image).image,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(service.image),
                                ),
                          title: Text(service.title),
                          onTap: () =>
                              showServiceDetails(context, service.serviceId),
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
      );
    }
  }
}
