import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/favorites_functions.dart';


ValueNotifier<List<dynamic>> userBagNotifier = ValueNotifier([]);

addProductToBag(Product product) async {
  final user = await getUser();
  user.userBag ??= [];
  user.userBag!.add(product);
  userBagNotifier.value = user.userBag!;
  userBagNotifier.notifyListeners();
  await Hive.box<UserModel>('userinfo').put(user.userID, user);
  log('${user.username}s bag: ${user.userBag?.toList().map((e) => e is ComboModel ? e.comboName : e is Product ? e.prodname : null)}');
  Fluttertoast.showToast(
      msg: '${product.prodname} added to your Bag',
      backgroundColor: Colors.amber,
      textColor: Colors.black54);
}

addComboToBag(ComboModel combo) async {
  final user = await getUser();
  user.userBag ??= [];
  user.userBag!.add(combo);
  userBagNotifier.value = user.userBag!;
  userBagNotifier.notifyListeners();
  await Hive.box<UserModel>('userinfo').put(user.userID, user);
  log('${user.username}s bag: ${user.userBag?.toList().map((e) => e is ComboModel ? e.comboName : e is Product ? e.prodname : null)}');
  Fluttertoast.showToast(
      msg: '${combo.comboName} added to your Bag',
      backgroundColor: Colors.amber,
      textColor: Colors.black54);
}

removeItemFromBag(int index) async {
  final user = await getUser();
  final userBag = user.userBag;
  userBag?.removeAt(index);
  userBagNotifier.value = user.userBag!;
  userBagNotifier.notifyListeners();
}

Future<double> getTotalBagAmount(List<dynamic>? userBag) async {
  double totalComboAmount = 0.0;
  double totalProductAmount = 0.0;
  double totalAmount = 0.0;

  if (userBag != null) {
    for (dynamic item in userBag) {
      if (item is ComboModel) {
        totalComboAmount += item.comboPrice ?? 0.0;
      } else if (item is Product) {
        totalProductAmount += item.prodprice ?? 0.0;
      }
    }
  } else {
    log('userBag is empty');
  }
  final productAmount = double.parse(totalProductAmount.toStringAsFixed(4));
  totalAmount = totalComboAmount + productAmount;
  // log('total from function: $totalAmount');

  return totalAmount;
}
