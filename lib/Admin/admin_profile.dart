import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Authentication/login.dart';
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
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: SnaccAppBar()),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    const Text('Admin',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
                onPressed: () {
                  logOutAdmin(context);
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
