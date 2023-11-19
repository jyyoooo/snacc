import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SnaccTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final String? validationMessage;
  final bool obscureText;
  final bool? showText;

  const SnaccTextField({
    Key? key,
    this.controller,
    this.validator,
    this.label = 'no labels given',
    this.validationMessage,
    this.obscureText = false,
    this.showText = true,
  }) : super(key: key);

  @override
  _SnaccTextFieldState createState() => _SnaccTextFieldState();
}

class _SnaccTextFieldState extends State<SnaccTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(13),
            TextFormField( 
              textCapitalization: TextCapitalization.characters,
              controller: widget.controller,
              obscureText: widget.obscureText && isObscure,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                suffixIcon: widget.showText == false
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        iconSize: 20,
                        color: Colors.black26,
                      )
                    : null,
                floatingLabelStyle: const TextStyle(
                  backgroundColor: Colors.white38,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                labelStyle: const TextStyle(color: Colors.black54),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: widget.label,
              ),
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.validationMessage;
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
