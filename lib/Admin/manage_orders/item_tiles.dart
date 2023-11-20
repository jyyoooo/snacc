import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';

class ComboTile extends StatelessWidget {
  final ComboModel combo;
  final bool isHistory;
  const ComboTile({super.key, required this.combo, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: combo.comboImgUrl != null
                                    ? combo.comboImgUrl!.contains('assets/')
                                        ? Image.asset(combo.comboImgUrl!)
                                        : Image.file(
                                            File(combo.comboImgUrl!),
                                            fit: BoxFit.cover,
                                          )
                                    : Image.asset(
                                        'assets/images/no-image-available.png'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 190,
                                  child: Text(
                                    combo.comboName!,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        isHistory
                            ? SizedBox(
                                width: 89,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${combo.comboPrice} ',
                                      style: GoogleFonts.nunitoSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class ProductTIle extends StatelessWidget {
  final Product product;
  final bool isHistory;
  const ProductTIle(
      {super.key, required this.product, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: product.prodimgUrl != null
                                    ? product.prodimgUrl!.contains('assets/')
                                        ? Image.asset(product.prodimgUrl!)
                                        : Image.file(
                                            File(product.prodimgUrl!),
                                            fit: BoxFit.cover,
                                          )
                                    : Image.asset(
                                        'assets/images/no-image-available.png'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    product.prodname!,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        isHistory
                            ? SizedBox(
                                width: 89,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${product.prodprice} ',
                                      style: GoogleFonts.nunitoSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
