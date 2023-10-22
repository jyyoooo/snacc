import 'package:flutter/material.dart';
import 'package:snacc/Admin/admin_account.dart';
import 'dart:ui';
import 'package:snacc/UserPages/bag.dart';
import 'package:snacc/UserPages/favorites.dart';
import 'package:snacc/UserPages/user_account.dart';
import 'package:snacc/UserPages/user_home.dart';

class UserNavigation extends StatefulWidget {
  // final String? username;
  const UserNavigation({
    super.key,
  });

  @override
  State<UserNavigation> createState() => _UserNavigationState();
}

int selectedIndex = 0;
List<Widget> routes = <Widget>[
  const UserHome(
    
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
                backgroundColor:Colors.grey,
                elevation: 5,
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
