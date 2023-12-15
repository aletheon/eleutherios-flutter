import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ListUserFavoriteScreen extends ConsumerWidget {
  const ListUserFavoriteScreen({super.key});

  void removeFavorite(String serviceId, WidgetRef ref, BuildContext context) {
    ref
        .watch(favoriteControllerProvider.notifier)
        .deleteFavorite(serviceId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('detail/$serviceId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userFavoritesProvider).when(
          data: (favorites) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Favorites(${favorites.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: favorites.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("You don't have any favorites"),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (BuildContext context, int index) {
                        final favorite = favorites[index];

                        return ref
                            .watch(getServiceByIdProvider(favorite.serviceId))
                            .when(
                              data: (service) {
                                return ListTile(
                                  title: Text(service!.title),
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
                                    onPressed: () => removeFavorite(
                                      favorite.serviceId,
                                      ref,
                                      context,
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

                        // return ListTile(
                        //   leading: forum.image == Constants.avatarDefault
                        //       ? CircleAvatar(
                        //           backgroundImage:
                        //               Image.asset(forum.image).image,
                        //         )
                        //       : CircleAvatar(
                        //           backgroundImage: NetworkImage(forum.image),
                        //         ),
                        //   title: Text(forum.title),
                        //   onTap: () => showForumDetails(context, forum.forumId),
                        // );
                      },
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
