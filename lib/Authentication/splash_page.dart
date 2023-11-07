import 'package:flutter/material.dart';
import 'package:snacc/Functions/login_functions.dart';

class SnaccSplash extends StatefulWidget {
  const SnaccSplash({super.key});

  @override
  State<SnaccSplash> createState() => _SnaccSplashState();
}

class _SnaccSplashState extends State<SnaccSplash> {
  @override
  void initState() {
    super.initState();
    print('CHECKING FOR LOGGED USERS');
    splashLoginCheck(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/Snacc.png'),
      ),
    );
  }
}
