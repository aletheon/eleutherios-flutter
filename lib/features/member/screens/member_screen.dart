import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class MemberScreen extends ConsumerWidget {
  final String memberId;
  const MemberScreen({super.key, required this.memberId});

  void updateMember(Member member, WidgetRef ref, BuildContext context) async {
    ref
        .read(memberControllerProvider.notifier)
        .updateMember(member: member, context: context);
  }

  void addToCart(BuildContext context, WidgetRef ref, Service service) {
    Routemaster.of(context).push('add-to-cart/${service.serviceId}');
  }

  void editService(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void navigateToServiceTools(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId/service-tools');
  }

  void navigateToPolicy(BuildContext context, String policyId) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  void navigateToLikes(BuildContext context) {
    Routemaster.of(context).push('likes');
  }

  void likeService(BuildContext context, WidgetRef ref, Service service) {
    UserModel userModel = ref.read(userProvider)!;
    var result =
        userModel.favorites.where((f) => f == service.serviceId).toList();
    if (result.isEmpty) {
      ref
          .read(favoriteControllerProvider.notifier)
          .createFavorite(context, service.serviceId, service.uid);
    } else {
      ref
          .read(favoriteControllerProvider.notifier)
          .deleteFavorite(context, service.serviceId);
    }
  }

  void addForum(BuildContext context, WidgetRef ref, Service service) {
    Routemaster.of(context).push('/addforum/${service.serviceId}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getMemberByIdProvider(memberId)).when(
          data: (member) {
            return ref.watch(getServiceByIdProvider(member!.serviceId)).when(
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
                                              service.price > 0
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Text(
                                                        NumberFormat.currency(
                                                                symbol:
                                                                    '${service.currency} ',
                                                                locale: 'en_US',
                                                                decimalDigits:
                                                                    2)
                                                            .format(
                                                                service.price),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
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
                                          service.tags.isNotEmpty
                                              ? Wrap(
                                                  alignment: WrapAlignment.end,
                                                  direction: Axis.horizontal,
                                                  children:
                                                      service.tags.map((e) {
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
                                                        backgroundColor: service
                                                                    .price ==
                                                                -1
                                                            ? Pallete
                                                                .freeServiceTagColor
                                                            : Pallete
                                                                .paidServiceTagColor,
                                                        label: Text(
                                                          '#$e',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                )
                                              : const SizedBox(),
                                          service.description.isNotEmpty
                                              ? Wrap(
                                                  children: [
                                                    Text(service.description),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      Wrap(
                                        children: [
                                          // like button
                                          service.uid == user.uid
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        navigateToLikes(
                                                            context),
                                                    style: ElevatedButton
                                                        .styleFrom(
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
                                                    child: Text(
                                                        'Likes(${service.likes.length})'),
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        likeService(context,
                                                            ref, service),
                                                    style: ElevatedButton
                                                        .styleFrom(
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
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'Like',
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        ref
                                                                .watch(
                                                                    userProvider)!
                                                                .favorites
                                                                .where((f) =>
                                                                    f ==
                                                                    service
                                                                        .serviceId)
                                                                .toList()
                                                                .isEmpty
                                                            ? const Icon(
                                                                Icons
                                                                    .favorite_outline,
                                                              )
                                                            : const Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          // tools button
                                          user.uid == service.uid
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        navigateToServiceTools(
                                                            context,
                                                            service.serviceId),
                                                    style: ElevatedButton
                                                        .styleFrom(
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
                                                  ),
                                                )
                                              : const SizedBox(),
                                          // edit service button
                                          user.uid == service.uid
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        editService(context),
                                                    style: ElevatedButton
                                                        .styleFrom(
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
                                                    child: const Text('Edit'),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          // add to forum button
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: OutlinedButton(
                                              onPressed: () => addForum(
                                                  context, ref, service),
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 25)),
                                              child: const Text('Add Forum'),
                                            ),
                                          ),
                                          // add to cart button
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: OutlinedButton(
                                              onPressed: () => addToCart(
                                                  context, ref, service),
                                              style: ElevatedButton.styleFrom(
                                                  // side: BorderSide(
                                                  //   width: 1.0,
                                                  //   color: service.price == -1
                                                  //       ? Pallete.freeServiceTagColor
                                                  //       : Pallete.paidServiceTagColor,
                                                  // ),
                                                  backgroundColor:
                                                      Pallete.darkGreenColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 25)),
                                              child: const Text('Add to Cart'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         service.image ==
                                  //                 Constants.avatarDefault
                                  //             ? CircleAvatar(
                                  //                 backgroundImage:
                                  //                     Image.asset(service.image)
                                  //                         .image,
                                  //                 radius: 35,
                                  //               )
                                  //             : CircleAvatar(
                                  //                 backgroundImage: NetworkImage(
                                  //                     service.image),
                                  //                 radius: 35,
                                  //               ),
                                  //         const SizedBox(
                                  //           height: 10,
                                  //         ),
                                  //         Row(
                                  //           children: [
                                  //             Expanded(
                                  //               child: Text(
                                  //                 service.title,
                                  //                 style: const TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                   fontSize: 16,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             const SizedBox(
                                  //               width: 10,
                                  //             ),
                                  //             service.public
                                  //                 ? const Icon(
                                  //                     Icons.lock_open_outlined)
                                  //                 : const Icon(
                                  //                     Icons.lock_outlined,
                                  //                     color: Pallete.greyColor),
                                  //           ],
                                  //         ),
                                  //         const SizedBox(
                                  //           height: 5,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       children: [
                                  //         // tools button
                                  //         user.uid == service.uid
                                  //             ? OutlinedButton(
                                  //                 onPressed: () =>
                                  //                     navigateToServiceTools(
                                  //                         service.serviceId,
                                  //                         context),
                                  //                 style:
                                  //                     ElevatedButton.styleFrom(
                                  //                         shape:
                                  //                             RoundedRectangleBorder(
                                  //                           borderRadius:
                                  //                               BorderRadius
                                  //                                   .circular(
                                  //                                       10),
                                  //                         ),
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .symmetric(
                                  //                                 horizontal:
                                  //                                     25)),
                                  //                 child: const Text(
                                  //                     'Service Tools'),
                                  //               )
                                  //             : const SizedBox(),
                                  //         const SizedBox(
                                  //           width: 5,
                                  //         ),
                                  //         OutlinedButton(
                                  //           onPressed: () => likeService(
                                  //               context, ref, service),
                                  //           style: ElevatedButton.styleFrom(
                                  //               shape: RoundedRectangleBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(10),
                                  //               ),
                                  //               padding:
                                  //                   const EdgeInsets.symmetric(
                                  //                       horizontal: 25)),
                                  //           child: Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.spaceEvenly,
                                  //             children: [
                                  //               const Text(
                                  //                 'Like',
                                  //               ),
                                  //               ref
                                  //                       .watch(userProvider)!
                                  //                       .favorites
                                  //                       .where((f) =>
                                  //                           f ==
                                  //                           service.serviceId)
                                  //                       .toList()
                                  //                       .isEmpty
                                  //                   ? const Icon(
                                  //                       Icons.favorite_outline,
                                  //                     )
                                  //                   : const Icon(
                                  //                       Icons.favorite,
                                  //                       color: Colors.red,
                                  //                     ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      }),
                      // ****************************************************
                      // list permissions
                      // ****************************************************
                      body: member.forumUid == user.uid &&
                              service!.uid != user.uid
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              itemCount: MemberPermissions.values.length,
                              itemBuilder: (BuildContext context, int index) {
                                final name =
                                    MemberPermissions.values[index].value;
                                final value =
                                    MemberPermissions.values[index].value;
                                return CheckboxListTile(
                                  title: Text(
                                    value,
                                    style: const TextStyle(
                                        color: Pallete.greyColor),
                                  ),
                                  value: member.permissions.contains(name),
                                  onChanged: (bool? selected) {
                                    if (selected!) {
                                      if (!member.permissions.contains(name)) {
                                        member.permissions.add(name);
                                      }
                                    } else {
                                      member.permissions.remove(name);
                                    }
                                    updateMember(member, ref, context);
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
