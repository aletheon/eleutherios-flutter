import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/search.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final getForumByIdProvider =
    StreamProvider.family.autoDispose((ref, String forumId) {
  return ref.watch(forumControllerProvider.notifier).getForumById(forumId);
});

final getForumByIdProvider2 =
    Provider.family.autoDispose((ref, String forumId) {
  try {
    return ref.watch(forumControllerProvider.notifier).getForumById(forumId);
  } catch (e) {
    rethrow;
  }
});

final getServiceForumsProvider =
    StreamProvider.family.autoDispose((ref, String serviceId) {
  return ref
      .watch(forumControllerProvider.notifier)
      .getServiceForums(serviceId);
});

final userForumsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(forumControllerProvider.notifier).getUserForums();
});

final forumsProvider = StreamProvider.autoDispose<List<Forum>>((ref) {
  return ref.watch(forumControllerProvider.notifier).getForums();
});

final getForumChildrenProvider =
    StreamProvider.family.autoDispose((ref, String parentId) {
  return ref.watch(forumControllerProvider.notifier).getForumChildren(parentId);
});

final searchPrivateForumsProvider = StreamProvider.family.autoDispose(
  (ref, Search search) {
    return ref
        .watch(forumControllerProvider.notifier)
        .searchPrivateForums(search);
  },
);

