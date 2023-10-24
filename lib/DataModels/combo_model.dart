import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/product_model.dart';
part 'combo_model.g.dart';

@HiveType(typeId: 3)
class ComboModel {

  @HiveField(0)
  String? comboName;

  @HiveField(1)
  double? comboPrice;

  @HiveField(2)
  String? comboImgUrl;

  @HiveField(3)
  List<Product?>? comboItems = [];

  ComboModel({this.comboImgUrl, this.comboItems, this.comboName, this.comboPrice});
}
