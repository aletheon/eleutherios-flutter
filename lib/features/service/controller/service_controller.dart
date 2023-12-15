import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/service/repository/service_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final getServiceByIdProvider =
    StreamProvider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(serviceControllerProvider.notifier)
      .getServiceById(serviceId);
});

final userServicesProvider = StreamProvider.autoDispose<List<Service>>((ref) {
  return ref.watch(serviceControllerProvider.notifier).getUserServices();
});

final servicesProvider = StreamProvider.autoDispose<List<Service>>((ref) {
  return ref.watch(serviceControllerProvider.notifier).getServices();
});

final searchServicesProvider = StreamProvider.family((ref, String query) {
  return ref.watch(serviceControllerProvider.notifier).searchServices(query);
});

final serviceControllerProvider =
    StateNotifierProvider<ServiceController, bool>((ref) {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ServiceController(
      serviceRepository: serviceRepository,
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class ServiceController extends StateNotifier<bool> {
  final ServiceRepository _serviceRepository;
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ServiceController(
      {required ServiceRepository serviceRepository,
      required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _serviceRepository = serviceRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createService(String title, String description, bool public,
      BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    final user = _ref.read(userProvider);
    String serviceId = const Uuid().v1().replaceAll('-', '');

    Service service = Service(
      serviceId: serviceId,
      uid: uid,
      title: title,
      titleLowercase: title.toLowerCase(),
      description: description,
      image: Constants.avatarDefault,
      banner: Constants.serviceBannerDefault,
      public: public,
      tags: [],
      policies: [],
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _serviceRepository.createService(service);
    user!.services.add(serviceId);
    final resUser = await _userProfileRepository.updateUser(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Service created successfully!');
      Routemaster.of(context).replace('/user/service/list');
    });
  }

  void updateService({
    required File? profileFile,
    required File? bannerFile,
    required Service service,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      // services/profile/123456
      final profileRes = await _storageRepository.storeFile(
          path: 'services/profile', id: service.serviceId, file: profileFile);

      profileRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => service = service.copyWith(image: r),
      );
    }

    if (bannerFile != null) {
      // services/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'services/banner', id: service.serviceId, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => service = service.copyWith(banner: r),
      );
    }
    final serviceRes = await _serviceRepository.updateService(service);
    state = false;
    serviceRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Service updated successfully!');
      // Routemaster.of(context).popUntil((routeData) {
      //   if (routeData.toString().split("/").last ==
      //       routeData.pathParameters['id']) {
      //     return true;
      //   }
      //   return false;
      // });
    });
  }

  Stream<List<Service>> getUserServices() {
    final uid = _ref.read(userProvider)!.uid;
    return _serviceRepository.getUserServices(uid);
  }

  Stream<List<Service>> getServices() {
    return _serviceRepository.getServices();
  }

  Stream<Service?> getServiceById(String serviceId) {
    return _serviceRepository.getServiceById(serviceId);
  }

  Stream<List<Service>> searchServices(String query) {
    return _serviceRepository.searchServices(query);
  }
}
