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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // CATEGORY LIST
              Column(
                children: [
                  const Text('Category',style: TextStyle(color: Colors.blue)),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
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
                ],
              ),
              
              // PRODUCT LIST
              Column(
                children: [
                  const Text('Product',style: TextStyle(color: Colors.blue)),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
                      itemHeight: 60,
                      value: selectedProduct,
                      items: productItems,
                      onChanged: (product) {
                        setState(() {
                          selectedProduct = product;
                          widget.onProductSelected(selectedProduct);
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
