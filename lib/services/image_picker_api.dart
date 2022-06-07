import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';

chooseImage() async {
  XFile? pickedFile = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 50);
  // pickedFile=await
  //
  return pickedFile;
}

final _firebaseStorage = FirebaseStorage.instance.ref().child("product_image");
uploadImageToStorage(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference = _firebaseStorage
        .child('product_images/${Path.basename(pickedFile!.path)}');
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
          "display_picture": value,
        });
      });
    });
  } else {
//write a code for android or ios
  }
}

uploadImageToTrainer(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference = _firebaseStorage
        .child('product_images/${Path.basename(pickedFile!.path)}');
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
            .collection('trainer')
            .doc()
            .update({
          "display_picture": value,
        });
      });
    });
  } else {
//write a code for android or ios
  }
}

uploadImageToUser(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference = FirebaseStorage.instance
        .ref()
        .child("user_image")
        .child('Users/${Path.basename(pickedFile!.path)}');
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
            .collection("user_details")
            .doc(id)
            .update({
          "image": value,
        });
      });
    });
  } else {
//write a code for android or ios
  }
}

addImageToStorage(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference = FirebaseStorage.instance
        .ref()
        .child("product_image")
        .child('images/${Path.basename(pickedFile!.path)}');
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
// <<<<<<< HEAD
// <<<<<<< HEAD

// <<<<<<< HEAD
//
// uploadImageToBanner(PickedFile? pickedFile, String? id) async {
//   if (kIsWeb) {
// =======
// uploadImageToBanner(XFile? pickedFile, String? id) async {
//   if (kIsWeb) {
// >>>>>>> 0a5609047c67f26f59a73d8ed566b1e865568769
// =======

// uploadImageToBanner(XFile? pickedFile, String? id) async {
//   if (kIsWeb) {
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======

uploadImageToBanner(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
// >>>>>>> /**/419576ed132f1f7631adea2357dfe8fbddca83b9
    Reference _reference = _firebaseStorage
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
            .update({
          //"display_picture": value,
          "image": value
        });
      });
    });
  } else {
//write a code for android or ios
  }
}

// <<<<<<< HEAD
// // <<<<<<< HEAD
// // // <<<<<<< HEAD
// // // uploadImageToCateogry(PickedFile? pickedFile, String? id) async {
// // //   if (kIsWeb) {
// // // =======
// //
// // uploadImageToCateogry(XFile? pickedFile, String? id) async {
// //   if (kIsWeb) {
// // // >>>>>>> 0a5609047c67f26f59a73d8ed566b1e865568769
// // =======
// uploadImageToCateogry(XFile? pickedFile, String? id) async {
//   if (kIsWeb) {
// // >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======
uploadImageToCateogry(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
    Reference _reference = _firebaseStorage
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
        await FirebaseFirestore.instance.collection("category").doc(id).update({
          //"display_picture": value,
          "image": value
        });
      });
    });
  } else {
//write a code for android or ios
  }
}

// <<<<<<< HEAD
// // <<<<<<< HEAD
// // // <<<<<<< HEAD
// // // final _firebaseStoragee =
// // //     FirebaseStorage.instance.ref().child("push_notifications");
// // //
// // // uploadImageToPush(PickedFile? pickedFile, String? id) async {
// // // =======
// // final _firebaseStorages = FirebaseStorage.instance.ref().child("amenities");
// // uploadImageToAmenities(XFile? pickedFile, String? id) async {
// // // >>>>>>> 0a5609047c67f26f59a73d8ed566b1e865568769
// // =======
//
// final _firebaseStorages = FirebaseStorage.instance.ref().child("amenities");
// uploadImageToAmenities(XFile? pickedFile, String? id) async {
// // >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======

