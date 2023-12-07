import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false); // is loading

  void updateUser(
      {required File? profileFile,
      required File? bannerFile,
      required UserModel userModel,
      required BuildContext context}) async {
    state = true;
    if (profileFile != null) {
      // users/profile/123456
      final profileRes = await _storageRepository.storeFile(
          path: 'users/profile', id: userModel.uid, file: profileFile);

      profileRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => userModel = userModel.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      // users/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'users/banner', id: userModel.uid, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => userModel = userModel.copyWith(banner: r),
      );
    }
    final res = await _userProfileRepository.updateUser(userModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'User updated successfully!');
      Routemaster.of(context).pop();
    });
  }
}
