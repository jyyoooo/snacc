import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/UserPages/userproductspage.dart';

class UserHome extends StatefulWidget {
  final List<Category> categories;
  const UserHome({super.key, required this.categories});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // @override
  // void initState() {
  //   super.initState();
  //   fetchCategories();
  // }

  // void fetchCategories() {
  //   categoryListNotifier.value = widget.categories;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: ValueListenableBuilder(
              valueListenable: categoryListNotifier,
              builder: (BuildContext context, List<Category> categorylist,
                  Widget? child) {
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categorylist.length,
                    itemBuilder: (context, index) {
                      final category = categorylist[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push((MaterialPageRoute(
                            builder: (context) => UserListProducts(
                              categoryName: category.categoryName,
                              id: category.id,
                            ),
                          )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.transparent,
                                    child: Image.file(File(category.imageUrl!)),
                                  )),
                              const SizedBox(height: 5),
                              Text(
                                category.categoryName!,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Offers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Card(
            elevation: 0,
            child: Image.asset('assets/images/Admin_page/ad_items.png'),
          ),
          const SizedBox(
            height: 8,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Combos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          Expanded(
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => SizedBox(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Expanded(
                              child: Image.asset(
                                'assets/popular_combos/Popcorn and cola.png',
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Product',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '\$12.50',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )),
          )
        ]),
      ),
    );
  }
}
