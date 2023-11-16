import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Admin/Widgets/edit_product.dart';
import 'package:snacc/DataModels/category_model.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .4,
        actions: [
          // EDIT CATEGORY
          EditCategory(
            categoryID: widget.categoryID,
          ),
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

class EditCategory extends StatefulWidget {
  final int? categoryID;

  const EditCategory({
    Key? key,
    required this.categoryID,
  }) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  String? updatedImgUrl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final category = getCategoryById(widget.categoryID);
        if (category != null) {
          final TextEditingController newCategoryNameCtrl =
              TextEditingController(text: category.categoryName);
          updatedImgUrl = category.imageUrl;

          await showModalBottomSheet(
            constraints: const BoxConstraints.tightForFinite(height: 500),
            useSafeArea: true,
            isScrollControlled: true,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SnaccTextField(
                          label: 'Category name',
                          controller: newCategoryNameCtrl,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: updatedImgUrl != null
                                  ? Image.file(
                                      File(updatedImgUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox(
                                      child: Image.asset(
                                          'assets/images/no-image-available.png'),
                                    ),
                            ),
                            SnaccButton(
                              width: 60,
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.blue,
                              ),
                              btncolor: Colors.white70,
                              inputText: 'New Image',
                              callBack: () async {
                                updatedImgUrl = await pickImageFromGallery();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SnaccButton(
                          textColor: Colors.white,
                          inputText: 'SAVE',
                          width: 80,
                          callBack: () async {
                            category.categoryName = newCategoryNameCtrl.text;
                            category.imageUrl = updatedImgUrl;
                            saveCategory(category);
                            categoryListNotifier.notifyListeners();
                            productListNotifier.value =
                                await getCategoryProducts(widget.categoryID);
                            productListNotifier.notifyListeners();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      },
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
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
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '₹${product.prodprice!}',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  // editProductDialog(
                                                  //     product,
                                                  //     widget.categoryID!,
                                                  //     context);
                                                  EditProduct.show(
                                                      context, product);
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
                    style: GoogleFonts.nunitoSans(
                        color: Colors.grey, fontSize: 17),
                  ),
                );
        },
      ),
    );
  }
}
