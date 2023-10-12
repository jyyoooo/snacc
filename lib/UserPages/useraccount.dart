import 'dart:io';

import 'package:flutter/material.dart';

class UserAccount extends StatelessWidget {

  // final String username;
  const UserAccount({super.key,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.person),
        title: const Text('Your Profile'),
      ),
      body: Column(
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
                  Text('hgfs')
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
