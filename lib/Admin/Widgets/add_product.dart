import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';

import '../../Functions/image_picker.dart';

addProductModalSheet(context, id, productlistNotifier) {
  TextEditingController productnamectrl = TextEditingController();
  TextEditingController productpricectrl = TextEditingController();
  String? selectedProductImgUrl;
  final productformkey = GlobalKey<FormState>();

  return showModalBottomSheet(
      backgroundColor: Colors.white,
      constraints: BoxConstraints.loose(const Size.fromHeight(600)),
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Form(
          key: productformkey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Add a new Product',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                          height: 80,
                          width: 80,
                          child: selectedProductImgUrl != null
                              ? Image.file(
                                  File(selectedProductImgUrl!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: Image.asset(
                                      'assets/images/no-image-available.png'),
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
                          
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: productnamectrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Product name',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: productpricectrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Price',
                  ),
                ),
                const SizedBox(height: 10),
                SnaccButton(
                  callBack: () {
                    final String productName = productnamectrl.text.trim();
                    final double productPrice =
                        double.tryParse(productpricectrl.text) ?? 0.00;
                    final categoryID = id;

                    // ADD PRODUCT
                    if (productName.isNotEmpty || productPrice.isNaN) {
                      addProduct(
                        productName,
                        productPrice,
                        selectedProductImgUrl,
                        categoryID,
                      );
                      
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Oops, Fields are empty!',
                          backgroundColor: Colors.red);
                    }

                    productnamectrl.clear();
                    productpricectrl.clear();
                  },
                  inputText: 'ADD PRODUCT',
                )
              ],
            ),
          ),
        );
      });
}
