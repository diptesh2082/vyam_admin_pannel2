import 'dart:io';
// import 'dart:html';
import 'dart:math';
import 'package:admin_panel_vyam/Screens/timings.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:admin_panel_vyam/services/maps_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import '../../services/MatchIDMethod.dart';
import '../../services/deleteMethod.dart';
import '../../services/image_picker_api.dart';
import 'Packages/Extra_package.dart';
import 'Packages/packages.dart';
import 'Trainers/Trainers.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';

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
  chooseImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    return pickedFile;
  }

  final _firebaseStorage =
      FirebaseStorage.instance.ref().child("product_image");
  uploadImageToStorage(PickedFile? pickedFile, String? id) async {
    if (kIsWeb) {
      Reference _reference =
          _firebaseStorage.child('images/${Path.basename(pickedFile!.path)}');
      await _reference
          .putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) async {
          var uploadedPhotoUrl = value;
          print(value);
          await FirebaseFirestore.instance
              .collection("product_details")
              .doc(id)
              .update({
            "display_picture": value,
            "images": FieldValue.arrayUnion([value])
          });
        });
      });
    } else {
//write a code for android or ios
    }
  }

// <<<<<<< HEAD
//   File? image;
//   Future pickImage() async {
//     try{
//       final image = await ImagePicker().pickImage(
//           source: ImageSource.gallery,
//           imageQuality: 60
//       );
//       if (image == null) return;
//       final imageTemporary = File(image.path);
//       setState(() {
//         this.image = imageTemporary;
//       });
//     } on PlatformException catch (e) {
//       // ignore: avoid_print
//       print("Faild to pick image: $e");
//     }
//
//   }
//
//
//   saveData(gymId)async {
//     // if (_globalKey.currentState!.validate()) {
//       try{
//         // _globalKey.currentState!.save();
//         final ref =  FirebaseStorage.instance.ref().child("gs://vyam-f99ab.appspot.com/productDetails").child(gymId+".jpg");
//         print(ref);
//         await ref.putFile(image!);
//         final url = await ref.getDownloadURL();
//         await FirebaseFirestore.instance.collection("product_details")
//             .doc(gymId).update({
//           "display_picture": url
//         });
//         // setState(() {
//         //   imageUrl=url;
//         //   // isLoading=false;
//         // }
//         // );
//       }catch (e){
//         // imageUrl="";
//       }
//
//       // print(imageUrl);
//
//     // }
//   }
// // =======
// //   List<String> multiimages = [];
// // >>>>>>> 2bd9314ce4369a0ee8841fb3648ac2b93b65ffa4

  @override
  void initState() {
    productStream = FirebaseFirestore.instance.collection("product_details");
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
                    onTap: showAddbox,
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back_ios_outlined)),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.add),
                              Text('Add Product',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                  'Gym ID',
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
                              DataColumn(
                                label: Text(
                                  'Location',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
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
                              DataColumn(
                                label: Text(
                                  'Extra Packages',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'upload Image',
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

  Future<List<XFile>> multiimagepicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  Future<String> uploadimage(XFile image) async {
    var x = Random().nextInt(9999);
    if (x < 1000) {
      x = x + 1000;
    }
    Reference db =
        FirebaseStorage.instance.ref().child("product_image").child("${x}");
    await db.putFile(File(image.path));
    // await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<List<String>> multiimageuploader(List<XFile> list) async {
    List<String> _path = [];
    for (XFile _image in list) {
      _path.add(await uploadimage(_image));
    }
    return _path;
  }

  // final TextEditingController morning = TextEditingController();
  // final TextEditingController evening = TextEditingController();
  // final TextEditingController closed = TextEditingController();
  // final TextEditingController morning_days = TextEditingController();
  // final TextEditingController evening_days = TextEditingController();

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
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
    bool legit = data['legit'];
    bool status = data["gym_status"];
    bool online_pay = data["online_pay"];
    String loctext = "${loc.latitude},${loc.longitude}";
    return DataRow(cells: [
      DataCell(data != null ? Text(data['name'] ?? "") : const Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : const Text("")),
      DataCell(data != null ? Text(gymId) : const Text("")),
      DataCell(data != null ? Text(data['gym_owner'] ?? "") : const Text("")),
      DataCell(data != null ? Text(data['gender'] ?? "") : const Text("")),
      DataCell(data != null
          ? GestureDetector(
              onTap: () async {
                await MapsLaucherApi().launchMaps(loc.latitude, loc.longitude);
              },
              child: Text(loctext))
          : const Text("")),
      DataCell(data != null ? Text(data['landmark'] ?? "") : const Text("")),
      DataCell(data != null ? Text(data['pincode'] ?? "") : const Text("")),
      DataCell(const Text('Trainer'), onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TrainerPage(tGymId: gymId),
        ));
      })),
      DataCell(const Text('Package '), onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PackagesPage(
            pGymId: gymId,
          ),
        ));
      }),
      DataCell(const Text('Extra Package '), onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ExtraPackagesPage(
            pGymId: gymId,
          ),
        ));
      }),
      DataCell(
        Row(
          children: [
            const Spacer(),
            GestureDetector(
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
            )
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
            child: Text(status.toString()),
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
            child: Text(legit.toString()),
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
          showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    address: data['address'],
                    gender: data['gender'],
                    name: data['name'],
                    pincode: data['pincode'],
                    gymId: data['gym_id'],
                    gymOwner: data['gym_owner'],
                    landmark: data['landmark'],
                    location: data['location'],
                  ),
                ),
              );
            },
          );
        },
      ),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: productStream, uniqueDocId: gymId);
      })
    ]);
  }

