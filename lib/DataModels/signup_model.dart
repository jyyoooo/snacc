import 'package:hive/hive.dart';

class SignUp {
  String? name;
  String? email;
  String? password;
  String? confirm;
}

Future<void> addUser() async {
  final userBox = Hive.openBox('userinfo');
}
