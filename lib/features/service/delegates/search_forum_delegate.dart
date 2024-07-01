import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/dialogs/search_tag_dialog.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/search.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class SearchForumDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final String serviceId;
  String searchType;
  SearchForumDelegate(this.ref, this.user, this.serviceId, this.searchType);

  List<String> searchValues = ['Private', 'Public'];
  List<String> searchTags = [];

  void registerService(BuildContext context, WidgetRef ref, String forumId) {
    ref
        .read(memberControllerProvider.notifier)
        .createMember(forumId, serviceId, context);
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('/forum/$forumId');
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
                  List<String> tags = await showDialog(
                    context: context,
                    builder: (context) => SearchTagDialog(
                      searchType: SearchType.forum.value,
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
            ref.watch(searchPrivateForumsProvider(searchPrivate)).when(
                  data: (forums) {
                    if (forums.isNotEmpty) {
                      List<Forum> forumsNotContainingService = [];
                      for (Forum f in forums) {
                        bool foundService = false;
                        for (String s in f.services) {
                          if (s == serviceId) {
                            foundService = true;
                            break;
                          }
                        }

                        if (foundService == false) {
                          forumsNotContainingService.add(f);
                        }
                      }

                      if (forumsNotContainingService.isNotEmpty) {
                        return showForumList(ref, forumsNotContainingService);
                      } else {
                        return Container(
                          alignment: Alignment.topCenter,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child:
                                Text('All of your forums are in the service'),
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
            ref.watch(searchPublicForumsProvider(searchPublic)).when(
                  data: (forums) {
                    if (forums.isNotEmpty) {
                      List<Forum> forumsNotContainingService = [];
                      for (Forum f in forums) {
                        bool foundService = false;
                        for (String s in f.services) {
                          if (s == serviceId) {
                            foundService = true;
                            break;
                          }
                        }

                        if (foundService == false) {
                          forumsNotContainingService.add(f);
                        }
                      }

                      if (forumsNotContainingService.isNotEmpty) {
                        return showForumList(ref, forumsNotContainingService);
                      } else {
                        return Container(
                          alignment: Alignment.topCenter,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text('All public forums are in the service'),
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
                )
          ],
        ),
      );
    }
  }

  Widget showForumList(WidgetRef ref, List<Forum> forums) {
    return Expanded(
      child: ListView.builder(
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
                        backgroundImage: Image.asset(forum.image).image,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(forum.image),
                      ),
                trailing: TextButton(
                  onPressed: () => registerService(context, ref, forum.forumId),
                  child: const Text(
                    'Add',
                  ),
                ),
                onTap: () => showForumDetails(context, forum.forumId),
              ),
              forum.tags.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 0, right: 0, left: 10),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        children: forum.tags.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: FilterChip(
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              onSelected: (value) {},
                              backgroundColor: Pallete.forumTagColor,
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
