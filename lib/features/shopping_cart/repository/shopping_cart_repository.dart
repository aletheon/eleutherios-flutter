import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/shopping_cart.dart';

final shoppingCartRepositoryProvider = Provider((ref) {
  return ShoppingCartRepository(firestore: ref.watch(firestoreProvider));
});

class ShoppingCartRepository {
  final FirebaseFirestore _firestore;
  ShoppingCartRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _shoppingCarts =>
      _firestore.collection(FirebaseConstants.shoppingCartsCollection);

  Stream<ShoppingCart?> getShoppingCartById(String shoppingCartId) {
    if (shoppingCartId.isNotEmpty) {
      final DocumentReference documentReference =
          _shoppingCarts.doc(shoppingCartId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return ShoppingCart.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<ShoppingCart?> getShoppingCartByUid(String uid) {
    if (uid.isNotEmpty) {
      return _shoppingCarts
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((event) {
        if (event.docs.isNotEmpty) {
          List<ShoppingCart> shoppingCarts = [];
          for (var doc in event.docs) {
            shoppingCarts
                .add(ShoppingCart.fromMap(doc.data() as Map<String, dynamic>));
          }
          return shoppingCarts.first;
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  FutureVoid createShoppingCart(ShoppingCart shoppingCart) async {
    try {
      return right(_shoppingCarts
          .doc(shoppingCart.shoppingCartId)
          .set(shoppingCart.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateShoppingCart(ShoppingCart shoppingCart) async {
    try {
      return right(_shoppingCarts
          .doc(shoppingCart.shoppingCartId)
          .update(shoppingCart.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteShoppingCart(String shoppingCartId) async {
    try {
      return right(_shoppingCarts.doc(shoppingCartId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
