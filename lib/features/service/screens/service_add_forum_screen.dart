import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class ServiceAddForumScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceAddForumScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void registerService(BuildContext context, WidgetRef ref, String forumId) {
    ref
        .read(registrantControllerProvider.notifier)
        .createRegistrant(forumId, _serviceId, context);
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

          return ref
              .watch(serviceIsRegisteredInForumProvider(Tuple2(
                forum.forumId,
                _serviceId,
              )))
              .when(
                data: (isRegistered) {
                  if (isRegistered == false) {
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
                        onPressed: () =>
                            registerService(context, ref, forum.forumId),
                        child: const Text(
                          'Add',
                        ),
                      ),
                      onTap: () => showForumDetails(context, forum.forumId),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
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
            return showForumList(ref, forums);
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
            return showForumList(ref, forums);
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

    return serviceProv.when(
      data: (service) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
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
                    onPressed: () {},
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
