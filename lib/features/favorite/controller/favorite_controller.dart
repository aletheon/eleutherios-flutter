import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/repository/favorite_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/favorite.dart';
import 'package:uuid/uuid.dart';

final getFavoriteByIdProvider = Provider.family((ref, String favoriteId) {
  final favoriteRepository = ref.watch(favoriteRepositoryProvider);
  return favoriteRepository.getFavoriteById(favoriteId);
});

final userFavoritesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(favoriteControllerProvider.notifier).getFavorites();
});

final favoriteControllerProvider =
    StateNotifierProvider<FavoriteController, bool>((ref) {
  final favoriteRepository = ref.watch(favoriteRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return FavoriteController(
      favoriteRepository: favoriteRepository,
      userProfileRepository: userProfileRepository,
      ref: ref);
});

class FavoriteController extends StateNotifier<bool> {
  final FavoriteRepository _favoriteRepository;
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  FavoriteController(
      {required FavoriteRepository favoriteRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _favoriteRepository = favoriteRepository,
        _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  void createFavorite(String serviceId, String serviceUid) async {
    state = true;
    final user = _ref.read(userProvider)!;
    String favoriteId = const Uuid().v1().replaceAll('-', '');

    Favorite favorite = Favorite(
      favoriteId: favoriteId,
      uid: user.uid,
      serviceId: serviceId,
      serviceUid: serviceUid,
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _favoriteRepository.createFavorite(favorite);
    user.favorites.add(serviceId);
    final resUser = await _userProfileRepository.updateUser(user);
    state = false;
  }

  void deleteFavorite(String serviceId, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider)!;
    var res = await _favoriteRepository.deleteFavorite(user.uid, serviceId);
    user.favorites.remove(serviceId);
    var userRes = await _userProfileRepository.updateUser(user);
    state = false;
    // res.fold((l) => showSnackBar(context, l.message), (r) {
    //   showSnackBar(context, 'Favorite removed successfully!');
    // });
  }

  Stream<List<Favorite>> getFavorites() {
    final uid = _ref.read(userProvider)!.uid;
    return _favoriteRepository.getFavorites(uid);
  }

  Stream<Favorite> getFavoriteById(String favoriteId) {
    return _favoriteRepository.getFavoriteById(favoriteId);
  }
}
