import 'dart:html';
import 'dart:io';
// import 'dart:html';
import 'dart:math';
import 'package:admin_panel_vyam/Screens/Product%20Details/offers/offers.dart';
import 'package:admin_panel_vyam/Screens/banners.dart';
import 'package:admin_panel_vyam/Screens/map_view.dart';
import 'package:admin_panel_vyam/Screens/timings.dart';
import 'package:flutter/foundation.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../services/MatchIDMethod.dart';
import '../../services/deleteMethod.dart';
import '../../services/image_picker_api.dart';
import '../globalVar.dart';
import 'Packages/packages.dart';
import 'Trainers/Trainers.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';

List<String> arr = [];
List<String> workoutArray = [];
List<String> d = [];
List<String> rules = [
  '· Bring your towel and use it',
  '· Bring seperate shoes.',
  '· Re-rack equipments',
  '· No heavy lifting without spotter'
];

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

int fd = 0;

class _ProductDetailsState extends State<ProductDetails> {
  final id = FirebaseFirestore.instance
      .collection('product_details')
      .doc()
      .id
      .toString();
  CollectionReference? productStream;
  CollectionReference? amenitiesStream;
  var image;
  String gender = 'male';
  String searchGymName = '';
  String pswd = '';

  @override
  void initState() {
    productStream = FirebaseFirestore.instance.collection("product_details");
    amenitiesStream = FirebaseFirestore.instance.collection("amenities");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor Details"),
      ),
      body: SafeArea(
        child: Material(
          elevation: 8,
          child: Container(
            // margin: EdgeInsets.only(bottom: 10),
            height: 800,
            width: 1450,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.0)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),

                            textStyle: const TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ShowAddBox(),
                            ));
                          },
                          child: const Text('Add Product'),
                        ),
                      ),
                      const Spacer(),
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
                              FocusScope.of(context).unfocus(); // <<<<<<< HEAD
                            },

                            onChanged: (value) {
                              if (value.isEmpty) {}
                              if (mounted) {
                                setState(() {
                                  searchGymName = value.toString();
                                  page = 1;
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
                    ],
                  ),
                  Center(
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
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              // ? DATATABLE
                              dataRowHeight: 65,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'Index',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )),
                                DataColumn(
                                  label: Text(
                                    'Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Address',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'GYM \n Owner ID',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Password',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Gym Owner',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Gender',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // DataColumn(
                                //   label: Text(
                                //     'Location',
                                //     style: TextStyle(fontWeight: FontWeight.w600),
                                //   ),
                                // ),
                                DataColumn(
                                  label: Text(
                                    'Branch',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Pincode',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),

                                DataColumn(
                                  label: Text(
                                    'Trainers',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ), //! For trainer
                                DataColumn(
                                  label: Text(
                                    'Packages',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Offers',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ), //!For Package
                                // DataColumn(
                                //   label: Text(
                                //     'Extra Packages',
                                //     style: TextStyle(fontWeight: FontWeight.w600),
                                //   ),
                                // ),
                                DataColumn(
                                  label: Text(
                                    'Upload Image',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Timings',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Gym_status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'User Block',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Online Pay Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Cash Pay Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Upload Display Image',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Edit',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Delete',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
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
                          const SizedBox(
                            width: 20,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("product_details")
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                fd = int.parse(
                                    ((snapshot.data.docs.length / 10).floor())
                                        .toString());
                                int index2 = 0;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.data == null) {
                                  print(snapshot.error);
                                  return Container();
                                }
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Container();
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  height: 50,
                                  width: 100,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: int.parse(
                                              ((snapshot.data.docs.length / 10)
                                                      .floor())
                                                  .toString()) +
                                          1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  color: page == index + 1
                                                      ? Colors.red
                                                      : Colors.teal,
                                                  height: 20,
                                                  width: 20,
                                                  child: Text(
                                                    "${index + 1}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                              ],
                                            ),
                                            onTap: () {
                                              // print(
                                              //     "start=${((index + 1) - 1) * 10} end= ${(index + 1) * 10}");
                                              print(index2);
                                              setState(() {
                                                index2 = index;
                                                start = ((index + 1) - 1) * 10;
                                                end = (index + 1) * 10;
                                                page = index + 1;
                                              });
                                              print(index2);
                                            });
                                      }),
                                );
                              }),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                start = ((fd + 1) - 1) * 10;
                                end = (fd + 1) * 10;
                                page = fd + 1;
                              });
                            },
                            child: Container(
                              height: 20,
                              width: 80,
                              color: Colors.teal,
                              child: const Text(
                                "Last Page",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
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
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<XFile>> multiimagepicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
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
    String? gymId;
    try {
      gymId = data['gym_id'].toString();
    } catch (e) {
      gymId = "#ERROR";
    }
    // GeoPoint loc = data['location'];
    String? name;
    try {
      name = data['name'].toString();
    } catch (e) {
      name = "#ERROR";
    }

    bool legit = false;
    try {
      legit = data['legit'];
    } catch (e) {
      legit = false;
    }

    bool status = false;
    try {
      status = data["gym_status"];
    } catch (e) {
      status = false;
    }

    bool online_pay = false;
    try {
      online_pay = data["online_pay"];
    } catch (e) {
      online_pay = false;
    }
    bool cash_pay = false;
    try {
      cash_pay = data["cash_pay"];
    } catch (e) {
      cash_pay = false;
    }
    List imgList = [];
    try {
      imgList = data["images"];
    } catch (e) {
      imgList = ["Null"];
    }

    String? imagess;
    try {
      imagess = data['display_picture'].toString();
    } catch (e) {
      imagess = "#ERROR";
    }
    String? address;
    try {
      address = data['address'].toString();
    } catch (e) {
      address = "#ERROR";
    }
    String? password;
    try {
      password = data['password'].toString();
    } catch (e) {
      password = "#ERROR";
    }
    String? gym_owner;
    try {
      gym_owner = data['gym_owner'].toString();
    } catch (e) {
      gym_owner = "#ERROR";
    }
    String? gender;
    try {
      gender = data['gender'].toString();
    } catch (e) {
      gender = "#ERROR";
    }
    String? branch;
    try {
      branch = data['branch'].toString();
    } catch (e) {
      branch = "#ERROR";
    }
    String? pincode;
    try {
      pincode = data['pincode'].toString();
    } catch (e) {
      pincode = "#ERROR";
    }
    GeoPoint location = GeoPoint(0, 0);
    try {
      location = data['location'];
    } catch (e) {
      location = GeoPoint(0, 0);
    }

    List<dynamic> arr2 = [];
    try {
      arr2 = data['amenities'];
    } catch (e) {
      arr2 = ["Null"];
    }

    List<dynamic> WorkoutArray = [];
    try {
      WorkoutArray = data['workouts'];
    } catch (e) {
      WorkoutArray = ["Null"];
    }

    List<dynamic> serviceArray = [];
    try {
      serviceArray = data['service'];
    } catch (e) {
      serviceArray = ["Null"];
    }

    String? descriptionns;
    try {
      descriptionns = data['description'];
    } catch (e) {
      descriptionns = "#ERROR";
    }

    List<dynamic> ruless = [];
    try {
      ruless = data['rules'];
    } catch (e) {
      ruless = ["Null"];
    }

    // List<dynamic> arr2 = data['amenities'];
    // List<dynamic> WorkoutArray = data['workouts'];
    // List<dynamic> serviceArray = data['service'];
    String x, y;

    return DataRow(cells: [
      DataCell(data != null ? Text(index.toString()) : const Text("")),
      DataCell(name != null ? Text(name.toString()) : const Text("")),
      DataCell(address != null ? Text(address.toString()) : const Text("")),
      DataCell(gymId != null ? Text(gymId.toString()) : const Text("")),
      DataCell(password != null ? Text(password.toString()) : const Text("")),

      DataCell(gym_owner != null ? Text(gym_owner.toString()) : const Text("")),
// <<<<<<< HEAD
//       DataCell(data != null
//           ? Text(data['gender'].toString().toUpperCase())
//           : const Text("")),
// =======
      DataCell(gender != null ? Text(gender) : const Text("")),
// >>>>>>> cf1997613ff877c63a56c61e3009bdfe3639ccfa
      // DataCell(data != null
      //     ? GestureDetector(
      //         onTap: () async {
      //           await MapsLaucherApi().launchMaps(loc.latitude, loc.longitude);
      //         },
      //         child: Text(loctext))
      //: const Text("")),
      DataCell(branch != null ? Text(branch) : const Text("")),
      DataCell(pincode != null ? Text(pincode) : const Text("")),

      DataCell(ElevatedButton(
          child: const Text(
            'Trainer',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.yellowAccent),
          onPressed: (() {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TrainerPage(
                  gymId.toString(), name.toString(), branch.toString()),
            ));
          }))),

      DataCell(ElevatedButton(
        child: const Text('Packages'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PackagesPage(
                pGymId: gymId.toString(),
                o: name.toString(),
                land: branch.toString()),
          ));
        },
      )),

      DataCell(ElevatedButton(
        child: const Text('Offers'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => offersPage(
                offerId: gymId.toString(),
                name: name.toString(),
                landmark: branch.toString()),
          ));
        },
      )),

      DataCell(
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                send(gymId.toString());
              },
              child: const Center(
                child: Icon(
                  Icons.file_upload_outlined,
                  size: 20,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              child: const Text('View'),
              onPressed: () {
                print(imgList);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * .90,
                      width: MediaQuery.of(context).size.width * .92,
                      child: StreamBuilder<Object>(
                          stream: productStream!.snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return GridView.builder(
                                padding: const EdgeInsets.all(20.0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: imgList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 500,
                                          width: 500,
                                          child: FittedBox(
                                              child: Image.network(
                                            imgList[index].toString(),
                                            fit: BoxFit.fill,
                                          )),
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                          onPressed: () async {
                                            print(imgList.length);
                                            await deletee(
                                                // '12.jpeg',
                                                imgList[index].toString(),
                                                imgList);
                                            await FirebaseFirestore.instance
                                                .collection('product_details')
                                                .doc(gymId)
                                                .update({
                                              'images': FieldValue.arrayRemove(
                                                  [imgList[index]])
                                            });
                                            print("Delete!");
                                          },
                                          icon: const Icon(Icons.delete),
                                        )
                                      ],
                                    ),

                                    // minLeadin≥gWidth: double.infinity,
                                  );
                                });
                          }),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              // Adding timings +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------

              Get.to(() => Timings(
                    pGymId: gymId.toString(),
                  ));
              // bool temp = online_pay;
              // temp = !temp;
              // DocumentReference documentReference = FirebaseFirestore.instance
              //     .collection('product_details')
              //     .doc(gymId);
              // await documentReference
              //     .update({'online_pay': temp})
              //     .whenComplete(() => print("Legitimate toggled"))
              //     .catchError((e) => print(e));
            },
            child: const Text("See Timings"),
            style: ElevatedButton.styleFrom(primary: Colors.blue),
          ),
        ),
      ),
      // DataCell(
      //   Center(
      //     child: ElevatedButton(
      //       onPressed: () async {
      //         bool temp = legit;
      //         temp = !temp;
      //         DocumentReference documentReference = FirebaseFirestore.instance
      //             .collection('product_details')
      //             .doc(gymId);
      //         await documentReference
      //             .update({'gym_status': temp})
      //             .whenComplete(() => print("Legitimate toggled"))
      //             .catchError((e) => print(e));
      //       },
      //       child: Text(legit.toString()),
      //       style: ElevatedButton.styleFrom(
      //           primary: legit ? Colors.green : Colors.red),
      //     ),
      //   ),
      // ),

      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = status;
              temp = !temp;

              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(gymId);
              await documentReference
                  .update({'gym_status': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(x = status ? 'YES' : 'NO'),
            style: ElevatedButton.styleFrom(
                primary: status ? Colors.green : Colors.red),
          ),
        ),
      ),

      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = legit;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(gymId);
              await documentReference
                  .update({'legit': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
// <<<<<<< HEAD
//             child: Text(y = legit ? 'YES' : 'NO'),
// =======
            child: Text(y = legit ? 'YES' : 'NO'),
// >>>>>>> cf1997613ff877c63a56c61e3009bdfe3639ccfa
            style: ElevatedButton.styleFrom(
                primary: legit ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = online_pay;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(gymId);
              await documentReference
                  .update({'online_pay': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(online_pay ? "ON" : "OFF"),
            style: ElevatedButton.styleFrom(
                primary: online_pay ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = cash_pay;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(gymId);
              await documentReference
                  .update({'cash_pay': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(cash_pay ? "ON" : "OFF"),
            style: ElevatedButton.styleFrom(
                primary: cash_pay ? Colors.green : Colors.red),
          ),
        ),
      ),

      DataCell(
          datacelldisplay(disimg: imagess.toString(), idd: gymId.toString())),

      DataCell(
        const Text(""),
        showEditIcon: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductEditBox(
                        address: address.toString(),
                        gender: gender.toString(),
                        name: name.toString(),
                        pincode: pincode.toString(),
                        branch: branch.toString(),
                        gymId: gymId.toString(),
                        gymOwner: gym_owner.toString(),
                        // landmark: data['landmark'],
                        password: password.toString(),
                        imagee: imagess.toString(),
                        arr2: arr2,
                        WorkoutArray: WorkoutArray,
                        serviceArray: serviceArray,
                        description: descriptionns,
                        rules: ruless,
                        location: location,
                      )));
        },
      ),

      // DataCell(const Icon(Icons.delete), onTap: () {
      // deleteMethodVendor(
      //     stream: productStream,
      //     uniqueDocId: gymId,
      //     imagess: imagess,
      //     imlist: imgList);
      DataCell(const Icon(Icons.delete), onTap: () {
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
                              deleteMethodVendor(
                                  stream: productStream,
                                  uniqueDocId: gymId,
                                  imagess: imagess,
                                  imlist: imgList);
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
      // })
    ]);
  }

//Adding new data -----------------------------------------------------------------+++++++++++++++++++++++++++-------------------
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();
  final TextEditingController _numberCon = TextEditingController();

  Future<void> deletee(String reff, var s) async {
    // var pictureref = FirebaseFirestore.refFromURL(reff);
    await FirebaseStorage.instance.ref().child(reff).delete();
    print(s.length);
  }
}

