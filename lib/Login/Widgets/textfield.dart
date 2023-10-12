import 'package:flutter/material.dart';

class SnaccTextField extends StatelessWidget {
  TextEditingController? controller;
   SnaccTextField({super.key,this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color.fromARGB(255, 226, 226, 226))),
          child:  TextFormField(
            controller: controller,
            style:const TextStyle(fontSize: 16),
            decoration: const InputDecoration(border: InputBorder.none),
          )),
    );
  }
}
