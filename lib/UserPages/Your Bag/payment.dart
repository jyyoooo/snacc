import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/order_funtions.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/UserPages/Your%20Bag/order_sucess.dart';
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snaccbar.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                child: showTotalPayable(flooredAmount),
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

              // COD
              cashOnDeliveryMethod(),

              // FUTURE FEATURES
              // const Divider(height: .5),
              // buildPaymentCard(
              //     PaymentOption.card,
              //     'Debit/Credit Card',
              //     '(coming soon)',
              //     const Icon(Icons.credit_card_rounded, color: Colors.black87),
              //     BorderRadius.zero),
              // const Divider(
              //   height: .5,
              // ),
              // buildPaymentCard(
              //     PaymentOption.payPal,
              //     'PayPal',
              //     '(coming soon)',
              //     Icon(Icons.paypal, color: Colors.blue[800]),
              //     BorderRadius.zero),
              // const Divider(
              //   height: .5,
              // ),
              // buildPaymentCard(
              //     PaymentOption.upi,
              //     'UPI',
              //     '(coming soon)',
              //     const Icon(Icons.monetization_on, color: Colors.orange),
              //     const BorderRadius.vertical(
              //         top: Radius.zero, bottom: Radius.circular(15))),
              const Gap(25),
              Text('Your snacc will be delivered to:',
                  style: GoogleFonts.nunitoSans(color: Colors.grey)),
              const Gap(5),

              showSelectedAdress(seatScreenData),
              const Gap(25),
              proceedButton(seatScreenData, flooredAmount)
            ],
          ),
        ),
      ),
    );
  }

  // WIDGETS

  SnaccButton proceedButton(
      SeatScreenData seatScreenData, double? flooredAmount) {
    return SnaccButton(
        btncolor:
            selectedPaymentOption == null ? Colors.grey[300] : Colors.amber,
        inputText: 'PROCEED',
        callBack: () async {
          if (widget.user != null) {
            log('user :${widget.user?.username}');
            final screenNum = seatScreenData.selectedScreenNumber.toString();
            final seatNum = seatScreenData.selectedSeatNumber.toString();

            final String screenAndSeatNumber = screenNum + seatNum;

            log(screenAndSeatNumber);

            if (seatScreenData.selectedScreenNumber == null &&
                seatScreenData.selectedScreenNumber != 0 &&
                seatScreenData.selectedSeatNumber == null) {
              // Fluttertoast.showToast(
              //     msg: 'select your screen and seat before placing',
              //     backgroundColor: Colors.blue);
              showSnaccBar(context,
                  'select your screen and seat before placing', Colors.blue);
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
                  widget.user!.userBag?.clear();
                  userBagNotifier.value = widget.user!.userBag ?? [];
                  userBagNotifier.notifyListeners();
                  await pushToPage();
                }
              } else if (selectedPaymentOption == PaymentOption.card ||
                  selectedPaymentOption == PaymentOption.payPal ||
                  selectedPaymentOption == PaymentOption.upi) {
                // Fluttertoast.showToast(
                //     msg: 'Selected payment method is currently unavailable',
                //     backgroundColor: Colors.blue);
                showSnaccBar(
                    context,
                    'Selected payment method is currently unavailable',
                    Colors.blue);
              } else {
                showSnaccBar(
                    context, 'select a payment method first', Colors.blue);
              }
            }
          }
        });
  }

  Row showSelectedAdress(SeatScreenData seatScreenData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Screen ',
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold, fontSize: 17)),
        Text('${seatScreenData.selectedScreenNumber ?? 'not selected'}',
            style: GoogleFonts.nunitoSans(
              color: seatScreenData.selectedScreenNumber != null
                  ? Colors.blue
                  : Colors.red,
              fontSize: seatScreenData.selectedScreenNumber != null ? 20 : 15,
              fontWeight: seatScreenData.selectedScreenNumber != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            )),
        const Gap(5),
        Text('Seat',
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold, fontSize: 17)),
        Text(' ${seatScreenData.selectedSeatNumber ?? 'not selected'}',
            style: GoogleFonts.nunitoSans(
              color: seatScreenData.selectedSeatNumber != null
                  ? Colors.blue
                  : Colors.red,
              fontSize: seatScreenData.selectedSeatNumber != null ? 20 : 15,
              fontWeight: seatScreenData.selectedSeatNumber != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ))
      ],
    );
  }

  Widget cashOnDeliveryMethod() {
    return buildPaymentCard(
        PaymentOption.cod,
        'Cash On Delivery',
        '',
        const Icon(Icons.currency_rupee, color: Colors.teal, weight: 20),
        const BorderRadius.vertical(
            top: Radius.circular(15), bottom: Radius.circular(15)));
  }

  Row showTotalPayable(double? flooredAmount) {
    return Row(
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(
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
