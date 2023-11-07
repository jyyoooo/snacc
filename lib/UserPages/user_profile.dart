import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/UserPages/user_navigation.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Authentication/login.dart';

class UserAccount extends StatefulWidget {
  final UserModel? user;
  const UserAccount({
    this.user,
    super.key,
  });

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Your Profile',
          style:
              GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.amber[100],
                      child: const Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),
                    Text(
                      widget.user?.username ?? 'internal error',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Are you sure to log out of ${widget.user?.username}?',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          const SizedBox(
                            height: 20,
                          ),
                          SnaccButton(
                            textColor: Colors.white,
                              btncolor: Colors.red,
                              inputText: 'Logout',
                              callBack: () {
                                logoutUser(context);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              })
                        ],
                      );
                    });
              },
              child: ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
