import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';

Future<List<DropdownMenuItem<Category>>> fetchCategories() async {
  final categoriesBox = await Hive.openBox<Category>('category');
  final categoriesList = categoriesBox.values.toList();
  final categorydropdownitems = categoriesList
      .map((category) => DropdownMenuItem<Category>(
            value: category,
            child: Row(
              children: [
                Image.file(
                  File(category.imageUrl!),
                  width: 35,
                  height: 35,
                ),
                const SizedBox(width: 8),
                Text(category.categoryName!),
              ],
            ),
          ))
      .toList();
  return categorydropdownitems;
}

List<DropdownMenuItem<Product>> fetchProducts(Category selectedCategory) {
  return (selectedCategory.products ?? []).map((product) {
    return DropdownMenuItem<Product>(
      value: product,
      child: Row(
        children: [
          product.prodimgUrl != null
              ? Image.file(
                  File(product.prodimgUrl!),
                  width: 35,
                  height: 35,
                )
              : SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/images/no-image-available.png')),
          const SizedBox(
            width: 10,
          ),
          Text(product.prodname!),
        ],
      ),
    );
  }).toList();
}

createCombo(Product? productOne, Product? productTwo, String? comboImage) async {
  final comboBox = await Hive.openBox<ComboModel>('combos');
  final comboName = await getComboName(productOne, productTwo);
  final comboPrice = await getComboPrice(productOne, productTwo);
  
  comboImage ??= 'assets/images/no-image-available.png';

  final List<Product?> comboItems = [];
  comboItems.add(productOne);
  comboItems.add(productTwo);
  // ignore:avoid_print
  print(comboName);
  // ignore:avoid_print
  print(comboItems);


  final newCombo = ComboModel(comboName: comboName, comboImgUrl: comboImage, comboPrice: comboPrice,comboItems: comboItems);
  comboBox.add(newCombo);
  // ignore:avoid_print
  print(comboBox.values.last.comboName);

  
  
}

Future<List<ComboModel>> getcomboListFromHive()async{

  final comboBox = await Hive.openBox<ComboModel>('combos');

  final List<ComboModel> combosList = comboBox.values.toList();
  // ignore:avoid_print
  print('from comboListFromHive $combosList');

  return combosList;
}

Future<double> getComboPrice(Product? p1, Product? p2) async {
  final p1Price = p1?.prodprice ??= 0;
  final p2Price = p2?.prodprice ??= 0;

  final comboPrice = p1Price! + p2Price!;
  return comboPrice;
}

Future<String?> getComboName(Product? productOne, Product? productTwo) async {
  final String? nameOne = productOne?.prodname;
  final String? nameTwo = productTwo?.prodname;
  String? comboName;

  if (nameOne != null && nameTwo != null) {
    comboName = '$nameOne & $nameTwo';
  }

  return comboName;
}
