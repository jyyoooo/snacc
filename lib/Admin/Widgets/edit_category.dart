import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

import '../../Widgets/snacc_button.dart';

class EditCategory extends StatefulWidget {
  final int? categoryID;

  const EditCategory({
    Key? key,
    required this.categoryID,
  }) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  String? updatedImgUrl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final category = getCategoryById(widget.categoryID);
        if (category != null) {
          final TextEditingController newCategoryNameCtrl =
              TextEditingController(text: category.categoryName);
          updatedImgUrl = category.imageUrl;

          await showModalBottomSheet(
            constraints: const BoxConstraints.expand(),
            useSafeArea: true,
            isScrollControlled: true,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Edit ${category.categoryName} Category',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        Text(
                          'Select new image for the category',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.blue, fontSize: 15),
                        ),
                        const Gap(15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: updatedImgUrl != null
                                  ? Image.file(
                                      File(updatedImgUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox(
                                      child: Image.asset(
                                          'assets/images/no-image-available.png'),
                                    ),
                            ),
                            const Gap(10),
                            SnaccButton(
                              width: 60,
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.blue,
                              ),
                              btncolor: Colors.white70,
                              inputText: 'New Image',
                              callBack: () async {
                                updatedImgUrl = await pickImageFromGallery();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        SnaccTextField(
                          label: 'Category name',
                          controller: newCategoryNameCtrl,
                        ),
                        const Gap(20),
                        SnaccButton(
                          textColor: Colors.white,
                          inputText: 'SAVE',
                          width: 80,
                          callBack: () async {
                            category.categoryName = newCategoryNameCtrl.text;
                            category.imageUrl = updatedImgUrl;
                            saveCategory(category);
                            categoryListNotifier.notifyListeners();
                            productListNotifier.value =
                                await getCategoryProducts(widget.categoryID);
                            productListNotifier.notifyListeners();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      },
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
    );
  }
}
