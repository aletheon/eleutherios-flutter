import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/constants/firebase_constants.dart';
import 'package:reddit_tutorial/core/failure.dart';
import 'package:reddit_tutorial/core/providers/firebase_providers.dart';
import 'package:reddit_tutorial/core/type_defs.dart';
import 'package:reddit_tutorial/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel? userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          fullName: userCredential.user!.displayName ?? 'No name',
          userName: '',
          businessName: '',
          businessDescription: '',
          personalWebsite: '',
          businessWebsite: '',
          useBusinessProfile: false,
          email: userCredential.user!.email ?? 'No name',
          isAuthenticated: false,
          banner: Constants.bannerDefault,
          cert: 1,
          stripeCustomerId: '',
          stripeAccountId: '',
          stripeOnboardingStatus: '',
          stripeCurrency: 'USD',
          fcmToken: '',
          forumActivities: [],
          policyActivities: [],
          policies: [],
          forums: [],
          services: [],
          favorites: [],
          shoppingCartUserIds: [], // ensure each uid is unique and not a duplicate
          tags: [],
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          lastUpdateDate: DateTime.now(),
          creationDate: DateTime.now(),
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  Stream<UserModel?> getUserData(String uid) {
    if (uid.isNotEmpty) {
      final DocumentReference documentReference = _users.doc(uid);

      Stream<DocumentSnapshot> documentStream = documentReference.snapshots();

      return documentStream.map((event) {
        if (event.exists) {
          return UserModel.fromMap(event.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return const Stream.empty();
    }
    // return _users.doc(uid).snapshots().map(
    //       (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
    //     );
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
