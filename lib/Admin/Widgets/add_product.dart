import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

import '../../Functions/image_picker.dart';

class AddProductModalSheet extends StatefulWidget {
  final ValueNotifier<List<Product>?> productListNotifier;
  final int? categoryID;
  const AddProductModalSheet(
      {super.key, this.categoryID, required this.productListNotifier});

  @override
  AddProductModalSheetState createState() => AddProductModalSheetState();

  static void show(BuildContext context, GlobalKey<FormState> formKey,
      int categoryID, productListNotifier) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        constraints: const BoxConstraints.expand(),
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return AddProductModalSheet(
            categoryID: categoryID,
            productListNotifier: productListNotifier,
          );
        });
  }
}

class AddProductModalSheetState extends State<AddProductModalSheet> {
  TextEditingController productnamectrl = TextEditingController();
  TextEditingController productpricectrl = TextEditingController();
  String? selectedProductImgUrl;
  final productformkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Add a New Product',
            style: GoogleFonts.nunitoSans(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Gap(10),
          Text(
            'Select image for the product',
            style: GoogleFonts.nunitoSans(fontSize: 15, color: Colors.blue),
          ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: selectedProductImgUrl != null
                        ? Image.file(
                            File(selectedProductImgUrl!),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Image.asset(
                              'assets/images/no-image-available.png',
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
              SnaccButton(
                  width: 60,
                  btncolor: Colors.white70,
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.blue,
                  ),
                  inputText: '',
                  callBack: () async {
                    selectedProductImgUrl = await pickImageFromGallery();
                    setState(() {});
                  }),
            ],
          ),
          const Gap(10),
          SnaccTextField(
            controller: productnamectrl,
            label: 'Product name',
            // validationMessage: 'Product name is required',
          ),
          const Gap(5),
          SnaccTextField(
            controller: productpricectrl,
            label: 'Price',
            // validationMessage: 'Price is required',
          ),
          const Gap(10),
          SnaccButton(
            textColor: Colors.white,
            callBack: () {
              final String productName = productnamectrl.text.trim();
              final double productPrice =
                  double.tryParse(productpricectrl.text) ?? 0.00;
              final categoryID = widget.categoryID!;

              // ADD PRODUCT
              if (productName.isNotEmpty || productPrice.isNaN) {
                addProduct(
                  productName,
                  productPrice,
                  selectedProductImgUrl,
                  categoryID,
                );
                widget.productListNotifier.notifyListeners();
                Fluttertoast.showToast(
                    msg: '$productName added', backgroundColor: Colors.amber);
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(
                    msg: 'Oops, Fields are empty!',
                    backgroundColor: Colors.red);
              }
              productnamectrl.clear();
              productpricectrl.clear();
              selectedProductImgUrl = null;
            },
            inputText: 'ADD PRODUCT',
          )
        ],
      ),
    );
  }
}
