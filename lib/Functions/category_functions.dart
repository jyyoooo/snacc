import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';

void deleteCategory(int? id) async {
  final categoryBox = await Hive.openBox<Category>('category');
  await categoryBox.delete(id);
  print('deltecategory id = $id');
  categoryListNotifier.value.removeWhere((category) => category.categoryID == id);

  categoryListNotifier.notifyListeners();

  print('deleted id = $id');
}

void editCategory(
    widget, ValueNotifier<List<Product>> productlistNotifier) async {
  final category = getCategoryById(widget.id);
  if (category != null) {
    final TextEditingController newcategorynamectrl = TextEditingController();
    String? updatedImgUrl = category.imageUrl;

    final exisitingCategoryname = category.categoryName;

    // SAVE BTN
    category.categoryName = newcategorynamectrl.text ?? exisitingCategoryname;
    category.imageUrl = updatedImgUrl;
    updatedCategory(category);
    saveCategory(category);
    productlistNotifier.notifyListeners();
  }
}

// EDIT CATEGORY
Future<void> updatedCategory(Category updatedCategory) async {
  final categoryBox = await Hive.openBox<Category>('category');

  final existingCategory = categoryBox.get(updatedCategory.categoryID);

  if (existingCategory != null) {
    existingCategory.categoryName = updatedCategory.categoryName;
    existingCategory.imageUrl = updatedCategory.imageUrl;
    await categoryBox.put(updatedCategory.categoryID, existingCategory);
  }
}
//SAVE CATEGORY
Future<void> saveCategory(Category category) async {
  final categoryBox = Hive.box<Category>('category');
  await categoryBox.put(category.categoryID, category);
  await categoryBox.add(category);
}

Category? getCategoryById(int? categoryId) {
  if (categoryId == null) return null ;

  final categoryBox = Hive.box<Category>('category');
  final category = categoryBox.get(categoryId);

  return category;
}

// FETCH CATEGORY PRODUCTS
Future<List<Product>?> getCategoryProducts(int? categoryId) async {
  if (categoryId == null) return null;

  final categoryBox = await Hive.openBox<Category>('category');
  final category = categoryBox.get(categoryId);

  return category?.products;
}
