User userFromJson(Map<String, dynamic> str) => User.fromJson(str);

class User {
  User({
    required this.userName,
    required this.dm,
    required this.groups,
    required this.isBanned,
    required this.moddedReports,
  });

  String? userId;
  String userName;
  List<String> dm;
  List<String> groups;
  bool isBanned;
  int moddedReports;

  factory User.fromJson(Map<String, dynamic> json) => User(
    userName: json["user_name"],
    dm: List<String>.from(json["dm"].map((x) => x)),
    groups: List<String>.from(json["groups"].map((x) => x)),
    isBanned: json["is_banned"],
    moddedReports: json["modded_reports"],
  );
}