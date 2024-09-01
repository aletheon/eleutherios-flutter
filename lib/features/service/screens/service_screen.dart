import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/controller/shopping_cart_item_controller.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
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

  void addToCart(
    BuildContext context,
    ShoppingCart? shoppingCart,
    UserModel user,
    Service service,
  ) {
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getShoppingCartByUidProvider(user.uid)).when(
            data: (shoppingCart) {
              return ref.watch(getServiceByIdProvider(widget.serviceId)).when(
                    data: (service) {
                      return ref
                          .watch(getShoppingCartItemByServiceIdProvider(Tuple2(
                              shoppingCart!.shoppingCartId, widget.serviceId)))
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
                                            child: service!.banner ==
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
                                                                      .format(service
                                                                          .price),
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
                                                            direction:
                                                                Axis.horizontal,
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
                                                                  visualDensity:
                                                                      const VisualDensity(
                                                                          vertical:
                                                                              -4,
                                                                          horizontal:
                                                                              -4),
                                                                  onSelected:
                                                                      (value) {},
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
                                                      WrapCrossAlignment.center,
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
                                                                          Icons
                                                                              .favorite_outline,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .favorite,
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
                                                              child: const Text(
                                                                  'Edit'),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    // add to forum button
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
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
                                                                      BorderRadius
                                                                          .circular(
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
                                            //  HERE ROB
                                            //  HERE ROB
                                            //  HERE ROB
                                            //  HERE ROB
                                            //  HERE ROB
                                            //  HERE ROB
                                            //  HERE ROB
                                            service.uid != user.uid &&
                                                    service.canBeOrdered == true
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                    context)
                                                                .width,
                                                        child: const Divider(
                                                            color: Colors.grey,
                                                            thickness: 1.0),
                                                      ),
                                                      // add to cart button(s)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10),
                                                            child: Text(
                                                                '${service.quantity} available'),
                                                          ),
                                                          Card(
                                                            color: Colors.blue,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: SizedBox(
                                                              height: 35,
                                                              width: 120,
                                                              child:
                                                                  AnimatedSwitcher(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    IconButton(
                                                                        icon: const Icon(Icons
                                                                            .remove),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (quantity >
                                                                                0) {
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
                                                                    shoppingCartItem !=
                                                                            null
                                                                        ? Text((shoppingCartItem.quantity)
                                                                            .toString())
                                                                        : Text(quantity
                                                                            .toString()),
                                                                    IconButton(
                                                                        icon: const Icon(Icons
                                                                            .add),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
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
                                                          ),
                                                          shoppingCart.services
                                                                      .contains(
                                                                          service
                                                                              .serviceId) ==
                                                                  false
                                                              ? Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                  child:
                                                                      OutlinedButton(
                                                                    onPressed: () =>
                                                                        addToCart(
                                                                      context,
                                                                      shoppingCart,
                                                                      user,
                                                                      service,
                                                                    ),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Pallete.darkGreenColor,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                    child: const Text(
                                                                        'Add to Cart'),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                  child:
                                                                      OutlinedButton(
                                                                    onPressed: () =>
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
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                    child: const Text(
                                                                        'Remove from Cart'),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ],
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
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
