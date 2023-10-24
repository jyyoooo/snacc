import 'package:image_picker/image_picker.dart';

Future pickImageFromGallery() async {
  final imagePicker = ImagePicker();
  final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    return pickedImage.path;
  } else {
    return null;
  }
}
