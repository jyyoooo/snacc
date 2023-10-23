import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/product_model.dart';
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
  List<Product>? products = [];

  Category(
      {this.categoryID,
      required this.categoryName,
      required this.imageUrl,
      this.products});
}

ValueNotifier<List<Category>> categoryListNotifier = ValueNotifier([]);

void addCategory(Category category) async {
  final categoryBox = await Hive.openBox<Category>('category');
  final id = await categoryBox.add(category);
  //ignore:avoid_print
  print('category id from hive = $id');

  category.categoryID = id;

  await categoryBox.put(id, category);

  //ignore:avoid_print
  print('category id = ${category.categoryID}');

  if (!categoryListNotifier.value.any((category) => category.categoryID == id)) {
    categoryListNotifier.value.add(category);
    categoryListNotifier.notifyListeners();
  }
}

Future<void> displayalldata() async {
  final box = await Hive.openBox<Category>('category');
  final allvalues = box.values.toList();

  for (final category in allvalues) {
    //ignore:avoid_print
    print('name = ${category.categoryName}  with id = ${category.categoryID}');
  }
}
