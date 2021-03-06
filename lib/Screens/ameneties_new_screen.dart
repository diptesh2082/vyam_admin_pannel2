import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/CustomTextFieldClass.dart';
import 'package:path/path.dart' as Path;
import '../services/image_picker_api.dart';

class newAmeneties extends StatefulWidget {
  const newAmeneties({Key? key}) : super(key: key);

  @override
  State<newAmeneties> createState() => _newAmenetiesState();
}

var image;
var ds;

class _newAmenetiesState extends State<newAmeneties> {
  final amenityId = FirebaseFirestore.instance.collection('amenities').doc().id;
  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addId = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // customTextField3(hinttext: "Name", addcontroller: _addName),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add Amenites'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
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
                  customTextField3(hinttext: "Name", addcontroller: _addName),
                  // customTextField(
                  //     hinttext: "Image", addcontroller: _addImage),
                  const loadimage(),
                  // customTextField(hinttext: "ID", addcontroller: _addId),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection('amenities')
                              .doc(amenityId)
                              .set(
                            {
                              'name': _addName.text,
                              'image': ds,
                              'id': '',
                              'amenity_id': amenityId,
                              'gym_id': [],
                            },
                          ).whenComplete(() {
                            setState(() {
                              ds = null;
                            });
                          });
                          //     .then((snapshot) async {
                          //   await uploadImageToAmenities(image, amenityId);
                          // });

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
    );
  }
}

class loadimage extends StatefulWidget {
  const loadimage({Key? key}) : super(key: key);

  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              try {
                image = await chooseImage();
                if (image != null) {
                  setState(() {
                    isloading = true;
                  });
                }
                await getUrlImage(image);
                setState(() {
                  isloading = false;
                });
              } finally {
                setState(() {
                  isloading = false;
                });
              }
            },
            child: const Icon(
              Icons.upload_file_outlined,
            ),
          ),
          SizedBox(
            width: 300,
            height: 200,
            child: isloading && ds == null
                ? Container(
                    height: 100,
                    width: 200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ds != null
                    ? SizedBox(
                        height: 100,
                        width: 200,
                        child: Image.network(ds),
                      )
                    : const SizedBox(
                        height: 100,
                        width: 200,
                        child: Center(
                          child: Text(
                            "Please Upload Image",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
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
        ds = imageUrl;
      });
    }
  }
}
