import 'dart:ui';

import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final void Function(int index) onTabTapped;
  final int selectedIndex;

  const NavBar({
    Key? key,
    required this.onTabTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: BottomNavigationBar(
            onTap: widget.onTabTapped,
            elevation: 0,
            unselectedItemColor: Colors.black54,
            selectedItemColor: Colors.amber,
            currentIndex: widget.selectedIndex,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            iconSize: 24,
            items: const [
              BottomNavigationBarItem(
                tooltip: 'Home',
                backgroundColor: Color.fromARGB(30, 112, 112, 112),
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                tooltip: 'Favorites',
                backgroundColor: Color.fromARGB(30, 112, 112, 112),
                icon: Icon(Icons.favorite_border_rounded),
                activeIcon: Icon(Icons.favorite_rounded),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                tooltip: 'Your Bag',
                backgroundColor: Color.fromARGB(30, 112, 112, 112),
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag_rounded),
                label: 'Bag',
              ),
              BottomNavigationBarItem(
                tooltip: 'Your Profile',
                backgroundColor: Color.fromARGB(30, 112, 112, 112),
                icon: Icon(Icons.account_circle_outlined),
                activeIcon: Icon(Icons.account_circle_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
