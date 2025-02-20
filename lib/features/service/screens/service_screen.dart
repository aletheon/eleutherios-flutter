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
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:reddit_tutorial/models/shopping_cart_service_quantity.dart';
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
  final GlobalKey _scaffold = GlobalKey();
  bool firstTimeThrough = true;
  int quantity = 0;
  List<ShoppingCartServiceQuantity> shoppingCartServiceQuantities = [];

  void addToCart(
    BuildContext context,
    ShoppingCart? shoppingCart,
    String forumId,
    String memberId,
    int addToCartQuantity,
    Service service,
  ) {
    // add physical item to shopping cart
    if (service.type == ServiceType.physical.value) {
      if (service.quantity > 0) {
        ref
            .read(shoppingCartItemControllerProvider.notifier)
            .createShoppingCartItem(
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
    Service service,
  ) {
    // remove service from the currently logged in user
    ref
        .read(shoppingCartItemControllerProvider.notifier)
        .deleteShoppingCartItem(
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
    Service service,
  ) {
    ref
        .read(shoppingCartItemControllerProvider.notifier)
        .decreaseShoppingCartItemQuantity(
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

  void navigateToForum(
    BuildContext context,
    String forumId,
  ) {
    Routemaster.of(context).push('/forum/$forumId');
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.watch(userProvider)!;

      if (user.shoppingCartUserIds.isNotEmpty) {
        for (String userId in user.shoppingCartUserIds) {
          // get cart user
          UserModel? cartUser = await ref
              .read(authControllerProvider.notifier)
              .getUserData(userId)
              .first;

          if (cartUser != null) {
            // get shopping cart forums for this cartUser
            List<ShoppingCartForum>? shoppingCartForums = await ref
                .read(shoppingCartForumControllerProvider.notifier)
                .getShoppingCartForumsByUserId(cartUser.uid, user.uid)
                .first;

            if (shoppingCartForums.isNotEmpty) {
              for (ShoppingCartForum shoppingCartForum in shoppingCartForums) {
                ShoppingCartItem? shoppingCartItem = await ref
                    .read(shoppingCartItemControllerProvider.notifier)
                    .getShoppingCartItemByForumServiceId(
                      cartUser.shoppingCartId,
                      shoppingCartForum.forumId,
                      widget.serviceId,
                    )
                    .first;

                ShoppingCartServiceQuantity scsq = ShoppingCartServiceQuantity(
                  shoppingCartId: cartUser.shoppingCartId,
                  uid: cartUser.uid,
                  forumId: shoppingCartForum.forumId,
                  serviceId: widget.serviceId,
                  quantity: 0,
                );

                if (shoppingCartItem != null) {
                  scsq = scsq.copyWith(quantity: shoppingCartItem.quantity);
                }

                setState(() {
                  shoppingCartServiceQuantities.add(scsq);
                });
              }
            }
          }
        }
      }
    });
  }

  Widget showShoppingCartUsers(
    UserModel currentUser,
    Service service,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      itemCount: currentUser.shoppingCartUserIds.length,
      itemBuilder: (BuildContext context, int index) {
        final userId = currentUser.shoppingCartUserIds[index];

        if (service.uid != userId) {
          // get the user
          return ref.watch(getUserByIdProvider(userId)).when(
                data: (cartUser) {
                  if (cartUser != null) {
                    // get the shopping cart
                    return ref
                        .watch(getShoppingCartByUidProvider(cartUser.uid))
                        .when(
                          data: (shoppingCart) {
                            if (shoppingCart != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18.0, bottom: 3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Add to ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        cartUser.profilePic ==
                                                Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage: Image.asset(
                                                        cartUser.profilePic)
                                                    .image,
                                                radius: 16,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: Image.network(
                                                  cartUser.profilePic,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    return loadingProgress
                                                                ?.cumulativeBytesLoaded ==
                                                            loadingProgress
                                                                ?.expectedTotalBytes
                                                        ? child
                                                        : const CircularProgressIndicator();
                                                  },
                                                ).image,
                                                radius: 16,
                                              ),
                                        Text(
                                          " ${cartUser.fullName}'s shopping cart",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: const Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Divider(
                                        color: Colors.grey,
                                        thickness: 1.0,
                                      ),
                                    ),
                                  ),
                                  // ***************************************************
                                  // show forum info
                                  // ***************************************************
                                  // get the shopping cart forums
                                  ref
                                      .watch(shoppingCartForumsProvider(Tuple2(
                                          cartUser.uid, currentUser.uid)))
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
                                                                    forum
                                                                        .forumId,
                                                                    currentUser
                                                                        .uid,
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
                                                                            shoppingCartMember.serviceId))
                                                                        .when(
                                                                          data:
                                                                              (selectedService) {
                                                                            if (selectedService !=
                                                                                null) {
                                                                              // get shopping cart item
                                                                              return ref
                                                                                  .watch(
                                                                                    getShoppingCartItemByForumServiceIdProvider(
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
                                                                                          // forum and service title
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  forum.image == Constants.avatarDefault
                                                                                                      ? CircleAvatar(
                                                                                                          backgroundImage: Image.asset(forum.image).image,
                                                                                                          radius: 14,
                                                                                                        )
                                                                                                      : CircleAvatar(
                                                                                                          backgroundImage: Image.network(
                                                                                                            forum.image,
                                                                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                                                              return loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes ? child : const CircularProgressIndicator();
                                                                                                            },
                                                                                                          ).image,
                                                                                                          radius: 14,
                                                                                                        ),
                                                                                                  const SizedBox(
                                                                                                    width: 10,
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    child: Text(
                                                                                                      forum.title,
                                                                                                      style: const TextStyle(fontSize: 14),
                                                                                                    ),
                                                                                                    onTap: () => navigateToForum(context, forum.forumId),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: Alignment.topRight,
                                                                                            child: Wrap(
                                                                                              crossAxisAlignment: WrapCrossAlignment.center,
                                                                                              children: [
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
                                                                                                                        ShoppingCartServiceQuantity scsq = shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((s) => s.uid == cartUser.uid && s.forumId == forum.forumId)];
                                                                                                                        if (scsq.quantity > 0) {
                                                                                                                          int tempQuantity = scsq.quantity - 1;
                                                                                                                          scsq = scsq.copyWith(quantity: tempQuantity);
                                                                                                                          shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((s) => s.uid == cartUser.uid && s.forumId == forum.forumId)] = scsq;
                                                                                                                        }
                                                                                                                      });
                                                                                                                      decreaseQuantity(
                                                                                                                        context,
                                                                                                                        shoppingCart,
                                                                                                                        shoppingCartItem,
                                                                                                                        service,
                                                                                                                      );
                                                                                                                    }),
                                                                                                                shoppingCartItem != null ? Text((shoppingCartItem.quantity).toString()) : Text(shoppingCartServiceQuantities.where((s) => s.uid == cartUser.uid && s.forumId == forum.forumId).toList().first.quantity.toString()),
                                                                                                                IconButton(
                                                                                                                    icon: const Icon(Icons.add),
                                                                                                                    onPressed: () {
                                                                                                                      setState(() {
                                                                                                                        ShoppingCartServiceQuantity scsq = shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((s) => s.uid == cartUser.uid && s.forumId == forum.forumId)];
                                                                                                                        int tempQuantity = scsq.quantity + 1;
                                                                                                                        scsq = scsq.copyWith(quantity: tempQuantity);
                                                                                                                        shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((s) => s.uid == cartUser.uid && s.forumId == forum.forumId)] = scsq;
                                                                                                                      });
                                                                                                                      increaseQuantity(
                                                                                                                        context,
                                                                                                                        shoppingCart,
                                                                                                                        shoppingCartItem,
                                                                                                                        service,
                                                                                                                      );
                                                                                                                    }),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    : const SizedBox(),
                                                                                                shoppingCart.services.contains('${forum.forumId}-${service.serviceId}') == false
                                                                                                    ? Container(
                                                                                                        margin: const EdgeInsets.only(
                                                                                                          left: 3,
                                                                                                        ),
                                                                                                        child: OutlinedButton(
                                                                                                          onPressed: () => addToCart(
                                                                                                            context,
                                                                                                            shoppingCart,
                                                                                                            forum.forumId,
                                                                                                            shoppingCartMember.memberId,
                                                                                                            shoppingCartServiceQuantities[shoppingCartServiceQuantities.indexWhere((s) => s.uid == cartUser.uid && s.forumId == forum.forumId)].quantity,
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
                                                                                                          left: 3,
                                                                                                        ),
                                                                                                        child: OutlinedButton(
                                                                                                          onPressed: () => removeFromCart(
                                                                                                            context,
                                                                                                            shoppingCart,
                                                                                                            shoppingCartItem,
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
                                                                                          ),
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
                                                                          error: (error, stackTrace) =>
                                                                              ErrorText(error: error.toString()),
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
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget showOutput(
    UserModel currentUser,
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    Service service,
  ) {
    if (shoppingCart != null) {
      if (shoppingCartItem != null) {
        if (shoppingCartItem.forumId.isNotEmpty) {
          // Add to <forum owners> shopping cart
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Add to ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    currentUser.profilePic == Constants.avatarDefault
                        ? CircleAvatar(
                            backgroundImage:
                                Image.asset(currentUser.profilePic).image,
                            radius: 16,
                          )
                        : CircleAvatar(
                            backgroundImage: Image.network(
                              currentUser.profilePic,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                return loadingProgress?.cumulativeBytesLoaded ==
                                        loadingProgress?.expectedTotalBytes
                                    ? child
                                    : const CircularProgressIndicator();
                              },
                            ).image,
                            radius: 16,
                          ),
                    Text(
                      " ${currentUser.fullName}'s shopping cart",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                ),
              ),
              // ***************************************************
              // show forum info
              // ***************************************************
              // get the forum
              ref
                  .watch(
                    getForumByIdProvider(shoppingCartItem.forumId),
                  )
                  .when(
                    data: (forum) {
                      if (forum != null) {
                        return Column(
                          children: [
                            // forum and service title
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    forum.image == Constants.avatarDefault
                                        ? CircleAvatar(
                                            backgroundImage:
                                                Image.asset(forum.image).image,
                                            radius: 14,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: Image.network(
                                              forum.image,
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
                                            radius: 14,
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      child: Text(
                                        forum.title,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      onTap: () => navigateToForum(
                                          context, forum.forumId),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  service.quantity != -1
                                      ? Card(
                                          color: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: SizedBox(
                                            height: 35,
                                            width: 120,
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: Text(
                                                  (shoppingCartItem.quantity)
                                                      .toString()),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 3,
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () => removeFromCart(
                                        context,
                                        shoppingCart,
                                        shoppingCartItem,
                                        service,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Pallete.redPinkColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25)),
                                      child: const Text('Remove from Cart'),
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
            ],
          );
        } else {
          // Add to your shopping cart
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Add to your shopping cart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: const Divider(color: Colors.grey, thickness: 1.0),
                ),
                // add to cart button(s)
                Align(
                  alignment: Alignment.topRight,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
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
                                              service,
                                            );
                                          }),
                                      Text(
                                          shoppingCartItem.quantity.toString()),
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
                                left: 3,
                              ),
                              child: OutlinedButton(
                                onPressed: () => addToCart(
                                  context,
                                  shoppingCart,
                                  '',
                                  '',
                                  quantity,
                                  service,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Pallete.darkGreenColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25)),
                                child: const Text('Add to Cart'),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(
                                left: 3,
                              ),
                              child: OutlinedButton(
                                onPressed: () => removeFromCart(
                                  context,
                                  shoppingCart,
                                  shoppingCartItem,
                                  service,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Pallete.redPinkColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25)),
                                child: const Text('Remove from Cart'),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Add to your shopping cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: const Divider(color: Colors.grey, thickness: 1.0),
              ),
              // add to cart button(s)
              Align(
                alignment: Alignment.topRight,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
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
                                            service,
                                          );
                                        }),
                                    Text(quantity.toString()),
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
                              left: 3,
                            ),
                            child: OutlinedButton(
                              onPressed: () => addToCart(
                                context,
                                shoppingCart,
                                '',
                                '',
                                quantity,
                                service,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.darkGreenColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              child: const Text('Add to Cart'),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                              left: 3,
                            ),
                            child: OutlinedButton(
                              onPressed: () => removeFromCart(
                                context,
                                shoppingCart,
                                shoppingCartItem,
                                service,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.redPinkColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              child: const Text('Remove from Cart'),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return Scaffold(
      key: _scaffold,
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: ref.watch(getServiceByIdProvider(widget.serviceId)).when(
            data: (service) {
              if (service != null) {
                return ref.watch(getShoppingCartByUidProvider(user.uid)).when(
                      data: (shoppingCart) {
                        return ref
                            .watch(
                              getShoppingCartItemByForumServiceIdProvider(
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
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          service.image ==
                                                                  Constants
                                                                      .avatarDefault
                                                              ? CircleAvatar(
                                                                  backgroundImage:
                                                                      Image.asset(
                                                                              service.image)
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
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  service.price >
                                                                          0
                                                                      ? Container(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 10),
                                                                          child:
                                                                              Text(
                                                                            NumberFormat.currency(symbol: '${service.currency} ', locale: 'en_US', decimalDigits: 2).format(service.price),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const SizedBox(),
                                                                  service.public
                                                                      ? const Icon(
                                                                          Icons
                                                                              .lock_open_outlined)
                                                                      : const Icon(
                                                                          Icons
                                                                              .lock_outlined,
                                                                          color:
                                                                              Pallete.greyColor),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 3,
                                                              ),
                                                              service.quantity !=
                                                                      -1
                                                                  ? Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        '${service.quantity} available',
                                                                        softWrap:
                                                                            true,
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        service.title,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
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
                                              service.canBeOrdered &&
                                                      service.uid != user.uid
                                                  ? showOutput(
                                                      user,
                                                      shoppingCart,
                                                      shoppingCartItem,
                                                      service,
                                                    )
                                                  : const SizedBox(),
                                              service.canBeOrdered == true &&
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
