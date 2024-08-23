import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/repository/shopping_cart_item_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:reddit_tutorial/features/shopping_cart/repository/shopping_cart_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartItemByIdProvider =
    StreamProvider.family.autoDispose((ref, String shoppingCartItemId) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemById(shoppingCartItemId);
});

final getShoppingCartItemByServiceIdProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemByServiceId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartItemByServiceIdProvider2 =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemByServiceId(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartItemsProvider =
    StreamProvider.family.autoDispose((ref, String shoppingCartId) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItems(shoppingCartId);
});

final getUserShoppingCartItemsProvider =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(shoppingCartItemControllerProvider.notifier)
        .getUserShoppingCartItems(params.item1, params.item2);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartItemsByServiceIdProvider =
    StreamProvider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemsByServiceId(serviceId);
});

final getShoppingCartItemsByServiceIdProvider2 =
    Provider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemsByServiceId(serviceId);
});

final getUserShoppingCartItemsCountProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getUserShoppingCartItemCount(params.item1, params.item2);
});

final shoppingCartItemControllerProvider =
    StateNotifierProvider<ShoppingCartItemController, bool>((ref) {
  final shoppingCartItemRepository =
      ref.watch(shoppingCartItemRepositoryProvider);
  final shoppingCartRepository = ref.watch(shoppingCartRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return ShoppingCartItemController(
      shoppingCartItemRepository: shoppingCartItemRepository,
      shoppingCartRepository: shoppingCartRepository,
      serviceRepository: serviceRepository,
      ref: ref);
});

class ShoppingCartItemController extends StateNotifier<bool> {
  final ShoppingCartItemRepository _shoppingCartItemRepository;
  final ShoppingCartRepository _shoppingCartRepository;
  final ServiceRepository _serviceRepository;
  final Ref _ref;
  ShoppingCartItemController(
      {required ShoppingCartItemRepository shoppingCartItemRepository,
      required ShoppingCartRepository shoppingCartRepository,
      required ServiceRepository serviceRepository,
      required Ref ref})
      : _shoppingCartItemRepository = shoppingCartItemRepository,
        _shoppingCartRepository = shoppingCartRepository,
        _serviceRepository = serviceRepository,
        _ref = ref,
        super(false);

  void createShoppingCartItem(
    ShoppingCart shoppingCart,
    String? forumId,
    String? memberId,
    String serviceId,
    int quantity,
    BuildContext context,
  ) async {
    state = true;
    Forum? forum; // placeholder for forum
    Member? member; // placeholder for member

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    // ensure shoppingCart and service exist
    if (service != null) {
      // ensure service is not already an item
      if (shoppingCart.services.contains(serviceId) == false) {
        if (quantity > 0) {
          if (service.quantity > 0 && service.quantity > quantity) {
            if (forumId != null) {
              forum = await _ref
                  .read(forumControllerProvider.notifier)
                  .getForumById(forumId)
                  .first;
            }
            if (memberId != null) {
              member = await _ref
                  .read(memberControllerProvider.notifier)
                  .getMemberById(memberId)
                  .first;
            }
            String shoppingCartItemId = const Uuid().v1().replaceAll('-', '');

            // create shopping cart item
            ShoppingCartItem shoppingCartItem = ShoppingCartItem(
              shoppingCartItemId: shoppingCartItemId,
              shoppingCartId: shoppingCart.shoppingCartId,
              shoppingCartUid: shoppingCart.uid,
              forumId: forum != null ? forum.forumId : '',
              forumUid: forum != null ? forum.uid : '',
              memberId: member != null ? member.memberId : '',
              serviceId: serviceId,
              serviceUid: service.uid,
              quantity: quantity,
              lastUpdateDate: DateTime.now(),
              creationDate: DateTime.now(),
            );
            final res = await _shoppingCartItemRepository
                .createShoppingCartItem(shoppingCartItem);

            // add service to shopping cart items and service list
            shoppingCart.items.add(shoppingCartItemId);
            shoppingCart.services.add(serviceId);
            await _shoppingCartRepository.updateShoppingCart(shoppingCart);

            // reduce service quantity
            service = service.copyWith(quantity: service.quantity - quantity);
            await _serviceRepository.updateService(service);

            state = false;
            res.fold((l) => showSnackBar(context, l.message, true), (r) {
              showSnackBar(
                  context, 'Shopping cart item added successfully!', false);
            });
          } else {
            state = false;
            if (context.mounted) {
              showSnackBar(
                  context,
                  'There are no more of this service available to purchase',
                  true);
            }
          }
        } else {
          state = false;
          if (context.mounted) {
            showSnackBar(context, 'Quantity cannot be empty', true);
          }
        }
      } else {
        state = false;
        if (context.mounted) {
          showSnackBar(
              context, 'Service is already in the shopping cart', true);
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Shopping cart or service does not exist', true);
      }
    }
  }

  void updateShoppingCartItem(
      {required ShoppingCartItem shoppingCartItem,
      required BuildContext context}) async {
    state = true;
    final shoppingCartItemRes = await _shoppingCartItemRepository
        .updateShoppingCartItem(shoppingCartItem);
    state = false;
    shoppingCartItemRes.fold((l) => showSnackBar(context, l.message, true),
        (r) {
      showSnackBar(context, 'Shopping cart item updated successfully!', false);
    });
  }

  void updateShoppingCartItemQuantity(
    ShoppingCart shoppingCart,
    Service service,
    int quantity,
    BuildContext context,
  ) async {
    state = true;

    ShoppingCartItem? shoppingCartItem = await _ref
        .read(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemByServiceId(
            shoppingCart.shoppingCartId, service.serviceId)
        .first;

    if (shoppingCartItem != null) {
      if (shoppingCart.services.contains(service.serviceId)) {
        if (quantity == 0) {
          // delete shopping cart item
          final res = await _shoppingCartItemRepository
              .deleteShoppingCartItem(shoppingCartItem.shoppingCartItemId);

          // update shopping cart
          shoppingCart.items.remove(shoppingCartItem.shoppingCartItemId);
          shoppingCart.services.remove(shoppingCartItem.serviceId);
          await _shoppingCartRepository.updateShoppingCart(shoppingCart);

          // update service
          service = service.copyWith(
              quantity: service.quantity + shoppingCartItem.quantity);
          await _serviceRepository.updateService(service);

          state = false;
          res.fold((l) => showSnackBar(context, l.message, true), (r) {
            if (context.mounted) {
              showSnackBar(
                  context, 'Shopping cart item removed successfully!', false);
            }
          });
        } else if (service.quantity >= quantity) {
          shoppingCartItem = shoppingCartItem.copyWith(
              quantity: shoppingCartItem.quantity + quantity);
          final res = await _shoppingCartItemRepository
              .updateShoppingCartItem(shoppingCartItem);

          state = false;
          res.fold((l) => showSnackBar(context, l.message, true), (r) {
            if (context.mounted) {
              showSnackBar(
                  context, 'Shopping cart item updated successfully!', false);
            }
          });
        } else {
          if (context.mounted) {
            showSnackBar(
                context,
                'Not enough items to purchase there are only ${service.quantity} left',
                true);
          }
        }
      } else {
        state = false;
      }
    } else {
      state = false;
    }
  }

  void removeShoppingCartItem(
      ShoppingCart shoppingCart, Service service, BuildContext context) async {
    state = true;

    // get shopping cart item
    ShoppingCartItem? shoppingCartItem = await _ref
        .read(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemByServiceId(
            shoppingCart.shoppingCartId, service.serviceId)
        .first;

    if (shoppingCartItem != null) {
      if (shoppingCart.services.contains(service.serviceId) == true) {
        // delete shopping cart item
        final res = await _shoppingCartItemRepository
            .deleteShoppingCartItem(shoppingCartItem.shoppingCartItemId);

        // update shopping cart
        shoppingCart.items.remove(shoppingCartItem.shoppingCartItemId);
        shoppingCart.services.remove(shoppingCartItem.serviceId);
        await _shoppingCartRepository.updateShoppingCart(shoppingCart);

        // update service
        service = service.copyWith(
            quantity: service.quantity + shoppingCartItem.quantity);
        await _serviceRepository.updateService(service);

        state = false;
        res.fold((l) => showSnackBar(context, l.message, true), (r) {
          if (context.mounted) {
            showSnackBar(
                context, 'Shopping cart item removed successfully!', false);
          }
        });
      } else {
        state = false;
      }
    } else {
      state = false;
    }
  }

  void deleteShoppingCartItem(String shoppingCartId, String shoppingCartItemId,
      BuildContext context) async {
    state = true;

    // get shopping cart item
    final shoppingCartItem = await _ref
        .read(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemById(shoppingCartItemId)
        .first;

    // get shopping cart
    final shoppingCart = await _ref
        .watch(shoppingCartControllerProvider.notifier)
        .getShoppingCartById(shoppingCartId)
        .first;

    if (shoppingCart != null && shoppingCartItem != null) {
      // delete shopping cart item
      final res = await _shoppingCartItemRepository
          .deleteShoppingCartItem(shoppingCartItemId);

      // update policy
      shoppingCart.items.remove(shoppingCartItemId);
      shoppingCart.services.remove(shoppingCartItem.serviceId);
      await _shoppingCartRepository.updateShoppingCart(shoppingCart);

      state = false;
      res.fold((l) => showSnackBar(context, l.message, true), (r) {
        if (context.mounted) {
          showSnackBar(
              context, 'Shopping cart item deleted successfully!', false);
        }
      });
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context,
            'Shopping cart or shopping cart item does not exist', true);
      }
    }
  }

  Future<int?> getShoppingCartItemsByServiceIdCount(String serviceId) {
    state = true;
    return _shoppingCartItemRepository
        .getShoppingCartItemsByServiceIdCount(serviceId)
        .then(
      (value) {
        state = false;
        return value;
      },
    );
  }

  Future<int?> getShoppingCartItemCount(String shoppingCartId) {
    state = true;
    return _shoppingCartItemRepository
        .getShoppingCartItemCount(shoppingCartId)
        .then(
      (value) {
        state = false;
        return value;
      },
    );
  }

  Future<void> deleteShoppingCartItemsByShoppingCartId(String shoppingCartId) {
    return _shoppingCartItemRepository
        .deleteShoppingCartItemsByShoppingCartId(shoppingCartId);
  }

  Stream<List<ShoppingCartItem>> getShoppingCartItems(String shoppingCartId) {
    return _shoppingCartItemRepository.getShoppingCartItems(shoppingCartId);
  }

  Stream<List<ShoppingCartItem>> getUserShoppingCartItems(
      String shoppingCartId, String uid) {
    return _shoppingCartItemRepository.getUserShoppingCartItems(
        shoppingCartId, uid);
  }

  Stream<List<ShoppingCartItem>> getShoppingCartItemsByServiceId(
      String serviceId) {
    return _shoppingCartItemRepository
        .getShoppingCartItemsByServiceId(serviceId);
  }

  Stream<int> getUserShoppingCartItemCount(String shoppingCartId, String uid) {
    return _shoppingCartItemRepository.getUserShoppingCartItemCount(
        shoppingCartId, uid);
  }

  Stream<ShoppingCartItem?> getShoppingCartItemById(String shoppingCartItemId) {
    return _shoppingCartItemRepository
        .getShoppingCartItemById(shoppingCartItemId);
  }

  Stream<ShoppingCartItem?> getShoppingCartItemByServiceId(
      String shoppingCartId, String serviceId) {
    return _shoppingCartItemRepository.getShoppingCartItemByServiceId(
        shoppingCartId, serviceId);
  }
}
