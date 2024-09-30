import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/repository/auth_repository.dart';
import 'package:reddit_tutorial/features/shopping_cart/repository/shopping_cart_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:uuid/uuid.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

// final getUserByIdProvider = Provider.family((ref, String uid) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.getUserData(uid);
// });

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final shoppingCartRepository = ref.watch(shoppingCartRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    userProfileRepository: userProfileRepository,
    shoppingCartRepository: shoppingCartRepository,
    ref: ref,
  );
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;
  final ShoppingCartRepository _shoppingCartRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required UserProfileRepository userProfileRepository,
    required ShoppingCartRepository shoppingCartRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _userProfileRepository = userProfileRepository,
        _shoppingCartRepository = shoppingCartRepository,
        _ref = ref,
        super(false); // is loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final eitherUserModel = await _authRepository.signInWithGoogle();

    if (eitherUserModel.isRight()) {
      UserModel? user = eitherUserModel.toOption().toNullable();

      if (user != null) {
        if (user.shoppingCartId.isEmpty) {
          // create a shopping cart for this user
          String shoppingCartId = const Uuid().v1().replaceAll('-', '');
          ShoppingCart shoppingCart = ShoppingCart(
            shoppingCartId: shoppingCartId,
            uid: user.uid,
            services: [],
            items: [],
            lastUpdateDate: DateTime.now(),
            creationDate: DateTime.now(),
          );
          await _shoppingCartRepository.createShoppingCart(shoppingCart);
          user = user.copyWith(shoppingCartId: shoppingCartId);
          await _userProfileRepository.updateUser(user);
        }
      }
    }
    state = false;
    eitherUserModel.fold((l) {
      // showSnackBar(context, l.message, false);
    },
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel?> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logout();
  }
}
