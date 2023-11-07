import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Widgets/snacc_button.dart';
typedef OnImageSelectedCallback = void Function(String?);

void addCategoryModalSheet(
    BuildContext context, formKey,) {
  final catgoryNameCtrl = TextEditingController();
  String? selectedCategoryImageUrl;

  showModalBottomSheet(
    constraints: const BoxConstraints.tightForFinite(height: 550),
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Add a new Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
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
                        
                      },
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: 
                        // selectedCategoryImageUrl != null
                        //     ? Image.file(
                        //         File(selectedCategoryImageUrl),
                        //         fit: BoxFit.cover,
                        //       )
                        //     : 
                            Container(
                                color: Colors.grey,
                                child: Image.asset('assets/images/no-image-available.png'),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: catgoryNameCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Category name',
                  ),
                ),
                const SizedBox(height: 10),
                SnaccButton(
                  callBack: () {
                    final name = catgoryNameCtrl.text.trim();

                    if (name.isNotEmpty) {
                      addbtn(name, selectedCategoryImageUrl);
                    } else {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.red,
                        msg: "FIELDS ARE EMPTY!",
                      );
                    }
                    catgoryNameCtrl.clear();
                  },
                  inputText: 'Add New Category',
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
