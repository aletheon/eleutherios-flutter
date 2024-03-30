import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final getForumByIdProvider =
    StreamProvider.family.autoDispose((ref, String forumId) {
  return ref.watch(forumControllerProvider.notifier).getForumById(forumId);
});

final getForumByIdProvider2 = Provider.family((ref, String forumId) {
  try {
    return ref.watch(forumControllerProvider.notifier).getForumById(forumId);
  } catch (e) {
    rethrow;
  }
});

final userForumsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(forumControllerProvider.notifier).getUserForums();
});

final forumsProvider = StreamProvider.autoDispose<List<Forum>>((ref) {
  return ref.watch(forumControllerProvider.notifier).getForums();
});

final getChildrenProvider =
    StreamProvider.family.autoDispose((ref, String parentId) {
  return ref.watch(forumControllerProvider.notifier).getChildren(parentId);
});

final searchForumsProvider = StreamProvider.family((ref, String query) {
  return ref.watch(forumControllerProvider.notifier).searchForums(query);
});

final forumControllerProvider =
    StateNotifierProvider<ForumController, bool>((ref) {
  final forumRepository = ref.watch(forumRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ForumController(
      forumRepository: forumRepository,
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class ForumController extends StateNotifier<bool> {
  final ForumRepository _forumRepository;
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ForumController(
      {required ForumRepository forumRepository,
      required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _forumRepository = forumRepository,
        _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createForum(String? parentId, String title, String description,
      bool public, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider)!;
    Forum? parentForum;

    if (parentId != null) {
      parentForum = await _ref
          .read(forumControllerProvider.notifier)
          .getForumById(parentId)
          .first;
    }
    String forumId = const Uuid().v1().replaceAll('-', '');

    Forum forum = Forum(
      forumId: forumId,
      uid: user.uid,
      parentId: parentForum != null ? parentForum.forumId : '',
      parentUid: parentForum != null ? parentForum.uid : '',
      policyId: '',
      policyUid: '',
      ruleId: '',
      title: title,
      titleLowercase: title.toLowerCase(),
      description: description,
      image: Constants.avatarDefault,
      banner: Constants.forumBannerDefault,
      public: public,
      tags: [],
      registrants: [],
      posts: [],
      forums: [],
      breadcrumbs: [],
      breadcrumbReferences: [],
      recentPostId: '',
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _forumRepository.createForum(forum);

    if (parentForum != null) {
      // add the new forum to the parent forums list
      parentForum.forums.add(forumId);
      final parentRes = await _forumRepository.updateForum(parentForum);

      Future<Forum?> getCrumb(String forumId) async {
        try {
          Forum? tempForum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(forumId)
              .first;

          // update breadcrumb references for this forum in case
          // this forum is removed we know which children(s) breadcrumbs to update
          if (tempForum != null &&
              tempForum.forumId != forum.forumId &&
              !tempForum.breadcrumbReferences.contains(forum.forumId)) {
            tempForum.breadcrumbReferences.add(forum.forumId);
            final bcRes = await _forumRepository.updateForum(tempForum);
          }
          return tempForum;
        } catch (e) {
          print(e.toString());
          rethrow;
        }
      }

      Future<List<String>> getBreadCrumbPath(String forumId) async {
        try {
          List<String> breadcrumbs = [];

          // recursive function
          Future<Forum?> getBreadCrumb(String forumIdToRecurse) async {
            Future<Forum?> predicate(Forum? tempForum) async {
              if (tempForum != null) {
                breadcrumbs.add(tempForum.forumId);

                if (tempForum.parentId.isNotEmpty) {
                  return await getBreadCrumb(tempForum.parentId);
                } else {
                  return null;
                }
              } else {
                return null;
              }
            }

            // get our initial parent then recurse up the tree to the root parent
            return await getCrumb(forumIdToRecurse).then(predicate);
          }

          // Start our recursive function
          await getBreadCrumb(forumId);
          return breadcrumbs.reversed.toList();
        } catch (e) {
          print(e.toString());
          rethrow;
        }
      }

      // get the breadcrumbs for this forum
      List<String> breadcrumbs = await getBreadCrumbPath(forum.forumId);

      // *********************************************************
      // *********************************************************
      // *********************************************************
      // HERE ROB HAVE TO UPDATE forum.breadcrumbReferences for each breadcrumb
      // so that if this forum gets deleted they know they have to update
      // their breadcrumbs list
      // *********************************************************
      // *********************************************************
      // *********************************************************

      // store the breadcrumbs
      if (breadcrumbs.isNotEmpty) {
        forum = forum.copyWith(breadcrumbs: breadcrumbs);
        final res = await _forumRepository.updateForum(forum);
      }
    }

    user.forums.add(forumId);
    final resUser = await _userProfileRepository.updateUser(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Forum created successfully!');
      Routemaster.of(context).replace('/user/forum/list');
    });
  }

  // *************************************************************
  // *************************************************************
  // *************************************************************
  // *************************************************************
  // HERE ROB BUILD THIS ROUTINE OUT
  // *************************************************************
  // *************************************************************
  // *************************************************************
  // *************************************************************
  // *************************************************************
  void createForumFromRule(
      Rule rule, Policy policy, Service service, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider)!;
    String forumId = const Uuid().v1().replaceAll('-', '');

    Forum forum = Forum(
      forumId: forumId,
      uid: service.uid,
      parentId: '',
      parentUid: '',
      policyId: policy.policyId,
      policyUid: policy.uid,
      ruleId: rule.ruleId,
      title: rule.title,
      titleLowercase: rule.titleLowercase,
      description: rule.description,

      // HERE ROB HAVE TO MOVE IMAGE TO FORUM/

      image: rule.image,
      banner: rule.banner,
      public: rule.public,
      tags: rule.tags,
      registrants: [],
      posts: [],
      forums: [],
      breadcrumbs: [],
      breadcrumbReferences: [],
      recentPostId: '',
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    final res = await _forumRepository.createForum(forum);

    state = false;
  }

  void updateForum({
    required File? profileFile,
    required File? bannerFile,
    required Forum forum,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      // forums/profile/123456
      final profileRes = await _storageRepository.storeFile(
          path: 'forums/profile', id: forum.forumId, file: profileFile);

      profileRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => forum = forum.copyWith(image: r),
      );
    }

    if (bannerFile != null) {
      // forums/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'forums/banner', id: forum.forumId, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => forum = forum.copyWith(banner: r),
      );
    }
    final forumRes = await _forumRepository.updateForum(forum);
    state = false;
    forumRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Forum updated successfully!');
      // Routemaster.of(context).popUntil((routeData) {
      //   if (routeData.toString().split("/").last ==
      //       routeData.pathParameters['id']) {
      //     return true;
      //   }
      //   return false;
      // });
    });
  }

  Stream<List<Forum>> getUserForums() {
    final uid = _ref.read(userProvider)!.uid;
    return _forumRepository.getUserForums(uid);
  }

  Stream<List<Forum>> getForums() {
    return _forumRepository.getForums();
  }

  Stream<List<Forum>> getChildren(String parentId) {
    return _forumRepository.getChildren(parentId);
  }

  Stream<Forum?> getForumById(String forumId) {
    return _forumRepository.getForumById(forumId);
  }

  Stream<List<Forum>> searchForums(String query) {
    return _forumRepository.searchForums(query);
  }
}
