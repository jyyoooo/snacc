import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Admin/Widgets/add_category.dart';
import 'package:snacc/Admin/Widgets/combo_list_builder.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';

import '../DataModels/product_model.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Category>? categorieslist = [];
  final carouselCtrl = CarouselController();

  @override
  void initState() {
    super.initState();
    final categorieslist = Hive.box<Category>('category').values.toList();
    categoryListNotifier.value = categorieslist;
    print("catlist from init: $categorieslist");
  }

  // String? selectedImgUrl;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        leading: const Icon(
          Icons.transcribe,
          color: Colors.transparent,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome back, Admin',
          style: TextStyle(fontSize: 20, color: Colors.grey[800]),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Hive.box<Product>('products').clear();
                Hive.box<Category>('category').clear();
              },
              child: const Text(
                'clear all data',
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Catergories',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),

                  // ADD NEW CATEGORY
                  IconButton(
                    onPressed: () {
                      addCategoryModalSheet(context, _formKey,);
                    },
                    icon: const Icon(
                        size: 30, color: Colors.blue, Icons.add_rounded),
                  )
                ],
              ),
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
                  categoryListNotifier.value.isNotEmpty
                      ? ValueListenableBuilder(
                          valueListenable: categoryListNotifier,
                          builder: (BuildContext context,
                                  List<Category> categorylist, Widget? child) =>
                              Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: categorylist.length,
                                      itemBuilder: (context, index) {
                                        final category = categorylist[index];
                                        return InkWell(
                                          onLongPress: () {
                                            deleteCategoryDialog(
                                                context, category);
                                          },
                                          onTap: () {
                                            print(
                                                'tap id is ${category.categoryID}');
                                            Navigator.of(context)
                                                .push((MaterialPageRoute(
                                              builder: (context) =>
                                                  ListProducts(
                                                categoryName:
                                                    category.categoryName,
                                                id: category.categoryID,
                                              ),
                                            )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: 
                                                    category.imageUrl == null?
                                                    Container(
                                                      width: 70,
                                                      height: 70,
                                                      color: Colors.transparent,
                                                      child:
                                                           Image.asset('assets/images/no-image-available.png',
                                                                  height: 40),
                                                    )
                                                    :Container(
                                                      width: 70,
                                                      height: 70,
                                                      color: Colors.transparent,
                                                      child:
                                                            Image.file(File(
                                                              category.imageUrl!))
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
                        )
                      : const Padding(
                          padding: EdgeInsets.only(left: 120.0),
                          child: Center(
                              child: Text("No Categories found",
                                  style: TextStyle(color: Colors.grey))),
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            // CAROUSEL
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // CarouselSlider.builder(carouselController: carouselCtrl,itemCount: 3, itemBuilder: , options: ),
            //     const Text('Offers Section',
            //         style:
            //             TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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

            // const SizedBox(
            //   height: 8,
            // ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Popular Combos',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/popularcombo');
                      },
                      icon: const Icon(
                          size: 30, color: Colors.blue, Icons.add_rounded))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            const ComboListBuilder(
              isAdmin: true,
            )
          ]),
        ),
      ),
    );
  }
}
