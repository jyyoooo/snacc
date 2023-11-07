import 'dart:developer';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/Widgets/combo_list_builder.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/UserPages/user_productspage.dart';

class UserHome extends StatefulWidget {
  final UserModel? user;
  const UserHome({super.key, this.user});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void initState() {
    super.initState();
    // checkUserFav(widget.user!.favorites);
    final categorieslist = Hive.box<Category>('category').values.toList();
    categoryListNotifier.value = categorieslist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/Snacc.png',
          scale: 1.5,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ValueListenableBuilder(
                  valueListenable: categoryListNotifier,
                  builder: (BuildContext context, List<Category> categorylist,
                      Widget? child) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categorylist.length,
                      itemBuilder: (context, index) {
                        final category = categorylist[index];
                        return GestureDetector(
                          onTap: () {
                            log('');
                            Navigator.of(context).push((MaterialPageRoute(
                              builder: (context) => UserListProducts(
                                user: widget.user,
                                categoryName: category.categoryName,
                                id: category.categoryID,
                                userFavorites: widget.user!.favorites,
                              ),
                            )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.transparent,
                                      child:
                                          Image.file(File(category.imageUrl!)),
                                    )),
                                const SizedBox(height: 5),
                                Text(
                                  category.categoryName!,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[800],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              // OFFER CARD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Offers',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Card(
                elevation: 0,
                child: Image.asset('assets/images/Admin_page/ad_items.png'),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Combos',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 23, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const ComboListBuilder(
                isAdmin: false,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
