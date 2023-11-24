import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SnaccTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final String? validationMessage;
  final bool obscureText;
  final bool? showText;
  final TextCapitalization? textCapitalization;

  const SnaccTextField(
      {Key? key,
      this.controller,
      this.validator,
      this.label = 'no labels given',
      this.validationMessage,
      this.obscureText = false,
      this.showText = true,
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  @override
  _SnaccTextFieldState createState() => _SnaccTextFieldState();
}

class _SnaccTextFieldState extends State<SnaccTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        // color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            // const Gap(13),
            TextFormField(
              scrollController: ScrollController(),
              scrollPhysics: const BouncingScrollPhysics(),
              textCapitalization: widget.textCapitalization!,
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
                        color: Colors.blueGrey,
                      )
                    : null,
                floatingLabelStyle: const TextStyle(
                  backgroundColor: Colors.transparent,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                labelStyle: const TextStyle(color: Colors.black54),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                filled: true,
                fillColor: const Color.fromARGB(255, 228, 228, 228),
                focusedErrorBorder: OutlineInputBorder(
                  gapPadding: 3,
                  borderSide: const BorderSide(width: 2, color: Colors.amber),
                  borderRadius: BorderRadius.circular(17.5),
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3,
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                  borderRadius: BorderRadius.circular(17.5),
                ),
                focusedBorder: OutlineInputBorder(
                  gapPadding: 3,
                  borderSide: const BorderSide(width: 2.0, color: Colors.amber),
                  borderRadius: BorderRadius.circular(17.5),
                ),
                errorBorder: OutlineInputBorder( // Add this line
                  gapPadding: 3,
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                  borderRadius: BorderRadius.circular(17.5),
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
