import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/Admin/Widgets/add_product.dart';
import 'package:snacc/Admin/products.dart';
import 'package:snacc/DataModels/product_model.dart';

class SnaccFloatingButton extends StatefulWidget {
  final ValueNotifier<List<Product>?> productListNotifier;
  const SnaccFloatingButton({
    super.key,
    required this.productformkey,
    required this.widget,
    required this.productListNotifier,
  });

  final GlobalKey<FormState> productformkey;
  final ListProducts widget;

  @override
  State<SnaccFloatingButton> createState() => _SnaccFloatingButtonState();
}

class _SnaccFloatingButtonState extends State<SnaccFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        height: 45,
        width: 170,
        child: FloatingActionButton.extended(
          splashColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          // backgroundColor: const Color.fromARGB(255, 84, 203, 88),
          backgroundColor: Colors.amber,
          label: Row(
            children: [
              const Icon(
                Icons.add,
                color: Colors.black,
              ),
              const Gap(5),
              Text(
                'NEW PRODUCT',
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onPressed: () {
            AddProductModalSheet.show(
              context,
              widget.productformkey,
              widget.widget.categoryID!,
              widget.productListNotifier,
            );
          },
        ),
      ),
    );
  }
}
