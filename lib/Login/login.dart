import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/adminhome.dart';
import 'package:snacc/Admin/navigation.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Login/Widgets/button.dart';
import 'package:snacc/Login/Widgets/textfield.dart';
import 'package:snacc/UserPages/useraccount.dart';
import 'package:snacc/UserPages/usernavigation.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

    TextEditingController mailCtrl = TextEditingController();
    TextEditingController passCtrl = TextEditingController();

    Future<bool> userLogin() async {
      final usermail = mailCtrl.text.trim();
      final userpass = passCtrl.text.trim();

      final userbox = await Hive.box<UserModel>('userinfo');

      final userExists = userbox.values.any((storeduser) =>
          storeduser.userMail == usermail && storeduser.userPass == userpass);

      return userExists;
    }

    

    Future<bool> adminLogin() async {
      final adminmail = mailCtrl.text.trim();
      final adminpass = passCtrl.text.trim();

      if (adminmail == 'admin' && adminpass == 'admin') {
        return true;
      } else {
        return false;
      }
    }

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
                  callBack: () async {
                    if (await adminLogin()) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => Navigation())));
                    } else if (await userLogin()) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const UserNavigation()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Invalid login credentials!'),
                        elevation: 2,
                      ));
                    }
                  },
                  inputText: 'LOGIN',
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
