

import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelationPage extends StatefulWidget {
  const CancelationPage({Key? key}) : super(key: key);

  @override
  State<CancelationPage> createState() => _CancelationPageState();
}

class _CancelationPageState extends State<CancelationPage> {
  CollectionReference? cancellationStream;
  final Id = FirebaseFirestore.instance
      .collection('Cancellation Data')
      .doc()
      .id
      .toString();

  String searchGymName = '';

  @override
  void initState() {
    cancellationStream =
        FirebaseFirestore.instance.collection("Cancellation Data");
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
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: cancellationStream?.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      var doc = snapshot.data.docs;

                      if (searchGymName.length > 0) {
                        doc = doc.where((element) {
                          return element
                                  .get('cancel_choice')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchGymName.toString()) ||
                              element
                                  .get('user_name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchGymName.toString()) ||
                              element
                                  .get('cancel_remark')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchGymName.toString());
                        }).toList();
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // dataRowHeight: 75.0,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Index',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                              label: Text(
                                'Booking ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'User Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Vendor ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Vendor Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Phone number',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Cancel Choice',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Cancel Remark',
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
                          rows: _buildlist(context, doc),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Previous Page"),
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
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        page.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Next Page"),
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
    String Id = data.id;
    return DataRow(
      cells: [
        DataCell(data != null ? Text(index.toString()) : const Text("")),
        DataCell(
          data['booking_id'] != null
              ? SizedBox(
                  width: 100.0,
                  child: Text(data['booking_id'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['user_name'] != null
              ? SizedBox(
                  width: 100.0,
                  child: Text(data['user_name'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['vendor_id'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['cancel_remark'],
                  ),
                )
              : const Text(""),
        ),
        DataCell(
          data['vendor_name'] != null
              ? SizedBox(
                  width: 100.0,
                  child: Text(data['vendor_name'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['user_number'] != null
              ? SizedBox(
                  width: 100.0,
                  child: Text(data['user_number'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['cancel_choice'] != null
              ? SizedBox(
                  width: 400.0,
                  child: Text(data['cancel_choice'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['cancel_remark'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['cancel_remark'],
                  ),
                )
              : const Text(""),
        ),
        DataCell(
          const Text(''),
          showEditIcon: true,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    child: SingleChildScrollView(
                      child: CancelationEditBox(
                        user_name: data['user_name'],
                        user_number: data['user_number'],
                        cancel_choice: data['cancel_choice'],
                        cancel_remark: data['cancel_remark'],
                        Id: data['Id'],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                });
          },
        ),
        DataCell(
          Icon(Icons.delete),
          onTap: () {
            deleteMethod(stream: cancellationStream, uniqueDocId: Id);
          },
        ),
      ],
    );
  }
}

class CancelationEditBox extends StatefulWidget {
  const CancelationEditBox({
    Key? key,
    required this.Id,
    required this.cancel_choice,
    required this.cancel_remark,
    required this.user_name,
    required this.user_number,
  }) : super(key: key);

  final String cancel_choice;
  final String cancel_remark;
  final String Id;
  final String user_name;
  final String user_number;

  @override
  State<CancelationEditBox> createState() => _CancelationEditBoxState();
}

class _CancelationEditBoxState extends State<CancelationEditBox> {
  final TextEditingController _cancel_choice = TextEditingController();
  final TextEditingController _cancel_remark = TextEditingController();
  final TextEditingController _user_name = TextEditingController();
  final TextEditingController _user_number = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user_name.text = widget.user_name;
    _user_number.text = widget.user_number;
    _cancel_choice.text = widget.cancel_choice;
    _cancel_remark.text = widget.cancel_remark;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        // height: 580,
        // width: 800,
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
                  controller: _user_name,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'User Name'),
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
                  controller: _user_number,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'Phone number'),
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
                  controller: _cancel_choice,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'Question'),
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
                  controller: _cancel_remark,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'Answer'),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");
                      print('${widget.Id}');

                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('Cancellation Data')
                          .doc(widget.Id);
                      Map<String, dynamic> data = {
                        'user_name': _user_name.text,
                        'user_number': _user_number.text,
                        'cancel_choice': _cancel_choice.text,
                        'cancel_remark': _cancel_remark.text,
                      };
                      await FirebaseFirestore.instance
                          .collection('Cancellation Data')
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
