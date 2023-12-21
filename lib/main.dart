import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacc/Admin/build_popular_combo.dart';
import 'package:snacc/Admin/manage_orders/manage_orders.dart';
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
import 'package:snacc/UserPages/provider.dart';
import 'package:snacc/UserPages/user_navigation.dart';
import 'Admin/Widgets/carousel_management.dart';
import 'Admin/admin_home.dart';
import 'Admin/admin_navigation.dart';
import 'Admin/admin_profile.dart';
import 'Functions/populate_initial_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryAdapter().typeId) &&
      !Hive.isAdapterRegistered(ProductAdapter().typeId) &&
      !Hive.isAdapterRegistered(UserModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(ComboModelAdapter().typeId) &&
      !Hive.isAdapterRegistered(OrderAdapter().typeId) &&
      !Hive.isAdapterRegistered(PaymentOptionAdapter().typeId) &&
      !Hive.isAdapterRegistered(OrderStatusAdapter().typeId)) {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ComboModelAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(PaymentOptionAdapter());
    Hive.registerAdapter(OrderStatusAdapter());
  }
  await Hive.openBox<bool>('loggedUserBox');
  await Hive.openBox<Order>('orders');
  await Hive.openBox<Category>('category');
  await Hive.openBox<UserModel>('userinfo');
  await Hive.openBox<ComboModel>('combos');
  await Hive.openBox<Product>('products');
  await Hive.openBox<String>('carousel');

  await populateInitialData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SeatScreenData()),
        ChangeNotifierProvider(create: (context) => CarouselNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const SnaccSplash(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/selectLogin': (context) => const SelectLogin(),
        '/login': (context) => const Login(),
        '/userNavigation': (context) => const UserNavigation(),
        '/popularcombo': (context) => const PopularCombo(),
        '/orders': (context) => const OrdersPage(),
        '/adminHome': (context) => const AdminHome(),
        '/adminNavigation': (context) => const AdminNavigation(),
        '/adminAccount': (context) => const AdminAccount(),
        '/popularCombo': (context) => const PopularCombo(),
        '/carouselManagement' : (context) => const CarouselManagement(),
      },
    );
  }
}
