import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/policy.dart';

final policyRepositoryProvider = Provider((ref) {
  return PolicyRepository(firestore: ref.watch(firestoreProvider));
});

class PolicyRepository {
  final FirebaseFirestore _firestore;
  PolicyRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _policies =>
      _firestore.collection(FirebaseConstants.policiesCollection);

  Stream<Policy?> getPolicyById(String policyId) {
    if (policyId.isNotEmpty) {
      final DocumentReference documentReference = _policies.doc(policyId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return Policy.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<List<Policy>> getPolicies() {
    return _policies.where('public', isEqualTo: true).snapshots().map((event) {
      List<Policy> policies = [];
      for (var doc in event.docs) {
        policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
      }
      return policies;
    });
  }

  Stream<List<Policy>> getUserPolicies(String uid) {
    return _policies.where('uid', isEqualTo: uid).snapshots().map((event) {
      List<Policy> policies = [];
      for (var doc in event.docs) {
        policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
      }
      policies.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return policies;
    });
  }

  Stream<List<Policy>> searchPrivatePolicies(String uid, String query) {
    if (query.isNotEmpty) {
      return _policies
          .where('uid', isEqualTo: uid)
          .where(
            'titleLowercase',
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
        List<Policy> policies = [];
        for (var doc in event.docs) {
          policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policies;
      });
    } else {
      return _policies.where('uid', isEqualTo: uid).snapshots().map((event) {
        List<Policy> policies = [];
        for (var doc in event.docs) {
          policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policies;
      });
    }
  }

  Stream<List<Policy>> searchPublicPolicies(String query, List<String> tags) {
    if (query.isNotEmpty && tags.isNotEmpty) {
      return _policies
          .where('public', isEqualTo: true)
          .where(
            'titleLowercase',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(
                      query.codeUnitAt(query.length - 1) + 1,
                    ),
          )
          .where('tags', arrayContainsAny: tags)
          .snapshots()
          .map((event) {
        List<Policy> policies = [];
        for (var doc in event.docs) {
          policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policies;
      });
    } else if (query.isNotEmpty) {
      return _policies
          .where('public', isEqualTo: true)
          .where(
            'titleLowercase',
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
        List<Policy> policies = [];
        for (var doc in event.docs) {
          policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policies;
      });
    } else if (tags.isNotEmpty) {
      return _policies
          .where('public', isEqualTo: true)
          .where('tags', arrayContainsAny: tags)
          .snapshots()
          .map((event) {
        List<Policy> policies = [];
        for (var doc in event.docs) {
          policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policies;
      });
    } else {
      return _policies
          .where('public', isEqualTo: true)
          .snapshots()
          .map((event) {
        List<Policy> policies = [];
        for (var doc in event.docs) {
          policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
        }
        return policies;
      });
    }
  }

  Stream<List<Policy>> getServiceManagerPolicies(String serviceId) {
    return _policies
        .where('services', arrayContains: serviceId)
        .snapshots()
        .map((event) {
      List<Policy> policies = [];
      for (var doc in event.docs) {
        policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
      }
      policies.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return policies;
    });
  }

  Stream<List<Policy>> getServiceConsumerPolicies(String serviceId) {
    return _policies
        .where('consumers', arrayContains: serviceId)
        .snapshots()
        .map((event) {
      List<Policy> policies = [];
      for (var doc in event.docs) {
        policies.add(Policy.fromMap(doc.data() as Map<String, dynamic>));
      }
      policies.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return policies;
    });
  }

  FutureVoid createPolicy(Policy policy) async {
    try {
      return right(_policies.doc(policy.policyId).set(policy.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updatePolicy(Policy policy) async {
    try {
      return right(_policies.doc(policy.policyId).update(policy.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deletePolicy(String policyId) async {
    try {
      return right(_policies.doc(policyId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