class ShowAddBox extends StatefulWidget {
  const ShowAddBox({Key? key}) : super(key: key);

  @override
  State<ShowAddBox> createState() => _ShowAddBoxState();
}

class _ShowAddBoxState extends State<ShowAddBox> {
  CollectionReference? productStream;
  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  // final TextEditingController _addlandmark = TextEditingController();
  final TextEditingController _addgymownerid = TextEditingController();
  final TextEditingController _addpassword = TextEditingController();
  final TextEditingController _latitude = TextEditingController();

  final TextEditingController _longitude = TextEditingController();

  final _latitudeController = 0;
  final _longitudeController = 0;
  String addressVendor = '';

  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();
  final TextEditingController _numberCon = TextEditingController();
  final TextEditingController _addrules = TextEditingController();

  var dic;
  var multipic;
  var impath;
  bool isloading = false;

  // var xs;
  bool selected = false;
  CollectionReference? amenitiesStream;
  CollectionReference? workoutStream;

  var selectedValue = "MALE";

  @override
  void initState() {
    productStream = FirebaseFirestore.instance.collection("product_details");
    amenitiesStream = FirebaseFirestore.instance.collection("amenities");
    workoutStream = FirebaseFirestore.instance.collection("workouts");
    // RandomPasswordGenerator pswd = RandomPasswordGenerator();
    // xs = pswd.randomPassword(letters: true, uppercase: true, numbers: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add Vendor Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 2, right: 8),
                child: Text(
                  'Add Records',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Name:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(hinttext: "Name", addcontroller: _addname),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Address:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),

              customTextField(hinttext: "Address", addcontroller: _addaddress),
              customTextField(hinttext: "Latitude", addcontroller: _latitude),
              customTextField(hinttext: "Longitude", addcontroller: _longitude),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Gym Owner Id:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                  hinttext: "Gym Owner Id", addcontroller: _addgymownerid),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Add Password:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                  hinttext: "Password", addcontroller: _addpassword),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Branch:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                addcontroller: _branchController,
                hinttext: "branch",
              ),
              const SizedBox(height: 15),

              //customTextField(hinttext: "Gender", addcontroller: _addgender),

              Row(
                children: [
                  const Text('Gender:',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  DropdownButton(
                      value: selectedValue,
                      items: const [
                        DropdownMenuItem(
                          child: Text("Male"),
                          value: "MALE",
                        ),
                        DropdownMenuItem(
                          child: Text("Female"),
                          value: "FEMALE",
                        ),
                        DropdownMenuItem(
                            child: Text("Unisex"), value: "UNISEX"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      }),
                ],
              ),

              const SizedBox(height: 15),
// <<<<<<< HEAD
              Row(
                children: [
                  const SizedBox(
                    height: 15,
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
                ],
              ),
              const SizedBox(height: 15),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text('Landmark:',
              //       style:
              //           TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              // ),
              // customTextField(
              //     hinttext: "Landmark", addcontroller: _addlandmark),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Pincode:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                addcontroller: _addpincode,
                hinttext: "Pincode",
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Amenities:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: amenitiesStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return Container();
                  }
                  print("-----------------------------------");
                  var doc = snapshot.data.docs;
                  return SizedBox(
                    width: 400,
                    height: 500,
                    child: ListView.builder(
                        itemCount: doc.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool check = false;
                          return CheckBoxx(
                              doc[index]['name'], doc[index]['amenity_id']);
                        }),
                  );
                },
              )),
              const SizedBox(height: 15),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('SELECT WORKOUTS:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),

              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('workouts')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return Container();
                    }
                    print("-----------------------------------");
                    var document = snapshot.data.docs;
                    print(document);

                    return SizedBox(
                      width: 400,
                      height: 500,
                      child: ListView.builder(
                          itemCount: document.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckBoxx1(
                                document[index]['type'], document[index]['id']);
                          }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text("Categories",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("category")
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

                      return SizedBox(
                        width: 400,
                        height: 300,
                        child: ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool check = false;
                            return Echecka(
                              type: doc[index]['name'],
                              id: doc[index]['category_id'],
                              gymid: _addgymownerid.text,
                              // serviceArray: widget.serviceArray,
                            );
                          },
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Description:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                addcontroller: _descriptionCon,
                hinttext: "Description",
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Number:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                addcontroller: _numberCon,
                hinttext: "Number",
              ),
              const SizedBox(height: 20),
              customTextField(
                addcontroller: _addrules,
                hinttext: "Bullet Points",
              ),
              const SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rules.add(_addrules.text);
                          _addrules.text = "";
                        });
                      },
                      child: const Text("Add Points")),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rules.removeLast();
                          _addrules.text = "";
                        });
                      },
                      child: const Text("Remove Points"))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                rules.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Upload Display Image',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              loadimage(id: _addgymownerid.text),
              const SizedBox(height: 30),
              Row(
                children: [
                  // ElevatedButton(onPressed: (){
                  //     if(addressVendor!='')
                  //     {
                  //       setState(() {
                  //         _addaddress.text = getAddress();
                  //       });
                  //
                  //     }
                  //     print(_addaddress.text);
                  //
                  // }, child: Text('HELLO')),
                  ElevatedButton(
                    onPressed: () async {
                      print(dic);
                      GeoPoint dataForGeoPint = GeoPoint(
                          double.parse(_latitude.text.toString()),
                          double.parse(_longitude.text.toString()));

                      await matchID(
                          newId: _addgymownerid.text,
                          matchStream: productStream,
                          idField: 'gym_id');
                      FirebaseFirestore.instance
                          .collection('product_details')
                          .doc(_addgymownerid.text)
                          .set(
                        {
                          'address': _addaddress.text,
                          'gender': selectedValue,
                          'name': _addname.text,
                          'pincode': _addpincode.text,
                          'location': dataForGeoPint,
                          'gym_id': _addgymownerid.text,
                          'gym_owner': _addgymownerid.text,
                          // 'landmark': _addlandmark.text,
                          'total_booking': "",
                          'total_sales': "",
                          'legit': false,
                          "branch": _branchController.text,
                          "description": _descriptionCon.text,
                          "display_picture": image != null
                              ? image
                              : "https://www.kindpng.com/picc/m/22-223941_transparent-avatar-png-male-avatar-icon-transparent-png.png",
                          "images": [],
                          "locality": "",
                          "number": _numberCon.text,
                          "online_pay": true,
                          "payment_due": "",
                          "rating": 0.0,
                          "service": d,
                          "timings": [],
                          "token": [],
                          "view_count": 0.0,
                          "gym_status": false,
                          "amenities": arr,
                          "workouts": workoutArray,
                          "password": _addpassword.text,
                          'valid': true,
                          'rules': rules,
                        },
                        // ).then((snapshot) async {
                        //   await uploadImageToStorage(dic, _addgymownerid.text);
                        //   await FirebaseFirestore.instance
                        //       .collection('product_details')
                        //       .doc(_addgymownerid.text)
                        //       .update({'images': impath});
                        // });
                      );

                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print(impath);
                  //     },
                  //     child: Text('Press Me'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// <<<<<<< HEAD
// <<<<<<< HEAD
// =======
// <<<<<<< dewansh_new
// >>>>>>> 38dd6d5074aaa10b19649b11160fb9d2e51fa7d9
// =======
class loadimage extends StatefulWidget {
  const loadimage({Key? key, required this.id}) : super(key: key);
  final id;
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
        ElevatedButton(
          onPressed: () async {
            // dic = await chooseImage();

            image = await uploadToStroagees();
            // .then(setState(() {
            //   isloading = false;
            // }));
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
            ? Container(
                child: image != null
                    ? Image(
                        image: NetworkImage('$image'),
                        height: 200,
                        width: 200,
                      )
                    : const Center(child: CircularProgressIndicator()))
            : Container(
                child: const Text(
                "Please Upload Image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ))
      ],
    ));
  }

  uploadToStroagees() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;

    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();

      reader.readAsDataUrl(file!);
      setState(() {
        isloading = true;
      });
      reader.onLoadEnd.listen((event) async {
        var snapshot =
            await fs.ref().child('product_image/${widget.id}').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          image = downloadUrl;
        });
      });
    });
  }
}

