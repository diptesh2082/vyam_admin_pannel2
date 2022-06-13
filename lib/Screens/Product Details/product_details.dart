import 'dart:html';
import 'dart:io';
// import 'dart:html';
import 'dart:math';
import 'package:admin_panel_vyam/Screens/banners.dart';
import 'package:admin_panel_vyam/Screens/map_view.dart';
import 'package:admin_panel_vyam/Screens/timings.dart';
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

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

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
                            if (value.isEmpty) {
                              // _node.canRequestFocus=false;
                              // FocusScope.of(context).unfocus();
                            }
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
                  ],
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: productStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'GYM Owner ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym Owner',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gender',
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                                  'Landmark',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Pincode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              DataColumn(
                                label: Text(
                                  'Trainers',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ), //! For trainer
                              DataColumn(
                                label: Text(
                                  'Packages',
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timings',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym_status',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validity of User',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Online Pay Status',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Upload Display Image',
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

                              // DataColumn(label: Text('')), //! For edit pencil
                              // DataColumn(label: Text('')),
                            ],
                            rows: _buildlist(context, doc)),
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

  Future<List<XFile>> multiimagepicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  // Future<String> uploadimage(XFile image) async {
  //   var x = Random().nextInt(9999);
  //   if (x < 1000) {
  //     x = x + 1000;
  //   }
  //   Reference db =
  //       FirebaseStorage.instance.ref().child("product_image").child("${x}");
  //   await db.putFile(File(image.path));
  //   // await db.putFile(File(image.path));
  //   return await db.getDownloadURL();
  // }
  //
  // String getImageName(XFile image) {
  //   return image.path.split("/").last;
  // }
  //
  // Future<List<String>> multiimageuploader(List<XFile> list) async {
  //   List<String> _path = [];
  //   for (XFile _image in list) {
  //     _path.add(await uploadimage(_image));
  //   }
  //   return _path;
  // }

  // final TextEditingController morning = TextEditingController();
  // final TextEditingController evening = TextEditingController();
  // final TextEditingController closed = TextEditingController();
  // final TextEditingController morning_days = TextEditingController();
  // final TextEditingController evening_days = TextEditingController();

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    // var d=1;
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    // morning.text=data['timings']["gym"]["Morning"];
    // evening.text=data['timings']["gym"]["Evening"];
    // closed.text=data['timings']["gym"]["Closed"];
    // morning_days.text=data['timings']["gym"]["morning_days"];
    // evening_days.text=data['timings']["gym"]["evening_days"];
    String gymId = data['gym_id'];
    GeoPoint loc = data['location'];
    String name = data['name'];
    bool legit = data['legit'];
    bool status = data["gym_status"];
    bool online_pay = data["online_pay"];
    List imgList = data['images'];
    String landmark = data['landmark'];
    List<dynamic> arr2 = data['amenities'];
    List<dynamic> WorkoutArray = data['workouts'];
    List<dynamic> serviceArray = data['service'];

    String x, y;

    return DataRow(cells: [
      DataCell(data != null ? Text(data['name'] ?? "") : const Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : const Text("")),
      DataCell(data != null ? Text(gymId) : const Text("")),
      DataCell(data != null ? Text(data['gym_owner'] ?? "") : const Text("")),
// <<<<<<< HEAD
//       DataCell(data != null
//           ? Text(data['gender'].toString().toUpperCase())
//           : const Text("")),
// =======
      DataCell(data != null ? Text(data['gender'] ?? "") : const Text("")),
// >>>>>>> cf1997613ff877c63a56c61e3009bdfe3639ccfa
      // DataCell(data != null
      //     ? GestureDetector(
      //         onTap: () async {
      //           await MapsLaucherApi().launchMaps(loc.latitude, loc.longitude);
      //         },
      //         child: Text(loctext))

      //: const Text("")),
      DataCell(data != null ? Text(data['landmark'] ?? "") : const Text("")),
// >>>>>>> cf1997613ff877c63a56c61e3009bdfe3639ccfa
      DataCell(data != null ? Text(data['pincode'] ?? "") : const Text("")),

      DataCell(ElevatedButton(
          child: const Text(
            'Trainer',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.yellowAccent),
          onPressed: (() {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  TrainerPage(gymId, data['name'], data['branch']),
            ));
          }))),

      DataCell(ElevatedButton(
        child: const Text('Packages'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PackagesPage(pGymId: gymId, o: name, land: landmark),
          ));
        },
      )),
