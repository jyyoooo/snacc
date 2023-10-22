import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/category_functions.dart';

void addProduct(productName, productPrice, productImgUrl, categoryID) async {
  //NEW PEODUCT OBJECT
  Product newProduct = Product(
    prodimgUrl: productImgUrl ?? 'assets/images/no-image-available.png',
    prodname: productName,
    prodprice: productPrice,
    quantity: 0,
  );
  //ignore:avoid_print
  print('img - ${newProduct.prodimgUrl}');
  //ignore:avoid_print
  print('name - ${newProduct.prodname}');
  //ignore:avoid_print
  print('price - ${newProduct.prodprice}');

  Category? currentcategory = getCategoryById(categoryID);
  //ignore:avoid_print
  print('fetched category ${currentcategory?.categoryName}');

  if (currentcategory != null) {
    currentcategory.products ??= [];
    currentcategory.products?.add(newProduct);
    //ignore:avoid_print
    print('will be added to ${currentcategory.categoryName}');
  }else{
    //ignore:avoid_print
  print('category error');

  }

  await saveCategory(currentcategory!);

  //ignore:avoid_print
  print('products list = ${currentcategory.products}');
  //ignore:avoid_print
  print('category of = ${currentcategory.categoryName}');
}
