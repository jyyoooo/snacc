import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/order_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Widgets/snacc_button.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Column(
            children: [
              SnaccTileButton(
                  onPressed: () {
                    deleteAllOrdersDialog(context);
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
                    deleteAllProductsDialog(context);
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
                    deleteAllCategoriesDialog(context);
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
      ),
    );
  }

  Future<dynamic> deleteAllCategoriesDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Are you sure to delete all categories at once?',
                style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Warning: All data will be lost',
                      style: GoogleFonts.nunitoSans(color: Colors.red)),
                  Text('tap outside to cancel',
                      style: GoogleFonts.nunitoSans(color: Colors.grey))
                ],
              ),
              actions: [
                SnaccButton(
                    btncolor: Colors.red,
                    textColor: Colors.white,
                    inputText: 'DELETE',
                    callBack: () {
                      Hive.box<Category>('category').clear();
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'Deleted all Categories',
                          backgroundColor: Colors.blue);
                    })
              ],
            ));
  }

  Future<dynamic> deleteAllProductsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Are you sure to delete all products at once?',
                style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Warning: All data will be lost',
                      style: GoogleFonts.nunitoSans(color: Colors.red)),
                  Text('tap outside to cancel',
                      style: GoogleFonts.nunitoSans(color: Colors.grey))
                ],
              ),
              actions: [
                SnaccButton(
                    btncolor: Colors.red,
                    textColor: Colors.white,
                    inputText: 'DELETE',
                    callBack: () {
                      Hive.box<Product>('products').clear();
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'Deleted all Products',
                          backgroundColor: Colors.blue);
                    })
              ],
            ));
  }

  Future<dynamic> deleteAllOrdersDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              'Are you sure to delete all orders at once?',
              style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Warning: All data will be lost',
                    style: GoogleFonts.nunitoSans(color: Colors.red)),
                Text('tap outside to cancel',
                    style: GoogleFonts.nunitoSans(color: Colors.grey))
              ],
            ),
            actions: [
              SnaccButton(
                  btncolor: Colors.red,
                  textColor: Colors.white,
                  inputText: 'DELETE',
                  callBack: () {
                    Hive.box<Order>('orders').clear();
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: 'Deleted all Orders',
                        backgroundColor: Colors.blue);
                  })
            ],
          ));
}
