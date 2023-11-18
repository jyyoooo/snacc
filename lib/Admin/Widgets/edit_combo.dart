import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snacc/DataModels/combo_model.dart';
import 'package:snacc/Functions/category_functions.dart';
import 'package:snacc/Functions/combos_functions.dart';
import 'package:snacc/Functions/image_picker.dart';
import 'package:snacc/Widgets/snacc_button.dart';
import 'package:snacc/Widgets/snacc_textfield.dart';

class EditCombo extends StatefulWidget {
  ComboModel combo;

  EditCombo({required this.combo});
  @override
  EditComboState createState() => EditComboState();

  static void show(
      BuildContext context, GlobalKey<FormState> formKey, ComboModel combo) {
    showModalBottomSheet(
      constraints: const BoxConstraints.expand(),
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return EditCombo(
          combo: combo,
        );
      },
    );
  }
}

class EditComboState extends State<EditCombo> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController newComboNameController;
  late TextEditingController newComboPriceController;
  String? selectedComboImage;

  @override
  Widget build(BuildContext context) {
    newComboNameController =
        TextEditingController(text: widget.combo.comboName);
    newComboPriceController =
        TextEditingController(text: '${widget.combo.comboPrice}');

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Edit ${widget.combo.comboName}',
                style: GoogleFonts.nunitoSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              Text(
                'Select new image for the Combo',
                style: GoogleFonts.nunitoSans(fontSize: 15, color: Colors.blue),
              ),
              const Gap(20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: (selectedComboImage != null &&
                            selectedComboImage!.isNotEmpty)
                        ? Image.file(
                            File(selectedComboImage!),
                            fit: BoxFit.cover,
                            scale: 5,
                          )
                        : (widget.combo.comboImgUrl != null &&
                                widget.combo.comboImgUrl!.isNotEmpty)
                            ? Image.file(
                                File(widget.combo.comboImgUrl!),
                                fit: BoxFit.cover,
                                scale: 5,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey),
                                child: Image.asset(
                                  'assets/images/no-image-available.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                  ),
                  SnaccButton(
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.blue,
                    ),
                    width: 60,
                    btncolor: Colors.white70,
                    inputText: '',
                    callBack: () async {
                      await updateSelectedComboImage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SnaccTextField(
                controller: newComboNameController,
                label: 'New category name',
                validationMessage: 'Category name is required',
              ),
              SnaccTextField(
                controller: newComboPriceController,
                label: 'New Combo price',
              ),
              const Gap(10),
              SnaccButton(
                width: 80,
                textColor: Colors.white,
                callBack: () {
                  final newName = newComboNameController.text.trim();
                  final newPrice = newComboPriceController.text.trim();
                  formKey.currentState!.validate();

                  if (newName.isNotEmpty ||
                      selectedComboImage != null ||
                      newPrice.isNotEmpty) {
                    final comboBox = Hive.box<ComboModel>('combos');

                    widget.combo.comboName = newName;
                    widget.combo.comboPrice = double.parse(newPrice);
                    widget.combo.comboImgUrl =
                        selectedComboImage ?? widget.combo.comboImgUrl;
                    comboBox.put(widget.combo.comboID, widget.combo);
                    comboListNotifier.notifyListeners();
                  } else {
                    Fluttertoast.showToast(
                      textColor: Colors.black,
                      backgroundColor: Colors.amber,
                      msg: "New ",
                    );
                  }

                  setState(() {
                    newComboNameController.clear();
                    newComboPriceController.clear();
                    selectedComboImage = null;
                  });
                  Navigator.pop(context);
                },
                inputText: 'SAVE',
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSelectedComboImage() async {
    final pickedImage = await pickImageFromGallery();
    setState(() {
      selectedComboImage = pickedImage;
    });
  }
}
