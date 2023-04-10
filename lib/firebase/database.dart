import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/group.dart';
import '../models/message.dart';
import '../models/dm.dart';

class Database {
  final controller = Get.find<Controller>();
  final collectionUsers = FirebaseFirestore.instance.collection('Users');
  final collectionGroups = FirebaseFirestore.instance.collection('Groups');
  final collectionDM = FirebaseFirestore.instance.collection('DM');
  final collectionMessages = FirebaseFirestore.instance.collection('Messages');
  final collectionPosts = FirebaseFirestore.instance.collection('Posts');

  // USER ---------------------------------------------------

  initUserData() async {
    DocumentReference userDataDoc = collectionUsers.doc(controller.userId);
    userDataDoc
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) async {
      await userDataDoc.get().then((DocumentSnapshot documentSnapshot) {
        controller.userData.value =
            userFromJson(documentSnapshot.data() as Map<String, dynamic>);
        // print(controller.userData.value.userName);
        controller.userDataLoaded.value = true;
      });
    });
  }

  registerUser(String uid, String userName) async {
    await collectionUsers.doc(uid).set({
      'user_name': userName,
      'dm': [],
      'groups': [],
      'is_banned': false,
      'modded_reports': 0
    });
  }

  Future<User> getUser(String uid) async =>
      await collectionUsers.doc(uid).get().then((DocumentSnapshot doc) =>
          userFromJson(doc.data() as Map<String, dynamic>));

  // MESSAGE  ---------------------------------------------------

  Future<Message> readMessage(String messageId) async =>
      await collectionMessages
          .doc(messageId)
          .get()
          .then((snapshot) => messageFromJson(snapshot.data()!));

  writeMessage(String dmId, String content) async {
    DocumentReference newMessage = collectionMessages.doc();
    String newMessageId =
        await newMessage.get().then((snapshot) => snapshot.id);

    await newMessage.set({
      'content': content,
      'sender_id': controller.userId,
      'timestamp': DateTime.now(),
      'likes': 0,
      'reports': 0
    });
    await collectionDM.doc(dmId).update({
      'messages': FieldValue.arrayUnion([newMessageId])
    });
  }

  // POST ------------------------------------------------------

  Future<Post> readPost(String postId) async => await collectionPosts
      .doc(postId)
      .get()
      .then((snapshot) => postFromJson(snapshot.data()!));

  writePost(String groupId, String content) async {
    DocumentReference newPost = collectionPosts.doc();
    String newPostId = await newPost.get().then((snapshot) => snapshot.id);

    await newPost.set({
      'content': content,
      'sender_id': controller.userId,
      'timestamp': DateTime.now(),
      'likes': 0,
      'reports': 0
    });
    await collectionDM.doc(groupId).update({
      'messages': FieldValue.arrayUnion([newPostId])
    });
  }

  // DM ------------------------------------------------------

  Dm _dmFromSnap(DocumentSnapshot snapshot) =>
      dmFromJson(snapshot.data() as Map<String, dynamic>);

  Stream<Dm> streamDm(String dmId) => collectionDM
      .doc(dmId)
      .snapshots(includeMetadataChanges: true)
      .map(_dmFromSnap);

  openDM(String otherUserId) async {
    DocumentReference newDM = collectionDM.doc();
    String newDMId = await newDM.get().then((snapshot) => snapshot.id);

    await newDM.set({
      'members': [controller.userId, otherUserId],
      'messages': [],
    });
    await collectionUsers.doc(controller.userId).update({
      'dm': FieldValue.arrayUnion([newDMId])
    });
  }

  // GROUP --------------------------------------------------

  Group _groupFromSnap(DocumentSnapshot snapshot) =>
      groupFromJson(snapshot.data() as Map<String, dynamic>);

  Stream<Group> streamGroup(String groupId) => collectionGroups
      .doc(groupId)
      .snapshots(includeMetadataChanges: true)
      .map(_groupFromSnap);

  createGroup(String group) async {
    DocumentReference newGroup = collectionGroups.doc();
    String newGroupId = await newGroup.get().then((snapshot) => snapshot.id);

    await newGroup.set({
      'admin': controller.userId,
      'members': [],
      'posts': [],
    });
    await collectionUsers.doc(controller.userId).update({
      'groups': FieldValue.arrayUnion([newGroupId])
    });
  }

  Future<void> tryFunction() async {
    // var example = await FirebaseFirestore.instance.collection('Posts').get();
    // example.docs.forEach((element) {
    //   var ex = postFromJson(element.data());
    //   print(ex.content);
    //   print(json.encode(element.data(),
    //       toEncodable: (val) => (val as Timestamp).toDate().toString()));
    // });
    // var x = collectionMessages.doc();
    // await x.set({'content': 'holaaa2', 'sender_id': 'gg', 'timestamp': DateTime.now()});
    // var doc_id = await x.get();
    // await collectionDM.doc('AB').update({'messages': FieldValue.arrayUnion([doc_id.id])});
  }
}
