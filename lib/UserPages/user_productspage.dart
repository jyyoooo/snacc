import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class UserListProducts extends StatefulWidget {
  final List<dynamic>? userFavorites;
  final int? id;
  final String? categoryName;
  final UserModel? user;
  const UserListProducts(
      {Key? key,
      required this.categoryName,
      required this.id,
      required this.userFavorites,
      required this.user})
      : super(key: key);

  @override
  State<UserListProducts> createState() => _UserListProductsState();
}

class _UserListProductsState extends State<UserListProducts> {
  // bool isFavorited = false;
  TextEditingController productnamectrl = TextEditingController();
  TextEditingController productpricectrl = TextEditingController();
  final productformkey = GlobalKey<FormState>();
  String? productImgUrl;

  @override
  void initState() {
    super.initState();
    getCategoryProducts(widget.id).then((products) {
      setState(() {
        log('products in category ${widget.categoryName}: ${products.map((e) => e.prodname)}');
        productListNotifier.value = products;
        productListNotifier.notifyListeners();
      });

      productListNotifier.value = products;
      productListNotifier.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.categoryName ?? 'Category',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: productListNotifier.value.isNotEmpty &&
                  productListNotifier.value != null
              ? ValueListenableBuilder(
                  valueListenable: productListNotifier,
                  builder: (context, productlist, child) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: productListNotifier.value.length,
                    itemBuilder: (context, index) {
                      final product = productlist[index];

                      return GestureDetector(
                        onTap: () {
                          log('${product.isFavorite}');
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: product
                                                                ?.prodimgUrl !=
                                                            null
                                                        ? Image.file(
                                                            File(product!
                                                                .prodimgUrl!),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/no-image-available.png'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${product?.prodname!}',
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                        '₹${product?.prodprice!}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: product!.isFavorite!
                                                      ? const Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color: Colors.red)
                                                      : const Icon(
                                                          Icons
                                                              .favorite_outline_rounded,
                                                          color: Colors.grey),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (product.isFavorite!) {
                                                        removeProductFromFavorites(
                                                            product,
                                                            widget.user!);
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              '${product.prodname} removed from Favorites',
                                                          backgroundColor:
                                                              Colors.red,
                                                        );
                                                      } else {
                                                        addProductToFavorite(
                                                            product,
                                                            widget.user!);
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              '${product.prodname} added to Favorites',
                                                          backgroundColor:
                                                              Colors.amber,
                                                          textColor:
                                                              Colors.black87,
                                                        );
                                                      }
                                                    });
                                                  },
                                                ),
                                                SnaccButton(
                                                  width: 70,
                                                  inputText: 'ADD',
                                                  callBack: () {
                                                    addProductToBag(product);
                                                  },
                                                  btncolor: Colors.amber,
                                                ),
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
                  ),
                )
              : const Center(
                  heightFactor: 40,
                  child: Text(
                    'No Products found',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  )),
        ),
      ),
    );
  }
}