// <<<<<<< HEAD
// >>>>>>> 3924bca1e564ec0c3d3c9e1da255159690d475d9
// =======
// >>>>>>> Diptesh
// >>>>>>> 38dd6d5074aaa10b19649b11160fb9d2e51fa7d9
class CheckBoxx extends StatefulWidget {
  final String doc;
  final String id;

  const CheckBoxx(this.doc, this.id, {Key? key}) : super(key: key);

  @override
  State<CheckBoxx> createState() => _CheckBoxxState();
}

class _CheckBoxxState extends State<CheckBoxx> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            // bool selected=false;
            value: check,
            title: Text(widget.doc),
            onChanged: (bool? selected) async {
              setState(() {
                check = selected!;
              });
              if (selected == true) arr.add(widget.id);
              print(arr);
              if (selected == false) arr.remove(widget.id);
              print(arr);
            }),
      ],
    );
  }
}

class ECheckBox extends StatefulWidget {
  final String doc;
  final String id;
  final arr2;
  final String gym_id;

  const ECheckBox(this.doc, this.id, this.arr2, this.gym_id, {Key? key})
      : super(key: key);

  @override
  State<ECheckBox> createState() => _ECheckBoxState();
}

class _ECheckBoxState extends State<ECheckBox> {
  bool check = false;
  checkboxstatus() async {
    if (widget.arr2.contains(widget.id)) {
      setState(() {
        check = true;
      });
    } else {
      setState(() {
        check = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkboxstatus();
    print(widget.arr2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CheckboxListTile(
              // bool selected=false;
              value: check,
              title: Text(widget.doc),
              onChanged: (bool? selected) async {
                setState(() {
                  check = selected!;
                });
                if (selected == true) {
                  await FirebaseFirestore.instance
                      .collection('product_details')
                      .doc(widget.gym_id)
                      .update({
                    'amenities': FieldValue.arrayUnion([widget.id])
                  });
                }
                // print(widget.arr2);
                if (selected == false) {
                  await FirebaseFirestore.instance
                      .collection('product_details')
                      .doc(widget.gym_id)
                      .update({
                    'amenities': FieldValue.arrayRemove([widget.id])
                  });
                }
                // print(widget.arr2);
              }),
        ],
      ),
    );
  }
}

class CheckBoxx1 extends StatefulWidget {
  final String doc;
  final String id;

