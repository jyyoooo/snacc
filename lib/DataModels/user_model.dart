import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel {
  @HiveField(0)
  String? userID;

  @HiveField(1)
  String? userMail;

  @HiveField(2)
  String? userPass;

  @HiveField(3)
  String? username;

  @HiveField(4)
  String? confirmPass;

  UserModel({
    this.userID,
    required this.username,
    required this.userMail,
    required this.userPass,
    required this.confirmPass,
  });
}


