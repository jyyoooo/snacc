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

class UserBag extends StatefulWidget {
  const UserBag({super.key});

  @override
  State<UserBag> createState() => _UserBagState();
}

class _UserBagState extends State<UserBag> {
  UserModel? user;
  List<dynamic>? userBag;
  ValueNotifier<List<dynamic>?> userBagNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      setState(() {
        this.user = user;

        userBag = user.userBag ?? [];
        log('userBag items prices in initState: ${userBag?.map((e) => e is ComboModel ? e.comboPrice : e is Product ? e.prodprice : null)}');
        userBagNotifier.value = userBag;
        userBagNotifier.notifyListeners();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Your Bag',
            style: GoogleFonts.nunitoSans(
                fontSize: 23, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
              onPressed: () {
                user!.userBag!.clear();
                Hive.box<UserModel>('userinfo').put(user!.userID, user!);
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
            child: BagListBuilder(userBagNotifer: userBagNotifier, user: user)),
        ValueListenableBuilder<List<dynamic>?>(
            valueListenable: userBagNotifier,
            builder: (context, userBag, child) {
              if (userBag != null && user != null) {
                return Positioned(
                  height: 290,
                  bottom: 0,
                  left: 0,
                  right: 0,

                  // AMOUNT CARD
                  child: AmountCard(
                    user: user!,
                    userBag: userBag,
                  ),
                );
              } else {
                log('loading...');
                return const CircularProgressIndicator();
              }
            })
      ]),
    );
  }
}
