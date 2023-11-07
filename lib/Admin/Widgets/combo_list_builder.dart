import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/Admin/Widgets/combo_individual_page.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Functions/user_bag_function.dart';

import 'package:snacc/Widgets/snacc_button.dart';

class ComboListBuilder extends StatefulWidget {
  final bool isAdmin;

  const ComboListBuilder({super.key, required this.isAdmin});

  @override
  State<ComboListBuilder> createState() => _ComboListBuilderState();
}

class _ComboListBuilderState extends State<ComboListBuilder> {
  @override
  void initState() {
    super.initState();
    final comboList = Hive.box<ComboModel>('combos').values.toList();
    comboListNotifier.value = comboList;
  }

  @override
  Widget build(BuildContext context) {
    if (comboListNotifier.value.isNotEmpty) {
      setState(() {});
      return ValueListenableBuilder(
          valueListenable: comboListNotifier,
          builder: (BuildContext context, List<ComboModel> comboList,
              Widget? child) {
            return GridView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: comboList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 210,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final combo = comboList[index];

                  return InkWell(
                    onLongPress: () {
                      widget.isAdmin ? deleteComboDialog(context, combo) : null;
                      setState(() {});
                    },
                    onTap: () {
                      log('combo name: ${combo.comboName}');
                      log('combo id: ${combo.comboID}');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ComboItemPage(
                                isAdmin: widget.isAdmin,
                                combo: combo,
                              )));
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        // color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: Image.file(File(combo.comboImgUrl!)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              combo.comboName!,
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: widget.isAdmin == false
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '₹${combo.comboPrice}',
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SnaccButton(
                                          btncolor: Colors.amber,
                                          width: 70,
                                          inputText: 'ADD',
                                          callBack: () {
                                            addComboToBag(combo);
                                          })
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Center(
                                      child: Text('₹${combo.comboPrice}',
                                          style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          });
    } else {
      return const Center(
          heightFactor: 25,
          child: Text(
            'No Combos found',
            style: TextStyle(color: Colors.grey),
      )
     );
    }
  }
}
