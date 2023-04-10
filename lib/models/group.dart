import 'package:camo_chat/models/post.dart';
import 'package:camo_chat/models/user.dart';

Group groupFromJson(Map<String, dynamic> str) => Group.fromJson(str);

class Group {
  Group({
    required this.admin,
    required this.members,
    required this.posts,
  });

  String? id;
  String admin;
  List<String> members;
  List<User>? membersObj;
  List<String> posts;
  List<Post>? postsObj;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    admin: json["admin"].trim(),
    members: List<String>.from(json["members"].map((x) => x.trim())),
    posts: List<String>.from(json["posts"].map((x) => x.trim())),
  );
}