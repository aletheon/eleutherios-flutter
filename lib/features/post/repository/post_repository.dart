import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/post.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  Stream<Post?> getPostById(String postId) {
    if (postId.isNotEmpty) {
      final DocumentReference documentReference = _posts.doc(postId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return Post.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<Post?> getRecentPost(String forumId) {
    return _posts
        .where('forumId', isEqualTo: forumId)
        .orderBy('creationDate', descending: true)
        .limit(1)
        .snapshots()
        .map((event) {
      List<Post> posts = [];
      for (var doc in event.docs) {
        posts.add(Post.fromMap(doc.data() as Map<String, dynamic>));
      }
      if (posts.isNotEmpty) {
        return posts[0];
      } else {
        return null;
      }
    });
  }

  Stream<List<Post>> getPosts(String forumId) {
    return _posts.where('forumId', isEqualTo: forumId).snapshots().map((event) {
      List<Post> posts = [];
      for (var doc in event.docs) {
        posts.add(Post.fromMap(doc.data() as Map<String, dynamic>));
      }
      return posts;
    });
  }

  Stream<List<Post>> getForumPosts(String forumId) {
    return _posts.where('forumId', isEqualTo: forumId).snapshots().map((event) {
      List<Post> posts = [];
      for (var doc in event.docs) {
        posts.add(Post.fromMap(doc.data() as Map<String, dynamic>));
      }
      posts.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return posts;
    });
  }

  Stream<List<Post>> getUserPosts(String forumId, String uid) {
    return _posts
        .where('forumId', isEqualTo: forumId)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Post> posts = [];
      for (var doc in event.docs) {
        posts.add(Post.fromMap(doc.data() as Map<String, dynamic>));
      }
      posts.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return posts;
    });
  }

  Stream<List<Post>> searchPosts(String forumId, String query) {
    return _posts
        .where('forumId', isEqualTo: true)
        .where(
          'messageLowercase',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Post> posts = [];
      for (var doc in event.docs) {
        posts.add(Post.fromMap(doc.data() as Map<String, dynamic>));
      }
      return posts;
    });
  }

  FutureVoid createPost(Post post) async {
    try {
      return right(_posts.doc(post.postId).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updatePost(Post post) async {
    try {
      return right(_posts.doc(post.postId).update(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deletePost(String postId) async {
    try {
      return right(_posts.doc(postId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
