import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/category_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Functions/product_functions.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  EditProduct({required this.product});

  @override
  _EditProductState createState() => _EditProductState();

  static void show(BuildContext context, Product product) {
    showModalBottomSheet(
      showDragHandle: true,
      constraints: const BoxConstraints.expand(),
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return EditProduct(product: product);
      },
    );
  }
}

class _EditProductState extends State<EditProduct> {
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  String? newImage;

  @override
  void initState() {
    super.initState();
    newNameController.text = widget.product.prodname!;
    newPriceController.text = widget.product.prodprice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Edit ${widget.product.prodname}',
            style: GoogleFonts.nunitoSans(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Gap(20),
          Text(
            'Select new image for the product',
            style: GoogleFonts.nunitoSans(fontSize: 15, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.square(
                dimension: 100,
                child: (newImage != null && newImage!.isNotEmpty)
                    ? Image.file(File(newImage!))
                    : (widget.product.prodimgUrl != null &&
                            widget.product.prodimgUrl!.isNotEmpty)
                        ? widget.product.prodimgUrl!.contains('assets/')
                            ? Image.asset(widget.product.prodimgUrl!)
                            : Image.file(File(widget.product.prodimgUrl!))
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey),
                            child: Image.asset(
                              'assets/images/no-image-available.png',
                              fit: BoxFit.cover,
                            ),
                          ),
              ),
              SnaccButton(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.blue,
                ),
                width: 60,
                btncolor: Colors.white70,
                inputText: '',
                callBack: () async {
                  newImage = await pickImageFromGallery();
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          SnaccTextField(
            controller: newNameController,
            label: 'New product name',
          ),
          SnaccTextField(
            controller: newPriceController,
            label: 'New product price',
          ),
          const SizedBox(height: 10),
          SnaccButton(
            width: 80,
            textColor: Colors.white,
            callBack: () {
              widget.product.prodname = newNameController.text;
              widget.product.prodprice =
                  double.tryParse(newPriceController.text) ??
                      widget.product.prodprice;
              widget.product.prodimgUrl = newImage ?? widget.product.prodimgUrl;

              final productBox = Hive.box<Product>('products');
              productBox.put(widget.product.productID, widget.product);

              productListNotifier.notifyListeners();
              Navigator.pop(context);
            },
            inputText: 'SAVE',
          ),
        ],
      ),
    );
  }
}