  const CheckBoxx1(this.doc, this.id, {Key? key}) : super(key: key);

  @override
  State<CheckBoxx1> createState() => _CheckBoxxState1();
}

class _CheckBoxxState1 extends State<CheckBoxx1> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            // bool selected=false;
            value: check,
            title: Text(widget.doc),
            onChanged: (bool? selected) async {
              setState(() {
                check = selected!;
              });
              if (selected == true) workoutArray.add(widget.id);
              print(workoutArray);
              if (selected == false) workoutArray.remove(widget.id);
              print(workoutArray);
            }),
      ],
    );
  }
}

class Echecka extends StatefulWidget {
  const Echecka(
      {Key? key, required this.type, required this.id, required this.gymid})
      : super(key: key);
  final String type;
  final String id;
  final String gymid;
  @override
  State<Echecka> createState() => _EcheckaState();
}

class _EcheckaState extends State<Echecka> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            // bool selected=false;
            value: check,
            title: Text(widget.type),
            onChanged: (bool? selected) async {
              setState(() {
                check = selected!;
              });
              if (selected == true) d.add(widget.id);
              print(d);
              if (selected == false) d.remove(widget.id);
              print(d);
            }
            // print(widget.arr2);
            ),
      ],
    );
  }
}

class ECheckService extends StatefulWidget {
  final String type;
  final String id;
  final serviceArray;
  final String gymid;
  const ECheckService(
      {Key? key,
      required this.type,
      required this.id,
      required this.serviceArray,
      required this.gymid})
      : super(key: key);

