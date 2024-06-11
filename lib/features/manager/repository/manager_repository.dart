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

  Future<void> deleteAllManagers(String policyId) {
    WriteBatch batch = _firestore.batch();
    return _managers
        .where('policyId', isEqualTo: policyId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<Manager?> getManagerById(String managerId) {
    if (managerId.isNotEmpty) {
      final DocumentReference documentReference = _managers.doc(managerId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return Manager.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<Manager?> getManagerByServiceId(String policyId, String serviceId) {
    if (policyId.isNotEmpty && serviceId.isNotEmpty) {
      return _managers
          .where('policyId', isEqualTo: policyId)
          .where('serviceId', isEqualTo: serviceId)
          .snapshots()
          .map((event) {
        if (event.docs.isNotEmpty) {
          List<Manager> managers = [];
          for (var doc in event.docs) {
            managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
          }
          return managers.first;
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<Manager?> getUserSelectedManager(String policyId, String uid) {
    return _managers
        .where('policyId', isEqualTo: policyId)
        .where('serviceUid', isEqualTo: uid)
        .where('selected', isEqualTo: true)
        .snapshots()
        .map((event) {
      List<Manager> managers = [];

      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
        }
        return managers.first;
      } else {
        return null;
      }
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
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Manager> managers = [];
      for (var doc in event.docs) {
        managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
      }
      return managers;
    });
  }

  Stream<List<Manager>> getManagersByServiceId(String serviceId) {
    return _managers
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((event) {
      List<Manager> managers = [];
      for (var doc in event.docs) {
        managers.add(Manager.fromMap(doc.data() as Map<String, dynamic>));
      }
      return managers;
    });
  }

  Stream<int> getUserManagerCount(String policyId, String uid) {
    return _managers
        .where('policyId', isEqualTo: policyId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  Future<int> getManagersByServiceIdCount(String serviceId) async {
    AggregateQuerySnapshot query =
        await _managers.where('serviceId', isEqualTo: serviceId).count().get();
    return query.count;
  }

  Future<int> getManagerCount(String policyId) async {
    AggregateQuerySnapshot query =
        await _managers.where('policyId', isEqualTo: policyId).count().get();
    return query.count;
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
