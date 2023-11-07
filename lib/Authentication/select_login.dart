import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Authentication/login.dart';
import 'package:snacc/Authentication/signup.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class SelectLogin extends StatelessWidget {
  const SelectLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 200,
              child: Image.asset("assets/images/Snacc.png"),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset("assets/images/indofeb25 1.png"),
            ),
             Text(
              textAlign: TextAlign.center,
              'Skip the Line, Enjoy the Show\nBook Your Theater Snacks in a Snap!',
              style: GoogleFonts.nunitoSans(
                      fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SnaccButton(
                  btncolor: Colors.amber,
                    inputText: 'SIGNUP',
                    callBack: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const SignUp()));
                    },
                    width: 100,),
                SnaccButton(
                  textColor: Colors.white,
                    inputText: 'LOGIN',
                    callBack: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const Login()));
                    },
                    width: 100)
              ],
            )
          ],
        ),
      ),
    ));
  }
}
