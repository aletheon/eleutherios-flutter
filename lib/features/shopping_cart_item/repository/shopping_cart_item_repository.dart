import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/shopping_cart_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quiver/iterables.dart' as quiver;

//typedef for readability
typedef DocumentType = Map<String, dynamic>;
typedef SnapshotType = QueryDocumentSnapshot<DocumentType?>;

final shoppingCartItemRepositoryProvider = Provider((ref) {
  return ShoppingCartItemRepository(firestore: ref.watch(firestoreProvider));
});

class ShoppingCartItemRepository {
  final FirebaseFirestore _firestore;
  ShoppingCartItemRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _shoppingCartItems =>
      _firestore.collection(FirebaseConstants.shoppingCartItemsCollection);

  Future<void> deleteShoppingCartItemsByShoppingCartId(String shoppingCartId) {
    WriteBatch batch = _firestore.batch();
    return _shoppingCartItems
        .where('shoppingCartId', isEqualTo: shoppingCartId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  Stream<ShoppingCartItem?> getShoppingCartItemById(String shoppingCartItemId) {
    if (shoppingCartItemId.isNotEmpty) {
      final DocumentReference documentReference =
          _shoppingCartItems.doc(shoppingCartItemId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return ShoppingCartItem.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<ShoppingCartItem?> getShoppingCartItemByForumServiceId(
    String shoppingCartId,
    String forumId,
    String serviceId,
  ) {
    if (shoppingCartId.isNotEmpty &&
        forumId.isNotEmpty &&
        serviceId.isNotEmpty) {
      return _shoppingCartItems
          .where('shoppingCartId', isEqualTo: shoppingCartId)
          .where('forumId', isEqualTo: forumId)
          .where('serviceId', isEqualTo: serviceId)
          .snapshots()
          .map((event) {
        if (event.docs.isNotEmpty) {
          List<ShoppingCartItem> shoppingCartItems = [];
          for (var doc in event.docs) {
            shoppingCartItems.add(
                ShoppingCartItem.fromMap(doc.data() as Map<String, dynamic>));
          }
          return shoppingCartItems.first;
        } else {
          return null;
        }
      });
    } else if (shoppingCartId.isNotEmpty && serviceId.isNotEmpty) {
      return _shoppingCartItems
          .where('shoppingCartId', isEqualTo: shoppingCartId)
          // .where('forumId', isEqualTo: '')
          .where('serviceId', isEqualTo: serviceId)
          .snapshots()
          .map((event) {
        if (event.docs.isNotEmpty) {
          List<ShoppingCartItem> shoppingCartItems = [];
          for (var doc in event.docs) {
            shoppingCartItems.add(
                ShoppingCartItem.fromMap(doc.data() as Map<String, dynamic>));
          }
          return shoppingCartItems.first;
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<List<ShoppingCartItem>> getShoppingCartItemsByShoppingCartId(
      String shoppingCartId) {
    return _shoppingCartItems
        .where('shoppingCartId', isEqualTo: shoppingCartId)
        .orderBy('forumUid', descending: false)
        .orderBy('forumId', descending: false)
        .snapshots()
        .map((event) {
      List<ShoppingCartItem> shoppingCartItems = [];
      for (var doc in event.docs) {
        shoppingCartItems
            .add(ShoppingCartItem.fromMap(doc.data() as Map<String, dynamic>));
      }
      return shoppingCartItems;
    });
  }

  // https://github.com/firebase/flutterfire/discussions/7695

  Stream<List<ShoppingCartItem>> getShoppingCartItemsByItemIds(
    List<String> shoppingCartItemIds,
  ) {
    if (shoppingCartItemIds.isEmpty) return const Stream.empty();

    //1: generate chunked queries based on shoppingCartItemIds
    final splitQueries = quiver
        .partition(shoppingCartItemIds, 10)
        .map((e) => _shoppingCartItems.where('shoppingCartItemId', whereIn: e));

    //2: combine them with rxdart
    return Rx.combineLatest<QuerySnapshot<DocumentType>, List<SnapshotType>>(
      splitQueries.map((e) {
        Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
            e.snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
        return snapshots;
      }),
      (values) => quiver.merge(values.map((e) => e.docs)).toList(),
    ).map((docs) {
      List<ShoppingCartItem> shoppingCartItems = [];
      for (var doc in docs) {
        shoppingCartItems
            .add(ShoppingCartItem.fromMap(doc.data() as Map<String, dynamic>));
      }
      return shoppingCartItems;
    });
  }

  Stream<List<ShoppingCartItem>> getUserShoppingCartItemsByShoppingCartId(
      String shoppingCartId, String uid) {
    return _shoppingCartItems
        .where('shoppingCartId', isEqualTo: shoppingCartId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<ShoppingCartItem> shoppingCartItems = [];
      for (var doc in event.docs) {
        shoppingCartItems
            .add(ShoppingCartItem.fromMap(doc.data() as Map<String, dynamic>));
      }
      return shoppingCartItems;
    });
  }

  Stream<List<ShoppingCartItem>> getShoppingCartItemsByServiceId(
      String serviceId) {
    return _shoppingCartItems
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((event) {
      List<ShoppingCartItem> shoppingCartItems = [];
      for (var doc in event.docs) {
        shoppingCartItems
            .add(ShoppingCartItem.fromMap(doc.data() as Map<String, dynamic>));
      }
      return shoppingCartItems;
    });
  }

  Future<int?> getShoppingCartItemsByServiceIdCount(String serviceId) async {
    AggregateQuerySnapshot query = await _shoppingCartItems
        .where('serviceId', isEqualTo: serviceId)
        .count()
        .get();
    return query.count;
  }

  Future<int?> getShoppingCartItemCount(String shoppingCartId) async {
    AggregateQuerySnapshot query = await _shoppingCartItems
        .where('shoppingCartId', isEqualTo: shoppingCartId)
        .count()
        .get();
    return query.count;
  }

  Stream<int> getUserShoppingCartItemCount(String shoppingCartId, String uid) {
    return _shoppingCartItems
        .where('shoppingCartId', isEqualTo: shoppingCartId)
        .where('serviceUid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  FutureVoid createShoppingCartItem(ShoppingCartItem shoppingCartItem) async {
    try {
      return right(_shoppingCartItems
          .doc(shoppingCartItem.shoppingCartItemId)
          .set(shoppingCartItem.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateShoppingCartItem(ShoppingCartItem shoppingCartItem) async {
    try {
      return right(_shoppingCartItems
          .doc(shoppingCartItem.shoppingCartItemId)
          .update(shoppingCartItem.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteShoppingCartItem(String shoppingCartItemId) async {
    try {
      return right(_shoppingCartItems.doc(shoppingCartItemId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
