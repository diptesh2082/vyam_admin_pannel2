import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/image_picker_api.dart';
import 'package:path/path.dart' as Path;

class categoryAddScreen extends StatefulWidget {
  const categoryAddScreen({Key? key}) : super(key: key);

  @override
  State<categoryAddScreen> createState() => _categoryAddScreenState();
}

var image;
var imgUrl1;

class _categoryAddScreenState extends State<categoryAddScreen> {
  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('category');
    super.initState();
  }

  var catId = FirebaseFirestore.instance.collection('category').doc().id;
  CollectionReference? categoryStream;

  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addPosition = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _addStatus = true;
  String? selectedType;
  String? print_type = 'Status';

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

  @override
  Widget build(BuildContext context) {
    bool isloading = false;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Form(
        key: _formKey, //Changed
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
                  // customTextField3(
                  //     hinttext: "Status", addcontroller: _addStatus),
                  Text("Choose Position Except These"),
                  Container(
                    height: 100,
                    width: 700,
                    child: StreamBuilder(
                        stream: categoryStream!.snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          var doc = snapshot.data.docs;
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                  "${doc[index]['position'].toString()}, ",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              });
                        }),
                  ),

                  customTextField3(
                      hinttext: "Position", addcontroller: _addPosition),
                  loadimage(),

                  // Column(
                  //   children: [
                  //     const Text(
                  //       "Status",
                  //       style: TextStyle(
                  //           fontSize: 20, fontWeight: FontWeight.w100),
                  //     ),
                  //     Container(
                  //       color: Colors.white10,
                  //       width: 120,
                  //       child: DropdownButton(
                  //           hint: Text('$print_type'),
                  //           items: const [
                  //             DropdownMenuItem(
                  //               child: Text("TRUE"),
                  //               value: true,
                  //             ),
                  //             DropdownMenuItem(
                  //               child: Text("FALSE"),
                  //               value: false,
                  //             ),
                  //           ],
                  //           onChanged: dropDowntype),
                  //     ),
                  //   ],
                  // ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await matchID(
                              newId: catId,
                              matchStream: categoryStream,
                              idField: 'category_id');
                          await FirebaseFirestore.instance
                              .collection('category')
                              .doc(catId)
                              .set(
                            {
                              'status': true,
                              'image': imgUrl1,
                              'name': _addName.text,
                              'category_id': catId,
                              'position': _addPosition.text,
                            },
                          );

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Done'),
                    ),
                  ),
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
  @override
  bool isloading = false;
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
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
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
                  ),
          )
        ],
      ),
    );
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance.ref().child("category");

      Reference _reference =
          _firebaseStorage.child('category/${Path.basename(pickedFile!.path)}');
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
