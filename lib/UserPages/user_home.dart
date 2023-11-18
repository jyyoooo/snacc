import 'dart:developer';
import 'dart:io';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snacc/Admin/Widgets/carousel.dart';
import 'package:snacc/Admin/Widgets/combo_list_builder.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/UserPages/user_productspage.dart';
import 'package:snacc/Widgets/screen_and_seat.dart';

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
    final categorieslist = Hive.box<Category>('category').values.toList();
    categoryListNotifier.value = categorieslist;
    var seatScreenData = context.read<SeatScreenData>();
    log('${seatScreenData.selectedScreenNumber} ${seatScreenData.selectedSeatNumber}');
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CarouselNotifier>(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 95,
        title: const ScreenAndSeat(),
        centerTitle: true,
        backgroundColor: Colors.white,
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
              const Gap(5),
              UserCategoriesHorizontalList(widget: widget),
              const Gap(5),
              Text('Offers For You',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 23, fontWeight: FontWeight.bold)),
              const Gap(5),
              Consumer<CarouselNotifier>(
                builder: (context, carouselNotifier, child) {
                  return SnaccCarousel(
                    carouselImages:
                        Hive.box<String>('carousel').values.toList(),
                  );
                },
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

class UserCategoriesHorizontalList extends StatelessWidget {
  const UserCategoriesHorizontalList({
    super.key,
    required this.widget,
    // required this.widget,
  });

  final UserHome widget;
  // final UserHome widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ValueListenableBuilder(
        valueListenable: categoryListNotifier,
        builder: (BuildContext context, List<Category> categorylist,
            Widget? child) {
          return categorylist.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categorylist.length,
                  itemBuilder: (context, index) {
                    final category = categorylist[index];
                    return GestureDetector(
                      onTap: () {
                        log('');
                        Navigator.of(context)
                            .push((MaterialPageRoute(
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
                                  child: category.imageUrl != null
                                      ? Image.file(
                                          File(category.imageUrl!))
                                      : Image.asset(
                                          'assets/images/no-image-available.png'),
                                )),
                            const SizedBox(height: 5),
                            Text(
                              category.categoryName!,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                  'No Cateogries found',
                  style: GoogleFonts.nunitoSans(color: Colors.grey,fontSize: 15),
                ));
        },
      ),
    );
  }
}
