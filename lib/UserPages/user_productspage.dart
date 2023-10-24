import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class UserListProducts extends StatefulWidget {
  final int? id;
  final String? categoryName;
  const UserListProducts(
      {Key? key, required this.categoryName, required this.id})
      : super(key: key);

  @override
  State<UserListProducts> createState() => _UserListProductsState();
}

class _UserListProductsState extends State<UserListProducts> {
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
        print('no products available');
      }
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
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                                BorderRadius.circular(10),
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
                                            Text('₹${product.prodprice!}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                                            icon: const Icon(
                                                Icons.favorite_border),
                                            onPressed: () {}),
                                        SnaccButton(
                                          inputText: 'ADD',
                                          callBack: () {},
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
  Future pickImage() async {
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

    final existingCategory = categoryBox.get(updatedCategory.categoryID);

    if (existingCategory != null) {
      existingCategory.categoryName = updatedCategory.categoryName;
      existingCategory.imageUrl = updatedCategory.imageUrl;
      await categoryBox.put(updatedCategory.categoryID, existingCategory);
    }
  }

  Future<void> saveCategory(Category category) async {
    final categoryBox = Hive.box<Category>('category');
    await categoryBox.put(category.categoryID, category);
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
      print(currentcategory.categoryID);
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

  void deleteProduct(Product product) {
    Category? currentCategory = getCategoryById(widget.id);

    final int productindex =
        currentCategory!.products!.indexWhere((element) => element == product);

    currentCategory.products!.removeAt(productindex);

    saveCategory(currentCategory);

    productlistNotifier.notifyListeners();
  }
}

Category? getCategoryById(int? categoryId) {
  if (categoryId == null) return null;

  final categoryBox = Hive.box<Category>('category');
  final category = categoryBox.get(categoryId);

  return category;
}
