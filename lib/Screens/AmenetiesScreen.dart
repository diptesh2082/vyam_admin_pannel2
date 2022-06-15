import 'package:admin_panel_vyam/Screens/ameneties_new_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/deleteMethod.dart';
import '../services/image_picker_api.dart';
import 'package:path/path.dart' as Path;

class AmenetiesScreen extends StatefulWidget {
  const AmenetiesScreen({Key? key}) : super(key: key);

  @override
  State<AmenetiesScreen> createState() => _AmenetiesScreenState();
}

class _AmenetiesScreenState extends State<AmenetiesScreen> {
  CollectionReference? amenityStream;
  String searchAmeneties = '';

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
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Get.to(() => newAmeneties());
                    },
                    child: Text('Add Product'),
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
                Container(
                  width: 500,
                  height: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      // focusNode: _node,

                      autofocus: false,
                      textAlignVertical: TextAlignVertical.bottom,
                      onSubmitted: (value) async {
                        FocusScope.of(context).unfocus();
                      },
                      // controller: searchController,
                      onChanged: (value) {
                        if (value.length == 0) {
                          // _node.canRequestFocus=false;
                          // FocusScope.of(context).unfocus();
                        }
                        if (mounted) {
                          setState(() {
                            searchAmeneties = value.toString();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white12,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: amenityStream!
                        .orderBy('id', descending: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }

                      var doc = snapshot.data.docs;

                      if (searchAmeneties.length > 0) {
                        doc = doc.where((element) {
                          return element
                              .get('name')
                              .toString()
                              .toLowerCase()
                              .contains(searchAmeneties.toString());
                        }).toList();
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
                          rows: _buildlist(context, doc),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Previous Page"),
                      onPressed: () {
                        setState(() {
                          if (start > 0 && end > 0) {
                            start = start - 10;
                            end = end - 10;
                          }
                        });
                        print("Previous Page");
                      },
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      child: Text("Next Page"),
                      onPressed: () {
                        setState(() {
                          if (end < length) {
                            start = start + 10;
                            end = end + 10;
                          }
                        });
                        print("Next Page");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var start = 0;

  var end = 10;
  var length;

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    var d = 1;
    var s = start + 1;
    var snap = [];
    length = snapshot.length;
    snapshot.forEach((element) {
      if (end >= d++ && start <= d) {
        snap.add(element);
      }
    });
    return snap
        .map((data) => _buildListItem(context, data, s++, start, end))
        .toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data, int index,
      int start, int end) {
    String amenitiesId = data['amenity_id'];
    return DataRow(cells: [
      DataCell(data != null ? Text(index.toString()) : const Text("")),
      // DataCell(
      //   data['id'] != null ? Text(data['id'] ?? "") : const Text(""),
      // ),
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
          Get.to(() => ProductEditBox(
              name: data['name'],
              image: data['image'],
              amenityId: data['id'],
              am: data['amenity_id']));
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
        deleteMethodI(
            stream: FirebaseFirestore.instance.collection('amenities'),
            uniqueDocId: amenitiesId,
            imagess: data['image']);
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
  var imgUrl1;

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
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Edit Amenites'),
      ),
      body: Center(
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
                          await getUrlImage(imagee);
                        },
                        child: const Icon(
                          Icons.upload_file_outlined,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 200,
                        child: Container(
                          child: Image.network(
                            (imgUrl1 == null) ? ' ' : imgUrl1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                              'image': imgUrl1,
                              'id': _amenityId.text,
                              'amenity_id': amm,
                              'gym_id': [],
                            },
                          );
                          //     .then((snapshot) async {
                          //   await uploadImageToAmenities(imagee, amm);
                          // });

                          Navigator.pop(context);
                        } else {
                          FirebaseFirestore.instance
                              .collection('amenities')
                              .doc(amm)
                              .update(
                            {
                              'name': _name.text,
                              'image': imgUrl1,
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
        imgUrl1 = imageUrl;
      });
    }
  }
}
