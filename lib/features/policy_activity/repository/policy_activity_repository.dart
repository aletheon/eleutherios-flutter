import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/policy_activity.dart';

final policyActivityRepositoryProvider = Provider((ref) {
  return PolicyActivityRepository(firestore: ref.watch(firestoreProvider));
});

class PolicyActivityRepository {
  final FirebaseFirestore _firestore;
  PolicyActivityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _policyActivities =>
      _firestore.collection(FirebaseConstants.policyActivitiesCollection);

  Stream<PolicyActivity> getPolicyActivityById(String policyActivityId) {
    final DocumentReference documentReference =
        _policyActivities.doc(policyActivityId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return PolicyActivity.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<PolicyActivity?> getPolicyActivityByUserId(
      String policyId, String uid) {
    return _policyActivities
        .where('policyId', isEqualTo: policyId)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<PolicyActivity> policyActivities = [];

      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          policyActivities
              .add(PolicyActivity.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policyActivities.first;
      } else {
        return null;
      }
    });
  }

  Stream<List<PolicyActivity>> getPolicyActivities(String uid) {
    return _policyActivities
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<PolicyActivity> policyActivities = [];
      for (var doc in event.docs) {
        policyActivities
            .add(PolicyActivity.fromMap(doc.data() as Map<String, dynamic>));
      }
      policyActivities.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return policyActivities;
    });
  }

  FutureVoid createPolicyActivity(PolicyActivity policyActivity) async {
    try {
      return right(_policyActivities
          .doc(policyActivity.policyActivityId)
          .set(policyActivity.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deletePolicyActivity(String policyActivityId) async {
    try {
      return right(_policyActivities.doc(policyActivityId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
