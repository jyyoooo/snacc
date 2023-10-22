import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/Admin/admin_navigation.dart';
// import 'package:snacc/DataModels/signup_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Login/signup.dart';
import 'package:snacc/Widgets/button.dart';
import 'package:snacc/Widgets/textfield.dart';
import 'package:snacc/UserPages/user_account.dart';
import 'package:snacc/UserPages/user_navigation.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController mailCtrl = TextEditingController();
    TextEditingController passCtrl = TextEditingController();

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
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
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Enter your email',
                      style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 5),
                SnaccTextField(
                  controller: mailCtrl,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Enter your password',
                      style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 5),
                SnaccTextField(
                  controller: passCtrl,
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                    child: SnaccButton(
                  callBack: () => performLogin(context, mailCtrl, passCtrl),
                  inputText: 'LOGIN',
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
                    child: const Row(
                      children: [
                        Text('New user?'),
                        Text(
                          'Sign up',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  // Future<bool> userExists() async {
    //   final usermail = mailCtrl.text.trim();
    //   final userpass = passCtrl.text.trim();

    //   final userbox = await Hive.box<UserModel>('userinfo');

    //   final userExists = userbox.values.any((storeduser) =>
    //       storeduser.userMail == usermail && storeduser.userPass == userpass);

    //   return userExists;
    // }


// LOGIN BTN CALL BACK

    // if (await adminLogin()) {
                    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       builder: ((context) => Navigation())));
                    // }
                    //  else if (await

                    //  userLogin();
                    //  ) {
                    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       builder: (context) => const UserNavigation()));
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //     content: Text('Invalid login credentials!'),
                    //     elevation: 2,
                    //   ));
                    // }