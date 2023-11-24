import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/UserPages/Your%20Bag/amount_card.dart';
import 'package:snacc/UserPages/Your%20Bag/bag_list_builder.dart';
import 'package:snacc/Widgets/snacc_button.dart';

import '../../Functions/user_bag_function.dart';

class UserBag extends StatefulWidget {
  final UserModel? user;
  const UserBag({super.key, required this.user});

  @override
  State<UserBag> createState() => _UserBagState();
}

class _UserBagState extends State<UserBag> {
  // List<dynamic>? currentUserBag;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.user?.userBag != null) {
        userBagNotifier.value = widget.user!.userBag!;
        userBagNotifier.notifyListeners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: yourBagTitle(),
        actions: [
          userBagNotifier.value.isNotEmpty
              ? removeAllBagItems(context)
              : removeAllDummy()
        ],
      ),
      body: Stack(children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height - 300,
          width: MediaQuery.of(context).size.width,

          // BAG LIST
          child: userBagNotifier.value.isNotEmpty
              ? BagListBuilder(user: widget.user)
              : emptyBagMessage(),
        ),

        // AMOUNT CARD
        showAmountCard()
      ]),
    );
  }



  // WIDGETS

  ValueListenableBuilder<List<dynamic>?> showAmountCard() {
    return ValueListenableBuilder<List<dynamic>?>(
        valueListenable: userBagNotifier,
        builder: (context, userBag, child) {
          return Positioned(
            height: 262,
            bottom: 1,
            left: 0,
            right: 0,
            child: AmountCard(
              user: widget.user!,
              userBag: userBag,
            ),
          );
        });
  }

  Center emptyBagMessage() {
    return Center(
        child: Text(
      'Bag is empty',
      style: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 15),
    ));
  }

  TextButton removeAllDummy() {
    return TextButton(
        onPressed: () {},
        child: Text(
          'Remove All',
          style: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 14),
        ));
  }

  TextButton removeAllBagItems(BuildContext context) {
    return TextButton(
        onPressed: () {
          removeAllItemsInBagDialog(context);
        },
        child: Text(
          'Remove All',
          style: GoogleFonts.nunitoSans(color: Colors.red, fontSize: 14),
        ));
  }

  Text yourBagTitle() {
    return Text('Your Bag',
        style:
            GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold));
  }

  Future<dynamic> removeAllItemsInBagDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Remove all items in your Bag?',
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              actions: [
                SnaccButton(
                    textColor: Colors.white,
                    btncolor: Colors.red,
                    width: 110,
                    inputText: 'Remove',
                    callBack: () {
                      widget.user!.userBag?.clear();
                      Hive.box<UserModel>('userinfo')
                          .put(widget.user?.userID, widget.user!);
                      userBagNotifier.value = widget.user!.userBag!;
                      setState(() {});
                      userBagNotifier.notifyListeners();
                      Navigator.pop(context);
                    })
              ],
            ));
  }
}
