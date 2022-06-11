import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_picker_api.dart';
import 'Tracking/TrackingScreen.dart';
import 'package:path/path.dart' as Path;

class bannerNewPage extends StatefulWidget {
  const bannerNewPage({Key? key}) : super(key: key);

  @override
  State<bannerNewPage> createState() => _bannerNewPageState();
}

class _bannerNewPageState extends State<bannerNewPage> {
  final id = FirebaseFirestore.instance.collection('banner_details').doc().id;
  final TextEditingController _addname = TextEditingController();
  final bool _accesible = false;
  var image;
  var imgUrl1;

  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  String? print_type = 'accessible';

  void dropDowntype(bool? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      selectedType = selecetValue.toString();
      if (selecetValue == true) {
        print_type = "TRUE";
      }
      if (selecetValue == false) {
        print_type = "FALSE";
      }
    });
    // }
  }

  late DropzoneViewController controller;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('New Banners'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 600,
                width: 800,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Add Records',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      CustomTextField(
                          hinttext: "Name", addcontroller: _addname),
                      //CustomTextField(
                      //hinttext: "Image url", addcontroller: _addimage),

                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Text(
                              'Upload Image: ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
// <<<<<<< HEAD
// <<<<<<< HEAD
// <<<<<<< HEAD
//                                 image = await chooseImage();
//                                 await getUrlImage(image);
//                                 //uploadToStroage();
// =======
//                                 image = await chooseImage();
//                                 await getUrlImage(image);
// // >>>>>>> 4b8eeb3ff2a6cfa9a4d0218f27f80501132bdf71
// =======
// =======
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47

                                image = await chooseImage();
                                await getUrlImage(image);
                                //uploadToStroage();

// <<<<<<< HEAD
// >>>>>>> e2bea5635554890f907c9d88c8a5b0f830f5efe4
// =======
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                              },
                              child: const Icon(
                                Icons.upload_file_outlined,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 300,
                              height: 200,
                              child: Container(
// <<<<<<< HEAD
// <<<<<<< HEAD
// <<<<<<< HEAD
// =======

// >>>>>>> e2bea5635554890f907c9d88c8a5b0f830f5efe4
// =======
//
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                                  child: imgUrl1 != null
                                      ? Image.network(imgUrl1)
                                      : Container(
                                          child: Center(
                                            child: Text(
                                              'Please Upload Image',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
// <<<<<<< HEAD
// <<<<<<< HEAD
// =======
//                                 child:
//                                 Image.network((imgUrl1 == null) ? ' ' : imgUrl1,
//                                   fit: BoxFit.contain,),
//                               ),
//
// >>>>>>> 4b8eeb3ff2a6cfa9a4d0218f27f80501132bdf71
// =======

// >>>>>>> e2bea5635554890f907c9d88c8a5b0f830f5efe4
// =======

// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          const Text(
                            "Accessible",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w100),
                          ),
                          Container(
                            color: Colors.white10,
                            width: 120,
                            child: DropdownButton(
                                hint: Text('$print_type'),
                                items: const [
                                  DropdownMenuItem(
                                    child: Text("TRUE"),
                                    value: true,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("FALSE"),
                                    value: false,
                                  ),
                                ],
                                onChanged: dropDowntype),
                          ),
                        ],
                      ),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // await createReview(id);
                              await FirebaseFirestore.instance
                                  .collection('banner_details')
                                  .doc(id)
                                  .set(
                                {
                                  'name': _addname.text,
                                  'image': imgUrl1,
                                  'access': _accesible,
                                  'id': id,
                                },
                              );
                              //     .then(
                              //   (snapshot) async {
                              //     await uploadImageToBanner(image  , id);
                              //   },
                              // );

                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Done'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance.ref().child("banner");

      Reference _reference = _firebaseStorage
          .child('banner_details/${Path.basename(pickedFile!.path)}');
      await _reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        imgUrl1 = imageUrl;
      });
    }
  }
}
