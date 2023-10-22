import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/Admin/Widgets/combo_list.dart';
import 'package:snacc/Admin/Widgets/product_image_row.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Widgets/button.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';

class PopularCombo extends StatefulWidget {
  const PopularCombo({super.key});
  

  @override
  State<PopularCombo> createState() => _PopularComboState();
}

class _PopularComboState extends State<PopularCombo> {
  Product? selectedProduct;
  Product? productOne;
  Product? productTwo;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SnaccAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Create Combo'))),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ComboItemList(onProductSelected: handleSelectedProduct),


            SnaccButton(
              inputText: 'ADD',
              callBack: () {
                if (selectedProduct != null) {
                  updateImages();
                  setState(() {});
                } else {
                  // ignore: avoid_print
                  print('no product selected');
                }
              },
            ),
            const SizedBox(height: 10),
            ProductImageRow( 
              productOne: productOne,
              productTwo: productTwo,
            ),
          ],
        ),
      ),
    );
  }
}
