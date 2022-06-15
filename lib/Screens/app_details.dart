import 'package:admin_panel_vyam/Screens/add_app_details.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class appDetails extends StatefulWidget {
  const appDetails({Key? key}) : super(key: key);

  @override
  State<appDetails> createState() => _appDetailsState();
}

class _appDetailsState extends State<appDetails> {
  CollectionReference? appdetailStream;
  final Id =
      FirebaseFirestore.instance.collection('app details').doc().id.toString();

  @override
  void initState() {
    appdetailStream = FirebaseFirestore.instance.collection('app details');
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
            borderRadius: BorderRadius.circular(20.0),
          ),
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
                        Get.to(const addappdetail()); //showAddbox,
                      },
                      child: Text('Add Question')),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: appdetailStream?.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      var doc = snapshot.data.docs;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // dataRowHeight: 75.0,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'ID',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              'Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
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
                          rows: _buildlist(context, doc),
                        ),
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
    var d = 1;
    return snapshot.map((data) => _buildListItem(context, data, d++)).toList();
  }

  DataRow _buildListItem(
      BuildContext context, DocumentSnapshot data, int index) {
    return DataRow(
      cells: [
        DataCell(data != null ? Text(index.toString()) : const Text("")),
        // DataCell(
        //   data['id'] != null
        //       ? SizedBox(
        //           width: 100.0,
        //           child: Text(data['id'] ?? ""),
        //         )
        //       : const Text(""),
        // ),
        DataCell(
          data['details'] != null
              ? SizedBox(
                  width: 100.0,
                  child: Text(data['details'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(const Text(''), showEditIcon: true, onTap: () {
          Get.to(
            () => appDetailEditBox(
              details: data['details'],
              Id: data['id'],
            ),
          );
          onTap:
          () {
            Navigator.pop(context);
          };
        }),
        DataCell(
          Icon(Icons.delete),
          onTap: () {
            deleteMethod(stream: appdetailStream, uniqueDocId: Id);
          },
        ),
      ],
    );
  }
}

class appDetailEditBox extends StatefulWidget {
  const appDetailEditBox({
    Key? key,
    required this.details,
    required this.Id,
  }) : super(key: key);

  final String details;
  final String Id;

  @override
  State<appDetailEditBox> createState() => _appDetailEditBoxState();
}

class _appDetailEditBoxState extends State<appDetailEditBox> {
  final TextEditingController _details = TextEditingController();

  @override
  void initState() {
    super.initState();
    _details.text = widget.details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit cancelation questions"),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Records for this doc',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
              customTextField(hinttext: "Details", addcontroller: _details),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");
                      print('${widget.Id}');

                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('app details')
                          .doc(widget.Id);
                      Map<String, dynamic> data = {
                        'details': _details.text,
                      };
                      await FirebaseFirestore.instance
                          .collection('app details')
                          .doc(widget.Id)
                          .update(data);
                      print("after");
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
