import 'package:flutter/material.dart';
import 'package:snacc/Admin/adminhome.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/signup_model.dart';
import 'package:snacc/Login/select_login.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  if(!Hive.isAdapterRegistered(CategoryAdapter().typeId)){
    Hive.registerAdapter(CategoryAdapter());
  }
  await Hive.openBox<Category>('category');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home:const SelectLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

