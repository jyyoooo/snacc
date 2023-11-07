import 'package:flutter/material.dart';

import 'package:snacc/DataModels/category_model.dart';

import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/combos_functions.dart';

class ComboItemList extends StatefulWidget {
  final void Function(Product?) onProductSelected;

  const ComboItemList({super.key, required this.onProductSelected});

  @override
  State<ComboItemList> createState() => _ComboItemListState();
}

class _ComboItemListState extends State<ComboItemList> {
  List<DropdownMenuItem<Category>> categoryItem = [];
  Category? selectedCategory;
  Product? selectedProduct;
  List<DropdownMenuItem<Product>> productItems = [];

  @override
  void initState() {
    super.initState();
    fetchCategories().then((categories) => setState(
          () {
            categoryItem = categories;
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Choose a category to add products to a combo',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  // CATEGORY LIST
                  Column(
                    children: [
                      const Text('Category',
                          style: TextStyle(color: Colors.blue)),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),

                          // DROPDOWN
                          child: DropdownButton(
                            underline:const SizedBox(),
                            focusColor: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10),
                            hint: const Text(
                              'select category',
                              style: TextStyle(color: Colors.grey),
                            ),
                            itemHeight: 60,
                            value: selectedCategory,
                            items: categoryItem,
                            onChanged: (category) {
                              setState(() {
                                selectedCategory = category;
                                selectedProduct = null;
                                productItems = fetchProducts(selectedCategory!);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // PRODUCT LIST
                  Column(
                    children: [
                      const Text('Product',
                          style: TextStyle(color: Colors.blue)),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          
                          // DROPDOWN
                          child: DropdownButton(
                            underline:const SizedBox(),
                              borderRadius: BorderRadius.circular(10),
                              hint: const Text(
                                'select product',
                                style: TextStyle(color: Colors.grey),
                              ),
                              itemHeight: 60,
                              value: selectedProduct,
                              items: productItems,
                              onChanged: (product) {
                                setState(() {
                                  selectedProduct = product;
                                  widget.onProductSelected(selectedProduct);
                                });
                              }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
