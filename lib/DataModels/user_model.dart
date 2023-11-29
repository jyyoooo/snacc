import 'package:hive_flutter/hive_flutter.dart';


import 'order_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel {
  @HiveField(0)
  int? userID;

  @HiveField(1)
  String? userMail;

  @HiveField(2)
  String? userPass;

  @HiveField(3)
  String? username;

  @HiveField(4)
  String? confirmPass;

  @HiveField(5)
  List<dynamic>? favorites = [];

  @HiveField(6)
  List<dynamic>? userBag = [];

  @HiveField(7)
  List<Order>? userOrders = [];

  UserModel(
      {this.userID,
      required this.username,
      required this.userMail,
      required this.userPass,
      required this.confirmPass,
      this.favorites,
      this.userBag});
}
