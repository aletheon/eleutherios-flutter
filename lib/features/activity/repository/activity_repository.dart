import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/activity.dart';

final activityRepositoryProvider = Provider((ref) {
  return ActivityRepository(firestore: ref.watch(firestoreProvider));
});

class ActivityRepository {
  final FirebaseFirestore _firestore;
  ActivityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _activities =>
      _firestore.collection(FirebaseConstants.activitiesCollection);

  Stream<Activity> getActivityById(String activityId) {
    final DocumentReference documentReference = _activities.doc(activityId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return Activity.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<Activity?> getUserActivityByPolicyForumId(
      String policyForumId, String uid) {
    return _activities
        .where('policyForumId', isEqualTo: policyForumId)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Activity> activities = [];

      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          activities.add(Activity.fromMap(doc.data() as Map<String, dynamic>));
        }
        return activities.first;
      } else {
        return null;
      }
    });
  }

  Stream<List<Activity>> getActivities(String uid) {
    return _activities.where('uid', isEqualTo: uid).snapshots().map((event) {
      List<Activity> activities = [];
      for (var doc in event.docs) {
        activities.add(Activity.fromMap(doc.data() as Map<String, dynamic>));
      }
      activities.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return activities;
    });
  }

  Stream<List<Activity>> getForumActivities(String uid) {
    return _activities
        .where('uid', isEqualTo: uid)
        .where(
          'activityType',
          isEqualTo: ActivityType.forum,
        )
        .snapshots()
        .map((event) {
      List<Activity> activities = [];
      for (var doc in event.docs) {
        activities.add(Activity.fromMap(doc.data() as Map<String, dynamic>));
      }
      activities.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return activities;
    });
  }

  Stream<List<Activity>> getPolicyActivities(String uid) {
    return _activities
        .where('uid', isEqualTo: uid)
        .where(
          'activityType',
          isEqualTo: ActivityType.policy,
        )
        .snapshots()
        .map((event) {
      List<Activity> activities = [];
      for (var doc in event.docs) {
        activities.add(Activity.fromMap(doc.data() as Map<String, dynamic>));
      }
      activities.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return activities;
    });
  }

  FutureVoid createActivity(Activity activity) async {
    try {
      return right(_activities.doc(activity.activityId).set(activity.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteActivity(String activityId) async {
    try {
      return right(_activities.doc(activityId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
