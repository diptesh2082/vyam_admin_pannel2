import 'dart:ui';
import 'map_view.dart';
import 'package:admin_panel_vyam/Screens/banner_edit.dart';
import 'package:admin_panel_vyam/Screens/banner_new_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps/google_maps.dart';
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
bool ischeckk = false;

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
        title: const Text("Banners"),
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
                      child: const Text('Add Banner')),
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

                      if (searchBannerName.isNotEmpty) {
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
                                  'Banners',
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
    bool access = data['access'];
    bool visible = data['visible'];
    String banner_id = data['id'];
    bool setnavv = data['navigation'] == "/gym_details" ? true : false;
    String com = '';

    return DataRow(cells: [
      DataCell(data['position_id'] != null
          ? Text(data['position_id'] ?? "")
          : const Text("")),
      DataCell(
          data['name'] != null ? Text(data['name'] ?? "") : const Text("")),
      DataCell(data['image'] != null && data['image'] != "null"
          ? Image.network(data['image'])
          : const Text("Image Not Uploaded")),
      DataCell(ElevatedButton(
        onPressed: () async {
          setnavv = !setnavv;
          com = setnavv ? "/gym_details" : "";

          print("New $com");
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection('banner_details')
              .doc(banner_id);
          await documentReference
              .update({'navigation': com})
              .whenComplete(() => print("Legitimate toggled"))
              .catchError((e) => print(e));
          await documentReference
              .update({'access': setnavv})
              .whenComplete(() => print("Legitimate toggled"))
              .catchError((e) => print(e));
        },
        child: Text(
          setnavv ? "Activated" : "Deactivated",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
            primary: setnavv ? Colors.green : Colors.red),
      )),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = visible;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('banner_details')
                  .doc(banner_id);
              await documentReference
                  .update({'visible': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
// <<<<<<< HEAD
// <<<<<<< HEAD
            child: Text(visible ? "Enable" : "Disable"),

            style: ElevatedButton.styleFrom(
                primary: visible ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Get.to(
          () => EditBox(
              position: data['position_id'],
              name: data['name'],
              image: data['image'].toString(),
              id: data['id'],
              access: data['access'],
              navigation: data['navigation'],
              gym_id: data['gym_id'],
              area: data['area'],
              selectedArea: data['selected_area']),
        );
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethodI(
        //     stream: bannerStream,
        //     uniqueDocId: banner_id,
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
                                  stream: bannerStream,
                                  uniqueDocId: banner_id,
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

bool setnav = false;

class navedit extends StatefulWidget {
  const navedit({Key? key, required this.navtext}) : super(key: key);
  final String navtext;
  @override
  State<navedit> createState() => _naveditState();
}

String navcommandedit = '';

class _naveditState extends State<navedit> {
  var rs;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.navtext == "/gym_details") {
      setState(() {
        setnav = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Set Navigation"),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (setnav == false) {
              setState(() {
                setnav = true;
                navcommandedit = "/gym_details";
                print("Set NAv Activated In Edit");
              });
            } else {
              setState(() {
                setnav = false;
                navcommandedit = "";
                print("SET NAV DEACTIVATED In Edit");
              });
            }
            print("New $navcommandedit");
          },
          child: Text(
            setnav ? "Activated" : "Deactivated",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
              primary: setnav ? Colors.green : Colors.red),
        )
      ],
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
      required this.gym_id,
      required this.area,
      required this.selectedArea})
      : super(key: key);
  final String position;
  final String gym_id;
  final String navigation;
  final GeoPoint selectedArea;
  final bool area;
  final String name;
  final String image;
  final String id;
  final bool access;

  @override
  _EditBoxState createState() => _EditBoxState();
}

late GeoPoint sa;

class _EditBoxState extends State<EditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _navigation = TextEditingController();
  final TextEditingController _addaddress = TextEditingController();

  var id;
  var image;
  var imgUrl1;
  bool access = false;
  bool area = false;
  var gym_id = '';
  String searchGymName = '';
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
    area = widget.area;
    image = widget.image;
    namee = widget.gym_id;
    sa = widget.selectedArea;
    _navigation.text = widget.navigation;
  }

  void dropDowntype2(bool? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      area = selecetValue!;
      print(area);
    });

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          title: const Text('Edit Banners'),
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
                  // CustomTextField(
                  //     hinttext: "Navigation", addcontroller: _navigation),
                  navedit(navtext: _navigation.text),
                  Container(
                    width: 400,
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
                          FocusScope.of(context).unfocus(); // <<<<<<< HEAD
                        },

                        onChanged: (value) {
                          if (value.isEmpty) {}
                          if (mounted) {
                            setState(() {
                              searchGymName = value.toString();
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
                          var doc = snapshot.data.docs;

                          print("-----------------------------------");
                          if (searchGymName.isNotEmpty) {
                            doc = doc.where((element) {
                              return element
                                      .get('name')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchGymName.toString()) ||
                                  element
                                      .get('gym_id')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchGymName.toString()) ||
                                  element
                                      .get('address')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchGymName.toString());
                            }).toList();
                          }
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
                                      ischeckk = true;
                                    });
                                    print(namee);
                                  });
                            },
                          );
                        },
                      )),
                  //CustomTextField(hinttext: "Image url", addcontroller: _image),
                  Row(
                    children: [
                      const Text('Area Selection: '),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        color: Colors.white10,
                        child: DropdownButton(
                            hint: Text('$area'),
                            items: const [
                              DropdownMenuItem(
                                child: Text("true"),
                                value: true,
                              ),
                              DropdownMenuItem(
                                child: Text("false"),
                                value: false,
                              ),
                            ],
                            onChanged: dropDowntype2),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .75,
                        width: 900,
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Stack(
                          children: [
                            MapView(
                              address_con: _addaddress,
                            ),
                            const Center(
                              child: Icon(
                                Icons.location_on_rounded,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  editim(
                    imagea: image,
                    idd: id,
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(50),
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
                                  'image': image3 ?? widget.image,
                                  'id': id,
                                  'access': access,
                                  'gym_id': namee,
                                  'navigation': navcommandedit,
                                  'area': area,
                                  'selected_area': sa
                                },
                              ).whenComplete(() {
                                setState(() {
                                  image3 = null;
                                  navcommandedit = '';
                                });
                              });
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

var ds;

class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.idd})
      : super(key: key);
  final String imagea;
  final String idd;
  @override
  State<editim> createState() => _editimState();
}

var image3;

class _editimState extends State<editim> {
  @override
  String i2 = '';
  void initState() {
    // TODO: implement initState
    i2 = widget.imagea;
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
            setState(() {
              isloading = true;
            });
            var dic = await chooseImage();
            await addImageToStorage(dic, widget.idd);
            setState(() {
              isloading = false;
              i2 = image3;
            });
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
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child("banner_details")
          .child('images/$id');
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
              .collection("banner_details")
              .doc(id)
              .update({"image": value});
        });
      });
    } else {
//write a code for android or ios
    }
  }
}
