import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
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
    Future.delayed(const Duration(milliseconds: 2000), () {
      splashLoginCheck(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset('assets/images/Snacc.png'),
            ),
            Text(
              'version 1.0',
              style: GoogleFonts.nunitoSans(color: Colors.grey),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}
