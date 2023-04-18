import 'dart:async';

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
      'reports': 0,
      'is_modded': false
    });
    await collectionDM.doc(dmId).update({
      'messages': FieldValue.arrayUnion([newMessageId])
    });
  }

  likeMessage(String messageId) async {
    await collectionMessages.doc(messageId).update({
      'likes': FieldValue.increment(1),
    });
  }

  reportMessage(String messageId) async {
    Message message = await collectionMessages
        .doc(messageId)
        .get()
        .then((snapshot) => messageFromJson(snapshot.data()!));
    await collectionMessages
        .doc(messageId)
        .update({'reports': message.reports + 1});
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

  reportPost(String postId) async {
    Message post = await collectionPosts
        .doc(postId)
        .get()
        .then((snapshot) => messageFromJson(snapshot.data()!));
    await collectionPosts.doc(postId).update({'reports': post.reports + 1});
  }

  // DM ------------------------------------------------------

  Dm _dmFromSnap(DocumentSnapshot snapshot) =>
      dmFromJson(snapshot.data() as Map<String, dynamic>);

  Stream<Dm> streamDm(String dmId) => collectionDM
      .doc(dmId)
      .snapshots(includeMetadataChanges: true)
      .map(_dmFromSnap);

  Future<Dm> openDM(String otherUserId) async {
    DocumentReference newDM = collectionDM.doc();
    String newDMId = await newDM.get().then((snapshot) => snapshot.id);

    await newDM.set({
      'members': [controller.userId, otherUserId],
      'messages': [],
    });
    await collectionUsers.doc(controller.userId).update({
      'dm': FieldValue.arrayUnion([newDMId])
    });
    await collectionUsers.doc(otherUserId).update({
      'dm': FieldValue.arrayUnion([newDMId])
    });
    var openedDM = await newDM.get();
    return dmFromJson(openedDM.data() as Map<String, dynamic>);
  }

  Future<List<User>> searchDM() async {
    List<User> result = [];
    List<String> otherUsers = [];
    for (var dm in controller.userData.value.dm) {
      await collectionDM.doc(dm).get().then((value) {
        var dmObj = dmFromJson(value.data() as Map<String, dynamic>);
        if (dmObj.members[0] == controller.userId) {
          otherUsers.add(dmObj.members[1]);
        } else {
          otherUsers.add(dmObj.members[0]);
        }
      });
    }
    var collection = await collectionUsers.get();
    collection.docs.forEach((doc) {
      if (doc.id.trim() != controller.userId &&
          !otherUsers.contains(doc.id.trim())) {
        User user = userFromJson(doc.data());
        user.userId = doc.id;
        result.add(user);
      }
    });
    var blank = User(
        userName: 'blank',
        dm: [],
        groups: [],
        isBanned: false,
        moddedReports: 0);
    blank.userId = 'blank';
    result.insert(0, blank);
    return result;
  }

  // Future<StreamSubscription<dynamic>> listenDm() async {
  //   DocumentReference dmDataDoc =
  //       collectionDM.doc(controller.selectedDm.value.id);
  //   StreamSubscription docListener = dmDataDoc
  //       .snapshots(includeMetadataChanges: true)
  //       .listen((snapshot) async {
  //     await dmDataDoc.get().then((DocumentSnapshot documentSnapshot) {
  //       var dm = dmFromJson(documentSnapshot.data() as Map<String, dynamic>);
  //       for (var message in dm.messages) {
  //         if (!(controller.selectedDmMessages.contains(message))) {
  //           controller.selectedDmMessages.add(message);
  //           print(message);
  //         }
  //       }
  //       // print(controller.userData.value.userName);
  //       controller.userDataLoaded.value = true;
  //     });
  //   });
  //   return docListener;
  // }

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

  // Future<void> tryFunction() async {
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
  // }
}
