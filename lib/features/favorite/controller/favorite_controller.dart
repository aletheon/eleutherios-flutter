import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/repository/favorite_repository.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/favorite.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:uuid/uuid.dart';

final getFavoriteByIdProvider = Provider.family.autoDispose(
  (ref, String favoriteId) {
    final favoriteRepository = ref.watch(favoriteRepositoryProvider);
    return favoriteRepository.getFavoriteById(favoriteId);
  },
);

final userFavoritesProvider = StreamProvider.autoDispose(
  (ref) {
    return ref.watch(favoriteControllerProvider.notifier).getFavorites();
  },
);

final favoriteControllerProvider =
    StateNotifierProvider<FavoriteController, bool>((ref) {
  final favoriteRepository = ref.watch(favoriteRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return FavoriteController(
      favoriteRepository: favoriteRepository,
      userProfileRepository: userProfileRepository,
      serviceRepository: serviceRepository,
      ref: ref);
});

class FavoriteController extends StateNotifier<bool> {
  final FavoriteRepository _favoriteRepository;
  final UserProfileRepository _userProfileRepository;
  final ServiceRepository _serviceRepository;
  final Ref _ref;
  FavoriteController(
      {required FavoriteRepository favoriteRepository,
      required UserProfileRepository userProfileRepository,
      required ServiceRepository serviceRepository,
      required Ref ref})
      : _favoriteRepository = favoriteRepository,
        _userProfileRepository = userProfileRepository,
        _serviceRepository = serviceRepository,
        _ref = ref,
        super(false);

  void createFavorite(
      String serviceId, String serviceUid, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider)!;
    String favoriteId = const Uuid().v1().replaceAll('-', '');

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (service != null) {
      Favorite favorite = Favorite(
        favoriteId: favoriteId,
        uid: user.uid,
        serviceId: serviceId,
        serviceUid: serviceUid,
        lastUpdateDate: DateTime.now(),
        creationDate: DateTime.now(),
      );
      // create favorite
      await _favoriteRepository.createFavorite(favorite);

      // update user
      user.favorites.add(serviceId);
      await _userProfileRepository.updateUser(user);

      // update service likes
      service.likes.add(user.uid);
      await _serviceRepository.updateService(service);
      state = false;
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Service does not exist');
      }
    }
  }

  void deleteFavorite(String serviceId, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider)!;

    Service? service = await _ref
        .read(serviceControllerProvider.notifier)
        .getServiceById(serviceId)
        .first;

    if (service != null) {
      // delete favorite
      await _favoriteRepository.deleteFavorite(user.uid, serviceId);

      // delete favorite from users list
      user.favorites.remove(serviceId);
      await _userProfileRepository.updateUser(user);

      // update service likes
      service.likes.remove(user.uid);
      await _serviceRepository.updateService(service);
      state = false;
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Service does not exist');
      }
    }
  }

  Stream<List<Favorite>> getFavorites() {
    final uid = _ref.read(userProvider)!.uid;
    return _favoriteRepository.getFavorites(uid);
  }

  Stream<Favorite> getFavoriteById(String favoriteId) {
    return _favoriteRepository.getFavoriteById(favoriteId);
  }
}
