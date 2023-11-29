import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  int? categoryID;

  @HiveField(1)
  String? categoryName;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  List<int>? productsReference;

  Category(
      {this.categoryID,
      required this.categoryName,
      required this.imageUrl,
      List<int>? productsReference})
      : productsReference = productsReference ?? [];
}

ValueNotifier<List<Category>> categoryListNotifier = ValueNotifier([]);

void addCategory(Category category) async {

  // OPEN BOX
  final categoryBox = Hive.box<Category>('category');

  // GET ID FROM HIVE ON ADD AND ASSIGN IT TO A VARIABLE
  final id = await categoryBox.add(category);

  // ASSIGN THE ID FROM HIVE TO THE OBJECT'S ID FIELD
  category.categoryID = id;
  
  // UPDATE THE OBJECT IN THE BOX
  await categoryBox.put(id, category);

  log('category id = ${category.categoryID}');

  if (!categoryListNotifier.value
      .any((category) => category.categoryID == id)) {
    categoryListNotifier.value.add(category);
    categoryListNotifier.notifyListeners();
  }
  // SnaccBar(content: 'Snaccbar is working bro!', color: Colors.purple);
}
