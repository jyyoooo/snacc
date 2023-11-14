import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_floating_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

import '../DataModels/product_model.dart';

class ListProducts extends StatefulWidget {
  final int? categoryID;
  final String? categoryName;
  const ListProducts(
      {Key? key, required this.categoryName, required this.categoryID})
      : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  final productformkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getCategoryProducts(widget.categoryID).then((products) {
      setState(() {
        productListNotifier.value = products;
        productListNotifier.notifyListeners();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // EDIT CATEGORY
          IconButton(
              onPressed: () async {
                final category = getCategoryById(widget.categoryID);
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
                                  productListNotifier.notifyListeners();
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
          style:
              GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),

      // PRODUCTS LIST
      body: ListedProductsNotifier(categoryID: widget.categoryID),

      // NEW PRODUCT FLOATING BUTTON
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: SnaccFloatingButton(
          productListNotifier: productListNotifier,
          productformkey: productformkey,
          widget: widget,
        ),
      ),
    );
  }
}

// PRODUCTS LIST WIDGET

class ListedProductsNotifier extends StatefulWidget {
  final int? categoryID;
  const ListedProductsNotifier({super.key, required this.categoryID});

  @override
  State<ListedProductsNotifier> createState() => _ListedProductsNotifierState();
}

class _ListedProductsNotifierState extends State<ListedProductsNotifier> {
  late List<Product> productList;

  @override
  void initState() {
    super.initState();
    productList = productListNotifier.value;
  }

  @override
  void didUpdateWidget(ListedProductsNotifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (productList != productListNotifier.value) {
      setState(() {
        productList = productListNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ValueListenableBuilder(
        valueListenable: productListNotifier,
        builder:
            (BuildContext context, List<Product>? productlist, Widget? child) {
          return productListNotifier.value.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productListNotifier.value.length,
                  itemBuilder: (context, index) {
                    final product = productlist?[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onLongPress: () async {
                          await deleteProductDialog(
                            product,
                            widget.categoryID!,
                            context,
                            productListNotifier,
                          );
                          productListNotifier.value =
                              await getCategoryProducts(widget.categoryID);
                          productListNotifier.notifyListeners();
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                                      BorderRadius.circular(10),
                                                  child: product!.prodimgUrl ==
                                                          null
                                                      ? Image.asset(
                                                          'assets/images/no-image-available.png',
                                                        )
                                                      : Image.file(
                                                          File(product
                                                              .prodimgUrl!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                              const SizedBox.square(
                                                dimension: 20,
                                              ),
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
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '₹${product.prodprice!}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                    ),
                                                  ),
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
                                                  // editProduct(product);
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  heightFactor: 35,
                  child: Text(
                    'No Products found',
                    style: GoogleFonts.nunitoSans(color: Colors.grey),
                  ),
                );
        },
      ),
    );
  }
}
