import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.favorite,color: Colors.transparent,),
        title: const Text('Favorites'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Text('No Favorites'),
        Icon(
          Icons.favorite_rounded,color: Colors.grey,
          size: 50,
        )
      ])),
    );
  }
}