  @override
  State<ECheckService> createState() => _ECheckServiceState();
}

class _ECheckServiceState extends State<ECheckService> {
  bool check = false;

  checkBoxWorkout() async {
    if (widget.serviceArray.contains(widget.type)) {
      setState(() {
        check = true;
      });
    } else {
      setState(() {
        check = false;
      });
    }
  }

  @override
  void initState() {
    checkBoxWorkout();
    print(widget.serviceArray);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            // bool selected=false;
            value: check,
            title: Text(widget.type),
            onChanged: (bool? selected) async {
              setState(() {
                check = selected!;
              });
              if (selected == true) {
                await FirebaseFirestore.instance
                    .collection('product_details')
                    .doc(widget.gymid)
                    .update({
                  'service': FieldValue.arrayUnion([widget.type])
                });
              }
              // print(widget.arr2);
              if (selected == false) {
                await FirebaseFirestore.instance
                    .collection('product_details')
                    .doc(widget.gymid)
                    .update({
                  'service': FieldValue.arrayRemove([widget.type])
                });
              }
              // print(widget.arr2);
            }),
      ],
    );
  }
}

class ECheckBoxWorkout extends StatefulWidget {
  final String type;
  final String id;
  final worKoutArray;
  final String gymid;

  const ECheckBoxWorkout(this.worKoutArray, this.type, this.id, this.gymid,
      {Key? key})
      : super(key: key);

