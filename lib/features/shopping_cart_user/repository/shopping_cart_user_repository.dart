import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/shopping_cart_user.dart';

final shoppingCartUserRepositoryProvider = Provider((ref) {
  return ShoppingCartUserRepository(firestore: ref.watch(firestoreProvider));
});

class ShoppingCartUserRepository {
  final FirebaseFirestore _firestore;
  ShoppingCartUserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _shoppingCartUsers =>
      _firestore.collection(FirebaseConstants.shoppingCartUsersCollection);

  Stream<ShoppingCartUser> getShoppingCartUserById(String shoppingCartUserId) {
    final DocumentReference documentReference =
        _shoppingCartUsers.doc(shoppingCartUserId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return ShoppingCartUser.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<List<ShoppingCartUser>> getShoppingCartUsers() {
    return _shoppingCartUsers.snapshots().map((event) {
      List<ShoppingCartUser> shoppingCartUsers = [];
      for (var doc in event.docs) {
        shoppingCartUsers
            .add(ShoppingCartUser.fromMap(doc.data() as Map<String, dynamic>));
      }
      shoppingCartUsers
          .sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return shoppingCartUsers;
    });
  }

  FutureVoid createShoppingCartUser(ShoppingCartUser shoppingCartUser) async {
    try {
      return right(_shoppingCartUsers
          .doc(shoppingCartUser.shoppingCartUserId)
          .set(shoppingCartUser.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteShoppingCartUser(String shoppingCartUserId) async {
    try {
      return right(_shoppingCartUsers.doc(shoppingCartUserId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
