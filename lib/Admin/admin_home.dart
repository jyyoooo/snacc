import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:snacc/Admin/Widgets/add_category.dart';
import 'package:snacc/Admin/Widgets/carousel.dart';
// import 'package:snacc/Admin/Widgets/carousel_management.dart';
import 'package:snacc/Admin/Widgets/combo_list_builder.dart';
import 'package:snacc/DataModels/category_model.dart';
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
        leading: const SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: .4,
        title: title(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // SHOW CATEGORIES
              CategoryCard(formKey: _formKey),
              const Gap(5),

              // CATEGORY LIST
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CategoriesList()),

              // CAROUSEL
              addOffersPage(context),
              showCarousel(),
              
              // COMBO
              createCombo(context),
              const Gap(10),
              const ComboListBuilder(
                isAdmin: true,
              )
            ]),
          ),
        ),
      ),
    );
  }



  // WIDGETS
  Card createCombo(BuildContext context) {
    return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Create Combos',
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
            );
  }

  Consumer<CarouselNotifier> showCarousel() {
    return Consumer<CarouselNotifier>(
              builder: (context, carouselNotifier, child) {
                return SnaccCarousel(
                  carouselImages:
                      Hive.box<String>('carousel').values.toList(),
                );
              },
            );
  }

  Card addOffersPage(BuildContext context) {
    return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Add Offers',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/carouselManagement');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const CarouselManagement()));
                      },
                      icon: const Icon(
                          size: 30, color: Colors.blue, Icons.add_rounded)),
                ],
              ),
            );
  }

  Text title() {
    return Text(
        'Welcome back Admin',
        style: GoogleFonts.nunitoSans(
            fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
      );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('    Create Catergories',
              style: GoogleFonts.nunitoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800])),
          // ADD NEW CATEGORY
          IconButton(
            onPressed: () {
              AddCategoryModalSheet.show(context, _formKey);
            },
            icon: const Icon(size: 30, color: Colors.blue, Icons.add_rounded),
          )
        ],
      ),
    );
  }
}
