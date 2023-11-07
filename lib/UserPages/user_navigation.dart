import 'package:flutter/material.dart';
import 'package:snacc/Admin/admin_profile.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/login_functions.dart';
import 'dart:ui';
import 'package:snacc/UserPages/Your%20Bag/bag.dart';
import 'package:snacc/UserPages/favorites.dart';
import 'package:snacc/UserPages/user_profile.dart';
import 'package:snacc/UserPages/user_home.dart';

class UserNavigation extends StatefulWidget {
  // final String? username;
  const UserNavigation({
    super.key,
  });

  @override
  State<UserNavigation> createState() => _UserNavigationState();
}

late Future<UserModel?> userFuture;
int selectedIndex = 0;

class _UserNavigationState extends State<UserNavigation> {
  List<Widget> routes = [];
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();

    userFuture = getCurrentUser();
    userFuture.then((user) {
      setState(() {
        currentUser = user;

        routes = <Widget>[
          UserHome(
            user: currentUser,
          ),
          const Favorites(),
          const UserBag(),
          UserAccount(
            user: currentUser,
          )
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FutureBuilder(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return routes[selectedIndex];
            }
            return const CircularProgressIndicator();
          }),
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
                // backgroundColor: Colors.grey,
                elevation: .0,
                unselectedItemColor: Colors.black54,
                selectedItemColor: Colors.amber,
                currentIndex: selectedIndex,
                showUnselectedLabels: false,
                showSelectedLabels: true,
                iconSize: 24,
                items: [
                  BottomNavigationBarItem(
                      backgroundColor: const Color.fromARGB(30, 134, 134, 134),
                      icon: selectedIndex == 0
                          ? const Icon(Icons.home_rounded)
                          : const Icon(Icons.home_outlined),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      backgroundColor: const Color.fromARGB(30, 134, 134, 134),
                      icon: selectedIndex == 1
                          ? const Icon(Icons.favorite_rounded)
                          : const Icon(Icons.favorite_border_rounded),
                      label: 'Favorite'),
                  BottomNavigationBarItem(
                      backgroundColor: const Color.fromARGB(30, 134, 134, 134),
                      icon: selectedIndex == 2
                          ? const Icon(Icons.shopping_bag_rounded)
                          : const Icon(Icons.shopping_bag_outlined),
                      label: 'Bag'),
                  BottomNavigationBarItem(
                      backgroundColor: const Color.fromARGB(30, 134, 134, 134),
                      icon: selectedIndex == 3
                          ? const Icon(Icons.account_circle_rounded)
                          : const Icon(Icons.account_circle_outlined),
                      label: 'Account')
                ]),
          ),
        ),
      ),
    );
  }
}
