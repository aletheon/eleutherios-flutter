import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/controller/shopping_cart_forum_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/controller/shopping_cart_item_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_member/controller/shopping_cart_member_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum_member.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum_quantity.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class ServiceScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const ServiceScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
  int quantity = 0;
  String? dropdownUserValue;
  String? dropdownForumValue;
  bool firstTimeThroughQuantities = true;
  List<ShoppingCartForumQuantity> shoppingCartForumQuantities = [];

  void addToCart(
    BuildContext context,
    ShoppingCart? shoppingCart,
    UserModel user,
    Service service,
  ) {
    // add physical item to shopping cart
    if (service.type == ServiceType.physical.value) {
      if (service.quantity > 0) {
        if (user.shoppingCartUserIds.isEmpty) {
          // add service to the currently logged in user
          ref
              .read(shoppingCartItemControllerProvider.notifier)
              .createShoppingCartItem(
                user,
                shoppingCart,
                null,
                null,
                service.serviceId,
                quantity,
                context,
              );
        } else {
          // let the user choose which cart they want to add the service to including their own cart
          Routemaster.of(context).push('add-to-cart');
        }
      } else {
        showSnackBar(
            context,
            'There is not enough of this service to purchase there is zero available',
            true);
      }
    } else {
      // add non-physical item to shopping cart
      if (user.shoppingCartUserIds.isEmpty) {
        // add service to the currently logged in user
        ref
            .read(shoppingCartItemControllerProvider.notifier)
            .createShoppingCartItem(
              user,
              shoppingCart,
              null,
              null,
              service.serviceId,
              1,
              context,
            );
      } else {
        // let the user choose which cart they want to add the service to including their own cart
        Routemaster.of(context).push('add-to-cart');
      }
    }
  }

  void removeFromCart(
    BuildContext context,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    UserModel user,
    Service service,
  ) {
    if (user.shoppingCartUserIds.isEmpty) {
      // remove service from the currently logged in user
      ref
          .read(shoppingCartItemControllerProvider.notifier)
          .deleteShoppingCartItem(
            user,
            shoppingCart,
            shoppingCartItem,
            service,
            context,
          );
    } else {
      // let the user choose which cart they want to remove the service from including their own cart
      Routemaster.of(context).push('remove-from-cart');
    }
  }

  void increaseQuantity(
    BuildContext context,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    UserModel user,
    Service service,
  ) {
    ref
        .read(shoppingCartItemControllerProvider.notifier)
        .increaseShoppingCartItemQuantity(
          shoppingCart,
          shoppingCartItem,
          service,
          context,
        );
  }

  void decreaseQuantity(
    BuildContext context,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    UserModel user,
    Service service,
  ) {
    ref
        .read(shoppingCartItemControllerProvider.notifier)
        .decreaseShoppingCartItemQuantity(
          user,
          shoppingCart,
          shoppingCartItem,
          service,
          context,
        );
  }

  void editService(
    BuildContext context,
  ) {
    Routemaster.of(context).push('edit');
  }

  void navigateToServiceTools(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/service/${widget.serviceId}/service-tools');
  }

  void navigateToPolicy(
    BuildContext context,
    String policyId,
  ) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  void navigateToLikes(
    BuildContext context,
  ) {
    Routemaster.of(context).push('likes');
  }

  void likeService(
    BuildContext context,
    WidgetRef ref,
    Service service,
  ) {
    UserModel userModel = ref.read(userProvider)!;
    var result =
        userModel.favorites.where((f) => f == service.serviceId).toList();
    if (result.isEmpty) {
      ref
          .read(favoriteControllerProvider.notifier)
          .createFavorite(context, widget.serviceId, service.uid);
    } else {
      ref
          .read(favoriteControllerProvider.notifier)
          .deleteFavorite(context, widget.serviceId);
    }
  }

  void addForum(
    BuildContext context,
    WidgetRef ref,
  ) {
    Routemaster.of(context).push('/addforum/${widget.serviceId}');
  }

  void showUserDetails(
    BuildContext context,
    String uid,
  ) {
    Routemaster.of(context).push('/user/$uid');
  }

  // class ShoppingCartForumQuantity {
  // final String shoppingCartId;
  // final String uid; // owner or superuser of this shopping cart
  // final String forumId;
  // final int quantity;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final user = ref.watch(userProvider)!;

  //     if (user.shoppingCartUserIds.isNotEmpty) {
  //       for (String userId in user.shoppingCartUserIds) {
  //         // get cart user
  //         UserModel? cartUser = await ref
  //             .read(authControllerProvider.notifier)
  //             .getUserData(userId)
  //             .first;

  //         // HERE ROB NEED TO FETCH shoppingCartItem to SET the quantity with that stored in shoppingCartItem
  //         // return ref
  //         //                   .watch(getShoppingCartItemByServiceIdProvider(
  //         //                       Tuple2(shoppingCart!.shoppingCartId,
  //         //                           widget.serviceId)))
  //         //                   .when(
  //         //                     data: (shoppingCartItem) {

  //         if (cartUser != null) {
  //           // get shopping cart forums for this cartUser
  //           List<ShoppingCartForum>? shoppingCartForums = await ref
  //               .read(shoppingCartForumControllerProvider.notifier)
  //               .getShoppingCartForumsByUserId(cartUser.uid, user.uid)
  //               .first;
  //         }
  //       }
  //     }
  //   });
  // }

  // 0) give current user ability to add item to their shopping cart
  // 1) get user
  // 2) get shoppingCartUser
  // 3) get shoppingCartForum
  // 4) get shoppingCartMember
  // 5) list each user and the forums associated to them with a dropdown of each selected member with add-to-cart / remove-from-cart buttons

  Widget showShoppingCartUsers(
    UserModel user,
    Service service,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      itemCount: user.shoppingCartUserIds.length,
      itemBuilder: (BuildContext context, int index) {
        final userId = user.shoppingCartUserIds[index];

        // get the user
        return ref.watch(getUserByIdProvider(userId)).when(
              data: (cartUser) {
                if (cartUser != null) {
                  // get the shopping cart
                  return ref.watch(getShoppingCartByUidProvider(user.uid)).when(
                        data: (shoppingCart) {
                          if (shoppingCart != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // ***************************************************
                                // show user info
                                // ***************************************************
                                ListTile(
                                  title: Text(cartUser.fullName),
                                  leading: cartUser.profilePic ==
                                          Constants.avatarDefault
                                      ? CircleAvatar(
                                          backgroundImage:
                                              Image.asset(cartUser.profilePic)
                                                  .image,
                                          radius: 20,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: Image.network(
                                            cartUser.profilePic,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              return loadingProgress
                                                          ?.cumulativeBytesLoaded ==
                                                      loadingProgress
                                                          ?.expectedTotalBytes
                                                  ? child
                                                  : const CircularProgressIndicator();
                                            },
                                          ).image,
                                          radius: 20,
                                        ),
                                  onTap: () =>
                                      showUserDetails(context, cartUser.uid),
                                ),
                                // ***************************************************
                                // show forum info
                                // ***************************************************
                                // get the shopping cart forums
                                ref
                                    .watch(shoppingCartForumsProvider(
                                        Tuple2(cartUser.uid, user.uid)))
                                    .when(
                                      data: (shoppingCartForums) {
                                        if (shoppingCartForums.isNotEmpty) {
                                          return Column(
                                            children: shoppingCartForums
                                                .map((shoppingCartForum) {
                                              // get the forum
                                              return ref
                                                  .watch(
                                                    getForumByIdProvider(
                                                        shoppingCartForum
                                                            .forumId),
                                                  )
                                                  .when(
                                                    data: (forum) {
                                                      if (forum != null) {
                                                        // get selected shopping cart member
                                                        return ref
                                                            .watch(
                                                              getSelectedShoppingCartMemberProvider(
                                                                Tuple2(
                                                                  forum.forumId,
                                                                  user.uid,
                                                                ),
                                                              ),
                                                            )
                                                            .when(
                                                              data:
                                                                  (shoppingCartMember) {
                                                                if (shoppingCartMember !=
                                                                    null) {
                                                                  // get selected shopping cart member service
                                                                  return ref
                                                                      .watch(getServiceByIdProvider(
                                                                          shoppingCartMember
                                                                              .serviceId))
                                                                      .when(
                                                                        data:
                                                                            (selectedService) {
                                                                          if (selectedService !=
                                                                              null) {
                                                                            // get shopping cart item
                                                                            return ref
                                                                                .watch(
                                                                                  getShoppingCartItemByServiceIdProvider(
                                                                                    Tuple3(
                                                                                      shoppingCart.shoppingCartId,
                                                                                      forum.forumId,
                                                                                      widget.serviceId,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                                .when(
                                                                                  data: (shoppingCartItem) {
                                                                                    return Column(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: MediaQuery.sizeOf(context).width,
                                                                                          child: const Divider(color: Colors.grey, thickness: 1.0),
                                                                                        ),
                                                                                        // forum title
                                                                                        Align(
                                                                                          alignment: Alignment.topRight,
                                                                                          child: Wrap(
                                                                                            crossAxisAlignment: WrapCrossAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                forum.title,
                                                                                                style: const TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: 16,
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                ' - ${selectedService.title}',
                                                                                                style: const TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontStyle: FontStyle.italic,
                                                                                                  fontSize: 16,
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // add to cart button(s)
                                                                                        Align(
                                                                                          alignment: Alignment.topRight,
                                                                                          child: Wrap(
                                                                                            crossAxisAlignment: WrapCrossAlignment.center,
                                                                                            children: [
                                                                                              service.quantity != -1
                                                                                                  ? Container(
                                                                                                      margin: const EdgeInsets.only(right: 10),
                                                                                                      child: Text(
                                                                                                        '${service.quantity} available',
                                                                                                        softWrap: true,
                                                                                                      ),
                                                                                                    )
                                                                                                  : const SizedBox(),
                                                                                              service.quantity != -1
                                                                                                  ? Card(
                                                                                                      color: Colors.blue,
                                                                                                      shape: RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                      ),
                                                                                                      child: SizedBox(
                                                                                                        height: 35,
                                                                                                        width: 120,
                                                                                                        child: AnimatedSwitcher(
                                                                                                          duration: const Duration(milliseconds: 500),
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                            children: [
                                                                                                              IconButton(
                                                                                                                  icon: const Icon(Icons.remove),
                                                                                                                  onPressed: () {
                                                                                                                    setState(() {
                                                                                                                      if (quantity > 0) {
                                                                                                                        quantity--;
                                                                                                                      }
                                                                                                                    });
                                                                                                                    decreaseQuantity(
                                                                                                                      context,
                                                                                                                      shoppingCart,
                                                                                                                      shoppingCartItem,
                                                                                                                      user,
                                                                                                                      service,
                                                                                                                    );
                                                                                                                  }),
                                                                                                              shoppingCartItem != null ? Text((shoppingCartItem.quantity).toString()) : Text(quantity.toString()),
                                                                                                              IconButton(
                                                                                                                  icon: const Icon(Icons.add),
                                                                                                                  onPressed: () {
                                                                                                                    setState(() {
                                                                                                                      quantity++;
                                                                                                                    });
                                                                                                                    increaseQuantity(
                                                                                                                      context,
                                                                                                                      shoppingCart,
                                                                                                                      shoppingCartItem,
                                                                                                                      user,
                                                                                                                      service,
                                                                                                                    );
                                                                                                                  }),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  : const SizedBox(),
                                                                                              shoppingCart.services.contains(service.serviceId) == false
                                                                                                  ? Container(
                                                                                                      margin: const EdgeInsets.only(
                                                                                                        left: 5,
                                                                                                      ),
                                                                                                      child: OutlinedButton(
                                                                                                        onPressed: () => addToCart(
                                                                                                          context,
                                                                                                          shoppingCart,
                                                                                                          user,
                                                                                                          service,
                                                                                                        ),
                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                            backgroundColor: Pallete.darkGreenColor,
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                                                        child: const Text('Add to Cart'),
                                                                                                      ),
                                                                                                    )
                                                                                                  : Container(
                                                                                                      margin: const EdgeInsets.only(
                                                                                                        left: 5,
                                                                                                      ),
                                                                                                      child: OutlinedButton(
                                                                                                        onPressed: () => removeFromCart(
                                                                                                          context,
                                                                                                          shoppingCart,
                                                                                                          shoppingCartItem,
                                                                                                          user,
                                                                                                          service,
                                                                                                        ),
                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                            backgroundColor: Pallete.redPinkColor,
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                                                        child: const Text('Remove from Cart'),
                                                                                                      ),
                                                                                                    ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                  error: (error, stackTrace) => ErrorText(error: error.toString()),
                                                                                  loading: () => const Loader(),
                                                                                );
                                                                          } else {
                                                                            return const SizedBox();
                                                                          }
                                                                        },
                                                                        error: (error,
                                                                                stackTrace) =>
                                                                            ErrorText(error: error.toString()),
                                                                        loading:
                                                                            () =>
                                                                                const Loader(),
                                                                      );
                                                                } else {
                                                                  return const SizedBox();
                                                                }
                                                              },
                                                              error: (error,
                                                                      stackTrace) =>
                                                                  ErrorText(
                                                                      error: error
                                                                          .toString()),
                                                              loading: () =>
                                                                  const Loader(),
                                                            );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    },
                                                    error: (error,
                                                            stackTrace) =>
                                                        ErrorText(
                                                            error: error
                                                                .toString()),
                                                    loading: () =>
                                                        const Loader(),
                                                  );
                                            }).toList(),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader(),
                                    ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                } else {
                  return const SizedBox();
                }
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getServiceByIdProvider(widget.serviceId)).when(
            data: (service) {
              if (service != null) {
                return ref.watch(getShoppingCartByUidProvider(user.uid)).when(
                      data: (shoppingCart) {
                        return ref
                            .watch(
                              getShoppingCartItemByServiceIdProvider(
                                Tuple3(
                                  shoppingCart!.shoppingCartId,
                                  '',
                                  widget.serviceId,
                                ),
                              ),
                            )
                            .when(
                              data: (shoppingCartItem) {
                                return NestedScrollView(
                                  headerSliverBuilder:
                                      ((context, innerBoxIsScrolled) {
                                    return [
                                      SliverAppBar(
                                        expandedHeight: 150,
                                        flexibleSpace: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: service.banner ==
                                                      Constants
                                                          .serviceBannerDefault
                                                  ? Image.asset(
                                                      service.banner,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      service.banner,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child,
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
                                          delegate:
                                              SliverChildListDelegate.fixed(
                                            [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      service.image ==
                                                              Constants
                                                                  .avatarDefault
                                                          ? CircleAvatar(
                                                              backgroundImage:
                                                                  Image.asset(service
                                                                          .image)
                                                                      .image,
                                                              radius: 35,
                                                            )
                                                          : CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      service
                                                                          .image),
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
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child: Text(
                                                                    NumberFormat.currency(
                                                                            symbol:
                                                                                '${service.currency} ',
                                                                            locale:
                                                                                'en_US',
                                                                            decimalDigits:
                                                                                2)
                                                                        .format(
                                                                            service.price),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                          service.public
                                                              ? const Icon(Icons
                                                                  .lock_open_outlined)
                                                              : const Icon(
                                                                  Icons
                                                                      .lock_outlined,
                                                                  color: Pallete
                                                                      .greyColor),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      service.tags.isNotEmpty
                                                          ? Wrap(
                                                              alignment:
                                                                  WrapAlignment
                                                                      .end,
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: service
                                                                  .tags
                                                                  .map((e) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              5),
                                                                  child:
                                                                      FilterChip(
                                                                    visualDensity: const VisualDensity(
                                                                        vertical:
                                                                            -4,
                                                                        horizontal:
                                                                            -4),
                                                                    onSelected:
                                                                        (value) {},
                                                                    backgroundColor: service.price ==
                                                                            -1
                                                                        ? Pallete
                                                                            .freeServiceTagColor
                                                                        : Pallete
                                                                            .paidServiceTagColor,
                                                                    label: Text(
                                                                      '#$e',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            )
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      service.description
                                                              .isNotEmpty
                                                          ? Wrap(
                                                              children: [
                                                                Text(service
                                                                    .description),
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                  Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      // like button
                                                      service.uid == user.uid
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                              child:
                                                                  OutlinedButton(
                                                                onPressed: () =>
                                                                    navigateToLikes(
                                                                        context),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                25)),
                                                                child: Text(
                                                                    'Likes(${service.likes.length})'),
                                                              ),
                                                            )
                                                          : Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                              child:
                                                                  OutlinedButton(
                                                                onPressed: () =>
                                                                    likeService(
                                                                        context,
                                                                        ref,
                                                                        service),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                25)),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
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
                                                                                widget.serviceId)
                                                                            .toList()
                                                                            .isEmpty
                                                                        ? const Icon(
                                                                            Icons.favorite_outline,
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
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                              child:
                                                                  OutlinedButton(
                                                                onPressed: () =>
                                                                    navigateToServiceTools(
                                                                        context),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        padding: const EdgeInsets
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
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                              child:
                                                                  OutlinedButton(
                                                                onPressed: () =>
                                                                    editService(
                                                                        context),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                25)),
                                                                child:
                                                                    const Text(
                                                                        'Edit'),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      // add to forum button
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        child: OutlinedButton(
                                                          onPressed: () =>
                                                              addForum(
                                                            context,
                                                            ref,
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          25)),
                                                          child: const Text(
                                                              'Add Forum'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              service.uid != user.uid &&
                                                      service.canBeOrdered ==
                                                          true
                                                  ? Column(
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                      context)
                                                                  .width,
                                                          child: const Divider(
                                                              color:
                                                                  Colors.grey,
                                                              thickness: 1.0),
                                                        ),
                                                        // add to cart button(s)
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              service.quantity !=
                                                                      -1
                                                                  ? Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        '${service.quantity} available',
                                                                        softWrap:
                                                                            true,
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                              service.quantity !=
                                                                      -1
                                                                  ? Card(
                                                                      color: Colors
                                                                          .blue,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            120,
                                                                        child:
                                                                            AnimatedSwitcher(
                                                                          duration:
                                                                              const Duration(milliseconds: 500),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              IconButton(
                                                                                  icon: const Icon(Icons.remove),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      if (quantity > 0) {
                                                                                        quantity--;
                                                                                      }
                                                                                    });
                                                                                    decreaseQuantity(
                                                                                      context,
                                                                                      shoppingCart,
                                                                                      shoppingCartItem,
                                                                                      user,
                                                                                      service,
                                                                                    );
                                                                                  }),
                                                                              shoppingCartItem != null ? Text((shoppingCartItem.quantity).toString()) : Text(quantity.toString()),
                                                                              IconButton(
                                                                                  icon: const Icon(Icons.add),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      quantity++;
                                                                                    });
                                                                                    increaseQuantity(
                                                                                      context,
                                                                                      shoppingCart,
                                                                                      shoppingCartItem,
                                                                                      user,
                                                                                      service,
                                                                                    );
                                                                                  }),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                              shoppingCart.services
                                                                          .contains(
                                                                              service.serviceId) ==
                                                                      false
                                                                  ? Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                        left: 5,
                                                                      ),
                                                                      child:
                                                                          OutlinedButton(
                                                                        onPressed:
                                                                            () =>
                                                                                addToCart(
                                                                          context,
                                                                          shoppingCart,
                                                                          user,
                                                                          service,
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Pallete.darkGreenColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                        child: const Text(
                                                                            'Add to Cart'),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                        left: 5,
                                                                      ),
                                                                      child:
                                                                          OutlinedButton(
                                                                        onPressed:
                                                                            () =>
                                                                                removeFromCart(
                                                                          context,
                                                                          shoppingCart,
                                                                          shoppingCartItem,
                                                                          user,
                                                                          service,
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Pallete.redPinkColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                        child: const Text(
                                                                            'Remove from Cart'),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              service.uid != user.uid &&
                                                      service.canBeOrdered ==
                                                          true &&
                                                      user.shoppingCartUserIds
                                                          .isNotEmpty
                                                  ? showShoppingCartUsers(
                                                      user,
                                                      service,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ];
                                  }),
                                  body: const SizedBox(),
                                );
                              },
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              } else {
                return const SizedBox(); // service not found
              }
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
