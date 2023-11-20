import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/UserPages/user_profile/track_order.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class OrderSuccess extends StatelessWidget {
  final int userID;
  const OrderSuccess({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: const Alignment(.5, 2),
            colors: <Color>[
              Colors.amber[100]!,
              Colors.amber[50]!,
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Gap(screenHeight * .2),
            Center(
                child: Image.asset(
              'assets/images/Snacc.png',
              scale: 1.5,
            )),
            Gap(screenHeight * .02),
            Center(
                child: Image.asset(
              'assets/images/theaterPeople.png',
              scale: 2.5,
            )),
            const Gap(20),
            Text('ORDER SUCCESS',
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green)),
            Gap(screenHeight * .01),
            Text(
                'Sit back, Relax and Enjoy your Movie \nwhile we prepare your Snacc',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                )),
            Gap(screenHeight * .1),
            SnaccButton(
              inputText: 'TRACK ORDER',
              callBack: () async {
                // final thisOrder = await getThisOrderToTack();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrackOrders(
                              userID: userID,
                            )));
              },
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
