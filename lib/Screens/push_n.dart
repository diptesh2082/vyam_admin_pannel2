import 'package:admin_panel_vyam/Screens/push_new_screen.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:admin_panel_vyam/services/image_picker_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class Push extends StatefulWidget {
  const Push({
    Key? key,
  }) : super(key: key);

  @override
  State<Push> createState() => _PushState();
}

class _PushState extends State<Push> {
  CollectionReference? pushStream;
  @override
  void initState() {
    pushStream = FirebaseFirestore.instance.collection("push_notifications");
    super.initState();
  }

  var id = FirebaseFirestore.instance
      .collection('push_notifications')
      .doc()
      .id
      .toString();

  var millis, dt, d12, image;

  date() {
    millis = Timestamp.now().millisecondsSinceEpoch;
    dt = DateTime.fromMillisecondsSinceEpoch(millis);

    d12 = DateFormat('dd/MMM/yyyy, hh:mm a').format(dt);
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Get.to(() => const pushNew());
                    },
                    child: Text('Add Push Notification'),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: pushStream!.snapshots(),
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
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Definitions',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timestamp',
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
    String pushIdData = data['id'];
    return DataRow(cells: [
      DataCell(
          data['title'] != null ? Text(data['title'] ?? "") : const Text("")),
      DataCell(data['definition'] != null
          ? Text(data['definition'] ?? "")
          : const Text("")),
      DataCell(data['id'] != null ? Text(data['id'] ?? "") : const Text("")),
      DataCell(data['timestamp'] != null
          ? Text(data['timestamp'] ?? "")
          : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Get.to(() => ProductEditBox(
            title: data['title'],
            definition: data['definition'],
            id: data['id'],
            timestamp: data['timestamp'],
            image: data['image']));
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: pushStream, uniqueDocId: pushIdData);
      }),
    ]);
  }

  final TextEditingController _addtitle = TextEditingController();
  final TextEditingController _adddefiniton = TextEditingController();
  // var id = FirebaseFirestore.instance
  //     .collection('push_notifications')
  //     .doc()
  //     .id
  //     .toString();

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
  //                   customTextField(
  //                       hinttext: "Title", addcontroller: _addtitle),
  //                   customTextField(
  //                       hinttext: "Definition", addcontroller: _adddefiniton),
  //                   Container(
  //                     padding: EdgeInsets.all(20),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           'Upload Image: ',
  //                           style: TextStyle(
  //                               color: Colors.grey,
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 15),
  //                         ),
  //                         SizedBox(
  //                           width: 20,
  //                         ),
  //                         InkWell(
  //                           onTap: () async {
  //                             image = await chooseImage();
  //                           },
  //                           child: Icon(
  //                             Icons.upload_file_outlined,
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   // Text(
  //                   //   '$timestamp',
  //                   // ),
  //                   // customTextField(
  //                   //     hinttext: "Discount", addcontroller: _adddiscount),
  //                   // customTextField(
  //                   //     hinttext: "Title", addcontroller: _addtitle),
  //                   Center(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         date();
  //                         await matchID(
  //                             newId: id,
  //                             matchStream: pushStream,
  //                             idField: 'id');
  //                         await FirebaseFirestore.instance
  //                             .collection('push_notifications')
  //                             .doc(id)
  //                             .set(
  //                           {
  //                             'title': _addtitle.text,
  //                             'definition': _adddefiniton.text,
  //                             // 'image': ,
  //                             'id': id,
  //                             'timestamp': d12,
  //                           },
  //                         ).then((snapshot) async {
  //                           await uploadImageToPush(image, id);
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

class ProductEditBox extends StatefulWidget {
  const ProductEditBox(
      {Key? key,
      required this.title,
      required this.definition,
      required this.id,
      required this.timestamp,
      required this.image})
      : super(key: key);

  final String definition;
  final String id;
  final String timestamp;
  final String image;
  final String title;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _definition = TextEditingController();
  late final String image;
  late final String timestamp;
  late final String id;
  var millis, dt, d12;

  date() {
    millis = Timestamp.now().millisecondsSinceEpoch;
    dt = DateTime.fromMillisecondsSinceEpoch(millis);

    d12 = DateFormat('dd/MMM/yyyy, hh:mm a').format(dt);
  }

  @override
  void initState() {
    super.initState();
    _title.text = widget.title;
    _definition.text = widget.definition;
    image = widget.image;
    id = widget.id;
    timestamp = widget.timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Edit Push Notification'),
      ),
      body: SingleChildScrollView(
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
            customTextField(hinttext: "Title", addcontroller: _title),
            customTextField(
                hinttext: "Description", addcontroller: _definition),
            //
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    date();
                    print("/////");
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('push_notifications')
                        .doc(widget.id);
                    Map<String, dynamic> data = <String, dynamic>{
                      'title': _title.text,
                      'definition': _definition.text,
                      'image': image,
                      'timestamp': d12,
                      'id': id,
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
    );
  }
}
