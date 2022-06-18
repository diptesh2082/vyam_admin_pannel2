import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/image_picker_api.dart';

class pushNew extends StatefulWidget {
  const pushNew({Key? key}) : super(key: key);

  @override
  State<pushNew> createState() => _pushNewState();
}

class _pushNewState extends State<pushNew> {
  CollectionReference? pushStream;

  @override
  void initState() {
    pushStream = FirebaseFirestore.instance.collection("push_notifications");
    super.initState();
  }

  // var id = FirebaseFirestore.instance
  //     .collection('push_notifications')
  //     .doc()
  //     .id
  //     .toString();

  final TextEditingController _addtitle = TextEditingController();
  final TextEditingController _adddefiniton = TextEditingController();

  var millis, dt, d12, image;
  final _formKey = GlobalKey<FormState>();

  date() {
    millis = Timestamp.now().millisecondsSinceEpoch;
    dt = DateTime.fromMillisecondsSinceEpoch(millis);

    d12 = DateFormat('dd/MMM/yyyy, hh:mm a').format(dt);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('New Push Notification'),
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
                  customTextField3(hinttext: "Title", addcontroller: _addtitle),
                  customTextField3(
                      hinttext: "Description", addcontroller: _adddefiniton),
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
                            image = await chooseImage();
                            getUrlImage(image);

                          },
                          child: const Icon(
                            Icons.upload_file_outlined,
                          ),
                        ),

                        SizedBox(
                            width: 300,
                            height: 200,
                            child: image != null
                                ? Container(
                              child: Image.network(image),
                            )
                                : Container(
                              color: Colors.white,
                              child: const Center(
                                  child: Text(
                                    'Please Upload Image',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  )),
                            )),
                      ],
                    ),
                  ),
                  // Text(
                  //   '$timestamp',
                  // ),
                  // customTextField(
                  //     hinttext: "Discount", addcontroller: _adddiscount),
                  // customTextField(
                  //     hinttext: "Title", addcontroller: _addtitle),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        date();
                        if (_formKey.currentState!.validate()) {
                          // await matchID(
                          //     newId: id, matchStream: pushStream, idField: 'id');
                          await FirebaseFirestore.instance
                              .collection('push_notifications')
                              .doc()
                              .set(
                            {
                              'title': _addtitle.text,
                              'definition': _adddefiniton.text,
                              'image': image,
                              // 'id': "id",
                              'timestamp': d12,
                            },
                          );
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
        image = imageUrl;
      });
    }
  }


}
