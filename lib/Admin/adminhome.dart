import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Login/Widgets/button.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Category> categorieslist = [];

  @override
  void initState() {
    super.initState();
    final categorieslist = Hive.box<Category>('category').values.toList();
    categoryListNotifier.value = categorieslist;
  }

  String? selectedImgUrl;

  final catgoryNameCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? image;

  Future pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImgUrl = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // primary: true,
        title: const Text(
          'Welcome back, Admin',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Catergories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    SnaccButton(
                                        inputText: 'Pick Image',
                                        callBack: () {
                                          pickImage();
                                        }),
                                    SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: selectedImgUrl != null
                                            ? Image.file(
                                                File(selectedImgUrl!),
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.grey,
                                                child: const Icon(Icons.image),
                                              )),
                                    TextFormField(
                                      controller: catgoryNameCtrl,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Category name',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 10),
                                    SnaccButton(
                                      callBack: () {
                                        if (_formKey.currentState!.validate()) {
                                          addbtn();

                                          selectedImgUrl = null;
                                          catgoryNameCtrl.clear();
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const AlertDialog(
                                                    title: Text(
                                                        'Fields are empty'),
                                                  ));
                                        }
                                      },
                                      inputText: 'Add New Category',
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(size: 30, color: Colors.blue, Icons.edit))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: categoryListNotifier,
                  builder: (BuildContext context, List<Category> categorylist,
                          Widget? child) =>
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: categorylist.length,
                              itemBuilder: (context, index) {
                                final category = categorylist[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push((MaterialPageRoute(
                                      builder: (context) => ListProducts(
                                        categoryName: category.categoryName,
                                        id: category.id,
                                      ),
                                    )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              width: 70,
                                              height: 70,
                                              color: Colors.transparent,
                                              child: Image.file(
                                                  File(category.imageUrl!)),
                                            )),
                                        const SizedBox(height: 5),
                                        Text(
                                          category.categoryName!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text('Offers Section',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          //     IconButton(
          //         onPressed: () {},
          //         icon: const Icon(size: 30, color: Colors.blue, Icons.edit))
          //   ],
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          // Card(
          //   child: Image.asset('assets/images/Admin_page/ad_items.png'),
          // ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Combos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(size: 30, color: Colors.blue, Icons.edit))
            ],
          ),
          Expanded(
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => SizedBox(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Expanded(
                              child: Image.asset(
                                'assets/popular_combos/Popcorn and cola.png',
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Product',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '\$12.50',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )),
          )
        ]),
      ),
    );
  }

  Future<void> addbtn() async {
    final name = catgoryNameCtrl.text.trim();
    if (name.isEmpty) {
      return;
    }
    print('category name: $name , imgpath: $selectedImgUrl');

    final imagePath = selectedImgUrl;

    final category = Category(categoryName: name, imageUrl: imagePath);

    addCategory(category);

    categorieslist = Hive.box<Category>('category').values.toList();
    categoryListNotifier.value = categorieslist;

    displayalldata();
  }
}
