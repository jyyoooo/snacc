import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:snacc/Admin/Widgets/add_category.dart';
import 'package:snacc/Admin/Widgets/carousel.dart';
import 'package:snacc/Admin/Widgets/carousel_management.dart';
import 'package:snacc/Admin/Widgets/combo_list_builder.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Functions/admin_functions.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/UserPages/provider.dart';

import 'Widgets/categories_list.dart';

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
    log("current categories: ${categorieslist.map((e) => e.categoryName)}");
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<CarouselNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: .4,
        title: Text(
          'Welcome back Admin',
          style: GoogleFonts.nunitoSans(
              fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
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
          ),
          const Gap(5),

          // CATEGORY LIST
          CategoriesList(),

          const Gap(8),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Offers Section',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CarouselManagement()));
                      },
                      icon: const Icon(
                          size: 30, color: Colors.blue, Icons.add_rounded)),
                ],
              ),
            ),
          ),

          // CAROUSEL

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<CarouselNotifier>(
              builder: (context, carouselNotifier, child) {
                return SnaccCarousel(
                  carouselImages: Hive.box<String>('carousel').values.toList(),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
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
          ),
          const Gap(10),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ComboListBuilder(
              isAdmin: true,
            ),
          )
        ]),
      ),
    );
  }
}
