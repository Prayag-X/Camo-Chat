import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUsers {
  final firebaseDb = FirebaseFirestore.instance;
  final collectionUsers = FirebaseFirestore.instance.collection('Users');

  Future<void> registerUser(String uid, String email, String userName) async {
    print('CollectionReference object: $collectionUsers');
    if (userName.isEmpty) {
      print('Empty userName provided');
      return;
    }
    else
    {
      print('userName NOT empty');
      print(userName);
    }

    try {
      await collectionUsers.doc(uid).set({'user_name': userName, 'email': email});
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  Future<String> getUserName(String uid) async => await collectionUsers
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) => doc['user_name']);


  // Join group

  // Remove group

  // Create group

  // Groups list (realtime streambuilder)

  // Dms list (realtime streambuilder)

  // Open Dm

  // Posts in group (realtime streambuilder)

  // Dm in chatrooms (1on1) (realtime streambuilder)


}
