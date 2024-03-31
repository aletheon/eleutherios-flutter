import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ServiceLikesScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceLikesScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void navigateToUser(BuildContext context, String uid) {
    Routemaster.of(context).push(uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getServiceByIdProvider(_serviceId)).when(
          data: (service) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${service!.title} Likes',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                itemCount: service.likes.length,
                itemBuilder: (BuildContext context, int index) {
                  if (service.likes.isNotEmpty) {
                    return ref
                        .watch(getUserDataProvider(service.likes[index]))
                        .when(
                          data: (user) {
                            return ListTile(
                              leading: user!.profilePic ==
                                      Constants.avatarDefault
                                  ? CircleAvatar(
                                      backgroundImage:
                                          Image.asset(user.profilePic).image,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.profilePic),
                                    ),
                              title: Text(user.fullName),
                              onTap: () => navigateToUser(context, user.uid),
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => const Loader(),
                        );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('There are no likes for this service'),
                      ),
                    );
                  }
                },
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