//       DataCell(const Text('Extra Package '), onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ExtraPackagesPage(
//             pGymId: gymId,
// // <<<<<<< HEAD
// // =======
//           ),
//         ));
//       }),
//       DataCell(const Text('Extra Package '), onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ExtraPackagesPage(
//             pGymId: gymId,
//           ),
//         ));
//       }),
      DataCell(
        Row(
          children: [
            Container(
              child: GestureDetector(
                onTap: () async {
                  var image = await chooseImage();
                  await addImageToStorage(image, gymId);
                },
                child: const Center(
                  child: Icon(
                    Icons.file_upload_outlined,
                    size: 20,
                  ),
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
                      // =======
                      // >>>>>>> 39301b603a430fc9803df29ba70b59135c783388
                      height: MediaQuery.of(context).size.height * .90,
                      width: MediaQuery.of(context).size.width * .92,

                      child: StreamBuilder<Object>(
                          stream: productStream!.snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: data['images'].length,
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
                                          child: Image.network(
                                            data['images'][index].toString(),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                          onPressed: () async {
                                            print(data['images'].length);
                                            await deletee(
                                                // '12.jpeg',
                                                imgList[index].toString(),
                                                data['images']);
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
                    pGymId: gymId,
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
            child: Text(online_pay.toString()),
            style: ElevatedButton.styleFrom(
                primary: online_pay ? Colors.green : Colors.red),
          ),
        ),
      ),

      DataCell(
        Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () async {
                    // print('OS: ${Platform.operatingSystem}');
                    var dic = await chooseImage();
                    await uploadImageToStorage(dic, gymId);
                    // await pickImage();
                    // await saveData(gymId);
                  },
                  icon: const Icon(Icons.camera_alt_outlined)),
              const Text("Display Picture"),
            ],
          ),
        ),
      ),

      DataCell(
        const Text(""),
        showEditIcon: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductEditBox(
                        address: data['address'],
                        gender: data['gender'],
                        name: data['name'],
                        pincode: data['pincode'],
                        gymId: data['gym_id'],
                        gymOwner: data['gym_owner'],
                        landmark: data['landmark'],
                        password: data['password'],
                        imagee: data['display_picture'],
                        arr2: arr2,
                        WorkoutArray: WorkoutArray,

                        serviceArray: serviceArray,

                        description: data['description'],

                        // location: data['location'],
                      )));
        },
      ),

      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: productStream, uniqueDocId: gymId);
      })
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
  final TextEditingController _addlandmark = TextEditingController();
  final TextEditingController _addgymownerid = TextEditingController();
  final _latitudeController = 0;
  final _longitudeController = 0;
  String addressVendor = '';

  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();
  final TextEditingController _numberCon = TextEditingController();
  var dic;
  var multipic;
  var impath;
  var image;

  var xs;
  bool selected = false;
  CollectionReference? amenitiesStream;
  CollectionReference? workoutStream;

  var selectedValue = "MALE";

  @override
  void initState() {
    productStream = FirebaseFirestore.instance.collection("product_details");
    amenitiesStream = FirebaseFirestore.instance.collection("amenities");
    workoutStream = FirebaseFirestore.instance.collection("workouts");
    RandomPasswordGenerator pswd = RandomPasswordGenerator();
    xs = pswd.randomPassword(letters: true, uppercase: true, numbers: true);
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

              Container(
                child: Row(
                  children: [
                    const Text('Gender:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
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
              ),

              const SizedBox(height: 15),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Latitude:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Not Required',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const SizedBox(height: 15),
// <<<<<<< HEAD
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Longitude:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    'Not Required',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
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
// =======
//               Container(
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Longitude:',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700, fontSize: 15)),
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Text(
//                       'Not Required',
//                       style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                           fontStyle: FontStyle.italic),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Stack(
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height * .75,
//                           width: 900,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(color: Colors.grey))),
//                           child: Stack(
//                             children: [
//                               MapView(
//                                 address_con: _addaddress,
//                               ),
//                               const Center(
//                                 child: Icon(
//                                   Icons.location_on_rounded,
//                                   size: 40,
//                                   color: Colors.black,
//                                 ),
// >>>>>>> 6c3fa0070166be553c60e87a940531de62732a35
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Landmark:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                  hinttext: "Landmark", addcontroller: _addlandmark),
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
// <<<<<<< HEAD
              ),

              const Text(
                'SELECT WORKOUTS',
                style: TextStyle(fontSize: 20),
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
                child: const Text('Number:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              customTextField(
                addcontroller: _numberCon,
                hinttext: "Number",
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Upload Display Image',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // dic = await chooseImage();
                      image = uploadToStroagees();
                    },
                    child: const Text(
                      'Upload Gym Image',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  image != null
                      ? Image(
                          image: NetworkImage('$image'),
                          height: 200,
                          width: 200,
                        )
                      : Container(
                          color: Colors.black,
                          height: 200,
                          width: 200,
                        )
                ],
              ),

              const SizedBox(height: 10),
              Text(xs.toString()),
              Text(
                "Services",
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w700),
              ),
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
                        height: 500,
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

              // Text(
              //   'Upload Display Image',
              //   style:
              //       TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     image = uploadToStroagesss();
              //   },
              //   child: Text(
              //     'Upload Image',
              //     style:
              //         TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              //   ),
              // ),
              // // Image(
              // //   image: FileImage(vall, scale: 4),
              // // ),
              // SizedBox(
              //   height: 20,
              // ),

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
                          double.parse(_latitudeController.toString()),
                          double.parse(_longitudeController.toString()));

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
                          'landmark': _addlandmark.text,
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
                          "password": xs.toString(),
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

  uploadToStroagees() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;

    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();

      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs
            .ref()
            .child('product_image/${_addgymownerid.text}')
            .putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          image = downloadUrl;
        });
      });
    });
  }
}

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
                if (selected == true) arr.add(widget.id);
                print(arr);
                if (selected == false) arr.remove(widget.id);
                print(arr);
              }),
        ],
      ),
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
          Container(
            child: CheckboxListTile(
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
          ),
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
    if (widget.serviceArray.contains(widget.id)) {
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
    // required this.location,
    required this.landmark,
    required this.pincode,
    required this.imagee,
    this.arr2,
    this.WorkoutArray,
    this.serviceArray,
    this.description,
    required this.password,
  }) : super(key: key);

  final String name;
  final String address;
  final String gymId;
  final String gymOwner;
  final String gender;
  final String password;
  // final GeoPoint location;
  final String landmark;
  final String pincode;
  final imagee;
  final arr2;
  final WorkoutArray;

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
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String image = '';
  CollectionReference? amenitiesStream;
  CollectionReference? workoutStream;
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
    _landmark.text = widget.landmark;
    image = widget.imagee;
    _password.text = widget.password;
    _description.text = widget.description;
    amenitiesStream = FirebaseFirestore.instance.collection("amenities");
    workoutStream = FirebaseFirestore.instance.collection("workouts");
    // _location.text = "${widget.location.latitude}, ${widget.location.latitude}";
    // _latitudeController.text = widget.location.latitude.toString();
    // _longitudeController.text = widget.location.longitude.toString();
    // print(widget.location.latitude);
  }

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
              customTextField(hinttext: "Gym ID", addcontroller: _gymiid),
              customTextField(hinttext: "Gym Owner", addcontroller: _gymowner),
              customTextField(hinttext: "Gender", addcontroller: _gender),
              customTextField(
                  hinttext: "Description", addcontroller: _description),
              customTextField(hinttext: 'Password', addcontroller: _password),
              // customTextField(
              //     hinttext: 'Longitude', addcontroller: _longitudeController),
              customTextField(hinttext: "Landmark", addcontroller: _landmark),
              customTextField(hinttext: "Pincode", addcontroller: _pincode),
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
// <<<<<<< HEAD
// <<<<<<< HEAD
// =======
//
// >>>>>>> db16c184745ea062b80bb6d62b73b5f64792dc9e
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // dic = await chooseImage();
                      image = uploadToStroagees();
                    },
                    child: const Text(
                      'Upload Gym Image',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  image != null
                      ? Image(
                          image: NetworkImage('$image'),
                          height: 200,
                          width: 200,
                        )
                      : Container(
                          color: Colors.black,
                          height: 200,
                          width: 200,
                        )
                ],
// <<<<<<< HEAD
// =======
              ),
//
//                Text("Services",
//               style: GoogleFonts.poppins(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w700
// // >>>>>>> db16c184745ea062b80bb6d62b73b5f64792dc9e
//               ),
// =======
              Text(
                "Services",
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w700),
              ),
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

// <<<<<<< HEAD
// >>>>>>> 1f09f104c279e9107f7b92c5d9c2cf410db6e92c
// =======

// >>>>>>> db16c184745ea062b80bb6d62b73b5f64792dc9e
              // Text(image),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
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
                        // 'location': dataForGeoPint,
                        'password': _password.text,
                        'gym_id': _gymiid.text,
                        'gym_owner': _gymowner.text,
                        'landmark': _landmark.text,
                        'description': _description.text,
                      };
                      await documentReference
                          .update(data)
                          .whenComplete(() => print("Item Updated"))
                          .catchError((e) => print(e));
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

  uploadToStroagees() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;

    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();

      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot =
            await fs.ref().child('product_image/${widget.gymId}').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          image = downloadUrl;
        });
      });
    });
  }
}