final searchPublicForumsProvider = StreamProvider.family((ref, Search search) {
  return ref.watch(forumControllerProvider.notifier).searchPublicForums(search);
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

  Future<List<String>> getBreadCrumbPath(String breadCrumbPathForumId) async {
    try {
      List<String> breadcrumbs = [];

      Future<Forum?> getCrumb(String crumbForumId) async {
        try {
          Forum? tempForum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(crumbForumId)
              .first;

          // update breadcrumb references for this forum (i.e. breadCrumbPathForumId) in case
          // this forum is removed we know which children(s) breadcrumbs to update
          // if (tempForum != null &&
          //     tempForum.forumId != breadCrumbPathForumId &&
          //     !tempForum.breadcrumbReferences.contains(breadCrumbPathForumId)) {
          //   tempForum.breadcrumbReferences.add(breadCrumbPathForumId);
          //   await _forumRepository.updateForum(tempForum);
          // }
          return tempForum;
        } catch (e) {
          print(e.toString());
          rethrow;
        }
      }

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
      await getBreadCrumb(breadCrumbPathForumId);
      return breadcrumbs.reversed.toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  void createForum(String? parentId, String title, String description,
      bool public, List<String>? tags, BuildContext context) async {
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
      imageFileType: 'image/jpeg',
      imageFileName: Constants.avatarDefault.split('/').last,
      banner: Constants.forumBannerDefault,
      bannerFileType: 'image/jpeg',
      bannerFileName: Constants.forumBannerDefault.split('/').last,
      public: public,
      tags: tags != null && tags.isNotEmpty ? tags : [],
      services: [],
      members: [],
      posts: [],
      forums: [],
      breadcrumbs: [],
      breadcrumbReferences: [],
      recentPostId: '',
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
    await _forumRepository.createForum(forum);

    if (parentForum != null) {
      // add the new forum to the parent forums list
      parentForum.forums.add(forumId);
      await _forumRepository.updateForum(parentForum);

      // get the breadcrumbs for this forum
      List<String> breadcrumbs = await getBreadCrumbPath(forumId);

      // store the breadcrumbs
      if (breadcrumbs.isNotEmpty) {
        forum = forum.copyWith(breadcrumbs: breadcrumbs);
        await _forumRepository.updateForum(forum);

        // Create a reference in this forums breadcrumb references table to the parent forum that it is pointing to
        // So that if the parent gets deleted, we know we have to rebuild that reference forums, breadcrumbs
        for (String crumb in breadcrumbs) {
          if (crumb != forumId) {
            Forum? breadcrumb = await _ref
                .read(forumControllerProvider.notifier)
                .getForumById(crumb)
                .first;

            if (!breadcrumb!.breadcrumbReferences.contains(forumId)) {
              breadcrumb.breadcrumbReferences.add(forumId);
              await _forumRepository.updateForum(breadcrumb);
            }
          }
        }
      }
    }
    user.forums.add(forumId);
    final resUser = await _userProfileRepository.updateUser(user);
    state = false;
    resUser.fold((l) => showSnackBar(context, l.message, true), (r) {
      showSnackBar(context, 'Forum created successfully!', false);
      Routemaster.of(context).replace('/user/forum/list');
    });
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
        (l) => showSnackBar(context, l.message, true),
        (r) => forum = forum.copyWith(image: r),
      );
    }

    if (bannerFile != null) {
      // forums/banner/123456
      final bannerRes = await _storageRepository.storeFile(
          path: 'forums/banner', id: forum.forumId, file: bannerFile);

      bannerRes.fold(
        (l) => showSnackBar(context, l.message, true),
        (r) => forum = forum.copyWith(banner: r),
      );
    }
    final forumRes = await _forumRepository.updateForum(forum);
    state = false;
    forumRes.fold((l) => showSnackBar(context, l.message, true), (r) {
      showSnackBar(context, 'Forum updated successfully!', false);
    });
  }

  void deleteForum(String userId, String forumId, BuildContext context) async {
    state = true;
    UserModel? user = await _ref
        .read(authControllerProvider.notifier)
        .getUserData(userId)
        .first;

    Forum? forum = await _ref
        .read(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;

    if (user != null && forum != null) {
      // get the parent and remove forum from parent
      if (forum.parentId.isNotEmpty) {
        Forum? parentForum = await _ref
            .read(forumControllerProvider.notifier)
            .getForumById(forum.parentId)
            .first;

        if (parentForum != null) {
          parentForum.forums.remove(forumId);
          await _forumRepository.updateForum(parentForum);
        }
      }

      // remove members from forum
      if (forum.members.isNotEmpty) {
        await _ref
            .read(memberControllerProvider.notifier)
            .deleteMembersByForumId(forumId);
      }

      // iterate through breadcrumbs and remove breadcrumbReferences
      if (forum.breadcrumbs.isNotEmpty) {
        // iterate breadcrumbs
        for (String crumb in forum.breadcrumbs) {
          // grab the breadcrumb
          Forum? breadcrumbForum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(crumb)
              .first;

          // check if we have a breadcrumb
          if (breadcrumbForum != null) {
            // remove reference to childForum
            breadcrumbForum.breadcrumbReferences.remove(forumId);
            await _forumRepository.updateForum(breadcrumbForum);
          }
        }
      }

      // iterate through breadcrumbReferences and rebuild those childrens breadcrumbs
      if (forum.breadcrumbReferences.isNotEmpty) {
        for (String reference in forum.breadcrumbReferences) {
          // grab the forum
          Forum? referenceForum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(reference)
              .first;

          // check if we have a forum
          if (referenceForum != null) {
            // check if parentId equals forumId being deleted and set it to empty as
            // this forum will no longer exist
            if (referenceForum.parentId == forumId) {
              referenceForum =
                  referenceForum.copyWith(parentId: '', parentUid: '');
            }

            // recreate the breadcrumbs for this forum
            List<String> breadcrumbs =
                await getBreadCrumbPath(referenceForum.forumId);

            if (breadcrumbs.isNotEmpty) {
              referenceForum =
                  referenceForum.copyWith(breadcrumbs: breadcrumbs);
              await _forumRepository.updateForum(referenceForum);

              // Create a reference in this forums breadcrumb references table to the parent forum that it is pointing to
              // So that if the parent gets deleted, we know we have to rebuild that reference forums, breadcrumbs
              for (String crumb in breadcrumbs) {
                if (crumb != referenceForum.forumId) {
                  Forum? breadcrumb = await _ref
                      .read(forumControllerProvider.notifier)
                      .getForumById(crumb)
                      .first;

                  if (!breadcrumb!.breadcrumbReferences
                      .contains(referenceForum.forumId)) {
                    breadcrumb.breadcrumbReferences.add(referenceForum.forumId);
                    await _forumRepository.updateForum(breadcrumb);
                  }
                }
              }
            } else {
              referenceForum = referenceForum.copyWith(breadcrumbs: []);
              await _forumRepository.updateForum(referenceForum);
            }
          }
        }
      }
      // remove forum from user forum list
      user.forums.remove(forumId);
      await _userProfileRepository.updateUser(user);

      // delete forum
      final resDeleteForum = await _forumRepository.deleteForum(forumId);
      state = false;
      resDeleteForum.fold(
        (l) => showSnackBar(context, l.message, true),
        (r) {
          showSnackBar(context, 'Forum deleted successfully!', false);
        },
      );
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'User or rule does not exist', false);
      }
    }
  }

  // Note: we are only removing the forum from its parent we are not deleting it from the system
  // end users can still participate or serve one another through the child forum.
  void removeChildForum(
      String forumId, String childForumId, BuildContext context) async {
    state = true;
    Forum? forum = await _ref
        .read(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;

    Forum? childForum = await _ref
        .read(forumControllerProvider.notifier)
        .getForumById(childForumId)
        .first;

    if (forum != null && childForum != null) {
      forum.forums.remove(childForumId);
      final resChildForum = await _forumRepository.updateForum(forum);

      // iterate through childForum.breadcrumbs and remove childForum.breadcrumbReferences
      if (childForum.breadcrumbs.isNotEmpty) {
        // iterate breadcrumbs
        for (String crumb in childForum.breadcrumbs) {
          // grab the breadcrumb
          Forum? breadcrumbForum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(crumb)
              .first;

          // check if we have a breadcrumb
          if (breadcrumbForum != null) {
            // remove reference to childForum
            breadcrumbForum.breadcrumbReferences.remove(childForumId);
            await _forumRepository.updateForum(breadcrumbForum);
          }
        }
      }
      // remove breadcrumbs from childForum and dissociate from parent
      childForum =
          childForum.copyWith(breadcrumbs: [], parentId: '', parentUid: '');
      await _forumRepository.updateForum(childForum);

      // iterate through childForum.breadcrumbReferences and rebuild those childrens breadcrumbs
      if (childForum.breadcrumbReferences.isNotEmpty) {
        for (String reference in childForum.breadcrumbReferences) {
          // grab the forum
          Forum? referenceForum = await _ref
              .read(forumControllerProvider.notifier)
              .getForumById(reference)
              .first;

          // check if we have a forum
          if (referenceForum != null) {
            // recreate the breadcrumbs for this forum
            List<String> breadcrumbs =
                await getBreadCrumbPath(referenceForum.forumId);

            if (breadcrumbs.isNotEmpty) {
              referenceForum =
                  referenceForum.copyWith(breadcrumbs: breadcrumbs);
              await _forumRepository.updateForum(referenceForum);

              // Create a reference in this forums breadcrumb references table to the parent forum that it is pointing to
              // So that if the parent gets deleted, we know we have to rebuild that reference forums, breadcrumbs
              for (String crumb in breadcrumbs) {
                if (crumb != referenceForum.forumId) {
                  Forum? breadcrumb = await _ref
                      .read(forumControllerProvider.notifier)
                      .getForumById(crumb)
                      .first;

                  if (!breadcrumb!.breadcrumbReferences
                      .contains(referenceForum.forumId)) {
                    breadcrumb.breadcrumbReferences.add(referenceForum.forumId);
                    await _forumRepository.updateForum(breadcrumb);
                  }
                }
              }
            } else {
              referenceForum = referenceForum.copyWith(breadcrumbs: []);
              await _forumRepository.updateForum(referenceForum);
            }
          }
        }
      }
      state = false;
      resChildForum.fold(
        (l) => showSnackBar(context, l.message, true),
        (r) {
          showSnackBar(context, 'Forum deleted successfully!', false);
        },
      );
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, 'Forum or child forum does not exist', false);
      }
    }
  }

  Stream<List<Forum>> getUserForums() {
    final uid = _ref.read(userProvider)!.uid;
    return _forumRepository.getUserForums(uid);
  }

  Stream<List<Forum>> getForums() {
    return _forumRepository.getForums();
  }

  Stream<List<Forum>> getForumChildren(String parentId) {
    return _forumRepository.getForumChildren(parentId);
  }

  Stream<Forum?> getForumById(String forumId) {
    return _forumRepository.getForumById(forumId);
  }

  Stream<Forum?> getForumByRuleId(String ruleId) {
    return _forumRepository.getForumByRuleId(ruleId);
  }

  Stream<List<Forum>> getServiceForums(String serviceId) {
    return _forumRepository.getServiceForums(serviceId);
  }

  Stream<List<Forum>> searchPrivateForums(Search search) {
    return _forumRepository.searchPrivateForums(search);
  }

  Stream<List<Forum>> searchPublicForums(Search search) {
    return _forumRepository.searchPublicForums(search);
  }
}
