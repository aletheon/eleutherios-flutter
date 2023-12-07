import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/favorite.dart';

final favoriteRepositoryProvider = Provider((ref) {
  return FavoriteRepository(firestore: ref.watch(firestoreProvider));
});

class FavoriteRepository {
  final FirebaseFirestore _firestore;
  FavoriteRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _favorites =>
      _firestore.collection(FirebaseConstants.favoritesCollection);

  Stream<Favorite> getFavoriteById(String favoriteId) {
    final DocumentReference documentReference = _favorites.doc(favoriteId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      return Favorite.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Stream<List<Favorite>> getFavorites(String uid) {
    return _favorites.where('uid', isEqualTo: uid).snapshots().map((event) {
      List<Favorite> favorites = [];
      for (var doc in event.docs) {
        favorites.add(Favorite.fromMap(doc.data() as Map<String, dynamic>));
      }
      favorites.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return favorites;
    });
  }

  FutureVoid createFavorite(Favorite favorite) async {
    try {
      return right(_favorites
          .doc(favorite.favoriteId)
          .set(favorite.toMap())
          .then((value) {
        // added this delay for some reason the record wasn't being created in firestore
        Future.delayed(const Duration(seconds: 0), () {
          return;
        });
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateFavorite(Favorite favorite) async {
    try {
      return right(
          _favorites.doc(favorite.favoriteId).update(favorite.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteFavorite(String uid, String serviceId) async {
    try {
      return right(_favorites
          .where('uid', isEqualTo: uid)
          .where('serviceId', isEqualTo: serviceId)
          .snapshots()
          .map((event) {
            List<Favorite> favorites = [];
            for (var doc in event.docs) {
              favorites
                  .add(Favorite.fromMap(doc.data() as Map<String, dynamic>));
            }
            return favorites;
          })
          .first
          .then((element) {
            if (element.isNotEmpty) {
              _favorites.doc(element[0].favoriteId).delete();
            }
          }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
