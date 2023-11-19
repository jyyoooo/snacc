import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Authentication/login.dart';
import 'package:snacc/Authentication/signup.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class SelectLogin extends StatelessWidget {
  const SelectLogin({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: screenWidth,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'snacc_logo',
                  child: SizedBox(
                    width: screenWidth * .3,
                    height: screenHeight * .25,
                    child: Image.asset(
                      "assets/images/Snacc.png",
                      scale: 1,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Hero(tag: 'snaccHeroImg',
                  child: SizedBox(
                    width: screenWidth * .5,
                    height: screenHeight * .3,
                    child: Image.asset(
                      "assets/images/indofeb25 1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  'Skip the Line, Enjoy the Show\nBook Your Theater Snacks in a Snap!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    fontSize: screenWidth < 600 ? 17 : 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * .1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SnaccButton(
                      btnRadius: 15,
                      textColor: Colors.black,
                      width: screenWidth * 0.6,
                      height: 45,
                      btncolor: Colors.amber,
                      inputText: 'GET STARTED',
                      callBack: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                    ),
                    SnaccButton(
                      btnRadius: 15,
                      btncolor: Colors.grey[50],
                      width: screenWidth * 0.6,
                      height: 45,
                      textColor: Colors.blue,
                      inputText: 'LOGIN',
                      callBack: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
