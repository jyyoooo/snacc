import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/product_model.dart';
part 'category_model.g.dart';

@HiveType(typeId: 0)
class Category {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? categoryName;

  @HiveField(2)
  String? imageUrl;
  
  @HiveField(3)
  List<Product>? products = [];

  Category(
      {this.id,
      required this.categoryName,
      required this.imageUrl,
      this.products});
}







ValueNotifier<List<Category>> categoryListNotifier = ValueNotifier([]);

void addCategory(Category category) async {
  final categoryBox = await Hive.openBox<Category>('category');
  final id = await categoryBox.add(category);
  category.id = id;

  print('category id = ${category.id}');
  categoryListNotifier.value.add(category);
  categoryListNotifier.notifyListeners();
}



Future<void> displayalldata() async {
  final box = await Hive.openBox<Category>('category');
  final allvalues = box.values.toList();
  for (final category in allvalues) {
    print('name = ${category.categoryName}');
    print('id = ${category.id}');
    print('imageid = ${category.imageUrl}');
    print('product list = ${category.products}');
  }
}
