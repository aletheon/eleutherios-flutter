import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/shopping_cart_forum.dart';

final shoppingCartForumRepositoryProvider = Provider((ref) {
  return ShoppingCartForumRepository(firestore: ref.watch(firestoreProvider));
});

class ShoppingCartForumRepository {
  final FirebaseFirestore _firestore;
  ShoppingCartForumRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _shoppingCartForums =>
      _firestore.collection(FirebaseConstants.shoppingCartForumsCollection);

  Future<void> deleteShoppingCartForumsByShoppingCartUserId(
      String shoppingCartUserId) {
    WriteBatch batch = _firestore.batch();
    return _shoppingCartForums
        .where('shoppingCartUserId', isEqualTo: shoppingCartUserId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<ShoppingCartForum?> getShoppingCartForumById(
      String shoppingCartForumId) {
    final DocumentReference documentReference =
        _shoppingCartForums.doc(shoppingCartForumId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      if (event.exists) {
        return ShoppingCartForum.fromMap(event.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<List<ShoppingCartForum>> getShoppingCartForumsByUserId(String userId) {
    return _shoppingCartForums
        .where('cartUid', isEqualTo: userId)
        .snapshots()
        .map((event) {
      List<ShoppingCartForum> shoppingCartForums = [];
      for (var doc in event.docs) {
        shoppingCartForums
            .add(ShoppingCartForum.fromMap(doc.data() as Map<String, dynamic>));
      }
      shoppingCartForums
          .sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return shoppingCartForums;
    });
  }

  Stream<ShoppingCartForum?> getShoppingCartForumByUserId(
      String uid, String forumId) {
    return _shoppingCartForums
        .where('uid', isEqualTo: uid)
        .where('forumId', isEqualTo: forumId)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        List<ShoppingCartForum> shoppingCartForums = [];
        for (var doc in event.docs) {
          shoppingCartForums.add(
              ShoppingCartForum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return shoppingCartForums.first;
      } else {
        return null;
      }
    });
  }

  Stream<ShoppingCartForum?> getShoppingCartForumByForumMemberId(
      String forumId, String memberId) {
    return _shoppingCartForums
        .where('forumId', isEqualTo: forumId)
        .where('members', arrayContains: memberId)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        List<ShoppingCartForum> shoppingCartForums = [];
        for (var doc in event.docs) {
          shoppingCartForums.add(
              ShoppingCartForum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return shoppingCartForums.first;
      } else {
        return null;
      }
    });
  }

  FutureVoid createShoppingCartForum(
      ShoppingCartForum shoppingCartForum) async {
    try {
      return right(_shoppingCartForums
          .doc(shoppingCartForum.shoppingCartForumId)
          .set(shoppingCartForum.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateShoppingCartForum(
      ShoppingCartForum shoppingCartForum) async {
    try {
      return right(_shoppingCartForums
          .doc(shoppingCartForum.shoppingCartForumId)
          .update(shoppingCartForum.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteShoppingCartForum(String shoppingCartForumId) async {
    try {
      return right(_shoppingCartForums.doc(shoppingCartForumId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
