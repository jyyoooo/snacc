import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

ValueNotifier<List<Product>> productListNotifier = ValueNotifier([]);
// ADD PRODUCT
Future<void> addProduct(
  String prodName,
  double prodPrice,
  String? prodImgUrl,
  int categoryID,
) async {
  final product = Product(
    description: null,
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

// // EDIT PRODUCT
// void editProduct(Product product, int? categoryID) async {
//   final productBox = Hive.box<Product>('products');
//   await productBox.put(product.productID, product);

//   final category = getCategoryById(categoryID);

//   if (category != null &&
//       category.productsReference != null &&
//       !category.productsReference!.contains(product.productID)) {
//     category.productsReference!.add(product.productID!);
//     saveCategory(category);
//   }
// }

// void editProductDialog(Product product, int categoryID, context,
//    ) async {
//   TextEditingController newNameController =
//       TextEditingController(text: product.prodname);
//   TextEditingController newPriceController =
//       TextEditingController(text: product.prodprice.toString());
//   TextEditingController descriptionController =
//       TextEditingController(text: product.description);
//   String? newImage;

//   await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog.adaptive(
//           title: Text(
//             'Edit ${product.prodname}',
//             style: GoogleFonts.nunitoSans(),
//           ),
//           content: SizedBox(
//             height: 350,
//             child: Column(
//               children: [
//                 SizedBox.square(
//                   dimension: 80,
//                   child: product.prodimgUrl != null
//                       ? Image.file(File(product.prodimgUrl!))
//                       : Image.asset('assets/images/no-image-available.png'),
//                 ),
//                 SnaccButton(
//                   btncolor: Colors.white,
//                   textColor: Colors.blue,
//                     width: 80,
//                     icon: const Icon(Icons.image,color: Colors.blue,),
//                     inputText: '',
//                     callBack: () async {
//                       newImage = await pickImageFromGallery();
//                     }),
//                 SnaccTextField(
//                   controller: newNameController,
//                   label: 'Product Name',
//                 ),
//                 SnaccTextField(
//                   controller: newPriceController,
//                   label: 'Price',
//                 ),
//                 SnaccTextField(
//                     controller: descriptionController, label: 'Description')
//               ],
//             ),
//           ),
//           actions: [
//             SnaccButton(
//               inputText: 'SAVE',
//               callBack: () {
//                 final productsBox = Hive.box<Product>('products');

//                 product.prodname = newNameController.text;
//                 product.prodprice = double.tryParse(newPriceController.text);
//                 product.prodimgUrl = newImage ?? product.prodimgUrl;
//                 productsBox.put(product.productID, product);
//                 productListNotifier.notifyListeners();
//               },
//               textColor: Colors.white,
//             )
//           ],
//         );
//       });
// }

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
deleteProductDialog(Product product, int categoryID, context,
    ValueNotifier<List<Product>?> productListNotifier) async {
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

