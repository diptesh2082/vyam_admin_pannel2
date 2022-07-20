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

var ds;
// <<<<<<< HEAD
// =======
//
// >>>>>>> 21d9c030cebb9d9fd030fc57983203910f0655fa

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
                  const Text("Choose Position Except These"),
                  SizedBox(
                    height: 100,
                    width: 700,
                    child: StreamBuilder(
                        stream: categoryStream!.snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          var doc = snapshot.data.docs;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                  "${doc[index]['position'].toString()}, ",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              });
                        }),
                  ),

                  customTextField3(
                      hinttext: "Position", addcontroller: _addPosition),
                  loadimage(id: catId),
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
                              'image': ds,
                              'name': _addName.text,
                              'category_id': catId,
                              'position': _addPosition.text,
                            },
                          ).whenComplete(() {
                            setState(() {
                              ds = null;
                            });
                          });

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
  loadimage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool isloading = false;
  var imgUrl1;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        const Text(
          "Category Image",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
            child: const Icon(Icons.camera_alt),
            onTap: () async {
              try {
                var profileImage = await chooseImage();
                if (profileImage != null) {
                  setState(() {
                    isloading = true;
                  });
                }
                await getUrlImage(profileImage);
                setState(() {
                  isloading = false;
                });
              } finally {
                setState(() {
                  isloading = false;
                });
              }
            }),
        SizedBox(
          width: 200,
          height: 100,
          child: isloading && ds == null
              ? const SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(
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
                      child: Text(
                        "Please Upload Image",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
        ),
      ],
    ));
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
        var imgUrl1 = imageUrl;
        ds = imgUrl1;
      });
    }
  }
}
