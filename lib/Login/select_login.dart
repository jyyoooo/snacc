import 'package:flutter/material.dart';
import 'package:snacc/Login/login.dart';
import 'package:snacc/Login/signup.dart';

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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.amber),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const SignUp()));
                    },
                    child: const Text('SIGN UP')),
                ButtonTheme(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.greenAccent),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const Login()));
                      },
                      child: const Text('LOG IN')),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
