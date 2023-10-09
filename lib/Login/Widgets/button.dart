import 'package:flutter/material.dart';

class SnaccButton extends StatelessWidget {
  final Size? minimumSize;
  final String inputText;
  final VoidCallback? callBack;
  
  const SnaccButton({super.key, this.minimumSize, required this.inputText, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize:const Size(100, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.greenAccent),
          onPressed: () {callBack!();},
          child: Text(inputText)),
    );
  }
}
