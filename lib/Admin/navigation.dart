import 'package:flutter/material.dart';
import 'package:snacc/Admin/adminaccount.dart';
import 'dart:ui';

import 'package:snacc/Admin/adminhome.dart';
import 'package:snacc/Admin/orders.dart';

class Navigation extends StatefulWidget {
  Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

int selectedIndex = 0;
List<Widget> routes = <Widget>[AdminHome(), const Orders(), const Accounts()];

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true,
      body: routes[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: BottomNavigationBar(
              
              onTap: (index){setState(() {
                selectedIndex = index;
              });},
                backgroundColor: const Color.fromRGBO(0, 0, 0, .32),
                elevation: 0,
                unselectedItemColor: Colors.white,
                currentIndex: selectedIndex,
                showUnselectedLabels: false,
                showSelectedLabels: true,
                iconSize: 24,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_outlined),
                      label: 'Account')
                ]),
          ),
        ),
      ),
    );
  }
}
