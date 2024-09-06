import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/shopping_cart_member.dart';

final shoppingCartMemberRepositoryProvider = Provider((ref) {
  return ShoppingCartMemberRepository(firestore: ref.watch(firestoreProvider));
});

class ShoppingCartMemberRepository {
  final FirebaseFirestore _firestore;
  ShoppingCartMemberRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _shoppingCartMembers =>
      _firestore.collection(FirebaseConstants.shoppingCartMembersCollection);

  Future<void> deleteShoppingCartMembersByShoppingCartForumId(
      String shoppingCartForumId) {
    WriteBatch batch = _firestore.batch();
    return _shoppingCartMembers
        .where('shoppingCartForumId', isEqualTo: shoppingCartForumId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<ShoppingCartMember?> getShoppingCartMemberById(
      String shoppingCartMemberId) {
    final DocumentReference documentReference =
        _shoppingCartMembers.doc(shoppingCartMemberId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      if (event.exists) {
        return ShoppingCartMember.fromMap(event.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<ShoppingCartMember?> getShoppingCartMemberByMemberId(String memberId) {
    return _shoppingCartMembers
        .where('memberId', isEqualTo: memberId)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        List<ShoppingCartMember> shoppingCartMembers = [];
        for (var doc in event.docs) {
          shoppingCartMembers.add(
              ShoppingCartMember.fromMap(doc.data() as Map<String, dynamic>));
        }
        return shoppingCartMembers.first;
      } else {
        return null;
      }
    });
  }

  Stream<List<ShoppingCartMember>> getShoppingCartMembers(
    String forumId,
    String uid,
  ) {
    return _shoppingCartMembers
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<ShoppingCartMember> shoppingCartMembers = [];
      for (var doc in event.docs) {
        shoppingCartMembers.add(
            ShoppingCartMember.fromMap(doc.data() as Map<String, dynamic>));
      }
      shoppingCartMembers
          .sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return shoppingCartMembers;
    });
  }

  Stream<int> getShoppingCartMemberCount(String forumId, String uid) {
    return _shoppingCartMembers
        .where('forumId', isEqualTo: forumId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  FutureVoid createShoppingCartMember(
      ShoppingCartMember shoppingCartMember) async {
    try {
      return right(_shoppingCartMembers
          .doc(shoppingCartMember.shoppingCartMemberId)
          .set(shoppingCartMember.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateShoppingCartMember(
      ShoppingCartMember shoppingCartMember) async {
    try {
      return right(_shoppingCartMembers
          .doc(shoppingCartMember.shoppingCartMemberId)
          .update(shoppingCartMember.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteShoppingCartMember(String shoppingCartMemberId) async {
    try {
      return right(_shoppingCartMembers.doc(shoppingCartMemberId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
