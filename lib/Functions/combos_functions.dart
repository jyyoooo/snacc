import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/category_model.dart';

// FETCH CATEGORIES + +

Future<List<DropdownMenuItem<Category>>> fetchCategories() async {
  final categoriesBox = Hive.box<Category>('category');
  final categoriesList = categoriesBox.values.toList();
  final categorydropdownitems = categoriesList
      .map((category) => DropdownMenuItem<Category>(
            value: category,
            child: Row(
              children: [
                category.imageUrl != null 
                    ? Image.file(
                        File(category.imageUrl!),
                        width: 35,
                        height: 35,
                      )
                    : SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/images/no-image-available.png')),
                const SizedBox(width: 8),
                Text(category.categoryName!),
              ],
            ),
          ))
      .toList();
  return categorydropdownitems;
}

// FETCH PRODUCTS + +

List<DropdownMenuItem<Product>> fetchProducts(Category selectedCategory) {
  final allProducts = Hive.box<Product>('products').values.toList();
  return (selectedCategory.productsReference ?? []).map((productID) {
    final product = allProducts.firstWhere(
      (product) => product.productID == productID,
      orElse: () => Product(
          description: '',
          prodname: "Product not found",
          prodprice: null,
          prodimgUrl: null),
    );
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
          SizedBox(width:80,child: Text(product.prodname!,overflow: TextOverflow.fade,)),
        ],
      ),
    );
  }).toList();
}

// CREATE COMBO + +

final ValueNotifier<List<ComboModel>> comboListNotifier = ValueNotifier([]);

Future<bool> createCombo(
    Product? productOne, Product? productTwo, String? comboImage,String? description) async {
  if (productOne == null || productTwo == null) {
    return false;
  }
  final comboBox = await Hive.openBox<ComboModel>('combos');
  final comboName = await getComboName(productOne, productTwo);
  final comboPrice = await getComboPrice(productOne, productTwo);

  final List<Product?> comboItems = [];
  comboItems.add(productOne);
  comboItems.add(productTwo);

  log('$comboName');
  log("$comboItems");

  final newCombo = ComboModel(
      comboName: comboName,
      comboImgUrl: comboImage,
      comboPrice: comboPrice,
      comboItems: comboItems,
      description: description
      );
      

  final id = await comboBox.add(newCombo);
  newCombo.comboID = id;

  await comboBox.put(id, comboBox.values.last);

  log('${comboBox.values.last.comboName}');
  if (comboBox.values.last == newCombo) {
    comboListNotifier.value.add(newCombo);
    comboListNotifier.notifyListeners();
    return true;
  }
  return false;
}

// DELETE COMBO + +

void deleteCombo(int id) async {
  final comboBox = await Hive.openBox<ComboModel>('combos');
  comboBox.delete(id);

  comboListNotifier.value.removeWhere((combo) => combo.comboID == id);
  comboListNotifier.notifyListeners();
}

// GET COMBO FROM HIVE Database + +

Future<List<ComboModel>> getcomboListFromHive() async {
  final comboBox = await Hive.openBox<ComboModel>('combos');

  final List<ComboModel> combosList = comboBox.values.toList();

  return combosList;
}

// GET COMBO PRICE + +

Future<double> getComboPrice(Product? p1, Product? p2) async {
  final p1Price = p1?.prodprice ?? 0;
  final p2Price = p2?.prodprice ?? 0;

  final comboPrice = p1Price + p2Price;
  return comboPrice;
}

// GET COOMBO NAME + +

Future<String?> getComboName(Product? productOne, Product? productTwo) async {
  final String? nameOne = productOne?.prodname;
  final String? nameTwo = productTwo?.prodname;
  String? comboName;

  if (nameOne != null && nameTwo != null) {
    comboName = '$nameOne & $nameTwo';
  }

  return comboName;
}

//  EDIT COMBO

void editCombo() async {}

Future<List<ComboModel>> getAllCombos() async {
  final comboBox = await Hive.openBox<ComboModel>('combos');
  return comboBox.values.toList();
}

deleteComboDialog(
  context,
  ComboModel combo,
) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${combo.comboName} Combo?'),
          // content: const Text('tap outside to cancel',style: TextStyle(color: Colors.grey),),
          actions: <Widget>[
            SnaccButton(
              width: 90,
              textColor: Colors.white,
              btncolor: Colors.red,
              inputText: 'DELETE',
              callBack: () {
                if (combo.comboID != null) {
                  deleteCombo(combo.comboID!);

                  Navigator.of(context).pop();

                  log('deleted id = ${combo.comboID!}');
                } else {
                  log('deletion error');
                }
              },
            )
          ],
        );
      });
}
