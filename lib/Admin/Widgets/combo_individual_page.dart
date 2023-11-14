import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Functions/favorites_functions.dart';
import 'package:snacc/Functions/user_bag_function.dart';
import 'package:snacc/Widgets/snacc_appbar.dart';
import 'package:snacc/Widgets/snacc_button.dart';

class ComboItemPage extends StatefulWidget {
  final ComboModel? combo;
  final bool? isAdmin;
  const ComboItemPage({super.key, required this.combo, this.isAdmin});

  @override
  State<ComboItemPage> createState() => _ComboItemPageState();
}

class _ComboItemPageState extends State<ComboItemPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: SnaccAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: widget.isAdmin == true
                ? <Widget>[
                    IconButton(
                        onPressed: () async {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ))
                  ]
                : null,
          )),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
                width: 320,
                height: 300,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer)
                  ],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Image.file(
                  File(widget.combo!.comboImgUrl!),
                  scale: 2,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.combo!.comboName!,
                style: GoogleFonts.nunitoSans(
                    fontSize: 20, fontWeight: FontWeight.normal),
              ),
              widget.isAdmin!?const SizedBox.shrink():
              IconButton(
                  icon: widget.combo!.isFavorite!
                      ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline_rounded,
                          color: Colors.grey,
                        ),
                  onPressed: () async {
                    log('${widget.combo?.isFavorite}');
                    if (widget.combo!.isFavorite!) {
                      await removeComboFromFavorites(widget.combo!);
                      Fluttertoast.showToast(
                          msg:
                              '${widget.combo!.comboName} removed from favorites',
                          backgroundColor: Colors.red);
                    } else {
                      await addComboToFavorite(widget.combo!);
                      Fluttertoast.showToast(
                          msg: '${widget.combo!.comboName} added to favorites',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    }
                    setState(() {});
                  })
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${widget.combo!.comboPrice!}',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                widget.isAdmin == false
                    ? SnaccButton(
                        width: 70,
                        btncolor: Colors.amber,
                        inputText: 'ADD',
                        callBack: () {addComboToBag(widget.combo!);})
                    : const Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
