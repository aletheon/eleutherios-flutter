import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/delegates/search_forum_delegate.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final GlobalKey _scaffold = GlobalKey();
final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class ServiceAddForumScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceAddForumScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void registerService(WidgetRef ref, String forumId) {
    ref
        .read(memberControllerProvider.notifier)
        .createMember(forumId, _serviceId, _scaffold.currentContext!);
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('/forum/$forumId');
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
              onPressed: () => registerService(ref, forum.forumId),
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

  Widget showForums(WidgetRef ref, Service service, String searchType) {
    final userForumsProv = ref.watch(userForumsProvider);
    final forumsProv = ref.watch(forumsProvider);
    final user = ref.watch(userProvider)!;

    if (searchType == "Private") {
      if (user.forums.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("You haven't created any forums"),
          ),
        );
      } else {
        return userForumsProv.when(
          data: (forums) {
            List<Forum> forumsNotContainingService = [];
            for (Forum f in forums) {
              bool foundService = false;
              for (String s in f.services) {
                if (s == _serviceId) {
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
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
      }
    } else {
      return forumsProv.when(
        data: (forums) {
          if (forums.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("There are no publc forums"),
              ),
            );
          } else {
            List<Forum> forumsNotContainingService = [];
            for (Forum f in forums) {
              bool foundService = false;
              for (String s in f.services) {
                if (s == _serviceId) {
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
          }
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceProv = ref.watch(getServiceByIdProvider(_serviceId));
    final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return serviceProv.when(
      data: (service) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Forum',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Private"),
                  Radio(
                      value: "Private",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  const Text("Public"),
                  Radio(
                      value: "Public",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchForumDelegate(
                          ref,
                          user,
                          _serviceId,
                          ref.read(searchRadioProvider.notifier).state,
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              showForums(ref, service!, searchRadioProv)
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
