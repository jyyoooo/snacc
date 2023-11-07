import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/Admin/build_popular_combo.dart';
import 'package:snacc/Admin/manage_orders/manage_orders.dart';
// import 'package:snacc/Admin/create_popular_combo.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/order_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Authentication/login.dart';
import 'package:snacc/Authentication/select_login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Authentication/splash_page.dart';
import 'package:snacc/UserPages/Your%20Bag/payment.dart';
import 'package:snacc/UserPages/user_home.dart';
import 'package:snacc/UserPages/user_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // await Firebase.initializeApp();

  if (!Hive.isAdapterRegistered(CategoryAdapter().typeId) &&
      !Hive.isAdapterRegistered(ProductAdapter().typeId) &&
      !Hive.isAdapterRegistered(UserModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(ComboModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(OrderAdapter().typeId)&&
      !Hive.isAdapterRegistered(PaymentOptionAdapter().typeId)&&
      !Hive.isAdapterRegistered(OrderStatusAdapter().typeId)) {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ComboModelAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(PaymentOptionAdapter());
    Hive.registerAdapter(OrderStatusAdapter());
  }
  await Hive.openBox<Order>('orders');
  await Hive.openBox<Category>('category');
  await Hive.openBox<UserModel>('userinfo');
  await Hive.openBox<ComboModel>('combos');
  await Hive.openBox<Product>('products');
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
