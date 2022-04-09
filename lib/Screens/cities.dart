import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AmenetiesScreen extends StatefulWidget {
  const AmenetiesScreen({Key? key}) : super(key: key);

  @override
  State<AmenetiesScreen> createState() => _AmenetiesScreenState();
}

class _AmenetiesScreenState extends State<AmenetiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('amenities').snapshots(),
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
                    'Images',
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
                    'Edit',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              rows: _buildlist(context, snapshot.data!.docs),
              // rows: const [],
            ),
          );
        },
      ),
    );
  }
}

List<DataRow> _buildlist(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return snapshot.map((data) => _buildListItem(context, data)).toList();
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
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
        data['name'] == true ? Text(data['name']) : const Text("Disabled"),
      ),
      DataCell(
        const Text(''),
        showEditIcon: true,
        onTap: () {
          print("Open Edit Box");
        },
      )
    ],
  );
}