  @override
  State<ECheckBoxWorkout> createState() => _ECheckBoxWorkoutState();
}

class _ECheckBoxWorkoutState extends State<ECheckBoxWorkout> {
  bool check = false;

  checkBoxWorkout() async {
    if (widget.worKoutArray.contains(widget.id)) {
      setState(() {
        check = true;
      });
    } else {
      setState(() {
        check = false;
      });
    }
  }

  @override
  void initState() {
    checkBoxWorkout();
    print(widget.worKoutArray);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            // bool selected=false;
            value: check,
            title: Text(widget.type),
            onChanged: (bool? selected) async {
              setState(() {
                check = selected!;
              });
              if (selected == true) {
                await FirebaseFirestore.instance
                    .collection('product_details')
                    .doc(widget.gymid)
                    .update({
                  'workouts': FieldValue.arrayUnion([widget.id])
                });
              }
              // print(widget.arr2);
              if (selected == false) {
                await FirebaseFirestore.instance
                    .collection('product_details')
                    .doc(widget.gymid)
                    .update({
                  'workouts': FieldValue.arrayRemove([widget.id])
                });
              }
              // print(widget.arr2);
            }),
      ],
    );
  }
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.address,
    required this.name,
    required this.gymId,
    required this.gymOwner,
    required this.gender,
    required this.location,
    // required this.location,
    // required this.landmark,
    required this.pincode,
    required this.imagee,
    this.arr2,
    this.WorkoutArray,
    this.serviceArray,
    this.description,
    required this.password,
    required this.branch,
    required this.rules,
  }) : super(key: key);

  final String name;
  final String address;
  final String gymId;
  final String branch;
  final String gymOwner;
  final String gender;
  final String password;
  final GeoPoint location;
  // final String landmark;
  final String pincode;
  final String imagee;
  final arr2;
  final WorkoutArray;
  final List rules;

  final serviceArray;

  final description;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _gymiid = TextEditingController();
  final TextEditingController _gymowner = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _branch = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _rules = TextEditingController();

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String imagess = '';
  List rs = [];
  CollectionReference? amenitiesStream;
  CollectionReference? workoutStream;
  CollectionReference? categoryStream;
  @override
  void initState() {
    super.initState();
    print(widget.address);
    _address.text = widget.address;
    _gender.text = widget.gender;
    _name.text = widget.name;
    _pincode.text = widget.pincode;
    _gymiid.text = widget.gymId;
    _gymowner.text = widget.gymOwner;
    _branch.text = widget.branch;
    imagess = widget.imagee;
    _password.text = widget.password;
    rs = widget.rules;
    _description.text = widget.description;
    amenitiesStream = FirebaseFirestore.instance.collection("amenities");
    workoutStream = FirebaseFirestore.instance.collection("workouts");
    categoryStream = FirebaseFirestore.instance.collection('category');
    // _location.text = "${widget.location.latitude}, ${widget.location.latitude}";
    _latitudeController.text = widget.location.latitude.toString();
    _longitudeController.text = widget.location.longitude.toString();
    // print(widget.location.latitude);
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Box'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
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
              customTextField(hinttext: "Name", addcontroller: _name),
              customTextField(hinttext: "Address", addcontroller: _address),
              customTextField(
                  hinttext: "Latitude", addcontroller: _latitudeController),
              customTextField(
                  hinttext: "Longitude", addcontroller: _longitudeController),

              customTextField(hinttext: "Gym ID", addcontroller: _gymiid),
              customTextField(hinttext: "Gym Owner", addcontroller: _gymowner),
              customTextField(hinttext: "Gender", addcontroller: _gender),
              customTextField(
                  hinttext: "Description", addcontroller: _description),
              customTextField(hinttext: 'Password', addcontroller: _password),
              const SizedBox(height: 20),
              customTextField(
                addcontroller: _rules,
                hinttext: "Bullet Points",
              ),
              const SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rs.add(_rules.text);
                          _rules.text = "";
                        });
                      },
                      child: const Text("Add Points")),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rs.removeLast();
                          _rules.text = "";
                        });
                      },
                      child: const Text("Remove Points"))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                rs.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // customTextField(
              //     hinttext: 'Longitude', addcontroller: _longitudeController),
              customTextField(hinttext: "Branch", addcontroller: _branch),
              customTextField(hinttext: "Pincode", addcontroller: _pincode),
              editim(imagea: widget.imagee, gymid: _gymiid.text),
              const Text(
                "Choose Amenities",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: amenitiesStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return Container();
                  }
                  print("-----------------------------------");
                  var doc = snapshot.data.docs;
                  return SizedBox(
                    width: 400,
                    height: 500,
                    child: ListView.builder(
                        itemCount: doc.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool check = false;
                          return ECheckBox(
                              doc[index]['name'],
                              doc[index]['amenity_id'],
                              widget.arr2,
                              _gymiid.text);
                        }),
                  );
                },
              )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Choose Workout",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),

              Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: workoutStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");
                      var doc = snapshot.data.docs;

                      return SizedBox(
                        width: 400,
                        height: 500,
                        child: ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool check = false;
                            return ECheckBoxWorkout(
                                widget.WorkoutArray,
                                doc[index]['type'],
                                doc[index]['id'],
                                _gymiid.text);
                          },
                        ),
                      );
                    }),
              ),

              const Text(
                "Choose Categories",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),

              Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: categoryStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");
                      var doc = snapshot.data.docs;

                      return SizedBox(
                        width: 400,
                        height: 500,
                        child: ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool check = false;
                            return ECheckService(
                              type: doc[index]['name'],
                              id: doc[index]['category_id'],
                              gymid: _gymiid.text,
                              serviceArray: widget.serviceArray,
                            );
                          },
                        ),
                      );
                    }),
              ),
              // Text(image),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      GeoPoint dataForGeoPint = GeoPoint(
                          double.parse(_latitudeController.text),
                          double.parse(_longitudeController.text));
                      print("The Gym id is : ${_gymiid.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc(_gymiid.text);

                      Map<String, dynamic> data = <String, dynamic>{
                        'address': _address.text,
                        'gender': _gender.text,
                        'name': _name.text,
                        'pincode': _pincode.text,
                        'location': dataForGeoPint,
                        'password': _password.text,
                        'gym_id': _gymiid.text,
                        'gym_owner': _gymowner.text,
                        'branch': _branch.text,
                        'description': _description.text,
                        'display_picture': image2 ?? widget.imagee,
                        'rules': rs
                      };
                      await documentReference.update(data).whenComplete(() {
                        print("Item Updated");
                      }).catchError((e) => print(e));
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
    );
  }
}

