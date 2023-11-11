import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

class AddCategoryModalSheet extends StatefulWidget {
  @override
  AddCategoryModalSheetState createState() => AddCategoryModalSheetState();

  static void show(BuildContext context, GlobalKey<FormState> formKey) {
    showModalBottomSheet(
      constraints: const BoxConstraints.tightForFinite(height: 650),
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return AddCategoryModalSheet();
      },
    );
  }
}

class AddCategoryModalSheetState extends State<AddCategoryModalSheet> {
  final formKey = GlobalKey<FormState>();
  final catgoryNameCtrl = TextEditingController();
  String? selectedCategoryImageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Add a new Category',
                style: GoogleFonts.nunitoSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              Text(
                'Select image for the category',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                ),
              ),
              const Gap(20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: selectedCategoryImageUrl != null
                        ? Image.file(
                            File(selectedCategoryImageUrl!),
                            fit: BoxFit.cover,
                            scale: 5,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey),
                            child: Image.asset(
                              'assets/images/no-image-available.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  SnaccButton(
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.blue,
                    ),
                    width: 60,
                    btncolor: Colors.white70,
                    inputText: '',
                    callBack: () async {
                      selectedCategoryImageUrl = await pickImageFromGallery();
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SnaccTextField(
                controller: catgoryNameCtrl,
                label: 'New category name',
                validationMessage: 'Category name is required',
              ),
              const Gap(10),
              SnaccButton(
                textColor: Colors.white,
                callBack: () {
                  final name = catgoryNameCtrl.text.trim();
                  formKey.currentState!.validate();

                  if (name.isNotEmpty || selectedCategoryImageUrl != null) {
                    addbtn(name, selectedCategoryImageUrl);
                  } else {
                    Fluttertoast.showToast(
                      textColor: Colors.black,
                      backgroundColor: Colors.amber,
                      msg: "Pick image and category name",
                    );
                  }
                  catgoryNameCtrl.clear();
                },
                inputText: 'ADD CATEGORY',
              )
            ],
          ),
        ),
      ),
    );
  }
}
