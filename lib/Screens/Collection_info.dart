import 'dart:io';

import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/CustomTextFieldClass.dart';
import '../services/image_picker_api.dart';
import 'package:path/path.dart' as Path;

class UserInformation extends StatefulWidget {
  const UserInformation({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  CollectionReference? userDetailStream;
  String searchUser = ' ';
  @override
  void initState() {
    userDetailStream = FirebaseFirestore.instance.collection("user_details");
    super.initState();
    // _address = TextEditingController();
    // _pincode = TextEditingController();
    // _gender = TextEditingController();
    // _gymid = TextEditingController();
    // _addaddress = TextEditingController();
    // _addgender = TextEditingController();
    // _gymowner = TextEditingController();
  }

  @override
  var xs = "Yes";
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => detailsadd()));
                    },
                    child: Text('Add User'),
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
                            searchUser = value.toString();
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
                    stream: userDetailStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      var doc = snapshot.data.docs;

                      if (searchUser.length > 0) {
                        doc = doc.where((element) {
                          return element
                                  .get('name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString()) ||
                              element
                                  .get('gender')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString()) ||
                              element
                                  .get('address')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString());
                        }).toList();
                      }

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Profile Image',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //     label: Text(
                              //   'UserId',
                              //   style: TextStyle(fontWeight: FontWeight.w600),
                              // )),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
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
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Locality',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Sub Locality',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Pincode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validity of User',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              // DataColumn(
                              //   label: Text(
                              //     'Latitude',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'Longitude',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
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
                              )
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

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String userIDData = data['userId'];
    String profileImage = data['image'];
    bool legit = data['legit'];

    return DataRow(cells: [
      DataCell(
        profileImage != "null" || profileImage != null
            ? CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: profileImage,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            : const CircleAvatar(
                backgroundColor: Colors.black,
                child: Text('Null'),
              ),
      ),
      // DataCell(data != null ? Text(userIDData) : Text("")),
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['email'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gender'] ?? "") : Text("")),
      DataCell(data != null
          ? Text((data['number']).toString().substring(3, 13))
          : Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['locality'] ?? "") : Text("")),
      // DataCell(data != null ? Text(data['subLocality'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['pincode'] ?? "") : Text("")),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = legit;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('user_details')
                  .doc(userIDData);
              await documentReference
                  .update({'legit': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(legit ? "Yes" : "No"),
            style: ElevatedButton.styleFrom(
                primary: legit ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (conext) => EditBox(
                imageurl: data['image'],
                address: data['address'],
                gender: data['gender'],
                email: data['email'],
                // latitude: data['lat'].toString(),
                // longitude: data['long'].toString(),
                locality: data['locality'],
                number: data['number'],
                subLocality: data['subLocality'],
                userid: data['userId'],
                name: data['name'],
                pincode: data['pincode'],
              ),
            ));
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: userDetailStream, uniqueDocId: userIDData);
      }),
    ]);
  }

  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addemail = TextEditingController();
  // final TextEditingController _addlatitude = TextEditingController();
  // final TextEditingController _addlongitude = TextEditingController();
  final TextEditingController _addlocality = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addnumber = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addsublocality = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();
  var profileImage;
  // showAddbox() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
  //           content: SizedBox(
  //             height: 480,
  //             width: 800,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'Add Records',
  //                     style: TextStyle(
  //                         fontFamily: 'poppins',
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14),
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Text("User Image"),
  //
  //                       IconButton(
  //                           onPressed: () async {
  //                             profileImage = await chooseImage();
  //                           },
  //                           icon: const Icon(Icons.camera_alt)),
  //                       // if(profileImage != null)
  //                       // Image.file();
  //                     ],
  //                   ),
  //                   customTextField(
  //                       hinttext: "phone number", addcontroller: _addnumber),
  //                   // customTextField(
  //                   //
  //                   //     hinttext: "UserID", addcontroller: _adduserid),
  //                   customTextField(hinttext: "Name", addcontroller: _addname),
  //                   customTextField(
  //                       hinttext: "Email", addcontroller: _addemail),
  //                   customTextField(
  //                       hinttext: "Gender", addcontroller: _addgender),
  //
  //                   customTextField(
  //                       hinttext: "Address", addcontroller: _addaddress),
  //                   customTextField(
  //                       hinttext: "Locality", addcontroller: _addlocality),
  //                   customTextField(
  //                       hinttext: "Sub Locality",
  //                       addcontroller: _addsublocality),
  //                   customTextField(
  //                     addcontroller: _addpincode,
  //                     hinttext: "Pincode",
  //                   ),
  //                   Center(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         FirebaseFirestore.instance
  //                             .collection('user_details')
  //                             .doc("+91${_addnumber.text}")
  //                             .set(
  //                           {
  //                             'address': _addaddress.text,
  //                             'userId': "+91${_addnumber.text}",
  //                             'name': _addname.text,
  //                             'email': _addemail.text,
  //                             'gender': _addgender.text,
  //                             'number': "+91${_addnumber.text}",
  //                             'locality': _addlocality.text,
  //                             'subLocality': _addsublocality.text,
  //                             'pincode': _addpincode.text,
  //                             'long': " ",
  //                             'lat': " ",
  //                             'image': ""
  //                           },
  //                         ).then((value) async {
  //                           await uploadImageToUser(
  //                               profileImage, "+91${_addnumber.text}");
  //                         });
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Text('Done'),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ));
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    required this.address,
    required this.gender,
    required this.email,
    required this.imageurl,
    // required this.latitude,
    // required this.longitude,
    required this.locality,
    required this.name,
    required this.number,
    required this.pincode,
    required this.subLocality,
    required this.userid,
  }) : super(key: key);

  final String address;
  final String gender;
  final String email;
  final String imageurl;
  // final String latitude;
  // final String longitude;
  final String locality;
  final String name;
  final String number;
  final String pincode;
  final String subLocality;
  final String userid;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  TextEditingController _address = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _email = TextEditingController();
  // TextEditingController _latitude = TextEditingController();
  // TextEditingController _longitude = TextEditingController();
  TextEditingController _locality = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _sublocality = TextEditingController();
  TextEditingController _userid = TextEditingController();
  var imgUrl1;
  var img;
  @override
  var x;
  void initState() {
    super.initState();
    print(widget.address);
    _address.text = widget.address;
    _gender.text = widget.gender;
    _email.text = widget.email;
    // _latitude.text = widget.latitude.toString();
    // _longitude.text = widget.longitude.toString();
    _locality.text = widget.locality;
    _number.text = widget.number;
    _name.text = widget.name;
    _pincode.text = widget.pincode;
    _sublocality.text = widget.subLocality;
    _userid.text = widget.userid;
    x = widget.number;
    img = widget.imageurl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit User Details'),
          ),
          backgroundColor: Colors.white10,
          body: Container(
            padding: EdgeInsets.all(20),
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
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _userid,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'UserID'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _name,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Name'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _email,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'email'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _gender,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gender'),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _number,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Phone Number'),
                    )),
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: Card(
                  //       child: TextField(
                  //     autofocus: true,
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     controller: _locality,
                  //     maxLines: 3,
                  //     decoration: const InputDecoration(
                  //         border: InputBorder.none,
                  //         hintStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //         hintMaxLines: 2,
                  //         hintText: 'Locality'),
                  //   )),
                  // ),
                  // SizedBox(
                  //   height: 50,
                  //   child: Card(
                  //       child: TextField(
                  //     autofocus: true,
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     controller: _sublocality,
                  //     maxLines: 3,
                  //     decoration: const InputDecoration(
                  //         border: InputBorder.none,
                  //         hintStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //         hintMaxLines: 2,
                  //         hintText: 'Sub Locality'),
                  //   )),
                  // ),
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _pincode,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Pincode'),
                    )),
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: Card(
                  //       child: TextField(
                  //     autofocus: true,
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     controller: _latitude,
                  //     maxLines: 3,
                  //     decoration: const InputDecoration(
                  //         border: InputBorder.none,
                  //         hintStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //         hintMaxLines: 2,
                  //         hintText: 'Latitude'),
                  //   )),
                  // ),
                  // SizedBox(
                  //   height: 50,
                  //   child: Card(
                  //       child: TextField(
                  //     autofocus: true,
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     controller: _longitude,
                  //     maxLines: 3,
                  //     decoration: const InputDecoration(
                  //         border: InputBorder.none,
                  //         hintStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //         hintMaxLines: 2,
                  //         hintText: 'Longitude'),
                  //   )),
                  // ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      img = await chooseImage();
                      await getUrlImage(img);
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

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print("/////");

                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('user_details')
                                    //change _number to _userid
                                    .doc("${x}");

                            Map<String, dynamic> data = <String, dynamic>{
                              // 'address': _address.text,
                              'gender': _gender.text,
                              'image': imgUrl1,
                              // 'lat': _latitude.text,
                              // 'long': _longitude.text,
                              'name': _name.text,
                              'pincode': _pincode.text,
                              'userId': _userid.text,

                              'locality': "",
                              'subLocality': "",

                              'email': _email.text,
                              'number': _number.text,
                            };
                            await documentReference
                                .update(data)
                                .whenComplete(() => print("Item Updated"))
                                .catchError((e) => print(e));
                            Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance.ref().child("category");

      Reference _reference =
          _firebaseStorage.child('category/${Path.basename(pickedFile!.path)}');
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

class detailsadd extends StatefulWidget {
  const detailsadd({Key? key}) : super(key: key);

  @override
  State<detailsadd> createState() => _detailsaddState();
}

class _detailsaddState extends State<detailsadd> {
  final TextEditingController _addaddress = TextEditingController();
  // final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addemail = TextEditingController();
  // final TextEditingController _addlatitude = TextEditingController();
  // final TextEditingController _addlongitude = TextEditingController();
  final TextEditingController _addlocality = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addnumber = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addsublocality = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();
  var profileImage;
  String gender = "Male";
  var imgUrl1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Add User Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
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
              Row(
                children: [
                  const Text(
                    "User Image",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    child: Icon(Icons.camera_alt),
                    onTap: () async {
                      profileImage = await chooseImage();
                      getUrlImage(profileImage);
                    },
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
              customTextField(
                  hinttext: "Contact Number", addcontroller: _addnumber),
              // customTextField(
              //
              //     hinttext: "UserID", addcontroller: _adduserid),
              customTextField(hinttext: "Name", addcontroller: _addname),
              customTextField(hinttext: "Email", addcontroller: _addemail),
              Row(
                children: [
                  Text(
                    "Gender: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                      value: gender,
                      items: const [
                        DropdownMenuItem(
                          child: Text("Male"),
                          value: "Male",
                        ),
                        DropdownMenuItem(
                          child: Text("Female"),
                          value: "Female",
                        ),
                        DropdownMenuItem(
                            child: Text("Unisex"), value: "Unisex"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          gender = value as String;
                        });
                      }),
                ],
              ),
              // customTextField(hinttext: "Gender", addcontroller: _addgender),

              customTextField(hinttext: "Address", addcontroller: _addaddress),

              // customTextField(
              //     hinttext: "Locality", addcontroller: _addlocality),
              // customTextField(
              //     hinttext: "Sub Locality", addcontroller: _addsublocality),
              customTextField(
                addcontroller: _addpincode,
                hinttext: "Pincode",
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('user_details')
                          .doc("+91${_addnumber.text}")
                          .set(
                        {
                          'address': "",
                          'userId': "+91${_addnumber.text}",
                          'name': _addname.text,
                          'email': _addemail.text,
                          'gender': gender,
                          'image': imgUrl1,
                          'number': "+91${_addnumber.text}",

                          'locality': "",
                          'subLocality': "",

                          'pincode': _addpincode.text,
                          'long': " ",
                          'lat': " ",
                          'legit': true
                          // 'image': ""
                        },
                      );
                      //     .then((value) async {
                      //   await uploadImageToUser(
                      //       profileImage, "+91${_addnumber.text}");
                      // });
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close')),
                ],
              ),
            ],
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
