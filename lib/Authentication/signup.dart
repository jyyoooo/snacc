import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';
import 'package:snacc/Authentication/login.dart';
import 'package:snacc/UserPages/user_home.dart';
import 'package:snacc/UserPages/user_navigation.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController namectrl = TextEditingController();
    TextEditingController mailctrl = TextEditingController();
    TextEditingController passctrl = TextEditingController();
    TextEditingController confirmctrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/images/Snacc.png'),
                        Image.asset(
                          'assets/images/indofeb25 1.png',
                          height: 150,
                        )
                      ],
                    ),
                    Center(
                        child: Text(
                      'Welcome to Snacc\n Let\'s sign you up!',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    )),
                    const Gap(15),
                    SnaccTextField(
                      label: 'Your Name',
                      controller: namectrl,
                      validationMessage: 'Enter your Name',
                    ),
                    SnaccTextField(
                      label: 'Username',
                      controller: mailctrl,
                      validationMessage: 'Enter your username',
                    ),
                    SnaccTextField(
                      obscureText: true,
                      label: 'Password',
                      controller: passctrl,
                      validationMessage: 'Enter your password',
                    ),
                    SnaccTextField(
                      obscureText: true,
                      label: 'Confrim password',
                      controller: confirmctrl,
                      validationMessage: 'Confirm your password',
                    ),
                    const Gap(20),
                    Center(
                        child: SnaccButton(
                      callBack: () async {
                        bool userCheck = false;
                        final String username = namectrl.text.trim();
                        final String mailid = mailctrl.text.trim();
                        final String password = passctrl.text;
                        final String confirm = confirmctrl.text;
                        if (username.length < 7) {
                          formKey.currentState?.validate();
                        }

                        if (username.isEmpty ||
                            mailid.isEmpty ||
                            password.isEmpty ||
                            confirm.isEmpty) {
                          formKey.currentState!.validate();
                          Fluttertoast.showToast(
                              msg:
                                  'Oops, you have to enter all details before doing that',
                              backgroundColor: Colors.red);
                        } else if (mailid.length < 7) {
                          Fluttertoast.showToast(
                              msg: 'Username is too short',
                              backgroundColor: Colors.amber,
                              textColor: Colors.black);
                        } else {
                          userCheck = await addUser(
                              username, mailid, password, confirm, context);
                        }

                        if (userCheck == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        } else {
                          log('oops signup failed');
                        }
                      },
                      textColor: Colors.white,
                      inputText: 'REGISTER',
                    )),
                    const Gap(30),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: Row(
                        children: [
                          const Gap(20),
                          Text('Already have an account?',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 14, color: Colors.black54)),
                          Text(' Log In',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
