import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/controller/shopping_cart_item_controller.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:reddit_tutorial/models/shopping_cart_item_display.dart';
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
  String lastUserId = '';
  String lastForumId = '';

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
                }
              }
            } else {
              scid = ShoppingCartItemDisplay(
                type: ShoppingCartItemType.service.value,
                shoppingCartItem: shoppingCartItem,
              );
              shoppingCartItemDisplays.add(scid);
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

    if (shoppingCartItemDisplays.isNotEmpty) {
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
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  ...shoppingCartItemDisplays.map((s) {
                    if (s.type == ShoppingCartItemType.user.value) {
                      return Text(
                          'Outputting user ${s.shoppingCartItem.forumUid}');
                    } else if (s.type == ShoppingCartItemType.forum.value) {
                      return Text(
                          'Outputting forum ${s.shoppingCartItem.forumId}');
                    } else {
                      return Text(
                          'Outputting service ${s.shoppingCartItem.serviceId}');
                    }
                  })
                ],
                // children: [
                //   ...shoppingCartItems.map((s) {
                //     // if (index >= shoppingCartItems.length) {
                //     //   print('in index $lastUserId');
                //     //   lastUserId = '';
                //     // }

                //     print('forumUid = ${s.forumUid}');
                //     print('lastUserId = $lastUserId');

                //     if (s.forumUid != lastUserId) {
                //       lastUserId = s.forumUid;

                //       print('forumUid 2 = ${s.forumUid}');
                //       print('lastUserId 2 = $lastUserId');

                //       return ref
                //           .watch(
                //             getUserByIdProvider(
                //               s.forumUid,
                //             ),
                //           )
                //           .when(
                //             data: (forumUser) {
                //               // output user info
                //               return Text(
                //                   'Outputting forum user ${s.forumId}');
                //             },
                //             error: (error, stackTrace) =>
                //                 ErrorText(error: error.toString()),
                //             loading: () => const Loader(),
                //           );
                //     } else {
                //       // get service user
                //       return ref
                //           .watch(
                //             getUserByIdProvider(
                //               s.serviceUid,
                //             ),
                //           )
                //           .when(
                //             data: (serviceUser) {
                //               // get service
                //               return ref
                //                   .watch(
                //                     getServiceByIdProvider(
                //                       s.serviceId,
                //                     ),
                //                   )
                //                   .when(
                //                     data: (service) {
                //                       // output service info
                //                       // output user info
                //                       return Text(
                //                           'Outputting service ${s.serviceId}');
                //                     },
                //                     error: (error, stackTrace) =>
                //                         ErrorText(
                //                             error: error.toString()),
                //                     loading: () => const Loader(),
                //                   );
                //             },
                //             error: (error, stackTrace) =>
                //                 ErrorText(error: error.toString()),
                //             loading: () => const Loader(),
                //           );
                //     }
                //   }),
                // ],
              ),
              // child: ListView.builder(
              //   itemCount: shoppingCartItems.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     ShoppingCartItem shoppingCartItem =
              //         shoppingCartItems[index];

              //     return Column(
              //       children: [
              //         ref
              //             .watch(
              //               getUserByIdProvider(
              //                 shoppingCartItem.forumUid,
              //               ),
              //             )
              //             .when(
              //               data: (shoppingCartItem) {
              //                 // output user info
              //                 return const SizedBox();
              //               },
              //               error: (error, stackTrace) =>
              //                   ErrorText(error: error.toString()),
              //               loading: () => const Loader(),
              //             ),
              //       ],
              //     );

              //     // return Column(
              //     //   children: [
              //     //     shoppingCartItem.forumUid.isNotEmpty
              //     //         ? ref
              //     //             .watch(
              //     //               getUserByIdProvider(
              //     //                   shoppingCartItem.forumUid),
              //     //             )
              //     //             .when(
              //     //               data: (forumUser) {
              //     //                 if (forumUser != null) {
              //     //                   if (lastUserId != forumUser.uid) {
              //     //                     lastUserId = forumUser.uid;
              //     //                     // output user information
              //     //                     // output forum information
              //     //                     // output service information
              //     //                     return const SizedBox();
              //     //                   } else {
              //     //                     // output forum information
              //     //                     // output service information
              //     //                     return const SizedBox();
              //     //                   }
              //     //                 } else {
              //     //                   return const SizedBox();
              //     //                 }
              //     //               },
              //     //               error: (error, stackTrace) =>
              //     //                   ErrorText(error: error.toString()),
              //     //               loading: () => const Loader(),
              //     //             )
              //     //         : ref
              //     //             .watch(
              //     //               getUserByIdProvider(
              //     //                   shoppingCartItem.serviceUid),
              //     //             )
              //     //             .when(
              //     //               data: (serviceUser) {
              //     //                 if (serviceUser != null) {
              //     //                   // output service information
              //     //                   return const SizedBox();
              //     //                 } else {
              //     //                   return const SizedBox();
              //     //                 }
              //     //               },
              //     //               error: (error, stackTrace) =>
              //     //                   ErrorText(error: error.toString()),
              //     //               loading: () => const Loader(),
              //     //             ),
              //     //   ],
              //     // );
              //   },
              // ),
            ),
            Container(
              child: isLoading ? const Loader() : Container(),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          title: Text(
            'View Cart(0)',
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color!,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: const Text(
              "No items in cart",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
    }
  }
}
