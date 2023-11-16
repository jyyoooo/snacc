import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Widgets/snacc_button.dart';

// ADD CATEGORY
Future<void> addbtn(name, String? selectedImgUrl) async {
  final String? imagePath = selectedImgUrl;
  log('addcatimg: $imagePath');

  final category = Category(categoryName: name, imageUrl: imagePath);

  addCategory(category);

  final categorieslist = Hive.box<Category>('category').values.toList();
  categoryListNotifier.value = categorieslist;
  categoryListNotifier.notifyListeners();
}

// DELETE CATEGORY
void deleteCategory(
  int? id,
) async {
  final categoryBox = await Hive.openBox<Category>('category');
  await categoryBox.delete(id);

  Future.delayed(Duration.zero, () {
    categoryListNotifier.value
        .removeWhere((category) => category.categoryID == id);
    categoryListNotifier.notifyListeners();
  });
  // Navigator.of(context).pop
}

//  EDIT CATEGORY
// void editCategory(
//     widget, ValueNotifier<List<Product>> productlistNotifier) async {
//   final category = getCategoryById(widget.id);
//   if (category != null) {
//     final TextEditingController newcategorynamectrl = TextEditingController();
//     String? updatedImgUrl = category.imageUrl;

//     final exisitingCategoryname = category.categoryName;

//     // SAVE BTN
//     category.categoryName = newcategorynamectrl.text ?? exisitingCategoryname;
//     category.imageUrl = updatedImgUrl;
//     // updatedCategory(category);
//     saveCategory(category);
//     productlistNotifier.notifyListeners();
//   }
// }

// // UPDATE CATEGORY IN DB
// Future<void> updatedCategory(Category updatedCategory) async {
//   final categoryBox = await Hive.openBox<Category>('category');

//   final existingCategory = categoryBox.get(updatedCategory.categoryID);

//   if (existingCategory != null) {
//     existingCategory.categoryName = updatedCategory.categoryName;

//     existingCategory.imageUrl = updatedCategory.imageUrl;

//     await categoryBox.put(updatedCategory.categoryID, existingCategory);
//   }
// }

//SAVE CATEGORY
Future<void> saveCategory(Category category) async {
  final categoryBox = Hive.box<Category>('category');
  await categoryBox.put(category.categoryID, category);
}

// FETCH CATEGORY BY ID
Category? getCategoryById(int? categoryId) {
  if (categoryId == null) return null;

  final categoryBox = Hive.box<Category>('category');
  final category = categoryBox.get(categoryId);

  return category;
}

Future<List<Category>> getAllCategories() async {
  final categoryBox = Hive.box<Category>('category');
  final allCategories = categoryBox.values.toList();
  return allCategories;
}

deleteCategoryDialog(
  context,
  Category category,
) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete \'${category.categoryName}\' category?'),
          // content: const Text('tap outside to cancel',style: TextStyle(color: Colors.grey),),
          actions: <Widget>[
            SnaccButton(
              textColor: Colors.white,
              btncolor: Colors.red,
              inputText: 'Delete',
              callBack: () {
                if (category.categoryID != null) {
                  deleteCategory(category.categoryID);

                  Navigator.of(context).pop();

                  print('deleted id = ${category.categoryID}');
                } else {
                  print('deletion error');
                }
              },
            )
          ],
        );
      });
}
