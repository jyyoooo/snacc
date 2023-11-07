import 'package:flutter/material.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/UserPages/favorites.dart';

class BagListBuilder extends StatefulWidget {
  final ValueNotifier userBagNotifer;
  final UserModel? user;
  const BagListBuilder({super.key,required this.userBagNotifer,required this.user});

  @override
  State<BagListBuilder> createState() => _BagListBuilderState();
}

class _BagListBuilderState extends State<BagListBuilder> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(height: 710,
              child: ValueListenableBuilder(
                valueListenable: widget.userBagNotifer,
                builder: (context, items, child) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                          product: item, user: widget.user!, favlist: widget.userBagNotifer);
                    } else {
                      return null;
                    }
                  },
                  itemCount: widget.userBagNotifer.value.length,
                ),
              ),
            ),
          ),
        );
  }
}