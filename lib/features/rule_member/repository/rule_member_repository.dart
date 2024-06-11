import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/rule_member.dart';

final ruleMemberRepositoryProvider = Provider((ref) {
  return RuleMemberRepository(firestore: ref.watch(firestoreProvider));
});

class RuleMemberRepository {
  final FirebaseFirestore _firestore;
  RuleMemberRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _ruleMembers =>
      _firestore.collection(FirebaseConstants.ruleMembersCollection);

  Future<void> deleteAllRuleMembers(String ruleId) {
    WriteBatch batch = _firestore.batch();
    return _ruleMembers
        .where('ruleId', isEqualTo: ruleId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<RuleMember?> getRuleMemberById(String ruleMemberId) {
    if (ruleMemberId.isNotEmpty) {
      final DocumentReference documentReference =
          _ruleMembers.doc(ruleMemberId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return RuleMember.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<bool> serviceIsRegisteredInRule(String ruleId, String serviceId) {
    return _ruleMembers
        .where('ruleId', isEqualTo: ruleId)
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        return true;
      }
      return false;
    });
  }

  Stream<List<RuleMember>> getRuleMembers(String ruleId) {
    return _ruleMembers
        .where('ruleId', isEqualTo: ruleId)
        .snapshots()
        .map((event) {
      List<RuleMember> ruleMembers = [];
      for (var doc in event.docs) {
        ruleMembers.add(RuleMember.fromMap(doc.data() as Map<String, dynamic>));
      }
      return ruleMembers;
    });
  }

  Stream<List<RuleMember>> getUserRuleMembers(String ruleId, String uid) {
    return _ruleMembers
        .where('ruleId', isEqualTo: ruleId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<RuleMember> ruleMembers = [];
      for (var doc in event.docs) {
        ruleMembers.add(RuleMember.fromMap(doc.data() as Map<String, dynamic>));
      }
      ruleMembers.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return ruleMembers;
    });
  }

  Stream<List<RuleMember>> getRuleMembersByServiceId(String serviceId) {
    return _ruleMembers
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((event) {
      List<RuleMember> ruleMembers = [];
      for (var doc in event.docs) {
        ruleMembers.add(RuleMember.fromMap(doc.data() as Map<String, dynamic>));
      }
      return ruleMembers;
    });
  }

  Stream<int> getUserRuleMemberCount(String ruleId, String uid) {
    return _ruleMembers
        .where('ruleId', isEqualTo: ruleId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  Stream<RuleMember?> getUserSelectedRuleMember(String ruleId, String uid) {
    return _ruleMembers
        .where('ruleId', isEqualTo: ruleId)
        .where('serviceUid', isEqualTo: uid)
        .where('selected', isEqualTo: true)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        List<RuleMember> ruleMembers = [];
        for (var doc in event.docs) {
          ruleMembers
              .add(RuleMember.fromMap(doc.data() as Map<String, dynamic>));
        }
        return ruleMembers.first;
      } else {
        return null;
      }
    });
  }

  Future<int> getRuleMembersByServiceIdCount(String serviceId) async {
    AggregateQuerySnapshot query = await _ruleMembers
        .where('serviceId', isEqualTo: serviceId)
        .count()
        .get();
    return query.count;
  }

  Future<int> getRuleMemberCount(String ruleId) async {
    AggregateQuerySnapshot query =
        await _ruleMembers.where('ruleId', isEqualTo: ruleId).count().get();
    return query.count;
  }

  FutureVoid createRuleMember(RuleMember ruleMember) async {
    try {
      return right(
          _ruleMembers.doc(ruleMember.ruleMemberId).set(ruleMember.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateRuleMember(RuleMember ruleMember) async {
    try {
      return right(
          _ruleMembers.doc(ruleMember.ruleMemberId).update(ruleMember.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteRuleMember(String ruleMemberId) async {
    try {
      return right(_ruleMembers.doc(ruleMemberId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
