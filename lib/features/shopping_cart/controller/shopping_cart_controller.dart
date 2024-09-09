import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/controller/shopping_cart_item_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart/repository/shopping_cart_repository.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartByIdProvider =
    StreamProvider.family.autoDispose((ref, String shoppingCartId) {
  return ref
      .watch(shoppingCartControllerProvider.notifier)
      .getShoppingCartById(shoppingCartId);
});

final getShoppingCartByIdProvider2 =
    Provider.family.autoDispose((ref, String shoppingCartId) {
  try {
    return ref
        .watch(shoppingCartControllerProvider.notifier)
        .getShoppingCartById(shoppingCartId);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartByUidProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  try {
    return ref
        .watch(shoppingCartControllerProvider.notifier)
        .getShoppingCartByUid(uid);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartByUidProvider2 =
    Provider.family.autoDispose((ref, String uid) {
  try {
    return ref
        .watch(shoppingCartControllerProvider.notifier)
        .getShoppingCartByUid(uid);
  } catch (e) {
    rethrow;
  }
});

final shoppingCartControllerProvider =
    StateNotifierProvider<ShoppingCartController, bool>((ref) {
  final shoppingCartRepository = ref.watch(shoppingCartRepositoryProvider);
  return ShoppingCartController(
      shoppingCartRepository: shoppingCartRepository, ref: ref);
});

class ShoppingCartController extends StateNotifier<bool> {
  final ShoppingCartRepository _shoppingCartRepository;
  final Ref _ref;
  ShoppingCartController(
      {required ShoppingCartRepository shoppingCartRepository,
      required Ref ref})
      : _shoppingCartRepository = shoppingCartRepository,
        _ref = ref,
        super(false);

  void createShoppingCart(
    String uid,
    BuildContext context,
  ) async {
    state = true;
    String shoppingCartId = const Uuid().v1().replaceAll('-', '');

    print('created shopping cart');

    // create shopping cart
    ShoppingCart shoppingCart = ShoppingCart(
      shoppingCartId: shoppingCartId,
      uid: uid,
      services: [],
      items: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _shoppingCartRepository.createShoppingCart(shoppingCart);

    state = false;
    res.fold((l) => showSnackBar(context, l.message, true), (r) {
      showSnackBar(context, 'Shopping cart added successfully!', false);
    });
  }

  void updateShoppingCart(
      {required ShoppingCart shoppingCart,
      required BuildContext context}) async {
    state = true;

    print('updating shopping cart ${shoppingCart.shoppingCartId}');

    final shoppingCartRes =
        await _shoppingCartRepository.updateShoppingCart(shoppingCart);
    state = false;
    shoppingCartRes.fold((l) => showSnackBar(context, l.message, true), (r) {
      showSnackBar(context, 'Shopping cart updated successfully!', false);
    });
  }

  void deleteShoppingCart(String shoppingCartId, BuildContext context) async {
    state = true;

    print('deleting shopping cart $shoppingCartId');

    // get shopping cart
    final shoppingCart = await _ref
        .read(shoppingCartControllerProvider.notifier)
        .getShoppingCartById(shoppingCartId)
        .first;

    if (shoppingCart != null) {
      // delete shopping cart
      final res =
          await _shoppingCartRepository.deleteShoppingCart(shoppingCartId);

      // remove items from cart
      if (shoppingCart.items.isNotEmpty) {
        await _ref
            .read(shoppingCartItemControllerProvider.notifier)
            .deleteShoppingCartItemsByShoppingCartId(shoppingCartId);
      }
      state = false;
      res.fold((l) => showSnackBar(context, l.message, true), (r) {
        if (context.mounted) {
          showSnackBar(context, 'Manager deleted successfully!', false);
        }
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Policy or manager does not exist', true);
      }
    }
  }

  Stream<ShoppingCart?> getShoppingCartById(String shoppingCartId) {
    return _shoppingCartRepository.getShoppingCartById(shoppingCartId);
  }

  Stream<ShoppingCart?> getShoppingCartByUid(String uid) {
    return _shoppingCartRepository.getShoppingCartByUid(uid);
  }
}
