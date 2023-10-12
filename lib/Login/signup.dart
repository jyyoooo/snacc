import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Login/Widgets/button.dart';
import 'package:snacc/Login/Widgets/textfield.dart';
import 'package:snacc/Login/login.dart';
import 'package:snacc/UserPages/userhome.dart';
import 'package:snacc/UserPages/usernavigation.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController namectrl = TextEditingController();
    TextEditingController mailctrl = TextEditingController();
    TextEditingController passctrl = TextEditingController();
    TextEditingController confirmctrl = TextEditingController();

    addUser() async {
      final userBox = await Hive.openBox<UserModel>('userinfo');

      final String username = namectrl.text.trim();
      final String mailid = mailctrl.text.trim();
      final String password = passctrl.text;
      final String confirm = confirmctrl.text;

      final user = UserModel(
          username: username,
          userMail: mailid,
          userPass: password,
          confirmPass: confirm);

      bool userExist = false;

      for (var storedUser in userBox.values) {
        if (storedUser.userMail == user.userMail) {
          userExist = true;
          break;
        }
      }

      if (!userExist) {
        if (password == confirm) {
          userBox.add(user);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords dont match')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User Already Exists'),
          elevation: 2,
        ));
      }

      print(user.userMail);
      print(userBox.values.toList());
    }

    return Material(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
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
                    child:
                        Text('Your Name', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  SnaccTextField(
                    controller: namectrl,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Enter your email',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  SnaccTextField(
                    controller: mailctrl,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Create a password',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  SnaccTextField(
                    controller: passctrl,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Confirm password',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  SnaccTextField(
                    controller: confirmctrl,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: SnaccButton(
                    callBack: () {
                      addUser();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Login()));
                    },
                    inputText: 'REGISTER',
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
