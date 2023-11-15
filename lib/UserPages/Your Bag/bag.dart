import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/UserPages/Your%20Bag/amount_card.dart';
import 'package:snacc/UserPages/Your%20Bag/bag_list_builder.dart';
import 'package:snacc/UserPages/favorites.dart';
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
          TextButton(
              onPressed: () {
                widget.user!.userBag?.clear();
                Hive.box<UserModel>('userinfo')
                    .put(widget.user?.userID, widget.user!);
                userBagNotifier.value = widget.user!.userBag!;
                userBagNotifier.notifyListeners();
              },
              child: Text(
                'Remove All',
                style: GoogleFonts.nunitoSans(color: Colors.red, fontSize: 15),
              ))
        ],
      ),
      body: Stack(children: <Widget>[
        Positioned(
          // BAG LIST
          child: userBagNotifier.value.isNotEmpty
              ? BagListBuilder(user: widget.user)
              :  Center(
                  child:
                  // SizedBox.shrink()
                   Text(
                  'Bag is empty',
                  style:
                      GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 17),
                )
                ),
        ),
        ValueListenableBuilder<List<dynamic>?>(
            valueListenable: userBagNotifier,
            builder: (context, userBag, child) {
              // if (userBag != null && widget.user != null) {
              return Positioned(
                height: 290,
                bottom: 0,
                left: 0,
                right: 0,

                // AMOUNT CARD
                child: AmountCard(
                  user: widget.user!,
                  userBag: userBag,
                ),
              );
              // } else {
              //   log('loading...');
              //   return const Center(
              //       child: CircularProgressIndicator(
              //     color: Colors.amber,
              //   ));
              // }
            })
      ]),
    );
  }
}
