import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/deleteMethod.dart';

class bookingNotification extends StatefulWidget {
  const bookingNotification({Key? key}) : super(key: key);

  @override
  State<bookingNotification> createState() => _bookingNotificationState();
}

class _bookingNotificationState extends State<bookingNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Booking Notifications"),
        ),
        backgroundColor: Colors.white10,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('booking_notifications')
                    .orderBy('time_stamp', descending: true)
                    .snapshots(),
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
                            'Name',
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
                            'Vendor Name\nVendor Branch',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Title',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date and Time',
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
                      rows: _buildlist(context, snapshot.data!.docs),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text("Previous Page"),
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      page.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.teal),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text("Next Page"),
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
        ));
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
    // String bookingId = data['notification_id'];

    String time =
        DateFormat("dd/MMM/yyyy, hh:mm a").format(data["time_stamp"].toDate());

    return DataRow(cells: [
      DataCell(
        Text(
          index.toString(),
        ),
      ),
      DataCell(
        data['user_name'] != null
            ? Text(data['user_name'].toString())
            : const Text(""),
      ),
      DataCell(
        data['user_id'] != null
            ? Text(data['user_id'].toString())
            : const Text(""),
      ),
      DataCell(
        data['vendor_name'] != null
            ? Text("${data['vendor_name'].toString()}\n${data["branch"]}")
            : const Text(""),
      ),
      DataCell(
        data['title'] != null ? Text(data['title'].toString()) : const Text(""),
      ),
      DataCell(
        data['status'] != null
            ? Text(data['status'].toString())
            : const Text(""),
      ),
      DataCell(
        data['time_stamp'] != null ? Text(time) : const Text(""),
      ),
      DataCell(const Icon(Icons.delete), onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: SizedBox(
              height: 170,
              width: 280,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Do you want to delete?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteMethod(
                                  stream: FirebaseFirestore.instance
                                      .collection('booking_notifications'),
                                  uniqueDocId: data.id);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Yes'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('No'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      })
    ]);
  }
}
