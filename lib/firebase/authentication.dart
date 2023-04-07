import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    UserCredential credentials =
        await firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    ));
    return credentials.user;
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
