import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
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
  final TextEditingController _addposition = TextEditingController();
  final TextEditingController _addnavigation = TextEditingController();

  final bool _accesible = false;
  var image;
  var imgUrl1;

  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  String? print_type = 'Clickable';
  String namee = "";
  String place = "";
  bool setnav = false;

  void dropDowntype(bool? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      selectedType = selecetValue.toString();
      if (selecetValue == true) {
        print_type = "Clickable";
      }
      if (selecetValue == false) {
        print_type = "Non-Clickable";
      }
      print(selectedType);
    });

    // }
  }

  late DropzoneViewController controller;
  bool _saving = false;
  CollectionReference? productStream;
  @override
  void initState() {
    // TODO: implement initState
    productStream = FirebaseFirestore.instance.collection("product_details");
    setnav = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('New Banners'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Center(
                child: Form(
                  key: _formKey,
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
                      const SizedBox(height: 50),
                      SizedBox(
                          height: 400,
                          width: 400,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: productStream!.snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.data == null) {
                                return Container();
                              }
                              print("-----------------------------------");
                              var doc = snapshot.data.docs;
                              print(snapshot.data.docs);
                              return ListView.builder(
                                itemCount: doc.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile<String>(
                                      value: doc[index]['gym_id'],
                                      title: Text(
                                          "${doc[index]['name'].toString()} || ${doc[index]['branch']}"),
                                      groupValue: namee,
                                      onChanged: (String? valuee) {
                                        setState(() {
                                          namee = valuee!;
                                          place = doc[index]['branch'];
                                        });
                                        print(namee);
                                      });
                                },
                              );
                            },
                          )),
                      SizedBox(
                        height: 20,
                      ),

                      customTextField3(
                          hinttext: "Name", addcontroller: _addname),
                      SizedBox(
                        height: 20,
                      ),

                      customTextField3(
                          hinttext: "Position", addcontroller: _addposition),
                      // customTextField3(
                      //     hinttext: "Navigation",
                      //     addcontroller: _addnavigation),
                      SizedBox(
                        height: 20,
                      ),
                      nav(),

                      //CustomTextField(
                      //hinttext: "Image url", addcontroller: _addimage),
                      loadimage(id: id),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       "Accessible",
                      //       style: TextStyle(
                      //           fontSize: 20, fontWeight: FontWeight.w100),
                      //     ),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     Container(
                      //       color: Colors.white10,
                      //       child: DropdownButton(
                      //           hint: Text('$print_type'),
                      //           items: const [
                      //             DropdownMenuItem(
                      //               child: Text("Clickable"),
                      //               value: true,
                      //             ),
                      //             DropdownMenuItem(
                      //               child: Text("Non-Clickable"),
                      //               value: false,
                      //             ),
                      //           ],
                      //           onChanged: dropDowntype),
                      //     ),
                      //   ],
                      // ),

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
                                  'position_id': _addposition.text,
                                  'name': _addname.text,
                                  'image': image3,
                                  'access': navcommand == "/gym_details"
                                      ? true
                                      : false,
                                  'id': id,
                                  'gym_id': namee != null ? namee : "",
                                  'navigation': navcommand,
                                  'visible': true
                                },
                              ).whenComplete(() {
                                setState(() {
                                  image3 = null;
                                  navcommand = '';
                                });
                              });
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
            ],
          ),
        ),
      ),
    );
  }
}

String navcommand = '';

class nav extends StatefulWidget {
  const nav({Key? key}) : super(key: key);

  @override
  State<nav> createState() => _navState();
}

class _navState extends State<nav> {
  @override
  bool setnav = false;

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text("Set Navigation"),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (setnav == false) {
                setState(() {
                  setnav = true;
                  navcommand = "/gym_details";
                  print("Set NAv Activated");
                });
              } else {
                setState(() {
                  setnav = false;
                  navcommand = "";
                  print("SET NAV DEACTIVATED");
                });
              }
              print("New ${navcommand}");
            },
            child: Text(
              setnav ? "Activated" : "Deactivated",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
                primary: setnav ? Colors.green : Colors.red),
          )
        ],
      ),
    );
  }
}

var image3;

class loadimage extends StatefulWidget {
  loadimage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        const Text(
          "User Image",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          child: const Icon(Icons.camera_alt),
          onTap: () async {
            setState(() {
              isloading = true;
            });
            var profileImage = await chooseImage();
            await getUrlImage(profileImage);
            setState(() {
              isloading = false;
            });
          },
        ),
        SizedBox(
          width: 200,
          height: 100,
          child: isloading
              ? Container(
                  height: 100,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : image3 != null
                  ? Container(
                      height: 100,
                      width: 200,
                      child: Image.network(image3),
                    )
                  : Container(
                      height: 100,
                      width: 200,
                      child: Center(child: Text("Please Upload Image")),
                    ),
        ),
      ],
    ));
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
        image3 = imageUrl;
      });
    }
  }
}