//Adding new data -----------------------------------------------------------------+++++++++++++++++++++++++++-------------------
  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addlandmark = TextEditingController();
  final TextEditingController _addgymownerid = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();
  final TextEditingController _numberCon = TextEditingController();

  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * .90,
              width: MediaQuery.of(context).size.width * .92,
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
                    customTextField(hinttext: "Name", addcontroller: _addname),
                    customTextField(
                        hinttext: "Address", addcontroller: _addaddress),
                    customTextField(
                        hinttext: "Gym Owner Id",
                        addcontroller: _addgymownerid),
                    customTextField(
                      addcontroller: _branchController,
                      hinttext: "branch",
                    ),
                    customTextField(
                        hinttext: "Gender", addcontroller: _addgender),
                    customTextField(
                        hinttext: 'Latitude',
                        addcontroller: _latitudeController),
                    customTextField(
                        hinttext: 'Longitude',
                        addcontroller: _longitudeController),
                    customTextField(
                        hinttext: "Landmark", addcontroller: _addlandmark),
                    customTextField(
                      addcontroller: _addpincode,
                      hinttext: "Pincode",
                    ),
                    customTextField(
                      addcontroller: _descriptionCon,
                      hinttext: "Description",
                    ),
                    customTextField(
                      addcontroller: _numberCon,
                      hinttext: "Number",
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          GeoPoint dataForGeoPint = GeoPoint(
                              double.parse(_latitudeController.text),
                              double.parse(_longitudeController.text));

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
                              'gender': _addgender.text,
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
                              "display_picture": "",
                              "images": [],
                              "locality": "",
                              "number": _numberCon.text,
                              "online_pay": true,
                              "payment_due": "",
                              "rating": 0.0,
                              "service": [],
                              "timings": [],
                              "token": [],
                              "view_count": 0.0,
                              "gym_status": false,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
}

// *Updating Item list Class

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.address,
    required this.name,
    required this.gymId,
    required this.gymOwner,
    required this.gender,
    required this.location,
    required this.landmark,
    required this.pincode,
  }) : super(key: key);

  final String name;
  final String address;
  final String gymId;
  final String gymOwner;
  final String gender;
  final GeoPoint location;
  final String landmark;
  final String pincode;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _gymiid = TextEditingController();
  final TextEditingController _gymowner = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

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
    _location.text = "${widget.location.latitude}, ${widget.location.latitude}";
    _latitudeController.text = widget.location.latitude.toString();
    _longitudeController.text = widget.location.longitude.toString();
    print(widget.location.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .90,
        width: MediaQuery.of(context).size.width * .92,
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
                  hinttext: 'Latitude', addcontroller: _latitudeController),
              customTextField(
                  hinttext: 'Longitude', addcontroller: _longitudeController),
              customTextField(hinttext: "Landmark", addcontroller: _landmark),
              customTextField(hinttext: "Pincode", addcontroller: _pincode),
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

                      GeoPoint dataForGeoPint = GeoPoint(
                          double.parse(_latitudeController.text),
                          double.parse(_longitudeController.text));

                      Map<String, dynamic> data = <String, dynamic>{
                        'address': _address.text,
                        'gender': _gender.text,
                        'name': _name.text,
                        'pincode': _pincode.text,
                        'location': dataForGeoPint,
                        'gym_id': _gymiid.text,
                        'gym_owner': _gymowner.text,
                        'landmark': _landmark.text
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
}
