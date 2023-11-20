import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/product_model.dart';

class ProductImageRow extends StatelessWidget {
  final Product? productOne;
  final Product? productTwo;

  const ProductImageRow({
    required this.productOne,
    required this.productTwo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // PRODUCT ONE
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Product 1',
              style: GoogleFonts.nunitoSans(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),

            // PRODUCT ONE NAME
            Text(
              productOne?.prodname ?? 'No Product Selected',
              style: GoogleFonts.nunitoSans(),
            ),
            const SizedBox(
              height: 10,
            ),

            // PRODUCT ONE IMAGE
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 134, 134, 134)
                        .withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),

              //IMAGE DATA
              child: productOne?.prodimgUrl != null && productOne != null
                  ? productOne!.prodimgUrl!.contains('assets/')
                      ? Image.asset(
                          productOne!.prodimgUrl!,
                          height: 60,
                        )
                      : Image.file(
                          File(productOne!.prodimgUrl!),
                          height: 60,
                        )
                  : SizedBox(
                      child: Image.asset('assets/images/no-image-available.png',
                          height: 60),
                    ),
            ),
          ],
        ),
        const Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(Icons.add),
          ],
        ),

        //PRODUCT TWO
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Product 2',
                style: GoogleFonts.nunitoSans(color: Colors.grey)),
            const SizedBox(
              height: 10,
            ),

            // PRODUCT NAME
            if (productTwo != null)
              Text(productTwo!.prodname!)
            else
              Text(
                'No Product Selected',
                style: GoogleFonts.nunitoSans(),
              ),
            const SizedBox(
              height: 10,
            ),

            // PRODUCT IMAGE
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 134, 134, 134)
                        .withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),

              // IMAGE DATA
              child: productTwo?.prodimgUrl == null && productTwo == null
                  ? SizedBox(
                      child: Image.asset('assets/images/no-image-available.png',
                          height: 60),
                    )
                  : productTwo!.prodimgUrl!.contains('assets/')
                      ? Image.asset(
                          productTwo!.prodimgUrl!,
                          height: 60,
                        )
                      : Image.file(
                          File(productTwo!.prodimgUrl!),
                          height: 60,
                        ),
            )
          ],
        ),
      ],
    );
  }
}
