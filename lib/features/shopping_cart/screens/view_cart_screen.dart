import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/controller/shopping_cart_item_controller.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:reddit_tutorial/models/shopping_cart_item_display.dart';
import 'package:reddit_tutorial/models/shopping_cart_service_quantity.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class ViewCartScreen extends ConsumerStatefulWidget {
  const ViewCartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends ConsumerState<ViewCartScreen> {
  final GlobalKey _scaffold = GlobalKey();
  int quantity = 0;
  List<ShoppingCartItemDisplay> shoppingCartItemDisplays = [];
  List<ShoppingCartServiceQuantity> shoppingCartServiceQuantities = [];
  String lastUserId = '';
  String lastForumId = '';

  void addToCart(
    BuildContext context,
    ShoppingCart? shoppingCart,
    String forumId,
    String memberId,
    int addToCartQuantity,
    UserModel user,
    Service service,
  ) {
    // add physical item to shopping cart
    if (service.type == ServiceType.physical.value) {
      if (service.quantity > 0) {
        // add service to the currently logged in user
        ref
            .read(shoppingCartItemControllerProvider.notifier)
            .createShoppingCartItem(
              user,
              shoppingCart,
              forumId,
              memberId,
              service.serviceId,
              addToCartQuantity,
              context,
            );
      } else {
        showSnackBar(
            context,
            'There is not enough of this service to purchase there is zero available',
            true);
      }
    } else {
      // add non-physical item to shopping cart
      ref
          .read(shoppingCartItemControllerProvider.notifier)
          .createShoppingCartItem(
            user,
            shoppingCart,
            forumId,
            memberId,
            service.serviceId,
            1,
            context,
          );
    }
  }

  void removeFromCart(
    BuildContext context,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    UserModel user,
    Service service,
  ) {
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
  }

  void increaseQuantity(
    BuildContext context,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.watch(userProvider)!;

      if (user.shoppingCartItemIds.isNotEmpty) {
        List<ShoppingCartItem>? shoppingCartItems = await ref
            .read(shoppingCartItemControllerProvider.notifier)
            .getShoppingCartItems(user.shoppingCartId)
            .first;

        if (shoppingCartItems.isNotEmpty) {
          for (ShoppingCartItem shoppingCartItem in shoppingCartItems) {
            ShoppingCartItemDisplay scid;

            if (shoppingCartItem.forumUid.isNotEmpty) {
              if (lastUserId != shoppingCartItem.forumUid) {
                lastUserId = shoppingCartItem.forumUid;
                scid = ShoppingCartItemDisplay(
                  type: ShoppingCartItemType.user.value,
                  shoppingCartItem: shoppingCartItem,
                );
                shoppingCartItemDisplays.add(scid);
                scid = ShoppingCartItemDisplay(
                  type: ShoppingCartItemType.forum.value,
                  shoppingCartItem: shoppingCartItem,
                );
                shoppingCartItemDisplays.add(scid);
                scid = ShoppingCartItemDisplay(
                  type: ShoppingCartItemType.service.value,
                  shoppingCartItem: shoppingCartItem,
                );
                shoppingCartItemDisplays.add(scid);
              } else {
                if (lastForumId != shoppingCartItem.forumId) {
                  lastForumId = shoppingCartItem.forumId;
                  scid = ShoppingCartItemDisplay(
                    type: ShoppingCartItemType.forum.value,
                    shoppingCartItem: shoppingCartItem,
                  );
                  shoppingCartItemDisplays.add(scid);
                  scid = ShoppingCartItemDisplay(
                    type: ShoppingCartItemType.service.value,
                    shoppingCartItem: shoppingCartItem,
                  );
                  shoppingCartItemDisplays.add(scid);
                } else {
                  scid = ShoppingCartItemDisplay(
                    type: ShoppingCartItemType.service.value,
                    shoppingCartItem: shoppingCartItem,
                  );
                  shoppingCartItemDisplays.add(scid);

                  ShoppingCartServiceQuantity scsq =
                      ShoppingCartServiceQuantity(
                    shoppingCartId: shoppingCartItem.shoppingCartId,
                    uid: shoppingCartItem.shoppingCartUid,
                    forumId: shoppingCartItem.forumId,
                    serviceId: shoppingCartItem.serviceId,
                    quantity: shoppingCartItem.quantity,
                  );

                  setState(() {
                    shoppingCartServiceQuantities.add(scsq);
                  });
                }
              }
            } else {
              scid = ShoppingCartItemDisplay(
                type: ShoppingCartItemType.enduser.value,
                shoppingCartItem: shoppingCartItem,
              );
              shoppingCartItemDisplays.add(scid);
              scid = ShoppingCartItemDisplay(
                type: ShoppingCartItemType.service.value,
                shoppingCartItem: shoppingCartItem,
              );
              shoppingCartItemDisplays.add(scid);

              ShoppingCartServiceQuantity scsq = ShoppingCartServiceQuantity(
                shoppingCartId: shoppingCartItem.shoppingCartId,
                uid: shoppingCartItem.shoppingCartUid,
                forumId: shoppingCartItem.forumId,
                serviceId: shoppingCartItem.serviceId,
                quantity: 0,
              );

              setState(() {
                shoppingCartServiceQuantities.add(scsq);
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(shoppingCartItemControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(
          'View Cart(${user.shoppingCartItemIds.length})',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: user.shoppingCartItemIds.isNotEmpty
                ? Column(
                    children: [
                      ...shoppingCartItemDisplays.map((s) {
                        return ref
                            .watch(
                              getShoppingCartItemByIdProvider(
                                s.shoppingCartItem.shoppingCartItemId,
                              ),
                            )
                            .when(
                              data: (shoppingCartItem) {
                                if (shoppingCartItem != null) {
                                  return ref
                                      .watch(
                                        getShoppingCartByIdProvider(
                                          s.shoppingCartItem.shoppingCartId,
                                        ),
                                      )
                                      .when(
                                        data: (shoppingCart) {
                                          if (shoppingCart != null) {
                                            if (s.type ==
                                                ShoppingCartItemType
                                                    .user.value) {
                                              return ref
                                                  .watch(
                                                    getUserByIdProvider(
                                                      shoppingCartItem.forumUid,
                                                    ),
                                                  )
                                                  .when(
                                                    data: (forumUser) {
                                                      if (forumUser != null) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 0,
                                                                  bottom: 12,
                                                                  left: 15),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  forumUser.profilePic ==
                                                                          Constants
                                                                              .avatarDefault
                                                                      ? CircleAvatar(
                                                                          backgroundImage:
                                                                              Image.asset(forumUser.profilePic).image,
                                                                          radius:
                                                                              14,
                                                                        )
                                                                      : CircleAvatar(
                                                                          backgroundImage:
                                                                              Image.network(
                                                                            forumUser.profilePic,
                                                                            loadingBuilder: (context,
                                                                                child,
                                                                                loadingProgress) {
                                                                              return loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes ? child : const CircularProgressIndicator();
                                                                            },
                                                                          ).image,
                                                                          radius:
                                                                              14,
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    forumUser
                                                                        .fullName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
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
                                            } else if (s.type ==
                                                ShoppingCartItemType
                                                    .forum.value) {
                                              return ref
                                                  .watch(
                                                    getForumByIdProvider(
                                                      shoppingCartItem.forumId,
                                                    ),
                                                  )
                                                  .when(
                                                    data: (forum) {
                                                      if (forum != null) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 0,
                                                                  bottom: 5,
                                                                  left: 50),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  forum.image ==
                                                                          Constants
                                                                              .avatarDefault
                                                                      ? CircleAvatar(
                                                                          backgroundImage:
                                                                              Image.asset(forum.image).image,
                                                                          radius:
                                                                              14,
                                                                        )
                                                                      : CircleAvatar(
                                                                          backgroundImage:
                                                                              Image.network(
                                                                            forum.image,
                                                                            loadingBuilder: (context,
                                                                                child,
                                                                                loadingProgress) {
                                                                              return loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes ? child : const CircularProgressIndicator();
                                                                            },
                                                                          ).image,
                                                                          radius:
                                                                              14,
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    forum.title,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
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
                                            } else if (s.type ==
                                                ShoppingCartItemType
                                                    .enduser.value) {
                                              return const SizedBox();
                                            } else {
                                              return ref
                                                  .watch(
                                                    getServiceByIdProvider(
                                                      shoppingCartItem
                                                          .serviceId,
                                                    ),
                                                  )
                                                  .when(
                                                    data: (service) {
                                                      if (service != null) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 0,
                                                            bottom: 0,
                                                            right: 5,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  service.image ==
                                                                          Constants
                                                                              .avatarDefault
                                                                      ? CircleAvatar(
                                                                          backgroundImage:
                                                                              Image.asset(service.image).image,
                                                                          radius:
                                                                              14,
                                                                        )
                                                                      : CircleAvatar(
                                                                          backgroundImage:
                                                                              Image.network(
                                                                            service.image,
                                                                            loadingBuilder: (context,
                                                                                child,
                                                                                loadingProgress) {
                                                                              return loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes ? child : const CircularProgressIndicator();
                                                                            },
                                                                          ).image,
                                                                          radius:
                                                                              14,
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    service
                                                                        .title,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                              // add to cart button(s)
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: Wrap(
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .center,
                                                                    children: [
                                                                      shoppingCartItem.memberUid.isEmpty ||
                                                                              shoppingCartItem.memberUid == user.uid
                                                                          ? service.type == ServiceType.physical.value
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
                                                                                                ShoppingCartServiceQuantity scsq = shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((j) => j.forumId == shoppingCartItem.forumId && j.serviceId == shoppingCartItem.serviceId)];
                                                                                                if (scsq.quantity > 0) {
                                                                                                  int tempQuantity = scsq.quantity - 1;
                                                                                                  scsq = scsq.copyWith(quantity: tempQuantity);
                                                                                                  shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((j) => j.forumId == shoppingCartItem.forumId && j.serviceId == shoppingCartItem.serviceId)] = scsq;
                                                                                                }
                                                                                              });
                                                                                              decreaseQuantity(
                                                                                                context,
                                                                                                shoppingCart,
                                                                                                shoppingCartItem,
                                                                                                user,
                                                                                                service,
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                          Text((shoppingCartItem.quantity).toString()),
                                                                                          IconButton(
                                                                                            icon: const Icon(Icons.add),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                ShoppingCartServiceQuantity scsq = shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((j) => j.forumId == shoppingCartItem.forumId && j.serviceId == shoppingCartItem.serviceId)];
                                                                                                int tempQuantity = scsq.quantity + 1;
                                                                                                scsq = scsq.copyWith(quantity: tempQuantity);
                                                                                                shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((j) => j.forumId == shoppingCartItem.forumId && j.serviceId == shoppingCartItem.serviceId)] = scsq;
                                                                                              });
                                                                                              increaseQuantity(
                                                                                                context,
                                                                                                shoppingCart,
                                                                                                shoppingCartItem,
                                                                                                service,
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : CircleAvatar(
                                                                                  backgroundColor: Colors.blue,
                                                                                  foregroundColor: Colors.white,
                                                                                  maxRadius: 15,
                                                                                  child: Text(
                                                                                    (shoppingCartItem.quantity).toString(),
                                                                                  ),
                                                                                )
                                                                          : CircleAvatar(
                                                                              backgroundColor: Colors.blue,
                                                                              foregroundColor: Colors.white,
                                                                              maxRadius: 15,
                                                                              child: Text(
                                                                                (shoppingCartItem.quantity).toString(),
                                                                              ),
                                                                            ),
                                                                      Container(
                                                                        margin:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                        ),
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
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              padding: const EdgeInsets.symmetric(horizontal: 25)),
                                                                          child:
                                                                              const Text('Remove from Cart'),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
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
                                            }
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
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      })
                    ],
                  )
                : Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "No items in cart",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
          ),
          Container(
            child: isLoading ? const Loader() : Container(),
          )
        ],
      ),
    );
  }
}
