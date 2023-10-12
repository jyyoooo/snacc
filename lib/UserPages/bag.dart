import 'package:flutter/material.dart';

class UserBag extends StatefulWidget {
  const UserBag({super.key});

  @override
  State<UserBag> createState() => _UserBagState();
}

class _UserBagState extends State<UserBag> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shopping_bag_rounded),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Your Bag'),
      ),
    ));
  }
}
