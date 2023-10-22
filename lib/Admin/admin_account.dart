import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/Login/login.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';

class AdminAccount extends StatelessWidget {
  // final String username;
  const AdminAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar:const  PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: SnaccAppBar()),
          
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,10,20,10),
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
                    const Text('Admin')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  'Logout Admin',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
      ),
    ));
  }
}
