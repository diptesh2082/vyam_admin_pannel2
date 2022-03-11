import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CollectionInfo extends StatefulWidget {
  //const CollectionInfo({Key? key}) : super(key: key);
  //final GlobalKey<ScaffoldState> scaffoldState;

  const CollectionInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionInfo> createState() => _CollectionInfoState();
}

class _CollectionInfoState extends State<CollectionInfo> {
  TextEditingController address = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController gymid = TextEditingController();
  TextEditingController add_address = TextEditingController();
  TextEditingController add_gender = TextEditingController();
  TextEditingController gymowner = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController gymname = TextEditingController();
  TextEditingController pincode = TextEditingController();
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 50.0, left: 180, right: 60, bottom: 50),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.amber.shade300,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add),
                      GestureDetector(
                        child: Text('Add User'),
                        onTap: showEditbox,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("product_details")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return DataTable(columns: const [
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Gender')),
                        DataColumn(label: Text('Gym ID')),
                        DataColumn(label: Text('Gym Owner')),
                        DataColumn(label: Text('Landmark')),
                        DataColumn(label: Text('Location')),
                        DataColumn(label: Text('Gym Name')),
                        DataColumn(label: Text('Pincode')),
                        DataColumn(label: Text(''))
                      ], rows: _buildlist(context, snapshot.data!.docs));
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
      DataCell(Text(data['address'])),
      DataCell(Text(data['gender'])),
      DataCell(Text(data['gym_id'])),
      DataCell(Text(data['gym_owner'])),
      DataCell(Text(data['landmark'])),
      DataCell(Text(data['location'].toString())),
      DataCell(Text(data['name'])),
      DataCell(Text(data['pincode'].toString())),
      DataCell(const Text(""), showEditIcon: true, onTap: showEditbox),
    ]);
  }

  Future showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: Container(
              height: 200,
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
                  SizedBox(
                    height: 50,
                    child: Card(
                        child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      controller: add_address,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
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
                      controller: add_gender,
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
                 const Center(
                      child: ElevatedButton(
                          onPressed: null,
                          /*() async {
                           
                            Map<String, dynamic> data1 = <String, dynamic>{
                              'address': add_address.text,
                              'gender': add_gender.text,
                              // 'gym_id': gymid
                            };
                            await FirebaseFirestore.instance
                                .collection('product_details')
                                .add(data1).whenComplete(() => print("Item Updated"))
                                .catchError((e) => print(e));

                            
                                
                            Navigator.pop(context);

                            /*FirebaseFirestore.instance
                                .collection('product_details')
                                .doc('RBRQKBuboUVvDAriCCVe')
                                .set(
                              {'address': address},
                            );*/
                          },*/
                          child: Text('Done')))
                ],
              ),
            ),
          ));

  Future showEditbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: Container(
              height: 480,
              width: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Records',
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
                      controller: address,
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
                      controller: gender,
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
                      controller: gymid,
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
                      controller: gymowner,
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
                      controller: landmark,
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
                      controller: location,
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
                      controller: gymname,
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
                      controller: pincode,
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
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('product_details')
                                      .doc('RBRQKBuboUVvDAriCCVe');

                              Map<String, dynamic> data = <String, dynamic>{
                                'address': address.text,
                                'gender': gender.text,
                                'gym_id': gymid.text,
                                'gym_owner': gymowner.text,
                                'landmark': landmark.text,
                                'location': location.text,
                                'name': gymname.text,
                                'pincode': pincode.text,
                              };
                              await documentReference
                                  .set(data)
                                  .whenComplete(() => print("Item Updated"))
                                  .catchError((e) => print(e));
                              Navigator.pop(context);

                              /*FirebaseFirestore.instance
                                  .collection('product_details')
                                  .doc('RBRQKBuboUVvDAriCCVe')
                                  .set(
                                {'address': address},
                              );*/
                            },
                            child: Text('Done'))),
                  )
                ],
              ),
            ),
          ));
}

   /* InkWell(
            child: Text('Add User'),
            onTap: () {
              showaddbox();
              Map<String, dynamic> data = <String, dynamic>{
                'address': address1.text,
                'gender': gender1.text,
                // 'gym_id': gymid
              };
              FirebaseFirestore.instance
                  .collection('product_details')
                  .add(data);
            },
          ),
      */
