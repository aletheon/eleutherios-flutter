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

  void removeFavorite(BuildContext context, WidgetRef ref, String serviceId) {
    ref
        .watch(favoriteControllerProvider.notifier)
        .deleteFavorite(serviceId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push(serviceId);
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
                ? Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'No favorites',
                        style: TextStyle(fontSize: 14),
                      ),
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
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              service!.title,
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          service.public
                                              ? const Icon(
                                                  Icons.lock_open_outlined,
                                                  size: 18,
                                                )
                                              : const Icon(Icons.lock_outlined,
                                                  size: 18,
                                                  color: Pallete.greyColor),
                                        ],
                                      ),
                                      leading: service.image ==
                                              Constants.avatarDefault
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  Image.asset(service.image)
                                                      .image,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(service.image),
                                            ),
                                      trailing: TextButton(
                                        onPressed: () => removeFavorite(
                                            context, ref, favorite.serviceId),
                                        child: const Text(
                                          'Remove',
                                        ),
                                      ),
                                      onTap: () => showServiceDetails(
                                          context, service.serviceId),
                                    ),
                                    service.tags.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, right: 20, left: 10),
                                            child: Wrap(
                                              alignment: WrapAlignment.end,
                                              direction: Axis.horizontal,
                                              children: service.tags.map((e) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: FilterChip(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4,
                                                            horizontal: -4),
                                                    onSelected: (value) {},
                                                    backgroundColor: Pallete
                                                        .freeServiceTagColor,
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
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      },
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
