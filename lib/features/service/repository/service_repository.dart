import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/service.dart';

final serviceRepositoryProvider = Provider((ref) {
  return ServiceRepository(firestore: ref.watch(firestoreProvider));
});

class ServiceRepository {
  final FirebaseFirestore _firestore;
  ServiceRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _services =>
      _firestore.collection(FirebaseConstants.servicesCollection);

  Stream<Service?> getServiceById(String serviceId) {
    final DocumentReference documentReference = _services.doc(serviceId);

    Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

    return documentStream.map((event) {
      if (event.exists) {
        return Service.fromMap(event.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<List<Service>> getServices() {
    return _services.where('public', isEqualTo: true).snapshots().map((event) {
      List<Service> services = [];
      for (var doc in event.docs) {
        services.add(Service.fromMap(doc.data() as Map<String, dynamic>));
      }
      return services;
    });
  }

  Stream<List<Service>> getUserServices(String uid) {
    return _services.where('uid', isEqualTo: uid).snapshots().map((event) {
      List<Service> services = [];
      for (var doc in event.docs) {
        services.add(Service.fromMap(doc.data() as Map<String, dynamic>));
      }
      services.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return services;
    });
  }

  Stream<List<Service>> searchServices(String query) {
    if (query.isNotEmpty) {
      return _services
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
        List<Service> services = [];
        for (var doc in event.docs) {
          services.add(Service.fromMap(doc.data() as Map<String, dynamic>));
        }
        return services;
      });
    } else {
      return _services
          .where('public', isEqualTo: true)
          .snapshots()
          .map((event) {
        List<Service> services = [];
        for (var doc in event.docs) {
          services.add(Service.fromMap(doc.data() as Map<String, dynamic>));
        }
        return services;
      });
    }
  }

  FutureVoid createService(Service service) async {
    try {
      return right(_services.doc(service.serviceId).set(service.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid updateService(Service service) async {
    try {
      return right(_services.doc(service.serviceId).update(service.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  FutureVoid deleteService(String serviceId) async {
    try {
      return right(_services.doc(serviceId).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
