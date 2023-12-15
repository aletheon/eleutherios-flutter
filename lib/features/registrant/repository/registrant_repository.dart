import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/registrant.dart';

final registrantRepositoryProvider = Provider((ref) {
  return RegistrantRepository(firestore: ref.watch(firestoreProvider));
});

class RegistrantRepository {
  final FirebaseFirestore _firestore;
  RegistrantRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _registrants =>
      _firestore.collection(FirebaseConstants.registrantsCollection);

  Stream<Registrant> getRegistrantById(String registrantId) {
    final DocumentReference documentReference = _registrants.doc(registrantId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return Registrant.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<bool> serviceIsRegisteredInForum(String forumId, String serviceId) {
    return _registrants
        .where('forumId', isEqualTo: forumId)
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        return true;
      }
      return false;
    });
  }

  Stream<List<Registrant>> getRegistrants(String forumId) {
    return _registrants
        .where('forumId', isEqualTo: forumId)
        .snapshots()
        .map((event) {
      List<Registrant> registrants = [];
      for (var doc in event.docs) {
        registrants.add(Registrant.fromMap(doc.data() as Map<String, dynamic>));
      }
      return registrants;
    });
  }

  Stream<List<Registrant>> getUserRegistrants(String forumId, String uid) {
    return _registrants
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Registrant> registrants = [];
      for (var doc in event.docs) {
        registrants.add(Registrant.fromMap(doc.data() as Map<String, dynamic>));
      }
      registrants.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return registrants;
    });
  }

  Stream<int> getUserRegistrantCount(String forumId, String uid) {
    return _registrants
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  Stream<Registrant> getUserSelectedRegistrant(String forumId, String uid) {
    return _registrants
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .where('selected', isEqualTo: true)
        .snapshots()
        .map((event) {
      List<Registrant> registrants = [];
      for (var doc in event.docs) {
        registrants.add(Registrant.fromMap(doc.data() as Map<String, dynamic>));
      }
      return registrants.first;
    });
  }

  FutureVoid createRegistrant(Registrant registrant) async {
    try {
      return right(
          _registrants.doc(registrant.registrantId).set(registrant.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateRegistrant(Registrant registrant) async {
    try {
      return right(
          _registrants.doc(registrant.registrantId).update(registrant.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteRegistrant(String registrantId) async {
    try {
      return right(_registrants.doc(registrantId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
