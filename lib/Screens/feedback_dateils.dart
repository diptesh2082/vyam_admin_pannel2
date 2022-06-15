import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedBackInfo extends StatefulWidget {
  const FeedBackInfo({Key? key}) : super(key: key);

  @override
  State<FeedBackInfo> createState() => _FeedBackInfoState();
}

class _FeedBackInfoState extends State<FeedBackInfo> {
  CollectionReference? categoryStream;
  CollectionReference? vendorStream;
  String searchGymName = '';

  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('Feedback');
    vendorStream = FirebaseFirestore.instance.collection('product_details');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                stream: categoryStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return Container();
                  }
                  var doc = snapshot.data.docs;

// <<<<<<< HEAD
                  if (searchGymName.length > 0) {
                    doc = doc.where((element) {
                      return element
                              .get('feedback_review')
                              .toString()
                              .toLowerCase()
                              .contains(searchGymName.toString()) ||
                          element
                              .get('vendor_id')
                              .toString()
                              .toLowerCase()
                              .contains(searchGymName.toString()) ||
                          element
                              .get('feedback_suggestion')
                              .toString()
                              .toLowerCase()
                              .contains(searchGymName.toString());
                    }).toList();
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowHeight: 65,
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Index',
// =======
//                 if (searchGymName.length > 0) {
//                   doc = doc.where((element) {
//                     return element
//                         .get('feedback_review')
//                         .toString()
//                         .toLowerCase()
//                         .contains(searchGymName.toString()) ||
//                         element
//                             .get('vendor_id')
//                             .toString()
//                             .toLowerCase()
//                             .contains(searchGymName.toString()) ||
//                         element
//                             .get('feedback_suggestion')
//                             .toString()
//                             .toLowerCase()
//                             .contains(searchGymName.toString());
//                   }).toList();
//                 }

// <<<<<<< someshwar
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: DataTable(
//                     dataRowHeight: 65,
//                     columns: const [
//                       DataColumn(
// =======
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     dataRowHeight: 65,
//                     columns: const [
//                       DataColumn(
//                           label: Text(
//                             'Index',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           )),
//                       DataColumn(
//                         label: Text(
//                           'Name',
// >>>>>>> 05d90541ad53debf68ad8405091343fc5d3a8558
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                        DataColumn(
// >>>>>>> Diptesh
                          label: Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Phone Number',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Images',
                        //     style: TextStyle(fontWeight: FontWeight.w600),
                        //   ),
                        // ),
                        DataColumn(
                          label: Text(
                            'GYMID',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Feedback Review Title',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Feedback Suggestion',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Edit',
                        //     style: TextStyle(fontWeight: FontWeight.w600),
                        //   ),
                        // ),
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
                      if (start > 0 && end > 0) {
                        start = start - 10;
                        end = end - 10;
                      }
                    });
                    print("Previous Page");
                  },
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text("Next Page"),
                  onPressed: () {
                    setState(() {
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
    );
  }

  var start = 0;

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
    String categoryID = data['feedback_id'];
    return DataRow(
      cells: [
        DataCell(data != null ? Text(index.toString()) : const Text("")),
        DataCell(
          data['feedback_name'] != null
              ? Text(data['feedback_name'] ?? "")
              : const Text(""),
        ),
        DataCell(data['user_id'] != null
            ? Text(data['user_id'].toString().substring(3, 13))
            : Text("")),
        DataCell(
          data['vendor_id'] != null
              ? Text(data['vendor_id'] ?? "")
              : const Text(""),
        ),
        DataCell(
          data['feedback_review'] != null
              ? Text(data['feedback_review'] ?? "")
              : const Text(""),
        ),
        DataCell(
          data['feedback_suggestion'] != null
              ? Text(data['feedback_suggestion'] ?? "")
              : const Text(""),
        ),
        // DataCell(
        //   data['image'] != null
        //       ? Image.network(
        //     data['image'] ?? "",
        //     scale: 0.5,
        //     height: 150,
        //     width: 150,
        //   )
        //       : const Text(""),
        // ),
        // DataCell(
        //   data['status'] == true
        //       ? const Text("Enabled")
        //       : const Text("Disabled"),
        // ),
        // DataCell(
        //   const Text(''),
        //   showEditIcon: true,
        //   onTap: () {
        //     print("Open Edit Box");
        //   },
        // ),
        DataCell(Icon(Icons.delete), onTap: () {
          deleteMethod(stream: categoryStream, uniqueDocId: categoryID);
        })
      ],
    );
  }
}
