import 'dart:ui';

import 'package:admin_panel_vyam/Screens/banner_edit.dart';
import 'package:admin_panel_vyam/Screens/banner_new_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_picker_api.dart';
import '../services/CustomTextFieldClass.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;

class BannerPage extends StatefulWidget {
  const BannerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

var image;
var imgUrl1;

class _BannerPageState extends State<BannerPage> {
  final id = FirebaseFirestore.instance.collection('banner_details').doc().id;
  CollectionReference? bannerStream;

  createReview(String nid) {
    final review = FirebaseFirestore.instance.collection('banner_details');
    review.doc(nid).set({'id': nid});
  }

  String searchBannerName = '';

  @override
  void initState() {
    bannerStream = FirebaseFirestore.instance.collection('banner_details');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banners"),
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
                        Get.to(const bannerNewPage()); //showAddbox,
                      },
                      child: Text('Add Banner')),
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
                            searchBannerName = value.toString();
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

                      var doc = snapshot.data.docs;

                      if (searchBannerName.length > 0) {
                        doc = doc.where((element) {
                          return element
                              .get('name')
                              .toString()
                              .toLowerCase()
                              .contains(searchBannerName.toString());
                        }).toList();
                      }

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Position',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
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
                                  'Navigation',
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
                            rows: _buildlist(context, doc)),
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
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        page.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Next Page"),
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
    bool access = data['access'];
    String banner_id = data['id'];

    return DataRow(cells: [
      DataCell(data['position_id'] != null
          ? Text(data['position_id'] ?? "")
          : const Text("")),
      DataCell(
          data['name'] != null ? Text(data['name'] ?? "") : const Text("")),
      DataCell(Image.network(data['image'])),
      DataCell(data['navigation'] != null
          ? Text(data['navigation'] ?? "")
          : const Text("")),
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
// <<<<<<< HEAD
// <<<<<<< HEAD
            child: Text(access ? "Clickable" : "Non-Clickable"),
// =======
//             child: Text(access ? 'Clickable' : 'Non-Clickable'),
// >>>>>>> 1f09f104c279e9107f7b92c5d9c2cf410db6e92c
// =======
//             child: Text(access ? "Clickable" : "Non-Clickable"),
//
// >>>>>>> db16c184745ea062b80bb6d62b73b5f64792dc9e
            style: ElevatedButton.styleFrom(
                primary: access ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Get.to(
          () => EditBox(
            position: data['position_id'],
            name: data['name'],
            image: data['image'],
            id: data['id'],
            access: data['access'],
            navigation: data['navigation'],
            gym_id: data['gym_id'],
          ),
        );
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethodI(
            stream: bannerStream,
            uniqueDocId: banner_id,
            imagess: data['image']);
      })
    ]);
  }

  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  String? print_type = 'accessible';
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
  const EditBox(
      {Key? key,
      required this.position,
      required this.name,
      required this.image,
      required this.id,
      required this.access,
      required this.navigation,
      required this.gym_id})
      : super(key: key);
  final String position;
  final String gym_id;
  final String navigation;
  final String name;
  final String image;
  final String id;
  final bool access;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _navigation = TextEditingController();

  var id;
  var image;
  var imgUrl1;
  bool access = false;
  var gym_id = '';

  // final TextEditingController _image = TextEditingController();
  CollectionReference? productStream;
  String namee = "edgefitness.kestopur@vyam.com";

  @override
  void initState() {
    productStream = FirebaseFirestore.instance.collection("product_details");

    super.initState();
    _position.text = widget.position;
    _name.text = widget.name;
    id = widget.id;
    image = widget.image;
    namee = widget.gym_id;
    _navigation.text = widget.navigation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          title: Text('Edit Banners'),
        ),
        body: Center(
          child: SizedBox(
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
                  CustomTextField(
                      hinttext: "Position", addcontroller: _position),
                  CustomTextField(
                      hinttext: "Navigation", addcontroller: _navigation),

                  SizedBox(
                      height: 400,
                      width: 400,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: productStream!.snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          String check = "Jee";
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
                                    });
                                    print(namee);
                                  });
                            },
                          );
                        },
                      )),
                  //CustomTextField(hinttext: "Image url", addcontroller: _image),

                  loadimage(),

                  Padding(
                    padding: EdgeInsets.all(50),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("/////");

                          FirebaseFirestore.instance
                              .collection('banner_details')
                              .doc(id)
                              .update(
                            {
                              'position_id': _position.text,
                              'name': _name.text,
                              'image': imgUrl1 == null ? image : imgUrl1,
                              'id': id,
                              'access': access,
                              'gym_id': namee,
                              'navigation': _navigation.text,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ),
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  )),
                ],
              ),
            ),
          ),
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
        imgUrl1 = imageUrl;
      });
    }
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
      padding: EdgeInsets.all(20),
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
                          child: Center(child: CircularProgressIndicator()))
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
                    ))
        ],
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
