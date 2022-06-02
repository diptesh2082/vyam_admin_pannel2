import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/image_picker_api.dart';

class categoryAddScreen extends StatefulWidget {
  const categoryAddScreen({Key? key}) : super(key: key);

  @override
  State<categoryAddScreen> createState() => _categoryAddScreenState();
}

class _categoryAddScreenState extends State<categoryAddScreen> {

  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('category');
    super.initState();
  }

  var catId =
      FirebaseFirestore.instance.collection('category').doc().id;
  CollectionReference? categoryStream;


  final TextEditingController _addName = TextEditingController();
  final TextEditingController  _addPosition = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var image;
  bool _addStatus = true ;
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
                  customTextField3(
                      hinttext: "Name", addcontroller: _addName),
                  // customTextField3(
                  //     hinttext: "Status", addcontroller: _addStatus),
                  customTextField3(
                      hinttext: "Position", addcontroller: _addPosition),

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
                          },
                          child: const Icon(
                            Icons.upload_file_outlined,
                          ),
                        )
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      const Text(
                        "Status",
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
                              'status': _addStatus,
                              //'image': _addImage.text,
                              'name': _addName.text,
                              'category_id': catId,
                              'position': _addPosition.text,
                            },
                          ).then(
                                (snapshot) async {
                              await uploadImageToCateogry(image, catId);
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
