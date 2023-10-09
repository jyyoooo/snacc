import 'package:flutter/material.dart';
import 'package:snacc/Admin/adminhome.dart';
import 'package:snacc/Admin/navigation.dart';
import 'package:snacc/Login/Widgets/button.dart';
import 'package:snacc/Login/Widgets/textfield.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
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
                const SnaccTextField(),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Enter your password',
                      style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 5),
                const SnaccTextField(),
                const SizedBox(
                  height: 15,
                ),
                Center(
                    child: SnaccButton(
                  callBack: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: ((context) =>  Navigation())));
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