///////////Edit Change
class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.gymid})
      : super(key: key);
  final String imagea;
  final String gymid;
  @override
  State<editim> createState() => _editimState();
}

class _editimState extends State<editim> {
  @override
  String i2 = '';
  void initState() {
    // TODO: implement initState
    i2 = widget.imagea;
    super.initState();
  }

// <<<<<<< HEAD
  @override
  bool isloading = false;
  // var imagee;
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

              await addImageToStorage(dic, widget.gymid);
              setState(() {
                isloading = false;
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
        isloading && image2 == null
            ? SizedBox(
                height: 200,
                width: 200,
                child: const CircularProgressIndicator())
            : image2 != null
                ? Image(
                    image: NetworkImage(image2.toString()),
                    height: 200,
                    width: 200,
                  )
                : Image(
                    image: NetworkImage(i2),
                    height: 200,
                    width: 200,
                  )
      ],
    );
  }

  addImageToStorage(XFile? pickedFile, String? id) async {
    if (kIsWeb) {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child("product_image")
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
            image2 = value;
          });
          print(value);
          await FirebaseFirestore.instance
              .collection("product_details")
              .doc(id)
              .update({"display_picture": value});
// =======
//       reader.readAsDataUrl(file!);
//       reader.onLoadEnd.listen((event) async {
//         var snapshot =
//         await fs.ref().child('product_image/${widget.gymId}').putBlob(file);
//         String downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           image = downloadUrl;
// >>>>>>> 21d9c030cebb9d9fd030fc57983203910f0655fa
        });
      });
    } else {
//write a code for android or ios
    }
  }
}

///////Edit Change
var image2 = null;

class datacelldisplay extends StatefulWidget {
  const datacelldisplay({Key? key, required this.disimg, required this.idd})
      : super(key: key);
  final String disimg;
  final String idd;
  @override
  State<datacelldisplay> createState() => _datacelldisplayState();
}

class _datacelldisplayState extends State<datacelldisplay> {
  bool isloadingg = false;
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        Column(
          children: [
            IconButton(
                onPressed: () async {
                  try {
                    var image2 = await chooseImage();
                    if (image2 != null) {
                      setState(() {
                        isloadingg = true;
                      });
                    }
                    await addImageToStorage(image2, widget.idd);
                  } finally {
                    setState(() {
                      isloadingg = false;
                    });
                  }
                },
                icon: const Icon(Icons.camera_alt_outlined)),
            const Text("Display Picture"),
          ],
        ),
        isloadingg
            ? const SizedBox(
                height: 100,
                width: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : widget.disimg != "null"
                ? SizedBox(
                    height: 100,
                    width: 200,
                    child: Image.network(widget.disimg),
                  )
                : const Center(child: Text("Image Not Uploaded")),
      ]),
    );
  }
}
