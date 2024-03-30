import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/registrant.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class RegistrantScreen extends ConsumerWidget {
  final String registrantId;
  const RegistrantScreen({super.key, required this.registrantId});

  void navigateToServiceTools(String serviceId, BuildContext context) {
    Routemaster.of(context).push('/service/$serviceId/service-tools');
  }

  void likeService(BuildContext context, WidgetRef ref, Service service) {
    UserModel userModel = ref.read(userProvider)!;
    var result =
        userModel.favorites.where((f) => f == service.serviceId).toList();
    if (result.isEmpty) {
      ref
          .read(favoriteControllerProvider.notifier)
          .createFavorite(service.serviceId, service.uid, context);
    } else {
      ref
          .read(favoriteControllerProvider.notifier)
          .deleteFavorite(service.serviceId, context);
    }
  }

  void updateRegistrant(
      Registrant registrant, WidgetRef ref, BuildContext context) async {
    ref
        .read(registrantControllerProvider.notifier)
        .updateRegistrant(registrant: registrant, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getRegistrantByIdProvider(registrantId)).when(
          data: (registrant) {
            return ref
                .watch(getServiceByIdProvider(registrant!.serviceId))
                .when(
                  data: (service) {
                    return NestedScrollView(
                      headerSliverBuilder: ((context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            expandedHeight: 150,
                            flexibleSpace: Stack(
                              children: [
                                Positioned.fill(
                                  child: service!.banner ==
                                          Constants.serviceBannerDefault
                                      ? Image.asset(
                                          service.banner,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          service.banner,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            return loadingProgress
                                                        ?.cumulativeBytesLoaded ==
                                                    loadingProgress
                                                        ?.expectedTotalBytes
                                                ? child
                                                : const CircularProgressIndicator();
                                          },
                                        ),
                                )
                              ],
                            ),
                            floating: true,
                            snap: true,
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate.fixed(
                                [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          service.image ==
                                                  Constants.avatarDefault
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      Image.asset(service.image)
                                                          .image,
                                                  radius: 35,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      service.image),
                                                  radius: 35,
                                                ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  service.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              service.public
                                                  ? const Icon(
                                                      Icons.lock_open_outlined)
                                                  : const Icon(
                                                      Icons.lock_outlined,
                                                      color: Pallete.greyColor),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // tools button
                                          user.uid == service.uid
                                              ? OutlinedButton(
                                                  onPressed: () =>
                                                      navigateToServiceTools(
                                                          service.serviceId,
                                                          context),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      25)),
                                                  child: const Text(
                                                      'Service Tools'),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          OutlinedButton(
                                            onPressed: () => likeService(
                                                context, ref, service),
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  'Like',
                                                ),
                                                ref
                                                        .watch(userProvider)!
                                                        .favorites
                                                        .where((f) =>
                                                            f ==
                                                            service.serviceId)
                                                        .toList()
                                                        .isEmpty
                                                    ? const Icon(
                                                        Icons.favorite_outline,
                                                      )
                                                    : const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      }),
                      // ****************************************************
                      // list permissions
                      // ****************************************************
                      body: registrant!.forumUid == user.uid &&
                              service!.uid != user.uid
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              itemCount: RegistrantPermissions.values.length,
                              itemBuilder: (BuildContext context, int index) {
                                final name =
                                    RegistrantPermissions.values[index].name;
                                final value =
                                    RegistrantPermissions.values[index].value;
                                return CheckboxListTile(
                                  title: Text(
                                    value,
                                    style: const TextStyle(
                                        color: Pallete.greyColor),
                                  ),
                                  value: registrant.permissions.contains(name),
                                  onChanged: (bool? selected) {
                                    if (selected!) {
                                      if (!registrant.permissions
                                          .contains(name)) {
                                        registrant.permissions.add(name);
                                      }
                                    } else {
                                      registrant.permissions.remove(name);
                                    }
                                    updateRegistrant(registrant, ref, context);
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  activeColor: Pallete.forumColor,
                                );
                              },
                            )
                          : const SizedBox(),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
