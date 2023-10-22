import 'package:flutter/material.dart';

class SnaccButton extends StatelessWidget {
  final double width;
  final double height;
  final String inputText;
  final VoidCallback? callBack;
  final Color? btncolor;
  final Icon? icon;

  const SnaccButton({
    Key? key,
    this.width = 150.0,
    this.height = 40.0,
    required this.inputText,
    required this.callBack,
    this.btncolor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: width, height: height),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: btncolor ?? const Color.fromARGB(255, 82, 211, 86),
          ),
          onPressed: () {
            callBack!();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                inputText,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
