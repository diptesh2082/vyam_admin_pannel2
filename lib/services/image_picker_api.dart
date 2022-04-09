import 'package:image_picker/image_picker.dart';

class ImagePickerAPI {
  final ImagePicker _imagePicker = ImagePicker();

  Future pickImage(ImageSource imageSource) async {
    try {
      XFile? file = await _imagePicker.pickImage(source: imageSource);
      return file!.path;
    } catch (e) {
      print(e);
    }
  }
}
