import 'dart:io';

import 'package:image_picker/image_picker.dart';
export 'image_picker_utiils.dart';



Future<File?> pickImageFromGallery() async {
  final imagePicker = ImagePicker();
  final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
  
  if (pickedImage != null) {
    return File(pickedImage.path);
  } else {
    return null;
  }
}
