import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Admin/Widgets/add_category.dart';
import 'package:snacc/Admin/Widgets/carousel.dart';
import 'package:snacc/Admin/Widgets/combo_list_builder.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Functions/category_functions.dart';

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
    log("catlist from init: $categorieslist");
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
          style: GoogleFonts.nunitoSans(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Hive.box<Product>('products').clear();
                Hive.box<Category>('category').clear();
              },
              child: Text(
                'Clear Data',
                style: GoogleFonts.nunitoSans(color: Colors.red),
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
                      style: GoogleFonts.nunitoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800])),

                  // ADD NEW CATEGORY
                  IconButton(
                    onPressed: () {
                      AddCategoryModalSheet.show(context, _formKey);
                    },
                    icon: const Icon(
                        size: 30, color: Colors.blue, Icons.add_rounded),
                  )
                ],
              ),
            ),
            const Gap(5),
            const CategoriesList(),
            const Gap(8),

            // CAROUSEL
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Offers Section',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                          size: 30, color: Colors.blue, Icons.add_rounded)),
                ],
              ),
            ),
            const Gap(8),
            SnaccCarousel(),
            const Gap(8),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Popular Combos',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
            const Gap(10),

            const ComboListBuilder(
              isAdmin: true,
            )
          ]),
        ),
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          categoryListNotifier.value.isNotEmpty
              ? ValueListenableBuilder(
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
                                return InkWell(
                                  onLongPress: () {
                                    deleteCategoryDialog(context, category);
                                  },
                                  onTap: () {
                                    // log('category id is ${category.categoryID}');
                                    Navigator.of(context)
                                        .push((MaterialPageRoute(
                                      builder: (context) => ListProducts(
                                        categoryName: category.categoryName,
                                        categoryID: category.categoryID,
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
                                            child: category.imageUrl == null
                                                ? Container(
                                                    width: 70,
                                                    height: 70,
                                                    color: Colors.transparent,
                                                    child: Image.asset(
                                                        'assets/images/no-image-available.png',
                                                        height: 40),
                                                  )
                                                : Container(
                                                    width: 70,
                                                    height: 70,
                                                    color: Colors.transparent,
                                                    child: Image.file(File(
                                                        category.imageUrl!)))),
                                        const Gap(5),
                                        Text(
                                          category.categoryName!,
                                          style: GoogleFonts.nunitoSans(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 120.0),
                  child: Center(
                      child: Text("No Categories found",
                          style: GoogleFonts.nunitoSans(color: Colors.grey))),
                ),
        ],
      ),
    );
  }
}
