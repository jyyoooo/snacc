import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';


ValueNotifier<List<Product>> productListNotifier = ValueNotifier([]);
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
  final updatedProductsList = await getCategoryProducts(categoryID);
  productListNotifier.value = updatedProductsList;
  productListNotifier.notifyListeners();
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
    productListNotifier.value = await getCategoryProducts(categoryID);
    productListNotifier.notifyListeners();
  }
}

// DELETE PRODUCT DIALOGBOX
deleteProductDialog(Product product, int categoryID, context,ValueNotifier<List<Product>?> productListNotifier) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete \'${product.prodname}\' ?'),
          actions: <Widget>[
            SnaccButton(
              width: 90,
              textColor: Colors.white,
              btncolor: Colors.red,
              inputText: 'DELETE',
              callBack: () async {
                final category = Hive.box<Category>('category')
                    .values
                    .firstWhere((element) => element.categoryID == categoryID);
                if (product.categoryID != null && product.productID != null) {
                  await deleteProduct(product.productID, category.categoryID);
                  productListNotifier.notifyListeners();

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

// GET ALL PRODUCTS IN A CATEGORY
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


  // void editProduct(Product product) async {
  //   final TextEditingController newprodnamectrl =
  //       TextEditingController(text: product.prodname);
  //   final TextEditingController newprodpricectrl =
  //       TextEditingController(text: "${product.prodprice}");
  //   // String? newprodImgUrl;
  //   final existingname = product.prodname;
  //   final exisitingprice = product.prodprice;
  //   // final productImg;

  //   await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text(
  //               'Edit ${product.prodname}',
  //               style: const TextStyle(color: Colors.blue),
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   const Text('New product name'),
  //                   const SizedBox(
  //                     height: 5,
  //                   ),
  //                   SnaccTextField(
  //                     controller: newprodnamectrl,
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   const Text('New product price'),
  //                   const SizedBox(
  //                     height: 5,
  //                   ),
  //                   SnaccTextField(
  //                     controller: newprodpricectrl,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: <Widget>[
  //               SnaccButton(
  //                   inputText: 'SAVE',
  //                   callBack: () async {
  //                     final currentCategory =
  //                         getCategoryById(widget.categoryID);
  //                     product.prodname = newprodnamectrl.text ?? existingname;
  //                     saveCategory(currentCategory!);
  //                     product.prodprice =
  //                         double.tryParse(newprodpricectrl.text) ??
  //                             exisitingprice;
  //                     productListNotifier.notifyListeners();
  //                     Navigator.pop(context);
  //                   })
  //             ],
  //           );
  //         });
  //       });
  // }

//   void deleteProduct(Product product) async {
//     await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             icon: const Icon(Icons.delete_forever),
//             title: const Text('Delete Product?'),
//             actions: [
//               SnaccButton(
//                   btncolor: Colors.red,
//                   inputText: 'Delete',
//                   callBack: () {
//                     Category? currentCategory = getCategoryById(widget.id);

//                     final int productindex = currentCategory!.products!
//                         .indexWhere((element) => element == product);

//                     currentCategory.products!.removeAt(productindex);

//                     saveCategory(currentCategory);
//                     Navigator.of(context).pop();

//                     productlistNotifier.notifyListeners();
//                   })
//             ],
//           );
//         });
//   }
// }
