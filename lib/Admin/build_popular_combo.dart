import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Admin/Widgets/combo_dropdown.dart';
import 'package:snacc/Admin/Widgets/product_image_row.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

class PopularCombo extends StatefulWidget {
  // final void Function(ComboModel) onComboCreated;
  const PopularCombo({
    super.key,
    // required this.onComboCreated
  });

  @override
  State<PopularCombo> createState() => _PopularComboState();
}

class _PopularComboState extends State<PopularCombo> {
  TextEditingController description = TextEditingController();
  Product? selectedProduct;
  Product? productOne;
  Product? productTwo;
  String? pickedImage;
  double? comboPrice;
  String? comboName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR //
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: .4,
          title: Text(
            'Create Combo',
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold, fontSize: 23),
          )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // CHOOSE PRODUCT //
              ComboItemList(onProductSelected: handleSelectedProduct),
              SnaccButton(
                width: 70,
                btncolor: Colors.amber,
                inputText: 'ADD',
                callBack: () async {
                  if (selectedProduct != null) {
                    updateImages();
                    setState(() {});
                  } else {
                    // ignore: avoid_print
                    print('no product selected');
                  }
                  comboPrice = await getComboPrice(productOne, productTwo);
                  comboName = await getComboName(productOne, productTwo);
                },
              ),

              const SizedBox(height: 10),

              // SHOW SELECTED PRODUCT IMAGE //
              ProductImageRow(
                productOne: productOne,
                productTwo: productTwo,
              ),
              const SizedBox(
                height: 15,
              ),

              // SHOW COMBO PRICE
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    color: Colors.grey[300],
                    height: 40,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ' ${comboName ??= 'Combo Name'}',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '₹ ${comboPrice ??= 0.00}',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )),
              ),
              SnaccTextField(
                  controller: description, label: 'Combo description'),
              const SizedBox(
                height: 20,
              ),

              // PICK COMBO IMAGE //
              Text(
                'Select combo image',
                style: GoogleFonts.nunitoSans(fontSize: 17, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: pickedImage != null
                        ? Image.file(File(pickedImage!))
                        : Center(
                            child: Text(
                            'No Image selected',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                                color: Colors.grey, fontSize: 15),
                          )),
                  ),
                  SnaccButton(
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.blue,
                    ),
                    inputText: '',
                    callBack: () async {
                      final String? pickedImagePath =
                          await pickImageFromGallery();
                      setState(() {
                        pickedImage = pickedImagePath;
                      });

                      log('pickedImagePath: $pickedImagePath');
                    },
                    width: 60,
                    btncolor: Colors.white70,
                  ),
                ],
              ),

              // ADD COMBO TO HIVE
              SnaccButton(
                  textColor: Colors.white,
                  inputText: 'CREATE COMBO',
                  callBack: () async {
                    final comboCreated =
                        await createCombo(productOne, productTwo, pickedImage,description.text);

                    if (comboCreated == true) {
                      setState(() {});
                      Fluttertoast.showToast(
                          backgroundColor: Colors.green, msg: "Combo Created!");
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                          backgroundColor: Colors.red,
                          msg: "Add something first!");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void handleSelectedProduct(Product? product) {
    setState(() {
      selectedProduct = product;
    });
  }

  void updateImages() {
    if (productOne == null) {
      productOne = selectedProduct;
      setState(() {
        productOne = selectedProduct;
      });
    } else if (productTwo == null) {
      productTwo = selectedProduct;
    } else {
      //ignore: avoid_print
      print('products already assigned');
    }
  }
}
