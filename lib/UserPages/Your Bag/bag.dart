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
      if (widget.user!.userBag != null) {
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
        title: Text('Your Bag',
            style: GoogleFonts.nunitoSans(
                fontSize: 23, fontWeight: FontWeight.bold)),
        actions: [
          userBagNotifier.value.isNotEmpty
              ? TextButton(
                  onPressed: () {
                    removeAllItemsInBag(context);
                  },
                  child: Text(
                    'Remove All',
                    style:
                        GoogleFonts.nunitoSans(color: Colors.red, fontSize: 14),
                  ))
              : TextButton(
                  onPressed: () {},
                  child: Text(
                    'Remove All',
                    style: GoogleFonts.nunitoSans(
                        color: Colors.grey, fontSize: 14),
                  ))
        ],
      ),
      body: Stack(children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height - 300,
          width: MediaQuery.of(context).size.width,
          // BAG LIST
          child: userBagNotifier.value.isNotEmpty
              ? BagListBuilder(user: widget.user)
              : Center(
                  child: Text(
                  'Bag is empty',
                  style:
                      GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 15),
                )),
        ),
        ValueListenableBuilder<List<dynamic>?>(
            valueListenable: userBagNotifier,
            builder: (context, userBag, child) {
              // if (userBag != null && widget.user != null) {
              return Positioned(
                height: 277,
                bottom: 1,
                left: 0,
                right: 0,

                // AMOUNT CARD
                child: AmountCard(
                  user: widget.user!,
                  userBag: userBag,
                ),
              );
            })
      ]),
    );
  }

  Future<dynamic> removeAllItemsInBag(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Remove all items in your Bag?',
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              actions: [
                SnaccButton(
                    textColor: Colors.white,
                    btncolor: Colors.red,
                    width: 100,
                    inputText: 'REMOVE',
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
