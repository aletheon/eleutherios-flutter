import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/forum_activity.dart';

final forumActivityRepositoryProvider = Provider((ref) {
  return ForumActivityRepository(firestore: ref.watch(firestoreProvider));
});

class ForumActivityRepository {
  final FirebaseFirestore _firestore;
  ForumActivityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _forumActivities =>
      _firestore.collection(FirebaseConstants.forumActivitiesCollection);

  Stream<ForumActivity> getForumActivityById(String forumActivityId) {
    final DocumentReference documentReference =
        _forumActivities.doc(forumActivityId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return ForumActivity.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<ForumActivity?> getUserActivityByForumId(String forumId, String uid) {
    return _forumActivities
        .where('forumId', isEqualTo: forumId)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<ForumActivity> forumActivities = [];

      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          forumActivities
              .add(ForumActivity.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forumActivities.first;
      } else {
        return null;
      }
    });
  }

  Stream<List<ForumActivity>> getForumActivities(String uid) {
    return _forumActivities
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<ForumActivity> forumActivities = [];
      for (var doc in event.docs) {
        forumActivities
            .add(ForumActivity.fromMap(doc.data() as Map<String, dynamic>));
      }
      forumActivities.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return forumActivities;
    });
  }

  FutureVoid createForumActivity(ForumActivity forumActivity) async {
    try {
      return right(_forumActivities
          .doc(forumActivity.forumActivityId)
          .set(forumActivity.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteForumActivity(String forumActivityId) async {
    try {
      return right(_forumActivities.doc(forumActivityId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
