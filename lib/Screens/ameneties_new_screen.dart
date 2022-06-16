import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/CustomTextFieldClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as Path;
import '../services/image_picker_api.dart';

class newAmeneties extends StatefulWidget {
  const newAmeneties({Key? key}) : super(key: key);

  @override
  State<newAmeneties> createState() => _newAmenetiesState();
}

var image;
var imgUrl1;

class _newAmenetiesState extends State<newAmeneties> {
  final amenityId = FirebaseFirestore.instance.collection('amenities').doc().id;
  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addId = TextEditingController();

  // customTextField3(hinttext: "Name", addcontroller: _addName),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Add Amenites'),
      ),
      body: Center(
        child: SizedBox(
          height: 480,
          width: 800,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Records',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                customTextField(hinttext: "Name", addcontroller: _addName),
                // customTextField(
                //     hinttext: "Image", addcontroller: _addImage),
                loadimage(),
                // customTextField(hinttext: "ID", addcontroller: _addId),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('amenities')
                          .doc(amenityId)
                          .set(
                        {
                          'name': _addName.text,
                          'image': imgUrl1,
                          'id': '',
                          'amenity_id': amenityId,
                          'gym_id': [],
                        },
                      );
                      //     .then((snapshot) async {
                      //   await uploadImageToAmenities(image, amenityId);
                      // });

                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class loadimage extends StatefulWidget {
  const loadimage({Key? key}) : super(key: key);

  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  @override
  bool isloading = false;
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            'Upload Image: ',
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () async {
              setState(() {
                isloading = true;
              });
              image = await chooseImage();
              await getUrlImage(image);
            },
            child: const Icon(
              Icons.upload_file_outlined,
            ),
          ),
          SizedBox(
              width: 300,
              height: 200,
              child: isloading
                  ? imgUrl1 != null
                      ? Container(
                          child: Image.network(imgUrl1),
                        )
                      : Container(
                          child: Center(child: CircularProgressIndicator()))
                  : Container(
                      color: Colors.white,
                      child: Center(
                          child: Text(
                        'Please Upload Image',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      )),
                    ))
        ],
      ),
    );
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage =
          FirebaseStorage.instance.ref().child("amenities");

      Reference _reference = _firebaseStorage
          .child('amenities/${Path.basename(pickedFile!.path)}');
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
