import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Authentication {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseDb = FirebaseFirestore.instance;

  Future<User?> isUserLoggedIn() async => firebaseAuth.currentUser;

  Future<bool> isUserRegistered(String uid) async {
    return await firebaseDb
        .collection('Users')
        .doc(uid)
        .get()
        .then((doc) => doc.exists);
  }

  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      // For web platform
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
        '545685942426-ej86rm4eetjj0p8rdat3gdqtfsgu7np5.apps.googleusercontent.com',
        scopes: [
          'email',
        ],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      UserCredential credentials =
      await firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          ));
      return credentials.user;
    } else {
      // For Android platform
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount!.authentication;
      final OAuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential credentials =
      await firebaseAuth.signInWithCredential(credential);
      return credentials.user;
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
