import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUsers {
  final firebaseDb = FirebaseFirestore.instance;
  final collectionUsers = FirebaseFirestore.instance.collection('Users');

  Future<void> registerUser(String uid, String email, String userName) async {
    await collectionUsers.doc(uid).set({'user_name': userName, 'email': email});
  }

  Future<String> getUserName(String uid) async => await collectionUsers
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) => doc['user_name']);
}
