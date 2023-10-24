import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/textfield.dart';

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
        // ignore:avoid_print
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

          // EDIT CATEGORY
          IconButton(
              onPressed: () async {
                final category = getCategoryById(widget.id);
                if (category != null) {
                  final TextEditingController newcategorynamectrl =
                      TextEditingController();
                  String? updatedImgUrl = category.imageUrl;

                  final exisitingCategoryname = category.categoryName;

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
                              const SizedBox(height: 20,),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                          child: const Icon(Icons.image,color: Colors.blue,),
                                        )),
                                  SnaccButton(
                                    width: 60,
                                    icon: const Icon(Icons.photo),
                                    btncolor: Colors.white70,
                                      inputText: 'new image',
                                      callBack: () async {
                                        final String? newImageURL = await pickImageFromGallery();
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

              // DELETE CATEGORY
          IconButton.filled(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Category?'),
                        actions: <Widget>[
                          SnaccButton(
                            btncolor: Colors.red,
                            inputText: 'Delete',
                            callBack: () {
                              if (widget.id != null) {
                                deleteCategory(widget.id);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminHome()));
                              } else {
                                print('category id is null');
                              }
                            },
                          )
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),


              // ADD PRODUCT
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  shape:const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return Form(
                        key: productformkey,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Text('Add a new Product',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: productImgUrl != null
                                            ? Image.file(
                                                File(productImgUrl!),
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.grey[300],
                                                child: Image.asset('assets/images/no-image-available.png'),
                                              )),
                                  ),
                                  SnaccButton(
                                      inputText: 'Pick Image',
                                      callBack: () async{
                                        

                                        productImgUrl = await pickImageFromGallery();
                                      }),
                                ],
                              ),
                              const SizedBox(height: 10),
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
                              SnaccButton(
                                callBack: () {
                                  final String productName = productnamectrl.text.trim();
                                  final double productPrice = double.tryParse(productpricectrl.text) ??0.00;
                                  final categoryID = widget.id;

                                  // ADD PRODUCT
                                  addProduct( productName, productPrice,productImgUrl,categoryID);
                                  productnamectrl.clear();
                                  productpricectrl.clear();
                                  // setState(() {
                                  //   productImgUrl = null;
                                  // });
                                },
                                inputText: 'ADD PRODUCT', 
                              )
                            ],
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
                return Card(
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
                                            child: product.prodimgUrl == null
                                                ? Image.asset(
                                                    'assets/images/no-image-available.png')
                                                : Image.file(
                                                    File(product.prodimgUrl!),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox.square(dimension: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product.prodname!,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text('₹${product.prodprice!}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                      ),
                    ],
                  ),
                );
              },
              itemCount: productlistNotifier.value.length,
            ),
          ),
        ),
      ),
    );
  }

  // bool isImagepickerActive = false;
  // Future pickprodImage() async {
  //   if (isImagepickerActive) return;
  //   isImagepickerActive = true;

  //   final imagePicker = ImagePicker();
  //   try {
  //     final pickedImage =
  //         await imagePicker.pickImage(source: ImageSource.gallery);
  //     if (pickedImage != null) {
  //       setState(() {
  //         productImgUrl = pickedImage.path;
  //       });
  //     } else if (pickedImage == null) {
  //       productImgUrl = 'assets/images/no-image-available.png';
  //     }
  //   } catch (e) {
  //     print('Error picking image: $e');
  //   }
  // }


  void editProduct(Product product) async {
    final TextEditingController newprodnamectrl = TextEditingController();
    final TextEditingController newprodpricectrl = TextEditingController();
    // String? newprodImgUrl;
    final existingname = product.prodname;
    final exisitingprice = product.prodprice;

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
                  ],
                ),
              ),
              actions: <Widget>[
                SnaccButton(
                    inputText: 'SAVE',
                    callBack: () {
                      // Category? currentcategory = getCategoryById(widget.id);
                      product.prodname = newprodnamectrl.text ?? existingname;
                      product.prodprice =
                          double.tryParse(newprodpricectrl.text) ??
                              exisitingprice;
                      productlistNotifier.notifyListeners();
                    })
              ],
            );
          });
        });
  }

  // void editCategory() async {}

  void deleteProduct(Product product) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.delete_forever),
            title: const Text('Delete Product?'),
            actions: [
              
              SnaccButton(
                btncolor: Colors.red,
                  inputText: 'Delete',
                  callBack: () {
                    Category? currentCategory = getCategoryById(widget.id);

                    final int productindex = currentCategory!.products!
                        .indexWhere((element) => element == product);
                    currentCategory.products!.removeAt(productindex);

                    saveCategory(currentCategory);
                    Navigator.of(context).pop();

                    productlistNotifier.notifyListeners();
                  })
            ],
          );
        });
  }
}
