import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Functions/category_functions.dart';

class CategoriesList extends StatelessWidget {
  late List<Category> categoryList;

   CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ValueListenableBuilder(
        valueListenable: categoryListNotifier,
        builder: (BuildContext context, List<Category> categoryList,
            Widget? child) {
          return categoryList.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final category = categoryList[index];
                    return InkWell(
                      onLongPress: () {
                        deleteCategoryDialog(context, category);
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListProducts(
                            categoryName: category.categoryName,
                            categoryID: category.categoryID,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: category.imageUrl == null
                                  ? Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.transparent,
                                      child: Image.asset(
                                        'assets/images/no-image-available.png',
                                        height: 40,
                                      ),
                                    )
                                  :category.imageUrl!.contains('asset')?Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.transparent,
                                      child: Image.asset(
                                          category.imageUrl!),
                                    ) :Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.transparent,
                                      child: Image.file(
                                          File(category.imageUrl!)),
                                    ),
                            ),
                            const Gap(5),
                            Text(
                              category.categoryName!,
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
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
                    'No Categories found',
                    style: GoogleFonts.nunitoSans(
                        color: Colors.grey, fontSize: 15),
                  ),
                );
        },
      ),
    );
  }
}