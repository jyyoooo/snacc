import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
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
          product.prodimgUrl == null
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

addProductToComboList(Product selectedProduct) async {}
