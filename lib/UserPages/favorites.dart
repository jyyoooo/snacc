import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/UserPages/user_navigation.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class Favorites extends StatefulWidget {
  final UserModel? user;
  const Favorites({super.key, required this.user});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<dynamic>? favList;

  @override
  void initState() {
    super.initState();

    setState(() {
      favList = widget.user?.favorites;
      favoriteListNotifier.value = favList ?? [];
      favoriteListNotifier.notifyListeners();
    });
    log('favorites: ${widget.user?.favorites?.toList().map((e) => e is ComboModel ? e.comboName : e is Product ? e.prodname : null)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: const Icon(
          Icons.favorite,
          color: Colors.white,
        ),
        actions: [
          favoriteListNotifier.value.isNotEmpty
              ? TextButton(
                  onPressed: () async {
                    await removeAllFavoriteShowDialog(context, favList!);
                    setState(() {
                      favoriteListNotifier.notifyListeners();
                    });
                  },
                  child: Text(
                    'Remove All',
                    style: GoogleFonts.nunitoSans(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ))
              : TextButton(
                  onPressed: () {},
                  child: Text(
                    'Remove All',
                    style: GoogleFonts.nunitoSans(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ))
        ],
        title: Text(
          'Favorites',
          style:
              GoogleFonts.nunitoSans(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              child: ValueListenableBuilder(
                valueListenable: favoriteListNotifier,
                builder: (context, favorites, child) =>
                    favoriteListNotifier.value.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final fav = favorites[index];

                              if (fav is ComboModel) {
                                return ComboListItem(
                                  isThisBag: false,
                                  combo: fav,
                                  user: widget.user!,
                                  favlist: favoriteListNotifier,
                                );
                              } else if (fav is Product) {
                                return ProductListItem(
                                    isThisBag: false,
                                    product: fav,
                                    user: widget.user ??
                                        UserModel(
                                            username: null,
                                            userMail: null,
                                            userPass: null,
                                            confirmPass: null),
                                    favlist: favoriteListNotifier);
                              } else {
                                return null;
                              }
                            },
                            itemCount: favoriteListNotifier.value.length,
                          )
                        : Center(
                            heightFactor: 9,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                Text(
                                  'No Favorites',
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
              ),
            )),
      ),
    );
  }
}

class ComboListItem extends StatefulWidget {
  final ComboModel combo;
  final UserModel user;
  final ValueNotifier favlist;
  final bool isThisBag;
  final int? index;

  const ComboListItem(
      {super.key,
      required this.combo,
      required this.user,
      required this.favlist,
      required this.isThisBag,
      this.index});

  @override
  State<ComboListItem> createState() => _ComboListItemState();
}

class _ComboListItemState extends State<ComboListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          log('fav combo id: ${widget.combo.comboID}');
        },
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
                                child: Image.file(
                                  File(widget.combo.comboImgUrl!),
                                  fit: BoxFit.cover,
                                ),
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
                                  width: 180,
                                  child: Text(
                                    widget.combo.comboName!,
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                !widget.isThisBag
                                    ? Text('₹${widget.combo.comboPrice!} ',
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 89,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    widget.isThisBag
                                        ? removeItemFromBag(widget.index!)
                                        : removeComboFromFavorites(
                                            widget.combo);
                                    widget.favlist.notifyListeners();
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.grey,
                                  )),
                              widget.isThisBag
                                  ? Text(
                                      '${widget.combo.comboPrice} ',
                                      style: GoogleFonts.nunitoSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SnaccButton(
                                      width: 70,
                                      inputText: 'ADD',
                                      callBack: () {
                                        addComboToBag(widget.combo);
                                      },
                                      btncolor: Colors.amber,
                                    ),
                            ],
                          ),
                        )
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

class ProductListItem extends StatefulWidget {
  final Product product;
  final UserModel user;
  final ValueNotifier favlist;
  final bool isThisBag;
  final int? index;

  const ProductListItem(
      {super.key,
      required this.product,
      required this.user,
      required this.favlist,
      required this.isThisBag,
      this.index});

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          log('fav product id: ${widget.product.productID}');
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                  child: widget.product.prodimgUrl != null
                                      ? Image.file(
                                          File(widget.product.prodimgUrl!),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 188,
                                    child: Text(
                                      widget.product.prodname!,
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  !widget.isThisBag
                                      ? Text('₹${widget.product.prodprice!} ',
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold))
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    widget.isThisBag
                                        ? removeItemFromBag(widget.index!)
                                        : removeProductFromFavorites(
                                            widget.product,
                                            widget.user,
                                            widget.favlist);
                                    widget.favlist.notifyListeners();
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.grey,
                                  )),
                              widget.isThisBag
                                  ? Text(
                                      '${widget.product.prodprice} ',
                                      style: GoogleFonts.nunitoSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SnaccButton(
                                      width: 70,
                                      inputText: 'ADD',
                                      callBack: () {
                                        addProductToBag(widget.product);
                                      },
                                      btncolor: Colors.amber,
                                    ),
                            ],
                          )
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
            ),
          ],
        ),
      ),
    );
  }
}
