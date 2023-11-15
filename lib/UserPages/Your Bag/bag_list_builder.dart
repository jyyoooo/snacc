import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/UserPages/favorites.dart';

class BagListBuilder extends StatefulWidget {
  final ValueNotifier userBagNotifer;
  final UserModel? user;
  const BagListBuilder(
      {super.key, required this.userBagNotifer, required this.user});

  @override
  State<BagListBuilder> createState() => _BagListBuilderState();
}

class _BagListBuilderState extends State<BagListBuilder> {
  @override
  void initState() {
    super.initState();
    if (widget.user!.userBag != null) {
      userBagNotifier.value = widget.user?.userBag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 710,
          child: userBagNotifier.value!.isNotEmpty
              ? ValueListenableBuilder(
                  valueListenable: widget.userBagNotifer,
                  builder: (context, items, child) => ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item is ComboModel) {
                        return ComboListItem(
                          index: index,
                          isThisBag: true,
                          combo: item,
                          user: widget.user!,
                          favlist: widget.userBagNotifer,
                        );
                      } else if (item is Product) {
                        return ProductListItem(
                            index: index,
                            isThisBag: true,
                            product: item,
                            user: widget.user!,
                            favlist: widget.userBagNotifer);
                      } else {
                        return const Text('lololololol');
                      }
                    },
                    itemCount: widget.userBagNotifer.value.length,
                  ),
                )
              : const Text('bag mt')),
    );
  }
}
