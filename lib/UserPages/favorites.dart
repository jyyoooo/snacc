import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Center(
          child: Column(children: [
        Text('No Favorites'),
        Icon(
          Icons.favorite_rounded,
          size: 50,
        )
      ])),
    );
  }
}
