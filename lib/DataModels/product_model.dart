import 'package:hive_flutter/hive_flutter.dart';
part 'product_model.g.dart';

@HiveType(typeId: 1)
class Product {

  @HiveField(0)
  String? prodimgUrl;

  @HiveField(1)
  String? prodname;

  @HiveField(2)
  double? prodprice;

  @HiveField(3)
  int? quantity;

  @HiveField(4)
  bool? isFavorite;

  Product(
      {required this.prodimgUrl,
      required this.prodname,
      required this.prodprice,
      this.quantity,this.isFavorite = false});
}


