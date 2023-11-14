import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';

TextButton clearData() {
  return TextButton(
      onPressed: () {
        Hive.box<Product>('products').clear();
        Hive.box<Category>('category').clear();
      },
      child: Text(
        'Clear Data',
        style: GoogleFonts.nunitoSans(color: Colors.red),
      ));
}
