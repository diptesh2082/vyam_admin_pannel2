import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedBackInfo extends StatefulWidget {
  const FeedBackInfo({Key? key}) : super(key: key);

  @override
  State<FeedBackInfo> createState() => _FeedBackInfoState();
}

class _FeedBackInfoState extends State<FeedBackInfo> {
  CollectionReference? categoryStream;

  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('Feedback');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: categoryStream!.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data == null) {
            return Container();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 65,
              columns: const [
                DataColumn(
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
              rows: _buildlist(context, snapshot.data!.docs),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String categoryID = data['feedback_id'];
    return DataRow(
      cells: [
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
