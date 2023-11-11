import 'package:flutter/material.dart';

class SnaccTileButton extends StatelessWidget {
  final Function? onPressed;
  final Widget? icon;
  final Widget? title;
  const SnaccTileButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(),
      onPressed: () {
        onPressed!();
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: icon,
          title: title,
        ),
      ),
    );
  }
}
