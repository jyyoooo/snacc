import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Widgets/button.dart';
import 'package:snacc/Login/login.dart';

class UserAccount extends StatelessWidget {
  // final String username;
  const UserAccount({
    super.key,
  });
  

  @override
  Widget build(BuildContext context) {
    
     getUser() async {
      final UserModel user = await getCurrentUser();
      String username = user.username!;
      return username;
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.person),
        title: const Text('Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.amber[100],
                      // backgroundImage: Image.file(File(user)),
                    ),
                    // Text()
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
                        title: const Text('Are you sure about that?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Tap outside to close',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: const Text(
                                  'Yes, Log out',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  logoutUser(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()));
                                })
                          ],
                        ),
                      );
                    });
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
