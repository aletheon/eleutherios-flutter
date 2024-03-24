import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class LeaveScreen extends ConsumerWidget {
  final String _forumId;
  const LeaveScreen({super.key, required String forumId}) : _forumId = forumId;

  void deRegisterService(BuildContext context, WidgetRef ref, String forumId,
      String registrantId) {
    ref
        .read(registrantControllerProvider.notifier)
        .deleteRegistrant(forumId, registrantId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumProv = ref.watch(getForumByIdProvider(_forumId));
    final registrantsProv = ref.watch(getRegistrantsProvider(_forumId));
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return forumProv.when(
      data: (forum) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Services',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: registrantsProv.when(
            data: (registrants) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: registrants.length,
                  itemBuilder: (BuildContext context, int index) {
                    final registrant = registrants[index];

                    if (registrant.serviceUid == user.uid) {
                      return ref
                          .watch(getServiceByIdProvider(registrant.serviceId))
                          .when(
                            data: (service) {
                              return ListTile(
                                title: registrant.selected == false
                                    ? Text(service!.title)
                                    : Row(
                                        children: [
                                          Text(service!.title),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.check,
                                            color:
                                                Color.fromARGB(255, 3, 233, 33),
                                          )
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
                                trailing: TextButton(
                                  onPressed: () => deRegisterService(
                                    context,
                                    ref,
                                    forum!.forumId,
                                    registrant.registrantId,
                                  ),
                                  child: const Text(
                                    'Remove',
                                  ),
                                ),
                                onTap: () => showServiceDetails(
                                    context, service.serviceId),
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
