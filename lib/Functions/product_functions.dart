import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';

// ADD PRODUCT
Future<void> addProduct(
  String prodName,
  double prodPrice,
  String? prodImgUrl,
  int categoryID,
) async {
  final product = Product(
    prodname: prodName,
    prodprice: prodPrice,
    prodimgUrl: prodImgUrl,
    categoryID: categoryID,
  );

  final productID = await addProductToCategory(product, categoryID);
  product.productID = productID;

  final productBox = Hive.box<Product>('products');
  await productBox.put(productID, product);
  log('added ${product.prodname} id: ${product.productID}');
  log('all products in box : ${Hive.box<Product>('products').values.toList().map((product) => product.prodname)}');
}

// ADD PRODUCT TO CATEGORY
Future<int> addProductToCategory(Product product, int categoryID) async {
  final productBox = Hive.box<Product>('products');
  final productID = await productBox.add(product);

  final category = getCategoryById(categoryID);
  if (category != null) {
    category.productsReference?.add(productID);
    log('cat pro ref: ${category.productsReference}');
    saveCategory(category);
  }

  return productID;
}

// EDIT PRODUCT
void editProduct(Product product, int? categoryID) async {
  final productBox = Hive.box<Product>('products');
  await productBox.put(product.productID, product);

  final category = getCategoryById(categoryID);

  if (category != null &&
      category.productsReference != null &&
      !category.productsReference!.contains(product.productID)) {
    category.productsReference!.add(product.productID!);
    saveCategory(category);
  }
}

// DELETE PRODUCT
deleteProduct(int? productID, int? categoryID) async {
  final productBox = await Hive.openBox<Product>('product');
  final categoryBox = await Hive.openBox<Category>('category');
  await productBox.delete(productID);

  final category = categoryBox.get(categoryID);

  log('deleted product: $productID');
  if (category != null) {
    category.productsReference?.remove(productID);
    saveCategory(category);
  }
}

deleteProductDialog(Product product, int categoryID, context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete "${product.prodname}" category?'),
          // content: const Text('tap outside to cancel',style: TextStyle(color: Colors.grey),),
          actions: <Widget>[
            SnaccButton(
              btncolor: Colors.red,
              inputText: 'Delete',
              callBack: () async {
                final category = Hive.box<Category>('category')
                    .values
                    .firstWhere((element) => element.categoryID == categoryID);
                if (product.categoryID != null && product.productID != null) {
                  deleteProduct(product.productID, category.categoryID);

                  Navigator.of(context).pop();

                  log('deleted id = ${category.categoryID}');
                } else {
                  log('deletion error');
                }
              },
            )
          ],
        );
      });
}

Future<List<Product>> getCategoryProducts(int? categoryId) async {
  if (categoryId == null) {
    log('categoryID null');
    return [];
  }

  final categoryBox = Hive.box<Category>('category');
  final category = categoryBox.get(categoryId);

  if (category == null) {
    log('category null');
    return [];
  }

  final productBox = Hive.box<Product>('products');
  final List<int>? productIDs = category.productsReference;

  if (productIDs == null) {
    log('productIDs null');
    return [];
  }

  final List<Product> products = productIDs
      .map((productID) => productBox.get(productID))
      .where((product) => product != null)
      .cast<Product>()
      .toList();

  return products;
}
