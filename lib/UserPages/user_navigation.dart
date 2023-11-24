import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import 'dart:ui';
import 'package:snacc/UserPages/Your%20Bag/bag.dart';
import 'package:snacc/UserPages/favorites.dart';
import 'package:snacc/UserPages/user_profile/user_profile.dart';
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

    selectedIndex = 0;
    userFuture = getUser();
    userFuture.then((user) {
      setState(() {
        currentUser = user;

        routes = <Widget>[
          UserHome(user: currentUser),
          Favorites(user: currentUser),
          UserBag(user: currentUser),
          UserAccount(user: currentUser)
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
              return const Center(child: CircularProgressIndicator());
            }),
        bottomNavigationBar: Material(
            elevation: 0,
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              splashColor: Colors.blue[20],
                              highlightColor: Colors.transparent,
                              splashFactory: null,
                              bottomNavigationBarTheme:
                                  const BottomNavigationBarThemeData(
                                      enableFeedback: true,)),
                          child: BottomNavigationBar(
                              type: BottomNavigationBarType.shifting,
                              onTap: (index) {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              selectedLabelStyle: GoogleFonts.nunitoSans(),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              enableFeedback: false,
                              unselectedItemColor: Colors.black54,
                              selectedItemColor: Colors.blue[500],
                              currentIndex: selectedIndex,
                              showUnselectedLabels: false,
                              showSelectedLabels: true,
                              iconSize: 24,
                              items: const [
                                BottomNavigationBarItem(
                                    tooltip: 'Home',
                                    backgroundColor:
                                        Color.fromARGB(300, 460, 460, 460),
                                    icon: Icon(Icons.home_outlined),
                                    activeIcon: Icon(Icons.home_rounded),
                                    label: 'Home'),
                                BottomNavigationBarItem(
                                    tooltip: 'Favorites',
                                    backgroundColor:
                                        Color.fromARGB(300, 460, 460, 460),
                                    icon: Icon(Icons.favorite_border_rounded),
                                    activeIcon: Icon(Icons.favorite_rounded),
                                    label: 'Favorite'),
                                BottomNavigationBarItem(
                                    tooltip: 'Your Bag',
                                    backgroundColor:
                                        Color.fromARGB(300, 460, 460, 460),
                                    icon: Icon(Icons.shopping_bag_outlined),
                                    activeIcon:
                                        Icon(Icons.shopping_bag_rounded),
                                    label: 'Bag'),
                                BottomNavigationBarItem(
                                    tooltip: 'Your Profile',
                                    backgroundColor:
                                        Color.fromARGB(300, 460, 460, 460),
                                    icon: Icon(Icons.account_circle_outlined),
                                    activeIcon:
                                        Icon(Icons.account_circle_rounded),
                                    label: 'Profile')
                              ]),
                        ))))));
  }
}
