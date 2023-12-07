import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/manager.dart';

final managerRepositoryProvider = Provider((ref) {
  return ManagerRepository(firestore: ref.watch(firestoreProvider));
});

class ManagerRepository {
  final FirebaseFirestore _firestore;
  ManagerRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _managers =>
      _firestore.collection(FirebaseConstants.managersCollection);

  Stream<Manager> getManagerById(String managerId) {
    final DocumentReference documentReference = _managers.doc(managerId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return Manager.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<Manager> getUserSelectedManager(String policyId, String uid) {
    return _managers
        .where('policyId', isEqualTo: policyId)
        .where('serviceUid', isEqualTo: uid)
        .where('selected', isEqualTo: true)
        .snapshots()
        .map((event) {
      List<Manager> managers = [];
      for (var doc in event.docs) {
        managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
      }
      return managers.first;
    });
  }

  Stream<List<Manager>> getManagers(String policyId) {
    return _managers
        .where('policyId', isEqualTo: policyId)
        .snapshots()
        .map((event) {
      List<Manager> managers = [];
      for (var doc in event.docs) {
        managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
      }
      return managers;
    });
  }

  Stream<List<Manager>> getUserManagers(String policyId, String uid) {
    return _managers
        .where('policyId', isEqualTo: policyId)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Manager> managers = [];
      for (var doc in event.docs) {
        managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
      }
      return managers;
    });
  }

  FutureVoid createManager(Manager manager) async {
    try {
      return right(_managers.doc(manager.managerId).set(manager.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateManager(Manager manager) async {
    try {
      return right(_managers.doc(manager.managerId).update(manager.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteManager(String managerId) async {
    try {
      return right(_managers.doc(managerId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
