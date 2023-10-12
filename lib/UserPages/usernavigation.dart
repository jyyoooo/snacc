import 'package:flutter/material.dart';
import 'package:snacc/Admin/adminaccount.dart';
import 'dart:ui';
import 'package:snacc/UserPages/bag.dart';
import 'package:snacc/UserPages/favorites.dart';
import 'package:snacc/UserPages/useraccount.dart';
import 'package:snacc/UserPages/userhome.dart';

class UserNavigation extends StatefulWidget {
  // final String? username;
  const UserNavigation({super.key,});

  @override
  State<UserNavigation> createState() => _UserNavigationState();
}


int selectedIndex = 0;
List<Widget> routes = <Widget>[
  const UserHome(
    categories: [],
  ),
  const Favorites(),
  const UserBag(),
  const UserAccount()
];

class _UserNavigationState extends State<UserNavigation> {
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
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: BottomNavigationBar(
              
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                backgroundColor: 
                Color.fromARGB(81, 42, 42, 42),
                elevation: 0,
                unselectedItemColor: Colors.black,
                selectedItemColor: Colors.amber,
                currentIndex: selectedIndex,
                showUnselectedLabels: false,
                showSelectedLabels: true,
                iconSize: 24,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_outline_rounded),
                      label: 'Favorite'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag_outlined), label: 'Bag'),
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
