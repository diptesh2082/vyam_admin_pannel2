
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';
import 'package:flutter/cupertino.dart';

import '../services/image_picker_api.dart';

class newAmeneties extends StatefulWidget {
  const newAmeneties({Key? key}) : super(key: key);

  @override
  State<newAmeneties> createState() => _newAmenetiesState();
}

class _newAmenetiesState extends State<newAmeneties> {
  final amenityId = FirebaseFirestore.instance.collection('amenities').doc().id;
  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addId = TextEditingController();
  var image;

  // customTextField3(hinttext: "Name", addcontroller: _addName),


  @override
  Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.white10,
  appBar: AppBar(
    title: Text('Add Amenites'),
  ),
  body:
  Center(
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
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
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
                      image = await chooseImage();
                    },
                    child: const Icon(
                      Icons.upload_file_outlined,
                    ),
                  )
                ],
              ),
            ),
            customTextField(hinttext: "ID", addcontroller: _addId),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('amenities')
                      .doc(amenityId)
                      .set(
                    {
                      'name': _addName.text,
                      // 'image': _addImage.text,
                      'id': _addId.text,
                      'amenity_id': amenityId,
                      'gym_id': [],
                    },
                  ).then((snapshot) async {
                    await uploadImageToAmenities(image, amenityId);
                  });

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
