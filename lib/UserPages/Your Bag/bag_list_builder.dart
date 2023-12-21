import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/DataModels/product_model.dart';
import 'package:snacc/DataModels/user_model.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/UserPages/favorites.dart';

class BagListBuilder extends StatefulWidget {
  // final ValueNotifier userBagNotifer;
  final UserModel? user;
  const BagListBuilder({super.key, required this.user});

  @override
  State<BagListBuilder> createState() => _BagListBuilderState();
}

class _BagListBuilderState extends State<BagListBuilder> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: 710,
            child: ValueListenableBuilder(
              valueListenable: userBagNotifier,
              builder: (context, items, child) =>
                  userBagNotifier.value.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = items[index];

                            if (item is ComboModel) {
                              return ComboListItem(
                                index: index,
                                isThisBag: true,
                                combo: item,
                                user: widget.user!,
                                favlist: userBagNotifier,
                              );
                            } else if (item is Product) {
                              return ProductListItem(
                                  index: index,
                                  isThisBag: true,
                                  product: item,
                                  user: widget.user!,
                                  favlist: userBagNotifier);
                            } else {
                              return const Text('something went wrong');
                            }
                          },
                          itemCount: userBagNotifier.value.length,
                        )
                      : emptyBagMessage(),
            ),
          ),
        ));
  }

  Center emptyBagMessage() {
    return Center(
      child: Text(
        'Bag is empty',
        style: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 17),
      ),
    );
  }
}
