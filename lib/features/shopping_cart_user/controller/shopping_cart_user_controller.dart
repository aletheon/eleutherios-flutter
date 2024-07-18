import 'package:reddit_tutorial/features/shopping_cart_user/repository/shopping_cart_user_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/models/shopping_cart_user.dart';
import 'package:uuid/uuid.dart';

final getShoppingCartUserByIdProvider =
    Provider.family.autoDispose((ref, String shoppingCartUserId) {
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  return shoppingCartUserRepository.getShoppingCartUserById(shoppingCartUserId);
});

final shoppingCartUsersProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref
      .watch(shoppingCartUserControllerProvider.notifier)
      .getShoppingCartUsers();
});

final shoppingCartUserControllerProvider =
    StateNotifierProvider<ShoppingCartUserController, bool>((ref) {
  final shoppingCartUserRepository =
      ref.watch(shoppingCartUserRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return ShoppingCartUserController(
      shoppingCartUserRepository: shoppingCartUserRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class ShoppingCartUserController extends StateNotifier<bool> {
  final ShoppingCartUserRepository _shoppingCartUserRepository;
  final Ref _ref;
  ShoppingCartUserController(
      {required ShoppingCartUserRepository shoppingCartUserRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _shoppingCartUserRepository = shoppingCartUserRepository,
        _ref = ref,
        super(false);

  void createShoppingCartUser(String uid, String cartUid) async {
    state = true;
    String shoppingCartUserId = const Uuid().v1().replaceAll('-', '');

    ShoppingCartUser shoppingCartUser = ShoppingCartUser(
      shoppingCartUserId: shoppingCartUserId,
      uid: uid,
      cartUid: cartUid,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _shoppingCartUserRepository
        .createShoppingCartUser(shoppingCartUser);
    state = false;
  }

  Stream<List<ShoppingCartUser>> getShoppingCartUsers() {
    return _shoppingCartUserRepository.getShoppingCartUsers();
  }
}
