import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../services/CustomTextFieldClass.dart';

class CollectionInfo extends StatefulWidget {
  const CollectionInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionInfo> createState() => _CollectionInfoState();
}

class _CollectionInfoState extends State<CollectionInfo> {
  CollectionReference? userDetailStream;
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
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add User',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
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

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'UserId',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
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
                                  'Number',
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
                              DataColumn(
                                label: Text(
                                  'Sub Locality',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Pincode',
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
                              DataColumn(label: Text('')),
                              DataColumn(label: Text(''))
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
    String userIDData = data['userId'];

    return DataRow(cells: [
      DataCell(data != null ? Text(userIDData) : Text("")),
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['email'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gender'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['number'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['locality'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['subLocality'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['pincode'] ?? "") : Text("")),
      // DataCell(Text(data['lat'] ?? "")),
      // DataCell(Text(data['long'] ?? "")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                child: SingleChildScrollView(
                  child: EditBox(
                    imageurl: 'url',
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
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            });
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
  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: SizedBox(
              height: 480,
              width: 800,
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
                    customTextField(
                        hinttext: "UserID", addcontroller: _adduserid),
                    customTextField(hinttext: "Name", addcontroller: _addname),
                    customTextField(
                        hinttext: "Email", addcontroller: _addemail),
                    customTextField(
                        hinttext: "Gender", addcontroller: _addgender),
                    customTextField(
                        hinttext: "phone number", addcontroller: _addnumber),
                    customTextField(
                        hinttext: "Address", addcontroller: _addaddress),
                    customTextField(
                        hinttext: "Locality", addcontroller: _addlocality),
                    customTextField(
                        hinttext: "Sub Locality",
                        addcontroller: _addsublocality),
                    customTextField(
                      addcontroller: _addpincode,
                      hinttext: "Pincode",
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('user_details')
                              .doc(_addnumber.text)
                              .set(
                            {
                              'address': _addaddress.text,
                              'userId': _adduserid.text,
                              'name': _addname.text,
                              'email': _addemail.text,
                              'gender': _addgender.text,
                              'number': _addnumber.text,
                              'locality': _addlocality.text,
                              'subLocality': _addsublocality.text,
                              'pincode': _addpincode.text,
                              'long': " ",
                              'lat': " ",
                              'image': "image"
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
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
  @override
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        content: SizedBox(
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
                    controller: _locality,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        hintMaxLines: 2,
                        hintText: 'Locality'),
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
                    controller: _sublocality,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        hintMaxLines: 2,
                        hintText: 'Sub Locality'),
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("/////");

                        DocumentReference documentReference =
                            FirebaseFirestore.instance
                                .collection('user_details')
                                //change _number to _userid
                                .doc(_number.text);

                        Map<String, dynamic> data = <String, dynamic>{
                          'address': _address.text,
                          'gender': _gender.text,
                          'image': 'imageurl',
                          // 'lat': _latitude.text,
                          // 'long': _longitude.text,
                          'name': _name.text,
                          'pincode': _pincode.text,
                          'userId': _userid.text,
                          'locality': _locality.text,
                          'subLocality': _sublocality.text,
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
