import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/UserPages/user_profile/purchase_history.dart';
import 'package:snacc/UserPages/user_profile/track_order.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Authentication/login.dart';
import '../../Widgets/snacc_tile_button.dart';

class UserAccount extends StatefulWidget {
  final UserModel? user;
  const UserAccount({
    this.user,
    Key? key,
  }) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const ProfileTitile(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // USERNAME CARD
            UserCard(widget: widget),
            const SizedBox(height: 30),

            // TRACK ORDER
            TrackYourOrder(widget: widget),

            // PURCHASE HISTORY
            PurchaseHistoryButton(widget: widget),

            // LOGOUT BUTTON
            Logout(widget: widget),
          ],
        ),
      ),
    );
  }
}

// WIDGETS

class ProfileTitile extends StatelessWidget {
  const ProfileTitile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Your Profile',
      style: GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
    );
  }
}

class TrackYourOrder extends StatelessWidget {
  const TrackYourOrder({
    super.key,
    required this.widget,
  });

  final UserAccount widget;

  @override
  Widget build(BuildContext context) {
    return SnaccTileButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TrackOrders(
              userID: widget.user!.userID!,
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.track_changes,
        color: Colors.green,
      ),
      title: Text(
        'Track Your Order',
        style: GoogleFonts.nunitoSans(color: Colors.black, fontSize: 17),
      ),
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({
    super.key,
    required this.widget,
  });

  final UserAccount widget;

  @override
  Widget build(BuildContext context) {
    return SnaccTileButton(
      title: Text(
        'Logout',
        style: GoogleFonts.nunitoSans(color: Colors.red, fontSize: 17),
      ),
      icon: const Icon(
        Icons.logout_rounded,
        color: Colors.red,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                SnaccButton(
                  textColor: Colors.white,
                  btncolor: Colors.red,
                  inputText: 'Logout',
                  callBack: () {
                    logoutUser(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                ),
              ],
              title: Text(
                'Are you sure to logout of ${widget.user!.username}?',
                style: GoogleFonts.nunitoSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}

class PurchaseHistoryButton extends StatelessWidget {
  const PurchaseHistoryButton({
    super.key,
    required this.widget,
  });

  final UserAccount widget;

  @override
  Widget build(BuildContext context) {
    return SnaccTileButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PurchaseHistory(
              userID: widget.user!.userID!,
            ),
          ),
        );
      },
      icon: Icon(
        Icons.history_rounded,
        color: Colors.indigo[400],
      ),
      title: Text(
        'Purchase History',
        style: GoogleFonts.nunitoSans(color: Colors.black, fontSize: 17),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.widget,
  });

  final UserAccount widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(10),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.lightGreenAccent[200],
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Gap(25),
            Text(
              widget.user?.username ?? 'internal error',
              style: GoogleFonts.nunitoSans(
                  fontSize: 23, fontWeight: FontWeight.bold),
            ),
            // Expanded(
            //     child: Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) =>  EditProfile(user: widget.user!,)));
            //         },
            //         icon: const Icon(
            //           Icons.edit_note,
            //           color: Colors.blue,
            //         )),
            //   ],
            // ))
          ],
        ),
      ),
    );
  }
}
