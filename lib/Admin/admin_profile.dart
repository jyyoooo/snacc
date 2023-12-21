import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Admin/Widgets/manage_store.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_tile_button.dart';

class AdminAccount extends StatelessWidget {
  const AdminAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        elevation: .4,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: title(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // admin profile card
                profileCard(),
                const Gap(20),
                // manage store button
                manageStoreTile(context),
                const Gap(10),
                // logout of admin button
                logoutAdminTile(context),
                const Gap(10),
              ],
            ),
          ],
        ),
      ),
    ));
  }



  // WIDGETS

  SnaccTileButton logoutAdminTile(BuildContext context) {
    return SnaccTileButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'Logout of Admin?',
                      style:
                          GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      SnaccButton(
                          width: 120,
                          btncolor: Colors.red,
                          textColor: Colors.white,
                          inputText: 'Logout',
                          callBack: () {
                            logOutAdmin(context);
                          })
                    ],
                  ));
        },
        icon: const Icon(
          Icons.logout_rounded,
          color: Colors.red,
        ),
        title: Text(
          'Logout Admin',
          style: GoogleFonts.nunitoSans(color: Colors.red),
        ));
  }

  SnaccTileButton manageStoreTile(BuildContext context) {
    return SnaccTileButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ManageStore()));
        },
        icon: Icon(
          Icons.storefront_outlined,
          color: Colors.blue[800],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manage Store',
              style: GoogleFonts.nunitoSans(),
            ),
            const Gap(5),
            Icon(
              Icons.warning_rounded,
              color: Colors.amber[600],
            )
          ],
        ));
  }

  Card profileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(10),
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue[50],
              child: const Icon(
                Icons.admin_panel_settings_sharp,
                size: 40,
                color: Colors.blue,
              ),
            ),
            const Gap(20),
            Text('Admin',
                style: GoogleFonts.nunitoSans(
                    fontSize: 20, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Text title() {
    return Text(
      'Profile',
      style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 23),
    );
  }
}
