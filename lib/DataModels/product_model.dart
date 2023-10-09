import 'package:hive_flutter/hive_flutter.dart';
part 'product_model.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String? prodimgUrl;
  @HiveField(1)
  String? name;
  @HiveField(2)
  double? price;
  @HiveField(3)
  int? quantity;

  Product({
    required this.prodimgUrl,
    required this.name,
    required this.price,
  });
}
