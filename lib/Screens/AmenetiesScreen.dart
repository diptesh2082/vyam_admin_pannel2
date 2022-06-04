import 'package:admin_panel_vyam/Screens/ameneties_new_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/deleteMethod.dart';
import '../services/image_picker_api.dart';

class AmenetiesScreen extends StatefulWidget {
  const AmenetiesScreen({Key? key}) : super(key: key);

  @override
  State<AmenetiesScreen> createState() => _AmenetiesScreenState();
}

class _AmenetiesScreenState extends State<AmenetiesScreen> {
  CollectionReference? amenityStream;

  final amenityId = FirebaseFirestore.instance.collection('amenities').doc().id;
  @override
  void initState() {
    super.initState();
    amenityStream = FirebaseFirestore.instance.collection('amenities');
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle:
                      const TextStyle(fontSize: 15 ),
                    ),
                    onPressed:() {
                      Get.to(() => newAmeneties());
                    },
                     child: Text(
                       'Add Product'
                     ),
                    // Container(
                    //   width: 120,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20.0)),
                    //   child: Row(
                    //     children: const [
                    //       Icon(Icons.add),
                    //       Text('Add Product',
                    //           style: TextStyle(fontWeight: FontWeight.w400)),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: amenityStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowHeight: 65,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Images',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Name',
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
                          rows: _buildlist(context, snapshot.data!.docs),
                        ),
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
    String amenitiesId = data['amenity_id'];
    return DataRow(cells: [
      DataCell(
        data['id'] != null ? Text(data['id'] ?? "") : const Text(""),
      ),
      DataCell(
        data['image'] != null
            ? Image.network(
                data['image'] ?? "",
                scale: 0.5,
                height: 150,
                width: 150,
              )
            : const Text(""),
      ),
      DataCell(
        data['name'] != null ? Text(data['name']) : const Text("Disabled"),
      ),
      DataCell(
        const Text(''),
        showEditIcon: true,
        onTap: () {
          Get.to(()=>ProductEditBox(name: data['name'], image: data['image'], amenityId: data['id'], am: data['amenity_id']));
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return GestureDetector(
          //       onTap: () => Navigator.pop(context),
          //       child: SingleChildScrollView(
          //         child: ProductEditBox(
          //             image: data['image'],
          //             amenityId: data['id'],
          //             name: data['name'],
          //             am: data['amenity_id']),
          //       ),
          //     );
          //   },
          // );
        },
      ),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(
            stream: FirebaseFirestore.instance.collection('amenities'),
            uniqueDocId: amenitiesId);
      })
    ]);
  }

  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addImage = TextEditingController();
  final TextEditingController _addId = TextEditingController();
  var image;

  // showAddbox() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
            // content: SizedBox(
            //   height: 480,
            //   width: 800,
            //   child: SingleChildScrollView(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           'Add Records',
            //           style: TextStyle(
            //               fontFamily: 'poppins',
            //               fontWeight: FontWeight.w600,
            //               fontSize: 14),
            //         ),
            //         customTextField(hinttext: "Name", addcontroller: _addName),
            //         // customTextField(
            //         //     hinttext: "Image", addcontroller: _addImage),
            //         Container(
            //           padding: EdgeInsets.all(20),
            //           child: Row(
            //             children: [
            //               Text(
            //                 'Upload Image: ',
            //                 style: TextStyle(
            //                     color: Colors.grey,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 15),
            //               ),
            //               const SizedBox(
            //                 width: 20,
            //               ),
            //               InkWell(
            //                 onTap: () async {
            //                   image = await chooseImage();
            //                 },
            //                 child: const Icon(
            //                   Icons.upload_file_outlined,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //         customTextField(hinttext: "ID", addcontroller: _addId),
            //         Center(
            //           child: ElevatedButton(
            //             onPressed: () async {
            //               await FirebaseFirestore.instance
            //                   .collection('amenities')
            //                   .doc(amenityId)
            //                   .set(
            //                 {
            //                   'name': _addName.text,
            //                   // 'image': _addImage.text,
            //                   'id': _addId.text,
            //                   'amenity_id': amenityId,
            //                   'gym_id': [],
            //                 },
            //               ).then((snapshot) async {
            //                 await uploadImageToAmenities(image, amenityId);
            //               });
            //
            //               Navigator.pop(context);
            //             },
            //             child: const Text('Done'),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          // ));
}

//EDIT FEATURE

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.name,
    required this.image,
    required this.amenityId,
    required this.am,
  }) : super(key: key);

  final String name;
  final String image;
  final String amenityId;
  final String am;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _image = TextEditingController();
  final TextEditingController _amenityId = TextEditingController();
  late String amm;

  @override
  void initState() {
    super.initState();
    _image.text = widget.image;
    _amenityId.text = widget.amenityId;
    _name.text = widget.name;
    amm = widget.am;
  }

  var imagee;
  bool checker = false;

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Edit Amenites'),
      ),
      body:
      Center(
      child: SizedBox(
          height: 580,
          width: 800,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update Records for this doc',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                customTextField3(hinttext: "Name", addcontroller: _name),
                // customTextField(hinttext: "Image", addcontroller: _image),
                Container(
                  padding: EdgeInsets.all(20),
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
                          setState(() {
                            checker = (checker == false) ? true : false;
                          });
                          imagee = await chooseImage();
                        },
                        child: const Icon(
                          Icons.upload_file_outlined,
                        ),
                      )
                    ],
                  ),
                ),
                customTextField(hinttext: "ID", addcontroller: _amenityId),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("The Gym id is : ${_amenityId.text}");
                        if (checker == true) {
                          FirebaseFirestore.instance
                              .collection('amenities')
                              .doc(amm)
                              .update(
                            {
                              'name': _name.text,
                              // 'image': _image,
                              'id': _amenityId.text,
                              'amenity_id': amm,
                              'gym_id': [],
                            },
                          ).then((snapshot) async {
                            await uploadImageToAmenities(imagee, amm);
                          });

                          Navigator.pop(context);
                        } else {
                          FirebaseFirestore.instance
                              .collection('amenities')
                              .doc(amm)
                              .update(
                            {
                              'name': _name.text,
                              'image': _image.text,
                              'id': _amenityId.text,
                              'amenity_id': amm,
                              'gym_id': [],
                            },
                          );

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Done'),
                    ),
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
