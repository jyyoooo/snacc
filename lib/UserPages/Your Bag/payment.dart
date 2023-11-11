import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/order_funtions.dart';
import 'package:snacc/UserPages/Your%20Bag/order_sucess.dart';
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class PaymentsPage extends StatefulWidget {
  final UserModel? user;
  final double? amountPayable;

  const PaymentsPage(
      {super.key, required this.amountPayable, required this.user});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  
  PaymentOption? selectedPaymentOption;

  @override
  Widget build(BuildContext context) {
    var seatScreenData = context.read<SeatScreenData>();
    final flooredAmount = widget.amountPayable?.floorToDouble();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Payment',
          style:
              GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              const Gap(60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payable:',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    Text(
                      '₹$flooredAmount',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(35),
              Text(
                'Select payment method',
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const Gap(10),
              buildPaymentCard(
                  PaymentOption.cod,
                  'Cash On Delivery',
                  '',
                  const Icon(Icons.currency_rupee,
                      color: Colors.teal, weight: 20),
                  const BorderRadius.vertical(
                      top: Radius.circular(15), bottom: Radius.zero)),
              const Divider(
                height: .5,
              ),
              buildPaymentCard(
                  PaymentOption.card,
                  'Debit/Credit Card',
                  '(coming soon)',
                  const Icon(Icons.credit_card_rounded, color: Colors.black87),
                  BorderRadius.zero),
              const Divider(
                height: .5,
              ),
              buildPaymentCard(
                  PaymentOption.payPal,
                  'PayPal',
                  '(coming soon)',
                  Icon(Icons.paypal, color: Colors.blue[800]),
                  BorderRadius.zero),
              const Divider(
                height: .5,
              ),
              buildPaymentCard(
                  PaymentOption.upi,
                  'UPI',
                  '(coming soon)',
                  const Icon(Icons.monetization_on, color: Colors.orange),
                  const BorderRadius.vertical(
                      top: Radius.zero, bottom: Radius.circular(15))),
              const Gap(50),
              SnaccButton(
                  btncolor: selectedPaymentOption == null
                      ? Colors.grey[300]
                      : Colors.amber,
                  inputText: 'PROCEED',
                  callBack: () async {
                    if (widget.user != null) {
                      log('user :${widget.user?.username}');
                      
                      final String screenAndSeatNumber =
                          '${seatScreenData.selectedScreenNumber}' +
                              '${seatScreenData.selectedSeatNumber.toString()}';

                      log(screenAndSeatNumber);

                      if (seatScreenData.selectedScreenNumber == null && seatScreenData.selectedScreenNumber != 0 &&
                          seatScreenData.selectedSeatNumber == null) {
                        Fluttertoast.showToast(
                            msg: 'select your screen and seat before placing',
                            backgroundColor: Colors.blue);
                      } else {
                        if (selectedPaymentOption == PaymentOption.cod) {
                          final bool orderCreated = await createOrder(
                            widget.user?.userID,
                            widget.user!.userBag,
                            flooredAmount!,
                            selectedPaymentOption!,
                            screenAndSeatNumber,
                          );

                          if (orderCreated) {
                            await pushToPage();
                          }
                        } else if (selectedPaymentOption ==
                                PaymentOption.card ||
                            selectedPaymentOption == PaymentOption.payPal ||
                            selectedPaymentOption == PaymentOption.upi) {
                          Fluttertoast.showToast(
                              msg:
                                  'Selected payment method is currently unavailable',
                              backgroundColor: Colors.blue);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'select a payment method first',
                              backgroundColor: Colors.blue);
                        }
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentCard(
    PaymentOption value,
    String title,
    String subtitle,
    Icon icon,
    BorderRadiusGeometry? borderRadius,
  ) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ??
              const BorderRadius.all(Radius.elliptical(15, 15))),
      child: InkResponse(
        onTap: () {
          setState(() {
            selectedPaymentOption = value;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<PaymentOption>(
                    activeColor: Colors.blue,
                    value: value,
                    groupValue: selectedPaymentOption,
                    onChanged: (PaymentOption? selectedValue) {
                      setState(() {
                        selectedPaymentOption = selectedValue;
                      });
                    },
                  ),
                  icon,
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.5,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pushToPage() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrderSuccess(
              userID: widget.user!.userID!,
            )));
  }
}

enum PaymentOption {
  cod,
  card,
  payPal,
  upi,
}

class PaymentOptionAdapter extends TypeAdapter<PaymentOption> {
  @override
  final int typeId = 7;

  @override
  PaymentOption read(BinaryReader reader) {
    return PaymentOption.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, PaymentOption paymentOption) {
    writer.writeByte(paymentOption.index);
  }
}
