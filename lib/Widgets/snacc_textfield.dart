import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SnaccTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final String? validationMessage;
  final bool obscureText;
  const SnaccTextField(
      {super.key,
      this.controller,
      this.validator,
      this.label = 'no labels given',
      this.validationMessage,this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    // const String defaultMessage = 'Enter details';
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(13),
            TextFormField(
              obscureText: obscureText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  backgroundColor: Colors.white38,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
                labelStyle: const TextStyle(color: Colors.black54),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: label,
              ),
              controller: controller,
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validationMessage;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
