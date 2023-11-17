import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/order_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Widgets/snacc_tile_button.dart';

class ManageStore extends StatelessWidget {
  const ManageStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .4,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Manage Store',
          style:
              GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            SnaccTileButton(
                onPressed: () {
                  Hive.box<Order>('orders').clear();
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete All Orders',
                  style: GoogleFonts.nunitoSans(color: Colors.red),
                )),
            SnaccTileButton(
                onPressed: () {
                   Hive.box<Product>('products').clear();
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete All Products',
                  style: GoogleFonts.nunitoSans(color: Colors.red),
                )),
            SnaccTileButton(
                onPressed: () {
                  Hive.box<Category>('category').clear();
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete All Categories',
                  style: GoogleFonts.nunitoSans(color: Colors.red),
                ))
          ],
        ),
      ),
    );
  }
}
