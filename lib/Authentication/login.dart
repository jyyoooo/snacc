import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Authentication/signup.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';
import 'package:snacc/Widgets/snaccbar.dart';


class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController mailCtrl = TextEditingController();
    TextEditingController passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(60),
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
                    'In the mood for\nyour movie treat? 🎥😋',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  )),
                  const Gap(30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        FocusScope(
                          child: SnaccTextField(
                            label: 'Enter your username',
                            controller: mailCtrl,
                            validationMessage: 'You must enter your username',
                          ),
                        ),
                        const Gap(8),
                        FocusScope(
                          child: SnaccTextField(
                            obscureText: true,
                            label: 'Enter your password',
                            controller: passCtrl,
                            validationMessage: 'You must enter your password',
                            showText: false,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: SnaccButton(
                    inputText: 'LOGIN',
                    btncolor: Colors.amber,
                    textColor: Colors.black,
                    btnRadius: 15,
                    width: 250,
                    height: 45,
                    callBack: ()async {
                      final String username = mailCtrl.text.trim();
                      final String password = passCtrl.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        formKey.currentState!.validate();
                        log('fields empty');
                      } else {
                      final isValidUser = await performLogin(context, username, password);
                      if(isValidUser){
                        FocusScope.of(context).requestFocus(FocusNode());
                        showSnaccBar(context, 'Logged in as $username', Colors.green);
                      }
                      }
                    },
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Row(
                        children: [
                          const Gap(20),
                          Text(
                            'New user?',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 14, color: Colors.black54),
                          ),
                          Text(' Sign up',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                  // TextButton(
                  //     onPressed: () {
                  //       Hive.box<Category>('category').clear();
                  //     },
                  //     child: const Text('Delete categories',style: TextStyle(color: Colors.red),)),
                  //     TextButton(
                  //     onPressed: () {
                  //       Hive.box<ComboModel>('combos').clear();
                  //     },
                  //     child: const Text('Delete combos',style: TextStyle(color: Colors.red),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
