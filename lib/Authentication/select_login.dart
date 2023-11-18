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
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SnaccButton(
                    btnRadius: 15,
                    textColor: Colors.black,
                    width: 250,
                    height: 45,
                    btncolor: Colors.amber,
                    inputText: 'SIGNUP',
                    callBack: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const SignUp()));
                    },
                  ),
                  SnaccButton(
                      btnRadius: 15,
                      btncolor: Colors.grey[50],
                      width: 250,
                      height: 45,
                      textColor: Colors.blue,
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
      ),
    ));
  }
}
