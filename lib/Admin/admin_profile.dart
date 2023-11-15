import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';
import 'package:snacc/Widgets/snacc_tile_button.dart';

class AdminAccount extends StatelessWidget {
  const AdminAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(30), child: SnaccAppBar()),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Gap(10),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red[50],
                      child: const Icon(
                        Icons.person,
                        size: 40,color: Colors.red,
                      ),
                    ),
                    const Gap(20),
                    const Text('Admin',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
            const Gap(450),
            SnaccTileButton(
                onPressed: () {
                  logOutAdmin(context);
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout Admin',
                  style: GoogleFonts.nunitoSans(color: Colors.red),
                ))
          ],
        ),
      ),
    ));
  }
}
