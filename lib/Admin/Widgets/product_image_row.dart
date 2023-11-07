import 'dart:io';

import 'package:flutter/material.dart';
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
            const Text(
              'Product 1',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),

            // PRODUCT ONE NAME
            Text(productOne?.prodname ?? 'No Product Selected'),
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
                  ? Image.file(
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
            SizedBox(height: 20,),
             Icon(Icons.add),
          ],
        ),

        //PRODUCT TWO
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Product 2', style: TextStyle(color: Colors.grey)),
            const SizedBox(
              height: 10,
            ),

            // PRODUCT NAME
            if (productTwo != null)
              Text(productTwo!.prodname!)
            else
              const Text('No Product Selected'),
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
