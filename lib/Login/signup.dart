import 'package:flutter/material.dart';
import 'package:snacc/Login/Widgets/button.dart';
import 'package:snacc/Login/Widgets/textfield.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Text('Your Name',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  const SnaccTextField(),
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
                    child: Text('Create a password',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  const SnaccTextField(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Confirm password',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 5),
                  const SnaccTextField(),
                  const SizedBox(
                    height: 15,
                  ),
                   Center(
                      child: SnaccButton(
                        callBack: (){},
                    inputText: 'LOGIN',
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
