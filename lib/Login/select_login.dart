import 'package:flutter/material.dart';
import 'package:snacc/Login/login.dart';
import 'package:snacc/Login/signup.dart';
import 'package:snacc/Widgets/button.dart';

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
            const Text(
              textAlign: TextAlign.center,
              'Skip the Line, Enjoy the Show\nBook Your Theater Snacks in a Snap!',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
                    }),
                SnaccButton(
                    inputText: 'LOGIN',
                    callBack: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const Login()));
                    })
              ],
            )
          ],
        ),
      ),
    ));
  }
}