final _firebaseStorages = FirebaseStorage.instance.ref().child("amenities");
uploadImageToAmenities(XFile? pickedFile, String? id) async {
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
  if (kIsWeb) {
    Reference _reference =
        _firebaseStorages.child('amenities/${Path.basename(pickedFile!.path)}');

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

final _firebaseStoragee =
    FirebaseStorage.instance.ref().child("product_details");

// <<<<<<< HEAD
// final _firebaseStoragee =
//     FirebaseStorage.instance.ref().child("product_details");
// //
// // <<<<<<< HEAD
// // final _firebaseStoragee =
// //     FirebaseStorage.instance.ref().child("product_details");
// //
// // // <<<<<<< HEAD
// // uploadImageToProduct(PickedFile? pickedFile, String? id) async {
// // =======
// uploadImageToProduct(XFile? pickedFile, String? id) async {
// // >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======
uploadImageToProduct(XFile? pickedFile, String? id) async {
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
  var uploadedPhotoUrl = " ";
  if (kIsWeb) {
    Reference _reference = _firebaseStoragee
        .child('product_details/${Path.basename(pickedFile!.path)}');
    await _reference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await _reference.getDownloadURL().then((value) async {
        uploadedPhotoUrl = value;
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
  return uploadedPhotoUrl;
}

// final _firebaseStorages = FirebaseStorage.instance.ref().child("amenities");
// <<<<<<< HEAD
// // <<<<<<< HEAD
// // // uploadImageToAmenities(PickedFile? pickedFile, String? id) async {
// // =======
// // //
// // uploadImageToAmenities(XFile? pickedFile, String? id) async {
// // >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======
//
// uploadImageToAmenities(XFile? pickedFile, String? id) async {
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
//   if (kIsWeb) {
//     Reference _reference =
//         _firebaseStorages.child('amenities/${Path.basename(pickedFile!.path)}');
//     await _reference
//         .putData(
//       await pickedFile.readAsBytes(),
//       SettableMetadata(contentType: 'image/jpeg'),
//     )
//         .whenComplete(() async {
//       await _reference.getDownloadURL().then((value) async {
//         var uploadedPhotoUrl = value;
//         print(value);
//         await FirebaseFirestore.instance
//             .collection("amenities")
//             .doc(id)
//             .update({"image": value});
//       });
//     });
//   } else {
// //write a code for android or ios
//   }
// }
// <<<<<<< HEAD
// // <<<<<<< HEAD
// // // =======
// // // // >>>>>>> 0a5609047c67f26f59a73d8ed566b1e865568769
// // final _firebaseStoraga =
// //     FirebaseStorage.instance.ref().child("push_notifications");
// // uploadImageToPush(PickedFile? pickedFile, String? id) async {

// //   if (kIsWeb) {
// //     Reference _reference = _firebaseStoraga
// // // =======
//
// uploadImageToPush(XFile? pickedFile, String? id) async {
//   if (kIsWeb) {
//     Reference _reference = _firebaseStorage
// // >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======
var uploadedPhotoUrl = " ";
uploadImageToPush(XFile? pickedFile, String? id) async {
  if (kIsWeb) {
    Reference _reference = _firebaseStorage
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
        .child('push_notifications/${Path.basename(pickedFile!.path)}');
    await _reference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await _reference.getDownloadURL().then((value) async {
        uploadedPhotoUrl = value;
        print(value);
// <<<<<<< HEAD
// // <<<<<<< HEAD
// //         await FirebaseFirestore.instance
// //             .collection("push_notifications")
// // =======
//         await FirebaseFirestore.instance
//             .collection("push_notifications")
// // >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// =======
        await FirebaseFirestore.instance
            .collection("push_notifications")
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
            .doc(id)
            .update({
          //"display_picture": value,
          "image": value
        });
// <<<<<<< HEAD
// =======
//
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
      });
    });
  } else {
//write a code for android or ios
  }
// <<<<<<< HEAD
// <<<<<<< HEAD
  return uploadedPhotoUrl;
}
// =======

// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
// // =======
//
// }
//
// >>>>>>> 419576ed132f1f7631adea2357dfe8fbddca83b9
