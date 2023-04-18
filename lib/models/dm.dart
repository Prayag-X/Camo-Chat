import 'package:camo_chat/models/message.dart';
import 'package:camo_chat/models/user.dart';

Dm dmFromJson(Map<String, dynamic> str) => Dm.fromJson(str);

class Dm {
  Dm({
    required this.members,
    required this.messages,
  });

  String? id;
  User? otherUser;
  List<String> members;
  List<String>? messages;
  List<Message>? messagesObj;

  factory Dm.fromJson(Map<String, dynamic> json) => Dm(
    members: List<String>.from(json["members"].map((x) => x.trim())),
    messages: List<String>.from(json["messages"].map((x) => x.trim())),
  );
}