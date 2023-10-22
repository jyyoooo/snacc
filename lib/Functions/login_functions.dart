import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/Admin/admin_navigation.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Login/login.dart';
import 'package:snacc/Login/select_login.dart';
import 'package:snacc/UserPages/user_account.dart';
import 'package:snacc/UserPages/user_navigation.dart';

// UserModel? loggedUser;

Future<bool> validateUser(String username, String password) async {
  final userBox = await Hive.openBox<UserModel>('userinfo');
  final loggedUserStatusBox = await Hive.openBox<bool>('loggedUserBox');
  final currentUserBox = await Hive.openBox<UserModel>('currentUser');
  List<UserModel> users = userBox.values.toList();

  for (var user in users) {
    if (user.userMail.toString() == username &&
        user.userPass.toString() == password) {
      // as user is found userLogin is set to TRUE
      loggedUserStatusBox.put('userLoggedIn', true);
      // loggedin user is added to currentUsersBox
      currentUserBox.add(user);
      print('logged user = ${user.username}');

      return true;
    }
  }
  return false;
}

 Future<UserModel> getCurrentUser() async {
  final currentUserBox = await Hive.openBox<UserModel>('currentUser');
  final currentUser = currentUserBox.values.toList();


  final user = currentUser.first;
  print(user.username);
 return user;
 
}

splashLoginCheck(context) async {
  final loggedUserBox = await Hive.openBox<bool>('loggedUserBox');
  final isLoggedIn = loggedUserBox.get('userLoggedIn');
  if (isLoggedIn == true) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const UserNavigation()));
  } else {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SelectLogin()));
  }
}

Future<bool> adminLogin(
    TextEditingController mailCtrl, TextEditingController passCtrl) async {
  final adminmail = mailCtrl.text.trim();
  final adminpass = passCtrl.text.trim();

  if (adminmail == 'admin' && adminpass == 'admin') {
    return true;
  } else {
    return false;
  }
}

Future<void> performLogin( context, TextEditingController mailCtrl,
    TextEditingController passCtrl) async {
  final String username = mailCtrl.text.trim();
  final String password = passCtrl.text.trim();

  if (username == 'admin' && password == 'admin') {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminNavigation()));
  } else {
    final bool isValidUser = await validateUser(username, password);
    if (isValidUser) {
      // Navigate to the user's home page after successful login
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const UserNavigation(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid login credentials!'),
        ),
      );
    }
  }
}
// removed BuildContext from function parameters in logoutUser and perform login
void logoutUser( context) async {
  final loggedUserStatusBox = await Hive.openBox<bool>('loggedUserBox');
  final currentUserBox = await Hive.openBox<UserModel>('currentUser');
  loggedUserStatusBox.put('userLoggedIn', false);
  // currentUserBox.deleteAll;
  currentUserBox.clear();
  // Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const Login()));
}

// SIGN UP

addUser(username, mailid, password, confirm, context) async {
  final userBox = await Hive.openBox<UserModel>('userinfo');
// creating a usermodel object
  final user = UserModel(
      username: username,
      userMail: mailid,
      userPass: password,
      confirmPass: confirm);

// Checking if the user already exists
  bool userExist = false;

  for (var storedUser in userBox.values) {
    if (storedUser.userMail == user.userMail) {
      userExist = true;
      break;
    }
  }

  if (!userExist) {
    if (password == confirm) {
      userBox.add(user);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content:  Text('You\'re all set! Log in now.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber[300],
          content: const Text('Passwords dont match')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amber[300],
      content: const Text('Oops, User Already Exists'),
      elevation: 2,
    ));
  }

  print(user.userMail);
  print(userBox.values.toList());
}
