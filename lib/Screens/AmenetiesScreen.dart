import 'package:admin_panel_vyam/Screens/ameneties_new_screen.dart';
import 'package:admin_panel_vyam/Screens/category_screen.dart';
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
      appBar: AppBar(
        title: const Text("Amenities"),
      ),
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
                      Get.to(() => const newAmeneties());
                    },
                    child: const Text('Add Product'),
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
                        if (value.isEmpty) {
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("Previous Page"),
                      onPressed: () {
                        setState(() {
                          if (start >= 1) page--;
                          if (start > 0 && end > 0) {
                            start = start - 10;
                            end = end - 10;
                          }
                        });
                        print("Previous Page");
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        page.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Next Page"),
                      onPressed: () {
                        setState(() {
                          if (end <= length) page++;
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
  var page = 1;
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
        data['image'] != null && data['image'] != "null"
            ? Image.network(
                data['image'] ?? "",
                scale: 0.5,
                height: 150,
                width: 150,
              )
            : const Text("Image Not Uploaded"),
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
              image: data['image'].toString(),
              amenityId: data['id'],
              am: amenitiesId));
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
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethodI(
        //     stream: FirebaseFirestore.instance.collection('amenities'),
        //     uniqueDocId: amenitiesId,
        //     imagess: data['image']);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: SizedBox(
              height: 170,
              width: 280,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Do you want to delete?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteMethodI(
                                  stream: FirebaseFirestore.instance
                                      .collection('amenities'),
                                  uniqueDocId: amenitiesId,
                                  imagess: data['image']);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Yes'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('No'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      })
    ]);
  }

  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addImage = TextEditingController();
  final TextEditingController _addId = TextEditingController();
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
  String amm = '';
  var im1;

  @override
  void initState() {
    super.initState();
    im1 = widget.image;
    _amenityId.text = widget.amenityId;
    _name.text = widget.name;
    amm = widget.am;
  }

  bool checker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Edit Amenites'),
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
                editim(imagea: im1, amid: amm),
                // customTextField(hinttext: "ID", addcontroller: _amenityId),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("The Gym id is : ${_amenityId.text}");

                        FirebaseFirestore.instance
                            .collection('amenities')
                            .doc(amm)
                            .update(
                          {
                            'name': _name.text,
                            'image': image3 ?? im1,
                            'id': _amenityId.text,
                            'amenity_id': amm,
                            'gym_id': [],
                          },
                        ).whenComplete(() {
                          image3 = null;
                        });
                        //     .then((snapshot) async {
                        //   await uploadImageToAmenities(imagee, amm);
                        // });

                        Navigator.pop(context);
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

class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.amid})
      : super(key: key);
  final String imagea;
  final String amid;
  @override
  State<editim> createState() => _editimState();
}

var image3;

class _editimState extends State<editim> {
  @override
  String i2 = '';
  String di = '';
  void initState() {
    // TODO: implement initState
    i2 = widget.imagea;
    di = widget.amid;
    super.initState();
  }

// <<<<<<< HEAD
  bool isloading = false;
  var imagee;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              var dic = await chooseImage();
              if (dic != null) {
                setState(() {
                  isloading = true;
                });
              }
              await addImageToStorage(dic, di);
              setState(() {
                isloading = false;
                i2 = image3;
              });
            } finally {
              setState(() {
                isloading = false;
              });
            }
          },
          child: const Text(
            'Upload Gym Image',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        isloading
            ? const SizedBox(
                height: 100,
                width: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox(
                height: 100,
                width: 200,
                child: Image.network(i2),
              ),
      ],
    );
  }

  addImageToStorage(XFile? pickedFile, String? id) async {
    if (kIsWeb) {
      Reference _reference =
          FirebaseStorage.instance.ref().child("amenities").child('images/$id');
      await _reference
          .putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) async {
          var uploadedPhotoUrl = value;
          setState(() {
            image3 = value;
          });
          print(value);
          await FirebaseFirestore.instance
              .collection("amenities")
              .doc(id)
              .update({"image": value});
        });
      });
    } else {
//write a code for android or ios
    }
  }
}
