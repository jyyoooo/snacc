import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';

// Products fucntions

 ValueNotifier<List<dynamic>> favoriteListNotifier = ValueNotifier<List<dynamic>>([]);
// add PRODUCT to FAVORITES

void addProductToFavorite(Product product, UserModel user) async {
  user.favorites ??= [];
  product.isFavorite = true;
  await Hive.box<Product>('products').put(product.productID, product);
  user.favorites!.add(product);
  await Hive.box<UserModel>('userinfo').put(user.userID, user);
}

// remove PRODUCT from FAVORITES

void removeProductFromFavorites(Product product, UserModel user,
    [ValueNotifier? favListNotifier]) async {
  user.favorites?.remove(product);
  await Hive.box<UserModel>('userinfo').put(user.userID, user);
  product.isFavorite = false;
  await Hive.box<Product>('products').put(product.productID, product);
  favListNotifier?.notifyListeners();
}

// Combos functions
// add COMBO to FAVORITES

addComboToFavorite(ComboModel combo) async {
  final user = await getUser();
  user.favorites ??= [];
  combo.isFavorite = true;
  await Hive.box<ComboModel>('combos').put(combo.comboID, combo);
  user.favorites!.add(combo);
  await Hive.box<UserModel>('userinfo').put(user.userID, user);
}

// remove PRODUCT from FAVORITES

removeComboFromFavorites(ComboModel combo) async {
  final user = await getUser();
  user.favorites?.remove(combo);
  Hive.box<UserModel>('userinfo').put(user.userID, user);
  combo.isFavorite = false;
  Hive.box<ComboModel>('combos').put(combo.comboID, combo);
}

// remove ALL FAVORITES

removeAllFavorites(List favList) async {
  final currentuser = await getCurrentUser();
  final user = Hive.box<UserModel>('userinfo')
      .values
      .firstWhere((user) => user.userID == currentuser?.userID);

  for (dynamic item in favList) {
    if (item is ComboModel) {
      if (item.isFavorite!) {
        item.isFavorite = false;
        Hive.box<ComboModel>('combos').put(item.comboID, item);
      }
    }else if(item is Product){
      if(item.isFavorite!){
        item.isFavorite = false;
        Hive.box<Product>('products').put(item.productID, item);
      }
    }
  }

  user.favorites?.clear();
  Hive.box<UserModel>('userinfo').put(user.userID, user);
}

Future<UserModel> getUser() async {
  final currentuser = await getCurrentUser();
  final user = Hive.box<UserModel>('userinfo')
      .values
      .firstWhere((user) => user.userID == currentuser?.userID);
  return user;
}


// remove all dialog

Future<dynamic> removeAllFavoriteShowDialog(context, List favList) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Remove all your favorites?'),
          actions: [
            SnaccButton(
              width: 100,
              textColor: Colors.white,
                btncolor: Colors.red,
                callBack: () {
                  removeAllFavorites(favList);
                  Navigator.pop(context);
                },
                inputText: 'REMOVE')
          ],
        );
      });
}
