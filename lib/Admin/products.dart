// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Admin/Widgets/add_product.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

class ListProducts extends StatefulWidget {
  final int? id;
  final String? categoryName;
  const ListProducts({Key? key, required this.categoryName, required this.id})
      : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  ValueNotifier<List<Product>?> productlistNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    getCategoryProducts(widget.id).then((products) {
      setState(() {
        log('products in category ${widget.categoryName}: $products');
        productlistNotifier.value = products;
        productlistNotifier.notifyListeners();
      });

      productlistNotifier.value = products;
      productlistNotifier.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: FloatingActionButton.extended(
            icon: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
            backgroundColor: const Color.fromARGB(255, 84, 203, 88),
            label: const Text(
              'New Product',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              addProductModalSheet(context, widget.id, productlistNotifier);
            }),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // EDIT CATEGORY
          IconButton(
              onPressed: () async {
                final category = getCategoryById(widget.id);
                if (category != null) {
                  final TextEditingController newcategorynamectrl =
                      TextEditingController(text: category.categoryName);
                  String? updatedImgUrl = category.imageUrl;

                  final exisitingCategoryname = category.categoryName;

                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Edit ${category.categoryName} Category',
                            style: const TextStyle(color: Colors.blue),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SnaccTextField(
                                controller: newcategorynamectrl,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: updatedImgUrl != null
                                          ? Image.file(
                                              File(updatedImgUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey,
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.blue,
                                              ),
                                            )),
                                  SnaccButton(
                                      width: 60,
                                      icon: const Icon(Icons.photo),
                                      btncolor: Colors.white70,
                                      inputText: 'new image',
                                      callBack: () async {
                                        final String? newImageURL =
                                            await pickImageFromGallery();
                                        if (newImageURL != null) {
                                          updatedImgUrl = updatedImgUrl;
                                        }
                                      }),
                                ],
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            SnaccButton(
                                inputText: 'Save',
                                callBack: () {
                                  category.categoryName =
                                      newcategorynamectrl.text ??
                                          exisitingCategoryname;
                                  category.imageUrl = updatedImgUrl;
                                  updatedCategory(category);
                                  saveCategory(category);
                                  productlistNotifier.notifyListeners();
                                })
                          ],
                        );
                      });
                }
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              )),
        ],
        title: Text(
          widget.categoryName ?? 'Category',
          style: const TextStyle(fontSize: 20),
        ),
      ),

      // PRODUCTS LIST
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: productlistNotifier.value!.isNotEmpty &&
                  productlistNotifier.value != null
              ? ValueListenableBuilder(
                  valueListenable: productlistNotifier,
                  builder: (context, productlist, child) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = productlist?[index];

                      return Card(
                        child: InkWell(
                          onLongPress: () async{
                            await deleteProductDialog(product, widget.id!, context);
                            productlistNotifier.notifyListeners();
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: product!
                                                                .prodimgUrl ==
                                                            null
                                                        ? Image.asset(
                                                            'assets/images/no-image-available.png')
                                                        : Image.file(
                                                            File(product
                                                                .prodimgUrl!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                const SizedBox.square(
                                                    dimension: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      product.prodname!,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                        '₹${product.prodprice!}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      editProduct(product);
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: productlistNotifier.value!.length,
                  ),
                )
              : const Center(
                  heightFactor: 40,
                  child: Text(
                    'No Products found',
                    style: TextStyle(color: Colors.grey),
                  )),
        ),
      ),
    );
  }

  void editProduct(Product product) async {
    final TextEditingController newprodnamectrl =
        TextEditingController(text: product.prodname);
    final TextEditingController newprodpricectrl =
        TextEditingController(text: "${product.prodprice}");
    // String? newprodImgUrl;
    final existingname = product.prodname;
    final exisitingprice = product.prodprice;
    final productImg;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Edit ${product.prodname}',
                style: const TextStyle(color: Colors.blue),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('New product name'),
                    const SizedBox(
                      height: 5,
                    ),
                    SnaccTextField(
                      controller: newprodnamectrl,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('New product price'),
                    const SizedBox(
                      height: 5,
                    ),
                    SnaccTextField(
                      controller: newprodpricectrl,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                SnaccButton(
                    inputText: 'SAVE',
                    callBack: () async {
                      final currentCategory = getCategoryById(widget.id);
                      product.prodname = newprodnamectrl.text ?? existingname;
                      saveCategory(currentCategory!);
                      product.prodprice =
                          double.tryParse(newprodpricectrl.text) ??
                              exisitingprice;
                      productlistNotifier.notifyListeners();
                      Navigator.pop(context);
                    })
              ],
            );
          });
        });
  }

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

// Future<List<Product>?> getCategoryProducts(int? categoryId) async {
//     if (categoryId == null) return null;

//     final categoryBox = await Hive.openBox<Category>('category');
//     final category = categoryBox.get(categoryId);

//     return category?.products ?? [];
}
