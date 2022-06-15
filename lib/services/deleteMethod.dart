import 'dart:async';
import 'dart:io';
import 'package:admin_panel_vyam/services/firestore_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/image_picker_api.dart';

Future<void> deletee(String reff) async {
  // var pictureref = FirebaseFirestore.refFromURL(reff);
  await FirebaseStorage.instance.ref().child(reff).delete();
}

Future<void> deleteMethodVendor(
    {CollectionReference? stream,
    String? uniqueDocId,
    String? imagess,
    List? imlist}) async {
  // await deletee(
  // '12.jpeg',
  // imlist[0].toString();
  imlist?.forEach((element) async {
    await deletee(
        // '12.jpeg',
        element.toString());
  });
  await deletee(imagess.toString());

  return stream!
      .doc(uniqueDocId)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}

Future<void> deleteMethodI({
  CollectionReference? stream,
  String? uniqueDocId,
  String? imagess,
}) async {
  await deletee(imagess.toString());

  return stream!
      .doc(uniqueDocId)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}

Future<void> deleteMethod({
  CollectionReference? stream,
  String? uniqueDocId,
}) async {
  return stream!
      .doc(uniqueDocId)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}
