import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/product_model.dart';
part 'combo_model.g.dart';

@HiveType(typeId: 3)
class ComboModel {
  @HiveField(0)
  int? comboID;

  @HiveField(1)
  String? comboName;

  @HiveField(2)
  double? comboPrice;

  @HiveField(3)
  String? comboImgUrl;

  @HiveField(4)
  List<Product?>? comboItems = [];

  @HiveField(5)
  bool? isFavorite;

  @HiveField(6)
  String? description;

  ComboModel(
      {this.comboID,
      this.comboImgUrl,
      this.comboItems,
      this.comboName,
      this.comboPrice,
      this.isFavorite = false});
   
}
