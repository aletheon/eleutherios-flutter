import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/models/search.dart';

final forumRepositoryProvider = Provider((ref) {
  return ForumRepository(firestore: ref.watch(firestoreProvider));
});

class ForumRepository {
  final FirebaseFirestore _firestore;
  ForumRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _forums =>
      _firestore.collection(FirebaseConstants.forumsCollection);

  Stream<Forum?> getForumById(String forumId) {
    if (forumId.isNotEmpty) {
      final DocumentReference documentReference = _forums.doc(forumId);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return Forum.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<List<Forum>> getForums() {
    return _forums.where('public', isEqualTo: true).snapshots().map((event) {
      List<Forum> forums = [];
      for (var doc in event.docs) {
        forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
      }
      return forums;
    });
  }

  Stream<List<Forum>> getForumChildren(String parentId) {
    return _forums
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((event) {
      List<Forum> forums = [];
      for (var doc in event.docs) {
        forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
      }
      forums.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return forums;
    });
  }

  Stream<List<Forum>> getUserForums(String uid) {
    return _forums.where('uid', isEqualTo: uid).snapshots().map((event) {
      List<Forum> forums = [];
      for (var doc in event.docs) {
        forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
      }
      forums.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return forums;
    });
  }

  Stream<List<Forum>> getServiceForums(String serviceId) {
    return _forums
        .where('services', arrayContains: serviceId)
        .snapshots()
        .map((event) {
      List<Forum> forums = [];
      for (var doc in event.docs) {
        forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
      }
      forums.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return forums;
    });
  }

  Stream<List<Forum>> searchPrivateForums(Search search) {
    if (search.query.isNotEmpty) {
      return _forums
          .where('uid', isEqualTo: search.uid)
          .where(
            'titleLowercase',
            isGreaterThanOrEqualTo: search.query.isEmpty ? 0 : search.query,
            isLessThan: search.query.isEmpty
                ? null
                : search.query.substring(0, search.query.length - 1) +
                    String.fromCharCode(
                      search.query.codeUnitAt(search.query.length - 1) + 1,
                    ),
          )
          .snapshots()
          .map((event) {
        List<Forum> forums = [];
        for (var doc in event.docs) {
          forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forums;
      });
    } else {
      return _forums
          .where('uid', isEqualTo: search.uid)
          .snapshots()
          .map((event) {
        List<Forum> forums = [];
        for (var doc in event.docs) {
          forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forums;
      });
    }
  }

  Stream<List<Forum>> searchPublicForums(Search search) {
    if (search.query.isNotEmpty && search.tags.isNotEmpty) {
      return _forums
          .where('public', isEqualTo: true)
          .where(
            'titleLowercase',
            isGreaterThanOrEqualTo: search.query.isEmpty ? 0 : search.query,
            isLessThan: search.query.isEmpty
                ? null
                : search.query.substring(0, search.query.length - 1) +
                    String.fromCharCode(
                      search.query.codeUnitAt(search.query.length - 1) + 1,
                    ),
          )
          .where('tags', arrayContainsAny: search.tags)
          .snapshots()
          .map((event) {
        List<Forum> forums = [];
        for (var doc in event.docs) {
          forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forums;
      });
    } else if (search.query.isNotEmpty) {
      return _forums
          .where('public', isEqualTo: true)
          .where(
            'titleLowercase',
            isGreaterThanOrEqualTo: search.query.isEmpty ? 0 : search.query,
            isLessThan: search.query.isEmpty
                ? null
                : search.query.substring(0, search.query.length - 1) +
                    String.fromCharCode(
                      search.query.codeUnitAt(search.query.length - 1) + 1,
                    ),
          )
          .snapshots()
          .map((event) {
        List<Forum> forums = [];
        for (var doc in event.docs) {
          forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forums;
      });
    } else if (search.tags.isNotEmpty) {
      return _forums
          .where('public', isEqualTo: true)
          .where('tags', arrayContainsAny: search.tags)
          .snapshots()
          .map((event) {
        List<Forum> forums = [];
        for (var doc in event.docs) {
          forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forums;
      });
    } else {
      return _forums.where('public', isEqualTo: true).snapshots().map((event) {
        List<Forum> forums = [];
        for (var doc in event.docs) {
          forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
        }
        return forums;
      });
    }
  }

  FutureVoid createForum(Forum forum) async {
    try {
      return right(_forums.doc(forum.forumId).set(forum.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateForum(Forum forum) async {
    try {
      return right(_forums.doc(forum.forumId).update(forum.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteForum(String forumId) async {
    try {
      return right(_forums.doc(forumId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
