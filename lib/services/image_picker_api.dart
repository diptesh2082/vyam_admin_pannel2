import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';

chooseImage() async {
  PickedFile? pickedFile = await ImagePicker().getImage(
    source: ImageSource.gallery,
  );
  return pickedFile;
}

final _firebaseStorage = FirebaseStorage.instance.ref().child("product_image");
uploadImageToStorage(PickedFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference =
        _firebaseStorage.child('images/${Path.basename(pickedFile!.path)}');
    await _reference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await _reference.getDownloadURL().then((value) async {
        var uploadedPhotoUrl = value;
        print(value);
        await FirebaseFirestore.instance
            .collection("product_details")
            .doc(id)
            .update({"display_picture": value});
      });
    });
  } else {
//write a code for android or ios
  }
}

addImageToStorage(PickedFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference =
        _firebaseStorage.child('images/${Path.basename(pickedFile!.path)}');
    await _reference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await _reference.getDownloadURL().then((value) async {
        var uploadedPhotoUrl = value;
        print(value);
        await FirebaseFirestore.instance
            .collection("product_details")
            .doc(id)
            .update({
          "images": FieldValue.arrayUnion([value])
        });
      });
    });
  } else {
//write a code for android or ios
  }
}

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

final _firebaseStoragee = FirebaseStorage.instance.ref().child("amenities");
uploadImageToAmeneties(PickedFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference =
        _firebaseStoragee.child('amenities/${Path.basename(pickedFile!.path)}');
    await _reference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await _reference.getDownloadURL().then((value) async {
        var uploadedPhotoUrl = value;
        print(value);
        await FirebaseFirestore.instance
            .collection("amenities")
            .doc(id)
            .update({"image": value});
      });
    });
  } else {
//write a code for android or ios
  }
}

uploadImageToBanner(PickedFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference = _firebaseStoragee
        .child('banner_details/${Path.basename(pickedFile!.path)}');
    await _reference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await _reference.getDownloadURL().then((value) async {
        var uploadedPhotoUrl = value;
        print(value);
        await FirebaseFirestore.instance
            .collection("banner_details")
            .doc(id)
            .update({"image": value});
      });
    });
  } else {
//write a code for android or ios
  }
}
