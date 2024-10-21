import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_forum/controller/shopping_cart_forum_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/controller/shopping_cart_item_controller.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum_quantity.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
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
  List<ShoppingCartForumQuantity> shoppingCartForumQuantities = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.watch(userProvider)!;
      print('here');

      if (user.shoppingCartItemIds.isNotEmpty) {
        print('here 2');
        List<ShoppingCartItem>? shoppingCartItems = await ref
            .read(shoppingCartItemControllerProvider.notifier)
            .getShoppingCartItems(user.shoppingCartId)
            .first;

        if (shoppingCartItems.isNotEmpty) {
          for (ShoppingCartItem shoppingCartItem in shoppingCartItems) {
            print(shoppingCartItem);
            ShoppingCartForumQuantity scfq = ShoppingCartForumQuantity(
              shoppingCartId: user.shoppingCartId,
              uid: user.uid,
              forumId: shoppingCartItem.forumId,
              quantity: shoppingCartItem.quantity,
            );

            setState(() {
              shoppingCartForumQuantities.add(scfq);
              print(shoppingCartForumQuantities);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      key: _scaffold,
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'View Cart',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Container(
          alignment: Alignment.topCenter,
          child: const Text(
            'No items in cart',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
