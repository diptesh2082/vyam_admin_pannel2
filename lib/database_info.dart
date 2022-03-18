import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CollectionInfo extends StatefulWidget {
  const CollectionInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionInfo> createState() => _CollectionInfoState();
}

class _CollectionInfoState extends State<CollectionInfo> {
  @override
  void initState() {
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
          padding: EdgeInsets.symmetric(horizontal: 5),
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
                    // onTap: showAddbox,
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
                    stream: FirebaseFirestore.instance
                        .collection("user_details")
                        .snapshots(),
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
    return DataRow(cells: [
      DataCell(data != null ? Text(data['userId'] ?? "") : Text("")),
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
        // showEditbox(
        //   imageurl: 'url',
        //   address: data['address']!,
        //   gender: data['gender'],
        //   email: data['email'],
        //   latitude: data['lat'].toString(),
        //   longitude: data['long'].toString(),
        //   locality: data['locality'],
        //   number: data['number'],
        //   subLocality: data['subLocality'],
        //   userid: data['userId'],
        //   name: data['name'],
        //   pincode: data['pincode'],
        // );
        showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: EditBox(
                  // imageurl: 'url',
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
              );
            });
      }),
    ]);
  }

  // showAddbox() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
  //           content: SizedBox(
  //             height: 200,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Add Records',
  //                   style: TextStyle(
  //                       fontFamily: 'poppins',
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 14),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                   child: Card(
  //                       child: TextField(
  //                     autofocus: true,
  //                     style: const TextStyle(
  //                       fontSize: 14,
  //                       fontFamily: 'poppins',
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                     controller: _addaddress,
  //                     maxLines: 3,
  //                     decoration: const InputDecoration(
  //                         border: InputBorder.none,
  //                         hintStyle: TextStyle(
  //                           fontSize: 14,
  //                           fontFamily: 'poppins',
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                         hintMaxLines: 2,
  //                         hintText: 'Address'),
  //                   )),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                   child: Card(
  //                       child: TextField(
  //                     autofocus: true,
  //                     style: const TextStyle(
  //                       fontSize: 14,
  //                       fontFamily: 'Poppins',
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                     controller: _addgender,
  //                     maxLines: 3,
  //                     decoration: const InputDecoration(
  //                         border: InputBorder.none,
  //                         hintStyle: TextStyle(
  //                           fontSize: 14,
  //                           fontFamily: 'Poppins',
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                         hintMaxLines: 2,
  //                         hintText: 'Gender'),
  //                   )),
  //                 ),
  //                 const Center(
  //                   child: ElevatedButton(
  //                     onPressed: null,
  //                     /*() async {
  //
  //                           Map<String, dynamic> data1 = <String, dynamic>{
  //                             'address': add_address.text,
  //                             'gender': add_gender.text,
  //                             // 'gym_id': gymid
  //                           };
  //                           await FirebaseFirestore.instance
  //                               .collection('product_details')
  //                               .add(data1).whenComplete(() => print("Item Updated"))
  //                               .catchError((e) => print(e));
  //
  //
  //
  //                           Navigator.pop(context);
  //
  //                           /*FirebaseFirestore.instance
  //                               .collection('product_details')
  //                               .doc('RBRQKBuboUVvDAriCCVe')
  //                               .update(
  //                             {'address': address},
  //                           );*/
  //                         },*/
  //                     child: Text('Done'),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ));

  // showEditbox({
  //   required String? address,
  //   required String? gender,
  //   required String? email,
  //   required String? imageurl,
  //   required String? latitude,
  //   required String? longitude,
  //   required String? locality,
  //   required String? name,
  //   required String? number,
  //   required String? pincode,
  //   required String? subLocality,
  //   required String? userid,
  // }) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       print("Address of this user is : $address");
  //       // _address!.text = address!;
  //       // _gender!.text = gender!;
  //       // _email!.text = email!;
  //       // _latitude!.text = latitude.toString();
  //       // _longitude!.text = longitude.toString();
  //       // _locality!.text = locality!;
  //       // _number!.text = number!;
  //       // _name!.text = name!;
  //       // _pincode!.text = pincode!;
  //       // _sublocality!.text = subLocality!;
  //       // _userid!.text = userid!;
  //       //12
  //
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(30))),
  //         content: SizedBox(
  //           height: 480,
  //           width: 800,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Update Records for this doc',
  //                 style: TextStyle(
  //                     fontFamily: 'poppins',
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 14),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _userid,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Address'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _name,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Gender'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _email,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Gym ID'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _gender,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Gym Owner'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _number,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Landmark'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _locality,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Location'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _sublocality,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Gym Name'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _pincode,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Pincode'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _latitude,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Pincode'),
  //                 )),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 child: Card(
  //                     child: TextField(
  //                   autofocus: true,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   controller: _longitude,
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                       border: InputBorder.none,
  //                       hintStyle: TextStyle(
  //                         fontSize: 14,
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                       hintMaxLines: 2,
  //                       hintText: 'Pincode'),
  //                 )),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: Center(
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       print("/////");
  //
  //                       DocumentReference documentReference = FirebaseFirestore
  //                           .instance
  //                           .collection('user_details')
  //                           .doc('');
  //
  //                       Map<String, dynamic> data = <String, dynamic>{
  //                         'address': _address!.text,
  //                         'gender': _gender!.text,
  //                         'image': 'imageurl',
  //                         'lat': _latitude!.text,
  //                         'long': _longitude!.text,
  //                         'name': _name!.text,
  //                         'pincode': _pincode!.text,
  //                         'userId': _userid!.text,
  //                         'locality': _locality!.text,
  //                         'subLocality': _sublocality!.text,
  //                         'email': _email!.text,
  //                         'number': _number!.text,
  //                       };
  //                       await documentReference
  //                           .set(data)
  //                           .whenComplete(() => print("Item Updated"))
  //                           .catchError((e) => print(e));
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text('Done'),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    this.address,
    this.gender,
    this.email,
    // this.imageurl,
    // this.latitude,
    // this.longitude,
    this.locality,
    this.name,
    this.number,
    this.pincode,
    this.subLocality,
    this.userid,
  }) : super(key: key);

  final String? address;
  final String? gender;
  final String? email;
  // final String? imageurl;
  // final String? latitude;
  // final String? longitude;
  final String? locality;
  final String? name;
  final String? number;
  final String? pincode;
  final String? subLocality;
  final String? userid;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  TextEditingController? _address;
  TextEditingController? _gender;
  TextEditingController? _email;
  TextEditingController? _latitude;
  TextEditingController? _longitude;
  TextEditingController? _locality;
  TextEditingController? _name;
  TextEditingController? _number;
  TextEditingController? _pincode;
  TextEditingController? _sublocality;
  TextEditingController? _userid;
  @override
  void initState() {
    super.initState();
    print(widget.address);
    _address!.text = widget.address!;

    // _gender!.text = widget.gender!;
    // _email!.text = widget.email!;
    // // _latitude!.text = widget.latitude.toString();
    // // _longitude!.text = widget.longitude.toString();
    // _locality!.text = widget.locality!;
    // _number!.text = widget.number!;
    // _name!.text = widget.name!;
    // _pincode!.text = widget.pincode!;
    // _sublocality!.text = widget.subLocality!;
    // _userid!.text = widget.userid!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                      hintText: 'Address'),
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
                      hintText: 'Gym ID'),
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
                      hintText: 'Gym Owner'),
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
                      hintText: 'Landmark'),
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
                      hintText: 'Location'),
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
                      hintText: 'Gym Name'),
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
                  controller: _latitude,
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
                  controller: _longitude,
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");

                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('user_details')
                          .doc('');

                      Map<String, dynamic> data = <String, dynamic>{
                        'address': _address!.text,
                        'gender': _gender!.text,
                        'image': 'imageurl',
                        'lat': _latitude!.text,
                        'long': _longitude!.text,
                        'name': _name!.text,
                        'pincode': _pincode!.text,
                        'userId': _userid!.text,
                        'locality': _locality!.text,
                        'subLocality': _sublocality!.text,
                        'email': _email!.text,
                        'number': _number!.text,
                      };
                      await documentReference
                          .set(data)
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
