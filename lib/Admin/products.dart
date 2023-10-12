import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Login/Widgets/button.dart';
import 'package:snacc/Login/Widgets/textfield.dart';

class ListProducts extends StatefulWidget {
  final int? id;
  final String? categoryName;
  const ListProducts({Key? key, required this.categoryName, required this.id})
      : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  TextEditingController productnamectrl = TextEditingController();
  TextEditingController productpricectrl = TextEditingController();
  final productformkey = GlobalKey<FormState>();

  String? productImgUrl;

  ValueNotifier<List<Product>> productlistNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    getCategoryProducts(widget.id).then((products) {
      if (products != null) {
        productlistNotifier.value = products;
      } else {
        print('products is null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                editCategory();
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              )),
          IconButton.filled(
              onPressed: () {
                if (widget.id != null) {
                  deleteCategory(widget.id);
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Form(
                          key: productformkey,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                SnaccButton(
                                    inputText: 'Pick Image',
                                    callBack: () {
                                      pickprodImage();
                                    }),
                                SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: productImgUrl != null
                                        ? Image.file(
                                            File(productImgUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey,
                                            child: const Icon(Icons.image),
                                          )),
                                TextFormField(
                                  controller: productnamectrl,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Product name',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: productpricectrl,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Price',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    addProduct();
                                  },
                                  child: const Text('Add New Product'),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(size: 30, color: Colors.blue, Icons.add))
        ],
        title: Text(
          widget.categoryName ?? 'Category',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ValueListenableBuilder(
            valueListenable: productlistNotifier,
            builder: (context, productlist, child) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final product = productlist[index];

                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(product.prodimgUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.prodname!,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text('${product.prodprice!}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {editProduct(product );},
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          deleteProduct(product);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
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
                  ],
                );
              },
              itemCount: productlistNotifier.value.length,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Product>?> getCategoryProducts(int? categoryId) async {
    if (categoryId == null) return null;

    final categoryBox = await Hive.openBox<Category>('category');
    final category = categoryBox.get(categoryId);

    return category?.products ?? [];
  }

  bool isImagepickerActive = false;
  Future pickprodImage() async {
    if (isImagepickerActive) return;
    isImagepickerActive = true;

    final imagePicker = ImagePicker();
    try {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          productImgUrl = pickedImage.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }

    // if (pickedImage != null) {
    //   setState(() {
    //     productImgUrl = pickedImage.path;
    //   });
    //   print(productImgUrl);
    // }
  }

  Future<void> updatedCategory(Category updatedCategory) async {
    final categoryBox = await Hive.openBox<Category>('category');

    final existingCategory = categoryBox.get(updatedCategory.id);

    if (existingCategory != null) {
      existingCategory.categoryName = updatedCategory.categoryName;
      existingCategory.imageUrl = updatedCategory.imageUrl;
      await categoryBox.put(updatedCategory.id, existingCategory);
    }
  }

  Future<void> saveCategory(Category category) async {
    final categoryBox = Hive.box<Category>('category');
    await categoryBox.put(category.id, category);
  }

  void addProduct() async {
    final String productName = productnamectrl.text.trim();
    final double productPrice = double.tryParse(productpricectrl.text) ?? 0.00;

    Product currentProduct = Product(
        prodimgUrl: productImgUrl ?? 'assets/images/Snacc.png',
        prodname: productName,
        prodprice: productPrice,
        quantity: 0);

    print('img - ${currentProduct.prodimgUrl}');
    print('name - ${currentProduct.prodname}');
    print('price - ${currentProduct.prodprice}');

    Category? currentcategory = getCategoryById(widget.id);
    if (currentcategory != null) {
      currentcategory.products ??= [];
      currentcategory.products!.add(currentProduct);
      print(currentcategory.id);
    }

    await saveCategory(currentcategory!);
    print('products list = ${currentcategory.products}');
    print('category of = ${currentcategory.categoryName}');

    productnamectrl.clear();
    productpricectrl.clear();
    setState(() {
      productImgUrl = null;
    });
  }

  void editProduct(Product product) async {
    final TextEditingController newprodnamectrl = TextEditingController();
    final TextEditingController newprodpricectrl = TextEditingController();
    String? newprodImgUrl;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit ${product.prodname}'),
              content: SingleChildScrollView(
                child: Column(
                  
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('New product name'),
                    SnaccTextField(
                      controller: newprodnamectrl,
                    ),
                    const Text('New product price'),
                    SnaccTextField(
                      controller: newprodpricectrl,
                    ),
                    // SnaccButton(
                    //     inputText: 'Choose new Image',
                    //     callBack: () async {
                    //       pickprodImage().then((newimg) => setState(() {
                    //             newprodImgUrl = newimg;
                    //           }));
                    //     }),
                    // SizedBox(
                    //   height: 80,
                    //   width: 80,
                    //   child: newprodImgUrl != null
                    //       ? Image.file(
                    //           File(newprodImgUrl!),
                    //           fit: BoxFit.cover,
                    //         )
                    //       : Container(
                    //           color: Colors.grey,
                    //           child: const Icon(Icons.image),
                    //         ),
                    // )
                  ],
                ),
              ),
              actions: <Widget>[
                SnaccButton(inputText: 'SAVE', callBack: () {
                  // Category? currentcategory = getCategoryById(widget.id);
                  product.prodname = newprodnamectrl.text;
                  product.prodprice = double.tryParse(newprodpricectrl.text)??0.00;
                  // product.prodimgUrl = newprodImgUrl;

                  productlistNotifier.notifyListeners();

                })
              ],
            );
          });
        });
  }

  void editCategory() async {
    final category = getCategoryById(widget.id);
    if (category != null) {
      final TextEditingController newcategorynamectrl = TextEditingController();
      String? updatedImgUrl = category.imageUrl;

      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit ${category.categoryName} Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SnaccTextField(
                    controller: newcategorynamectrl,
                  ),
                  SnaccButton(
                      inputText: 'new image',
                      callBack: () async {
                        final newImageURL = await pickprodImage();
                        if (newImageURL != null) {
                          updatedImgUrl = updatedImgUrl;
                        }
                      }),
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
                              child: const Icon(Icons.image),
                            ))
                ],
              ),
              actions: <Widget>[
                SnaccButton(
                    inputText: 'Save',
                    callBack: () {
                      category.categoryName = newcategorynamectrl.text;
                      category.imageUrl = updatedImgUrl;
                      updatedCategory(category);
                      saveCategory(category);
                      productlistNotifier.notifyListeners();
                    })
              ],
            );
          });
    }
  }

  Future<void> deleteCategory(int? id) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Category?'),
            actions: <Widget>[
              SnaccButton(
                  btncolor: Colors.white,
                  inputText: 'Cancel',
                  callBack: () {
                    Navigator.of(context).pop;
                  }),
              SnaccButton(
                  inputText: 'Yes, Delete',
                  callBack: () async {
                    final categoryBox =
                        await Hive.openBox<Category>('category');
                    await categoryBox.delete(id);
                    categoryListNotifier.value
                        .removeWhere((category) => category.id == id);
                    Navigator.of(context).pop;

                    // categoryListNotifier.value = categoryBox.values.toList();
                    categoryListNotifier.notifyListeners();
                    print(categoryBox);
                    print('deleted id = $id');
                  })
            ],
          );
        });
  }

  void deleteProduct(Product product) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon:const Icon(Icons.delete_forever),
            title: const Text('Delete Product?'),
            actions: [
              SnaccButton(
                  btncolor: Colors.white,
                  inputText: 'Cancel',
                  callBack: () {
                    Navigator.of(context).pop();
                  }),
              SnaccButton(
                  inputText: 'Delete',
                  callBack: () {
                    Category? currentCategory = getCategoryById(widget.id);

                    final int productindex = currentCategory!.products!
                        .indexWhere((element) => element == product);

                    currentCategory.products!.removeAt(productindex);

                    saveCategory(currentCategory);

                    productlistNotifier.notifyListeners();
                  })
            ],
          );
        });
  }
}

Category? getCategoryById(int? categoryId) {
  if (categoryId == null) return null;

  final categoryBox = Hive.box<Category>('category');
  final category = categoryBox.get(categoryId);

  return category;
}
