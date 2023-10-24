import 'package:flutter/material.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/Admin/popular_combo.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Login/login.dart';
import 'package:snacc/Login/select_login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Login/splash_page.dart';
import 'package:snacc/UserPages/user_home.dart';
import 'package:snacc/UserPages/user_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryAdapter().typeId) &&
      !Hive.isAdapterRegistered(ProductAdapter().typeId) &&
      !Hive.isAdapterRegistered(UserModelAdapter().typeId)&&
      !Hive.isAdapterRegistered(ComboModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ComboModelAdapter());
  }
  await Hive.openBox<Category>('category');
  await Hive.openBox<UserModel>('userinfo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const SnaccSplash(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/selectLogin': (context) => const SelectLogin(),
        '/userNavigation': (context) => const UserNavigation(),
        '/login': (context) => const Login(),
        '/popularcombo': (context) => const PopularCombo()
      },
    );
  }
}
