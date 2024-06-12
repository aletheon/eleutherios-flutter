import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/rule.dart';

final ruleRepositoryProvider = Provider((ref) {
  return RuleRepository(firestore: ref.watch(firestoreProvider));
});

class RuleRepository {
  final FirebaseFirestore _firestore;
  RuleRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _rules =>
      _firestore.collection(FirebaseConstants.rulesCollection);

  Future<void> deleteRulesByPolicyId(String policyId) {
    WriteBatch batch = _firestore.batch();
    return _rules
        .where('policyId', isEqualTo: policyId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<Rule?> getRuleById(String ruleId) {
    if (ruleId.isNotEmpty) {
      final DocumentReference documentReference = _rules.doc(ruleId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return Rule.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<List<Rule>> getRules(String policyId) {
    return _rules
        .where('policyId', isEqualTo: policyId)
        .snapshots()
        .map((event) {
      List<Rule> rules = [];
      for (var doc in event.docs) {
        rules.add(Rule.fromMap(doc.data() as Map<String, dynamic>));
      }
      return rules;
    });
  }

  Stream<List<Rule>> getManagerRules(String policyId, String managerId) {
    return _rules
        .where('policyId', isEqualTo: policyId)
        .where('managerId', isEqualTo: managerId)
        .snapshots()
        .map((event) {
      List<Rule> rules = [];
      for (var doc in event.docs) {
        rules.add(Rule.fromMap(doc.data() as Map<String, dynamic>));
      }
      return rules;
    });
  }

  Stream<List<Rule>> searchRules(String query) {
    return _rules
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
      List<Rule> rules = [];
      for (var doc in event.docs) {
        rules.add(Rule.fromMap(doc.data() as Map<String, dynamic>));
      }
      return rules;
    });
  }

  FutureVoid createRule(Rule rule) async {
    try {
      return right(_rules.doc(rule.ruleId).set(rule.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateRule(Rule rule) async {
    try {
      return right(_rules.doc(rule.ruleId).update(rule.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteRule(String ruleId) async {
    try {
      return right(_rules.doc(ruleId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
