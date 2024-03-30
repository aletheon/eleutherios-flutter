import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/providers/storage_repository_provider.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/forum/repository/forum_repository.dart';
import 'package:reddit_tutorial/features/post/repository/post_repository.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/post.dart';
import 'package:reddit_tutorial/models/registrant.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final getPostByIdProvider =
    StreamProvider.family.autoDispose((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final forumPostsProvider = StreamProvider.family((ref, String forumId) {
  return ref.watch(postControllerProvider.notifier).getForumPosts(forumId);
});

final userPostsProvider =
    StreamProvider.family.autoDispose((ref, Tuple2 params) {
  return ref
      .watch(postControllerProvider.notifier)
      .getUserPosts(params.item1, params.item2);
});

final postsProvider = StreamProvider.family.autoDispose((ref, String forumId) {
  return ref.watch(postControllerProvider.notifier).getPosts(forumId);
});

final searchPostsProvider = StreamProvider.family((ref, Tuple2 params) {
  return ref
      .watch(postControllerProvider.notifier)
      .searchPosts(params.item1, params.item2);
});

final getRecentPostProvider =
    StreamProvider.family.autoDispose((ref, String forumId) {
  return ref.watch(postControllerProvider.notifier).getRecentPost(forumId);
});

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final forumRepository = ref.watch(forumRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      forumRepository: forumRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final ForumRepository _forumRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  PostController(
      {required PostRepository postRepository,
      required ForumRepository forumRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _postRepository = postRepository,
        _forumRepository = forumRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createPost(String forumId, String registrantId, String message,
      File? imageFile, BuildContext context) async {
    state = true;
    Forum? forum = await _ref
        .read(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;
    Registrant? registrant = await _ref
        .read(registrantControllerProvider.notifier)
        .getRegistrantById(registrantId)
        .first;
    String postId = const Uuid().v1().replaceAll('-', '');

    Post post = Post(
      postId: postId,
      forumId: forumId,
      forumUid: forum!.uid,
      registrantId: registrantId,
      serviceId: registrant!.serviceId,
      serviceUid: registrant.serviceUid,
      message: message,
      messageLowercase: message.toLowerCase(),
      image: '',
      lastUpdateDate: DateTime.now(),
      creationDate: DateTime.now(),
    );

    // create post image
    if (imageFile != null) {
      // posts/image/123456
      final imageRes = await _storageRepository.storeFile(
          path: 'posts/image', id: postId, file: imageFile);

      imageRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => post = post.copyWith(image: r),
      );
    }
    // create post
    final res = await _postRepository.createPost(post);

    // update forum
    forum = forum.copyWith(
      recentPostId: postId,
    );
    forum.posts.add(postId);
    final resForum = await _forumRepository.updateForum(forum);
    state = false;
    resForum.fold((l) => showSnackBar(context, l.message), (r) {});
  }

  void updatePost({
    required Forum forum,
    required Post post,
    required File? imageFile,
    required BuildContext context,
  }) async {
    state = true;
    if (imageFile != null) {
      // posts/image/123456
      final imageRes = await _storageRepository.storeFile(
          path: 'posts/image', id: post.postId, file: imageFile);

      imageRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) => post = post.copyWith(image: r),
      );
    }
    final postRes = await _postRepository.updatePost(post);
    state = false;
    postRes.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Post updated successfully!');
    });
  }

  void deletePost({
    required String forumId,
    required String postId,
    required BuildContext context,
  }) async {
    state = true;

    // get forum
    Forum? forum = await _ref
        .read(forumControllerProvider.notifier)
        .getForumById(forumId)
        .first;

    // delete post
    final postRes = await _postRepository.deletePost(postId);

    // update forum
    if (forum!.recentPostId.isNotEmpty && forum.recentPostId == postId) {
      Post? recentPost = await _ref
          .read(postControllerProvider.notifier)
          .getRecentPost(forum.forumId)
          .first;

      if (recentPost != null) {
        forum = forum.copyWith(recentPostId: recentPost.postId);
      } else {
        forum = forum.copyWith(recentPostId: '');
      }
    }
    forum.posts.remove(postId);
    final resForum = await _forumRepository.updateForum(forum);
    state = false;
    postRes.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'Post deleted successfully!');
    });
  }

  Stream<List<Post>> getForumPosts(String forumId) {
    return _postRepository.getForumPosts(forumId);
  }

  Stream<List<Post>> getUserPosts(String forumId, String uid) {
    return _postRepository.getUserPosts(forumId, uid);
  }

  Stream<List<Post>> getPosts(String forumId) {
    return _postRepository.getPosts(forumId);
  }

  Stream<Post?> getRecentPost(String forumId) {
    return _postRepository.getRecentPost(forumId);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  Stream<List<Post>> searchPosts(String forumId, String query) {
    return _postRepository.searchPosts(forumId, query);
  }
}
