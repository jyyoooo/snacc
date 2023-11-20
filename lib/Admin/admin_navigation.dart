import 'package:flutter/material.dart';
import 'package:snacc/Admin/admin_profile.dart';
import 'dart:ui';
import 'package:snacc/Admin/admin_home.dart';
import 'package:snacc/Admin/manage_orders/manage_orders.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

int selectedIndex = 0;
List<Widget> routes = <Widget>[
  const AdminHome(),
  const OrdersPage(),
  const AdminAccount()
];

class _AdminNavigationState extends State<AdminNavigation> {

  @override
  void initState(){
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: routes[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                backgroundColor: Color.fromARGB(39, 149, 149, 149),
                elevation: 0,
                unselectedItemColor: Colors.black54,
                selectedItemColor: Colors.blue,
                currentIndex: selectedIndex,
                showUnselectedLabels: false,
                showSelectedLabels: true,
                iconSize: 24,
                items: [
                  BottomNavigationBarItem(
                      icon: selectedIndex == 0
                          ? const Icon(Icons.add_home_rounded)
                          : const Icon(Icons.add_home_outlined),
                      label: 'Products'),
                  BottomNavigationBarItem(
                      icon: selectedIndex == 1
                          ? const Icon(Icons.receipt_rounded)
                          : const Icon(Icons.receipt_outlined),
                      label: 'Orders'),
                  BottomNavigationBarItem(
                      icon: selectedIndex == 2
                          ? const Icon(Icons.admin_panel_settings_rounded)
                          : const Icon(Icons.admin_panel_settings_outlined),
                      label: 'Account')
                ]),
          ),
        ),
      ),
    );
  }
}
