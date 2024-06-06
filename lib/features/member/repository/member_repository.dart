import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/member.dart';

final memberRepositoryProvider = Provider((ref) {
  return MemberRepository(firestore: ref.watch(firestoreProvider));
});

class MemberRepository {
  final FirebaseFirestore _firestore;
  MemberRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _members =>
      _firestore.collection(FirebaseConstants.membersCollection);

  Future<void> deleteAllMembers(String forumId) {
    WriteBatch batch = _firestore.batch();
    return _members
        .where('forumId', isEqualTo: forumId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<Member?> getMemberById(String memberId) {
    if (memberId.isNotEmpty) {
      final DocumentReference documentReference = _members.doc(memberId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return Member.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<Member?> getMemberByServiceId(String forumId, String serviceId) {
    if (forumId.isNotEmpty && serviceId.isNotEmpty) {
      return _members
          .where('forumId', isEqualTo: forumId)
          .where('serviceId', isEqualTo: serviceId)
          .snapshots()
          .map((event) {
        if (event.docs.isNotEmpty) {
          List<Member> members = [];
          for (var doc in event.docs) {
            members.add(Member.fromMap(doc.data() as Map<String, dynamic>));
          }
          return members.first;
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<bool> serviceIsRegisteredInForum(String forumId, String serviceId) {
    return _members
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

  Stream<List<Member>> getMembers(String forumId) {
    return _members
        .where('forumId', isEqualTo: forumId)
        .snapshots()
        .map((event) {
      List<Member> members = [];
      for (var doc in event.docs) {
        members.add(Member.fromMap(doc.data() as Map<String, dynamic>));
      }
      return members;
    });
  }

  Stream<List<Member>> getUserMembers(String forumId, String uid) {
    return _members
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Member> members = [];
      for (var doc in event.docs) {
        members.add(Member.fromMap(doc.data() as Map<String, dynamic>));
      }
      members.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return members;
    });
  }

  Stream<List<Member>> getMembersByServiceId(String serviceId) {
    return _members
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((event) {
      List<Member> members = [];
      for (var doc in event.docs) {
        members.add(Member.fromMap(doc.data() as Map<String, dynamic>));
      }
      return members;
    });
  }

  Stream<int> getUserMemberCount(String forumId, String uid) {
    return _members
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  Stream<Member?> getUserSelectedMember(String forumId, String uid) {
    return _members
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .where('selected', isEqualTo: true)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        List<Member> members = [];
        for (var doc in event.docs) {
          members.add(Member.fromMap(doc.data() as Map<String, dynamic>));
        }
        return members.first;
      } else {
        return null;
      }
    });
  }

  Future<int> getMembersByServiceIdCount(String serviceId) async {
    AggregateQuerySnapshot query =
        await _members.where('serviceId', isEqualTo: serviceId).count().get();
    return query.count;
  }

  FutureVoid createMember(Member member) async {
    try {
      return right(_members.doc(member.memberId).set(member.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateMember(Member member) async {
    try {
      return right(_members.doc(member.memberId).update(member.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteMember(String memberId) async {
    try {
      return right(_members.doc(memberId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
