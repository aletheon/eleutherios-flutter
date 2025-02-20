import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart_item/repository/shopping_cart_item_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart/repository/shopping_cart_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartItemByIdProvider =
    StreamProvider.family.autoDispose((ref, String shoppingCartItemId) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemById(shoppingCartItemId);
});

final getShoppingCartItemByForumServiceIdProvider =
    StreamProvider.family.autoDispose((ref, Tuple3 params) {
  try {
    return ref
        .watch(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemByForumServiceId(
            params.item1, params.item2, params.item3);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartItemByForumServiceIdProvider2 =
    Provider.family.autoDispose((ref, Tuple3 params) {
  try {
    return ref
        .watch(shoppingCartItemControllerProvider.notifier)
        .getShoppingCartItemByForumServiceId(
            params.item1, params.item2, params.item3);
  } catch (e) {
    rethrow;
  }
});

final getShoppingCartItemsByItemIdsProvider =
    StreamProvider.family.autoDispose((ref, List<String> shoppingCartItemIds) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemsByItemIds(shoppingCartItemIds);
});

final getShoppingCartItemsByItemIdsProvider2 =
    Provider.family.autoDispose((ref, List<String> shoppingCartItemIds) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemsByItemIds(shoppingCartItemIds);
});

final getShoppingCartItemsByShoppingCartIdProvider =
    StreamProvider.family.autoDispose((ref, String shoppingCartId) {
  return ref
      .watch(shoppingCartItemControllerProvider.notifier)
      .getShoppingCartItemsByShoppingCartId(shoppingCartId);
});

final getUserShoppingCartItemsByShoppingCartIdProvider =
    Provider.family.autoDispose((ref, Tuple2 params) {
  try {
    return ref
        .watch(shoppingCartItemControllerProvider.notifier)
        .getUserShoppingCartItemsByShoppingCartId(params.item1, params.item2);
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
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final shoppingCartItemRepository =
      ref.watch(shoppingCartItemRepositoryProvider);
  final shoppingCartRepository = ref.watch(shoppingCartRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return ShoppingCartItemController(
      userProfileRepository: userProfileRepository,
      shoppingCartItemRepository: shoppingCartItemRepository,
      shoppingCartRepository: shoppingCartRepository,
      serviceRepository: serviceRepository,
      ref: ref);
});

class ShoppingCartItemController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final ShoppingCartItemRepository _shoppingCartItemRepository;
  final ShoppingCartRepository _shoppingCartRepository;
  final ServiceRepository _serviceRepository;
  final Ref _ref;
  ShoppingCartItemController(
      {required UserProfileRepository userProfileRepository,
      required ShoppingCartItemRepository shoppingCartItemRepository,
      required ShoppingCartRepository shoppingCartRepository,
      required ServiceRepository serviceRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _shoppingCartItemRepository = shoppingCartItemRepository,
        _shoppingCartRepository = shoppingCartRepository,
        _serviceRepository = serviceRepository,
        _ref = ref,
        super(false);

  void createShoppingCartItem(
    ShoppingCart? shoppingCart,
    String forumId,
    String memberId,
    String serviceId,
    int quantity,
    BuildContext context,
  ) async {
    state = true;
    Forum? forum;
    Member? member;
    UserModel? user;
    bool canAddServiceToCart = true;

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    // ensure shoppingCart and service exist
    if (shoppingCart != null && service != null) {
      // ensure service is not already in cart
      if (forumId.isNotEmpty &&
          shoppingCart.services.contains('$forumId-$serviceId') == true) {
        canAddServiceToCart = false;
      } else if (shoppingCart.services.contains(serviceId) == true) {
        canAddServiceToCart = false;
      }

      if (canAddServiceToCart == true) {
        if (forumId.isNotEmpty) {
          forum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(forumId)
              .first;
        }
        if (memberId.isNotEmpty) {
          member = await _ref
              .read(memberControllerProvider.notifier)
              .getMemberById(memberId)
              .first;
        }
        String shoppingCartItemId = const Uuid().v1().replaceAll('-', '');

        // declare shopping cart item
        ShoppingCartItem shoppingCartItem = ShoppingCartItem(
          shoppingCartItemId: shoppingCartItemId,
          shoppingCartId: shoppingCart.shoppingCartId,
          shoppingCartUid: shoppingCart.uid,
          forumId: forum != null ? forum.forumId : '',
          forumUid: forum != null ? forum.uid : '',
          memberId: member != null ? member.memberId : '',
          memberUid: member != null ? member.serviceUid : '',
          serviceId: serviceId,
          serviceUid: service.uid,
          quantity: quantity,
          lastUpdateDate: DateTime.now(),
          creationDate: DateTime.now(),
        );

        if ((memberId.isNotEmpty && member != null) &&
            member.permissions.contains(MemberPermissions.addtocart.value) ==
                false) {
          canAddServiceToCart = false;
        }

        if (canAddServiceToCart == true) {
          if (service.type == ServiceType.physical.value) {
            if (quantity > 0) {
              if (service.quantity > 0 && service.quantity >= quantity) {
                // create shopping cart item
                final res = await _shoppingCartItemRepository
                    .createShoppingCartItem(shoppingCartItem);

                // add service to shopping cart items and service list
                if (forum != null) {
                  shoppingCart.items
                      .add('${forum.forumId}-$shoppingCartItemId');
                  shoppingCart.services.add('${forum.forumId}-$serviceId');
                } else {
                  shoppingCart.items.add(shoppingCartItemId);
                  shoppingCart.services.add(serviceId);
                }
                await _shoppingCartRepository.updateShoppingCart(shoppingCart);

                if (shoppingCartItem.forumUid.isNotEmpty) {
                  // get forum user
                  user = await _ref
                      .read(authControllerProvider.notifier)
                      .getUserData(shoppingCartItem.forumUid)
                      .first;
                } else {
                  // get shopping cart user
                  user = await _ref
                      .read(authControllerProvider.notifier)
                      .getUserData(shoppingCart.uid)
                      .first;
                }

                // add shopping cart item to users shoppingCartItems list
                if (user != null) {
                  user.shoppingCartItemIds.add(shoppingCartItemId);
                  await _userProfileRepository.updateUser(user);
                }

                // check if we need to add shopping cart item to members shoppingCartItems list
                if (member != null && member.serviceUid != shoppingCart.uid) {
                  // get member user
                  UserModel? memberUser = await _ref
                      .read(authControllerProvider.notifier)
                      .getUserData(member.serviceUid)
                      .first;

                  if (memberUser != null) {
                    // add shopping cart item to members shoppingCartItems list
                    memberUser.shoppingCartItemIds.add(shoppingCartItemId);
                    await _userProfileRepository.updateUser(memberUser);
                  }
                }

                // reduce service quantity
                service =
                    service.copyWith(quantity: service.quantity - quantity);
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
                      'There is not enough of this service to purchase only ${service.quantity} available',
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
            // create shopping cart item
            final res = await _shoppingCartItemRepository
                .createShoppingCartItem(shoppingCartItem);

            // add service to shopping cart items and service list
            if (forum != null) {
              shoppingCart.items.add('${forum.forumId}-$shoppingCartItemId');
              shoppingCart.services.add('${forum.forumId}-$serviceId');
            } else {
              shoppingCart.items.add(shoppingCartItemId);
              shoppingCart.services.add(serviceId);
            }
            await _shoppingCartRepository.updateShoppingCart(shoppingCart);

            if (shoppingCartItem.forumUid.isNotEmpty) {
              // get forum user
              user = await _ref
                  .read(authControllerProvider.notifier)
                  .getUserData(shoppingCartItem.forumUid)
                  .first;
            } else {
              // get shopping cart user
              user = await _ref
                  .read(authControllerProvider.notifier)
                  .getUserData(shoppingCart.uid)
                  .first;
            }

            // add shopping cart item to users shoppingCartItems list
            if (user != null) {
              user.shoppingCartItemIds.add(shoppingCartItemId);
              await _userProfileRepository.updateUser(user);
            }

            // check if we need to add shopping cart item to members shoppingCartItems list
            if (member != null && member.serviceUid != shoppingCart.uid) {
              // get member user
              UserModel? memberUser = await _ref
                  .read(authControllerProvider.notifier)
                  .getUserData(member.serviceUid)
                  .first;

              if (memberUser != null) {
                // add shopping cart item to members shoppingCartItems list
                memberUser.shoppingCartItemIds.add(shoppingCartItemId);
                await _userProfileRepository.updateUser(memberUser);
              }
            }
            state = false;
            res.fold((l) => showSnackBar(context, l.message, true), (r) {
              showSnackBar(
                  context, 'Shopping cart item added successfully!', false);
            });
          }
        } else {
          state = false;
          if (context.mounted) {
            showSnackBar(
                context,
                'Member does not have permission to add item to shopping cart',
                true);
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

  void increaseShoppingCartItemQuantity(
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    Service service,
    BuildContext context,
  ) async {
    state = true;
    Member? member; // placeholder for member
    bool canAddServiceToCart = true;

    if (shoppingCart != null && shoppingCartItem != null) {
      if (shoppingCart.services.contains(service.serviceId) == true ||
          (shoppingCartItem.forumId.isNotEmpty &&
              shoppingCart.services.contains(
                      '${shoppingCartItem.forumId}-${service.serviceId}') ==
                  true)) {
        if (shoppingCartItem.memberId.isNotEmpty) {
          member = await _ref
              .read(memberControllerProvider.notifier)
              .getMemberById(shoppingCartItem.memberId)
              .first;
        }

        if (member != null &&
            member.permissions.contains(MemberPermissions.addtocart.value) ==
                false) {
          canAddServiceToCart = false;
        }

        if (canAddServiceToCart == true) {
          if (service.type == ServiceType.physical.value) {
            if (service.quantity > 0) {
              shoppingCartItem = shoppingCartItem.copyWith(
                  quantity: shoppingCartItem.quantity + 1);
              final res = await _shoppingCartItemRepository
                  .updateShoppingCartItem(shoppingCartItem);

              // update service
              service = service.copyWith(quantity: service.quantity - 1);
              await _serviceRepository.updateService(service);

              state = false;
              res.fold((l) => showSnackBar(context, l.message, true), (r) {
                if (context.mounted) {
                  showSnackBar(context,
                      'Shopping cart item updated successfully!', false);
                }
              });
            } else {
              state = false;
              if (context.mounted) {
                showSnackBar(
                    context,
                    'There is not enough of this service to purchase there is zero available',
                    true);
              }
            }
          } else {
            state = false;
            if (context.mounted) {
              showSnackBar(context,
                  'Service is non-physical and is cannot be incremented', true);
            }
          }
        } else {
          state = false;
          if (context.mounted) {
            showSnackBar(
                context,
                'Member does not have permission to add item to shopping cart',
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

  void decreaseShoppingCartItemQuantity(
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    Service service,
    BuildContext context,
  ) async {
    state = true;
    UserModel? user;
    Member? member; // placeholder for member
    bool canRemoveServiceFromCart = true;

    if (shoppingCart != null && shoppingCartItem != null) {
      if (shoppingCart.services.contains(service.serviceId) == true ||
          (shoppingCartItem.forumId.isNotEmpty &&
              shoppingCart.services.contains(
                      '${shoppingCartItem.forumId}-${service.serviceId}') ==
                  true)) {
        if (shoppingCartItem.memberId.isNotEmpty) {
          member = await _ref
              .read(memberControllerProvider.notifier)
              .getMemberById(shoppingCartItem.memberId)
              .first;
        }

        if (shoppingCartItem.forumUid.isNotEmpty) {
          // get forum user
          user = await _ref
              .read(authControllerProvider.notifier)
              .getUserData(shoppingCartItem.forumUid)
              .first;
        } else {
          // get shopping cart user
          user = await _ref
              .read(authControllerProvider.notifier)
              .getUserData(shoppingCart.uid)
              .first;
        }

        if (member != null &&
            member.permissions
                    .contains(MemberPermissions.removefromcart.value) ==
                false) {
          canRemoveServiceFromCart = false;
        }

        if (canRemoveServiceFromCart) {
          if (shoppingCartItem.quantity == 1) {
            // delete shopping cart item
            final res = await _shoppingCartItemRepository
                .deleteShoppingCartItem(shoppingCartItem.shoppingCartItemId);

            // update shopping cart
            if (shoppingCartItem.forumId.isNotEmpty) {
              shoppingCart.items.remove(
                  '${shoppingCartItem.forumId}-${shoppingCartItem.shoppingCartItemId}');
              shoppingCart.services.remove(
                  '${shoppingCartItem.forumId}-${shoppingCartItem.serviceId}');
            } else {
              shoppingCart.items.remove(shoppingCartItem.shoppingCartItemId);
              shoppingCart.services.remove(shoppingCartItem.serviceId);
            }
            await _shoppingCartRepository.updateShoppingCart(shoppingCart);

            // remove shopping cart item from users shoppingCartItems list
            if (user != null) {
              user.shoppingCartItemIds
                  .remove(shoppingCartItem.shoppingCartItemId);
              await _userProfileRepository.updateUser(user);
            }

            // check if we need to remove shopping cart item from members shoppingCartItems list
            if (member != null && member.serviceUid != shoppingCart.uid) {
              // get member user
              UserModel? memberUser = await _ref
                  .read(authControllerProvider.notifier)
                  .getUserData(member.serviceUid)
                  .first;

              if (memberUser != null) {
                // remove shopping cart item from members shoppingCartItems list
                memberUser.shoppingCartItemIds
                    .remove(shoppingCartItem.shoppingCartItemId);
                await _userProfileRepository.updateUser(memberUser);
              }
            }

            // update service
            service = service.copyWith(quantity: service.quantity + 1);
            await _serviceRepository.updateService(service);

            state = false;
            res.fold((l) => showSnackBar(context, l.message, true), (r) {
              if (context.mounted) {
                showSnackBar(
                    context, 'Shopping cart item removed successfully!', false);
              }
            });
          } else {
            shoppingCartItem = shoppingCartItem.copyWith(
                quantity: shoppingCartItem.quantity - 1);
            final res = await _shoppingCartItemRepository
                .updateShoppingCartItem(shoppingCartItem);

            // update service
            service = service.copyWith(quantity: service.quantity + 1);
            await _serviceRepository.updateService(service);

            state = false;
            res.fold((l) => showSnackBar(context, l.message, true), (r) {
              if (context.mounted) {
                showSnackBar(
                    context, 'Shopping cart item updated successfully!', false);
              }
            });
          }
        } else {
          state = false;
          if (context.mounted) {
            showSnackBar(
                context,
                'Member does not have permission to remove item from shopping cart',
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

  void deleteShoppingCartItem(
    ShoppingCart? shoppingCart,
    ShoppingCartItem? shoppingCartItem,
    Service service,
    BuildContext context,
  ) async {
    state = true;
    UserModel? user;
    Member? member;
    bool canRemoveServiceFromCart = true;

    if (shoppingCart != null && shoppingCartItem != null) {
      if (shoppingCart.services.contains(service.serviceId) == true ||
          (shoppingCartItem.forumId.isNotEmpty &&
              shoppingCart.services.contains(
                      '${shoppingCartItem.forumId}-${service.serviceId}') ==
                  true)) {
        if (shoppingCartItem.memberId.isNotEmpty) {
          member = await _ref
              .read(memberControllerProvider.notifier)
              .getMemberById(shoppingCartItem.memberId)
              .first;
        }

        if (shoppingCartItem.forumUid.isNotEmpty) {
          // get forum user
          user = await _ref
              .read(authControllerProvider.notifier)
              .getUserData(shoppingCartItem.forumUid)
              .first;
        } else {
          // get shopping cart user
          user = await _ref
              .read(authControllerProvider.notifier)
              .getUserData(shoppingCart.uid)
              .first;
        }

        if (member != null &&
            member.permissions
                    .contains(MemberPermissions.removefromcart.value) ==
                false) {
          canRemoveServiceFromCart = false;
        }

        if (canRemoveServiceFromCart) {
          // delete shopping cart item
          final res = await _shoppingCartItemRepository
              .deleteShoppingCartItem(shoppingCartItem.shoppingCartItemId);

          // update shopping cart
          if (shoppingCartItem.forumId.isNotEmpty) {
            shoppingCart.items.remove(
                '${shoppingCartItem.forumId}-${shoppingCartItem.shoppingCartItemId}');
            shoppingCart.services.remove(
                '${shoppingCartItem.forumId}-${shoppingCartItem.serviceId}');
          } else {
            shoppingCart.items.remove(shoppingCartItem.shoppingCartItemId);
            shoppingCart.services.remove(shoppingCartItem.serviceId);
          }

          await _shoppingCartRepository.updateShoppingCart(shoppingCart);

          // remove shopping cart item from users shoppingCartItems list
          if (user != null) {
            user.shoppingCartItemIds
                .remove(shoppingCartItem.shoppingCartItemId);
            await _userProfileRepository.updateUser(user);
          }

          // check if we need to remove shopping cart item from members shoppingCartItems list
          if (member != null && member.serviceUid != shoppingCart.uid) {
            // get member user
            UserModel? memberUser = await _ref
                .read(authControllerProvider.notifier)
                .getUserData(member.serviceUid)
                .first;

            if (memberUser != null) {
              // remove shopping cart item from members shoppingCartItems list
              memberUser.shoppingCartItemIds
                  .remove(shoppingCartItem.shoppingCartItemId);
              await _userProfileRepository.updateUser(memberUser);
            }
          }

          if (service.type == ServiceType.physical.value) {
            // update service
            service = service.copyWith(
                quantity: service.quantity + shoppingCartItem.quantity);
            await _serviceRepository.updateService(service);
          }
          state = false;
          res.fold((l) => showSnackBar(context, l.message, true), (r) {
            if (context.mounted) {
              showSnackBar(
                  context, 'Shopping cart item removed successfully!', false);
            }
          });
        } else {
          state = false;
          if (context.mounted) {
            showSnackBar(
                context,
                'Member does not have permission to remove item from shopping cart',
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

  Stream<List<ShoppingCartItem>> getShoppingCartItemsByItemIds(
      List<String> shoppingCartItemIds) {
    return _shoppingCartItemRepository
        .getShoppingCartItemsByItemIds(shoppingCartItemIds);
  }

  Stream<List<ShoppingCartItem>> getShoppingCartItemsByShoppingCartId(
      String shoppingCartId) {
    return _shoppingCartItemRepository
        .getShoppingCartItemsByShoppingCartId(shoppingCartId);
  }

  Stream<List<ShoppingCartItem>> getUserShoppingCartItemsByShoppingCartId(
      String shoppingCartId, String uid) {
    return _shoppingCartItemRepository.getUserShoppingCartItemsByShoppingCartId(
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

  Stream<ShoppingCartItem?> getShoppingCartItemByForumServiceId(
    String shoppingCartId,
    String forumId,
    String serviceId,
  ) {
    return _shoppingCartItemRepository.getShoppingCartItemByForumServiceId(
      shoppingCartId,
      forumId,
      serviceId,
    );
  }
}
