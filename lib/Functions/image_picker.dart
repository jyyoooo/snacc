import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future pickImageFromGallery() async {
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
        
    if (pickedImage == null) {
      return null;
      
    }
    log('pickedimg path: ${pickedImage.path}');
    return pickedImage.path;
  } on PlatformException catch (e) {
    print('somethings wrong: $e');
  }
}



// Future pickImage(ImageSource source) async {
//     try {
//       final image = await ImagePicker().pickImage(source: source);
//       if (image == null) return;
//       final imagePermanent = await saveImagePermanently(image.path);
//       setState(() => this.image = imagePermanent);
//     } on PlatformException catch (e) {
//       print('failed to pick image $e');
//     }
//   }
