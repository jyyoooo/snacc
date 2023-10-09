import 'package:flutter/material.dart';

class SnaccTextField extends StatelessWidget {
  const SnaccTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color.fromARGB(255, 226, 226, 226))),
          child: const TextField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(border: InputBorder.none),
          )),
    );
  }
}
