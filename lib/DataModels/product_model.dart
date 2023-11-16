import 'package:hive_flutter/hive_flutter.dart';
part 'product_model.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  int? productID;

  @HiveField(1)
  String? prodimgUrl;

  @HiveField(2)
  String? prodname;

  @HiveField(3)
  double? prodprice;

  @HiveField(4)
  int? quantity;

  @HiveField(5)
  bool? isFavorite;

  @HiveField(6)
  int? categoryID;

  @HiveField(7)
  String? description;

  Product(
      {required this.prodimgUrl,
      required this.prodname,
      required this.prodprice,
      required this.description,
      this.quantity,
      this.isFavorite = false,
      this.categoryID,
      this.productID});
      
}
