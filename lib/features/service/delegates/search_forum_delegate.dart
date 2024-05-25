import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class SearchForumDelegate extends SearchDelegate {
  final WidgetRef ref;
  final UserModel user;
  final String serviceId;
  final String searchType;
  SearchForumDelegate(this.ref, this.user, this.serviceId, this.searchType);

  final searchRadioProvider = StateProvider<String>((ref) => '');
  bool initializedSearch = false;

  void registerService(BuildContext context, WidgetRef ref, String forumId) {
    ref
        .read(memberControllerProvider.notifier)
        .createMember(forumId, serviceId, context);
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('/forum/$forumId');
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
              .watch(searchPrivateForumsProvider(
                  Tuple2(user.uid, query.toLowerCase())))
              .when(
                data: (forums) {
                  if (forums.isNotEmpty) {
                    List<Forum> forumsNotContainingService = [];
                    for (Forum f in forums) {
                      bool foundService = false;
                      for (String s in f.services) {
                        if (s == service!.serviceId) {
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
                          child: Text('All of your forums are in the service'),
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
              .watch(searchPublicForumsProvider(query.toLowerCase()))
              .when(
                data: (forums) {
                  if (forums.isNotEmpty) {
                    List<Forum> forumsNotContainingService = [];
                    for (Forum f in forums) {
                      bool foundService = false;
                      for (String s in f.services) {
                        if (s == service!.serviceId) {
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
                          child: Text('All public services are in the service'),
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

  Widget showForumList(WidgetRef ref, List<Forum> forums) {
    return Expanded(
      child: ListView.builder(
        itemCount: forums.length,
        itemBuilder: (BuildContext context, int index) {
          final forum = forums[index];

          return ListTile(
            title: Text(forum.title),
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
          );
        },
      ),
    );
  }
}
