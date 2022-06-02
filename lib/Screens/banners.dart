import 'package:admin_panel_vyam/Screens/banner_edit.dart';
import 'package:admin_panel_vyam/Screens/banner_new_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_picker_api.dart';
import '../services/CustomTextFieldClass.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  final id = FirebaseFirestore.instance.collection('banner_details').doc().id;
  CollectionReference? bannerStream;

  createReview(String nid ) {
    final review = FirebaseFirestore.instance.collection('banner_details');
    review.doc(nid).set({'id': nid });
  }

  @override
  void initState() {
    bannerStream = FirebaseFirestore.instance.collection('banner_details');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(const bannerNewPage());     //showAddbox,
                      },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add Banner',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("banner_details")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                    'Name',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  )),
                              DataColumn(
                                label: Text(
                                  'Image',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Access',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Edit',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Delete',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            rows: _buildlist(context, snapshot.data!.docs)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    bool access = data['access'];
    String banner_id = data['id'];

    return DataRow(cells: [
      DataCell(
          data['name'] != null ? Text(data['name'] ?? "") : const Text("")),
      DataCell(Image.network(data['image'])),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = access;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('banner_details')
                  .doc(banner_id);
              await documentReference
                  .update({'access': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(access.toString()),
            style: ElevatedButton.styleFrom(
                primary: access ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
       Get.to(()=>EditBox(name: data['name'], image: data['image'], id: data['id'], access: data['access']));
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return SingleChildScrollView(
        //         child: EditBox(
        //           image: data['image'],
        //           id: data['id'],
        //           name: data['name'],
        //           access: data['access'],
        //         ),
        //       );
        //     });
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: bannerStream, uniqueDocId: banner_id);
      })
    ]);
  }


  // final TextEditingController _addname = TextEditingController();
  // bool _accesible = false;
  var image;

  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  String? print_type = 'accessible';

  // showAddbox() => showDialog(
  //   context: context,
  //   builder: (context) => StatefulBuilder(builder: (context, setState) {
  //     void dropDowntype(bool? selecetValue) {
  //       // if(selecetValue is String){
  //       setState(() {
  //         selectedType = selecetValue.toString();
  //         if (selecetValue == true) {
  //           print_type = "TRUE";
  //         }
  //         if (selecetValue == false) {
  //           print_type = "FALSE";
  //         }
  //       });
  //       // }
  //     }
  //
  //
  //
  //
  //     return AlertDialog(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       content: Form(
  //         key: _formKey,
  //         child: SizedBox(
  //           height: 200,
  //           width: 800,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Add Records',
  //                   style: TextStyle(
  //                       fontFamily: 'poppins',
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 14),
  //                 ),
  //                 CustomTextField(
  //                     hinttext: "Name", addcontroller: _addname),
  //                 // CustomTextField(
  //                 //     hinttext: "Image url", addcontroller: _addimage),
  //
  //                 Container(
  //                   padding: const EdgeInsets.all(20),
  //                   child: Row(
  //                     children: [
  //                       const Text(
  //                         'Upload Image: ',
  //                         style: TextStyle(
  //                             color: Colors.grey,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 15),
  //                       ),
  //                       const SizedBox(
  //                         width: 20,
  //                       ),
  //                       InkWell(
  //                         onTap: () async {
  //                           image = await chooseImage();
  //                         },
  //                         child: const Icon(
  //                           Icons.upload_file_outlined,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //
  //                 Column(
  //                   children: [
  //                     const Text(
  //                       "Accessible",
  //                       style: TextStyle(
  //                           fontSize: 20, fontWeight: FontWeight.w100),
  //                     ),
  //                     Container(
  //                       color: Colors.white10,
  //                       width: 120,
  //                       child: DropdownButton(
  //                           hint: Text('$print_type'),
  //                           items: const [
  //                             DropdownMenuItem(
  //                               child: Text("TRUE"),
  //                               value: true,
  //                             ),
  //                             DropdownMenuItem(
  //                               child: Text("FALSE"),
  //                               value: false,
  //                             ),
  //                           ],
  //                           onChanged: dropDowntype),
  //                     ),
  //                   ],
  //                 ),

  //                 Center(
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       if (_formKey.currentState!.validate()) {
  //                        // await createReview(id);
  //                         await FirebaseFirestore.instance
  //                             .collection('banner_details')
  //                             .doc(id)
  //                             .set(
  //                           {
  //                             'name': _addname.text,
  //                             // 'image': _addimage.text,
  //                             'access': _accesible,
  //                             'id': id,
  //                           },
  //                         ).then(
  //                               (snapshot) async {
  //                             await uploadImageToBanner(image, id);
  //                           },
  //                         );
  //
  //                         Navigator.pop(context);
  //                       }
  //                     },
  //                     child: const Text('Done'),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }),
  // );
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hinttext,
    required this.addcontroller,
  }) : super(key: key);

  final TextEditingController addcontroller;
  final String hinttext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'This Field cannot be empty';
              }
              return null;
            },
            autofocus: true,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            controller: addcontroller,
            maxLines: 3,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                ),
                hintMaxLines: 2,
                hintText: hinttext),
          )),
    );
  }
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    required this.name,
    required this.image,
    required this.id,
    required this.access,
  }) : super(key: key);

  final String name;
  final String image;
  final String id;
  final bool access;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  final TextEditingController _name = TextEditingController();
  var id;
  var image;
  bool access = false;

  // final TextEditingController _image = TextEditingController();

  @override
  void initState() {
    super.initState();

    _name.text = widget.name;
    id = widget.id;
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return

Scaffold(
  // shape: const RoundedRectangleBorder(
  //     borderRadius: BorderRadius.all(Radius.circular(30))),
  // content:
 body:
 SizedBox(
    height: 600,
    width: 800,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Update Records for this doc',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
          CustomTextField(hinttext: "Name", addcontroller: _name),
          //CustomTextField(hinttext: "Image url", addcontroller: _image),


          Center(
            child: Container(
              padding: EdgeInsets.all(20),   //EdgeInsets.only(top: 8.0, left: 8.0)
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
          ),


          Padding(
            padding:  EdgeInsets.all(50),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  print("/////");

                  FirebaseFirestore.instance
                      .collection('banner_details')
                      .doc(id)
                      .update(
                    {
                      'name': _name.text,
                      //'image': image,
                      'id': id,
                      'access':access,
                    },
                  ).then((snapshot) async {
                    await uploadImageToBanner(image, id);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ),
        ],
      ),
    ),
  )
  );
  }
}