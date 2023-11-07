import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/Admin/admin_navigation.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Authentication/login.dart';
import 'package:snacc/Authentication/select_login.dart';
import 'package:snacc/UserPages/user_profile.dart';
import 'package:snacc/UserPages/user_navigation.dart';

// UserModel? loggedUser;

// void fireExample(){
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
// }

Future<bool> validateUser(String username, String password) async {
  final userBox = await Hive.openBox<UserModel>('userinfo');
  final loggedUserStatusBox = await Hive.openBox<bool>('loggedUserBox');
  final currentUserBox = await Hive.openBox<UserModel>('currentUser');
  List<UserModel> users = userBox.values.toList();

  for (var user in users) {
    if (user.userMail.toString() == username &&
        user.userPass.toString() == password) {
      loggedUserStatusBox.put('userLoggedIn', true);
      currentUserBox.add(user);
      log('logged user = ${user.username}');

      return true;
    }
  }
  return false;
}

Future<UserModel?> getCurrentUser() async {
  final nowUserBox = await Hive.openBox<UserModel>('currentUser');
  final user = nowUserBox.values.first;

  return user;
}

splashLoginCheck(context) async {
  final loggedUserBox = await Hive.openBox<bool>('loggedUserBox');
  final loggedAdmin = await Hive.openBox<bool>('adminCheck');

  final isLoggedIn = loggedUserBox.get('userLoggedIn');
  final isAdmin = loggedAdmin.get('adminCheck');

  if (isLoggedIn == true) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const UserNavigation()));
    log('user found');
  } else if (isAdmin == true) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminNavigation()));
    log('admin found');
  } else {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SelectLogin()));
    log(' no user found');
  }
}

Future<bool> adminLogin(
    TextEditingController mailCtrl, TextEditingController passCtrl) async {
  final isAdminLoggedIn = await Hive.openBox<bool>('adminCheck');
  final adminmail = mailCtrl.text.trim();
  final adminpass = passCtrl.text.trim();

  if (adminmail == 'admin' && adminpass == 'admin') {
    isAdminLoggedIn.put('adminLoggedIn', true);
    return true;
  } else {
    return false;
  }
}

Future<void> performLogin(context, username, password) async {
  if (username == 'admin' && password == 'admin') {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminNavigation()));
  } else if (username.isEmpty || password.isEmpty) {
    Fluttertoast.showToast(
        msg: 'Enter your Email and password', backgroundColor: Colors.red);
  } else {
    final bool isValidUser = await validateUser(username, password);
    if (isValidUser) {
      // Navigate to the user's home page after successful login
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const UserNavigation(),
          ),
          ModalRoute.withName('/'));
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

void logoutUser(context) async {
  final loggedUserStatusBox = await Hive.openBox<bool>('loggedUserBox');
  final currentUserBox = await Hive.openBox<UserModel>('currentUser');
  loggedUserStatusBox.put('userLoggedIn', false);

  currentUserBox.clear();

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
      ModalRoute.withName(''));
}

void logOutAdmin(context) async {
  final adminBox = await Hive.openBox<bool>('adminCheck');
  adminBox.put('adminLoggedIn', false);

  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
}

// SIGN UP

Future<bool> addUser(username, mailid, password, confirm, context) async {
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
      final id = await userBox.add(user);
      user.userID = id;
      await userBox.put(id, user);
      log('${user.username}s ID: ${user.userID}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('You\'re all set! Log in now.')));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber[300],
          content: const Text('Passwords dont match',
              style: TextStyle(color: Colors.black87))));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amber[300],
      content: const Text(
        'Oops, User Already Exists,Log in instead.',
        style: TextStyle(color: Colors.black87),
      ),
      elevation: 2,
    ));
  }
  return false;
}
