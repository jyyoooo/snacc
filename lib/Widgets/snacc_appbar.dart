import 'package:flutter/material.dart';

class SnaccAppBar extends StatelessWidget {
  final Text? title;
  final Widget? leading;
  final List<Widget>? actions;
  const SnaccAppBar(
      {super.key,
      this.title,
      this.leading = const Icon(
        Icons.abc,
        color: Colors.transparent,
      ),
      this.actions});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        title: title,
        leading: leading,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions:  actions ?? <Widget>[],
      ),
    );
  }
}
