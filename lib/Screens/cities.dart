import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/deleteMethod.dart';

class AmenetiesScreen extends StatefulWidget {
  const AmenetiesScreen({Key? key}) : super(key: key);

  @override
  State<AmenetiesScreen> createState() => _AmenetiesScreenState();
}

class _AmenetiesScreenState extends State<AmenetiesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('amenities').snapshots(),
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
                    'Index',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Images',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Edit',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(label: Text(''))
              ],
              rows: _buildlist(context, snapshot.data!.docs),
            ),
          );
        },
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
    return DataRow(
      cells: [
        DataCell(
          data['id'] != null ? Text(data['id'] ?? "") : const Text(""),
        ),
        DataCell(
          data['image'] != null
              ? Image.network(
                  data['image'] ?? "",
                  scale: 0.5,
                  height: 150,
                  width: 150,
                )
              : const Text(""),
        ),
        DataCell(
          data['name'] != null ? Text(data['name']) : const Text("Disabled"),
        ),
        DataCell(
          const Text(''),
          showEditIcon: true,
          onTap: () {
            print("Open Edit Box");
          },
        ),
        DataCell(const Icon(Icons.delete), onTap: () {
          //   deleteMethod(stream: FirebaseFirestore.instance.collection('amenities') , uniqueDocId: );
        })
      ],
    );
  }
}
