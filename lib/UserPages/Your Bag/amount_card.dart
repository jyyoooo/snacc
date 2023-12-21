import 'dart:ui';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/UserPages/Your%20Bag/payment.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snaccbar.dart';

class AmountCard extends StatefulWidget {
  final UserModel user;
  final List<dynamic>? userBag;
  const AmountCard({super.key, required this.userBag, required this.user});

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
            double? convenienceFee = total! * 10 / 100;
            double? addedTotal = total! + sGst + convenienceFee;
            final grandTotal = addedTotal.floorToDouble();
            log('grand total: $grandTotal');

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.grey[100],
                    width: double.maxFinite,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // TOTAL ROW
                          totalRow(),
                          const Gap(5),

                          // GST ROW
                          gstRow(sGst),

                          // FEE ROW
                          convinienceFeeRow(convenienceFee),

                          // GRAND TOTAL ROW
                          grandTotalRow(grandTotal),

                          // PAYEMENT BUTTON
                          paymentButton(grandTotal, context, addedTotal)
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

  Row totalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style:
              GoogleFonts.nunitoSans(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Text(
          '₹${total ??= 0}0',
          style:
              GoogleFonts.nunitoSans(fontSize: 17, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Row gstRow(double sGst) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '+ SGST 18%',
          style: GoogleFonts.nunitoSans(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        ),
        Text(
          '₹${sGst}0',
          style: GoogleFonts.nunitoSans(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }

  Row convinienceFeeRow(double convenienceFee) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Convenience fee',
          style: GoogleFonts.nunitoSans(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        ),
        Text(
          '₹${convenienceFee}0',
          style: GoogleFonts.nunitoSans(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }

  Row grandTotalRow(double grandTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Grand Total',
          style:
              GoogleFonts.nunitoSans(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          child: Text(
            '₹${grandTotal}0',
            overflow: TextOverflow.clip,
            style: GoogleFonts.nunitoSans(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  SnaccButton paymentButton(
      double grandTotal, BuildContext context, double addedTotal) {
    return SnaccButton(
        width: 130,
        textColor: Colors.black,
        btncolor: Colors.amber,
        inputText: "PAYMENT",
        callBack: () {
          if (grandTotal != 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentsPage(
                      user: widget.user,
                      amountPayable: addedTotal,
                    )));
          } else {
            showSnaccBar(context, 'No Snaccs to checkout', Colors.blue);
          }
        });
  }
}
