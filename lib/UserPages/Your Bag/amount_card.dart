import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/UserPages/Your%20Bag/payment.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class AmountCard extends StatefulWidget {
  final UserModel user;
  final List<dynamic>? userBag;
  const AmountCard({super.key, required this.userBag,required this.user});

  @override
  State<AmountCard> createState() => _AmountCardState();
}

class _AmountCardState extends State<AmountCard> {
  double? total;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: getTotalBagAmount(widget.userBag),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('somethings wrong: ${snapshot.error}');
          } else {
            total = snapshot.data;
            double? sGst = total! * 18 / 100;
            double? cGst = total! * 18 / 100;
            double? addedTotal = total! + sGst + cGst;
            final grandTotal = addedTotal.floorToDouble();
            log('grand total: $grandTotal');

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: const Color.fromARGB(100, 236, 236, 236),
                    width: double.maxFinite,
                    height: 210,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₹${total ??= 0}0',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '+ SGST 18%',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              Text(
                                '₹${sGst}0',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Convenience fee',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              Text(
                                '₹${cGst}0',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                // width: 50,height: 27,
                                child: Text(
                                  '₹${grandTotal}0',
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SnaccButton(
                              textColor: Colors.black,
                              btncolor: Colors.amber,
                              inputText: "PAYMENT",
                              callBack: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PaymentsPage(user: widget.user,
                                          amountPayable: addedTotal,
                                        )));
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
