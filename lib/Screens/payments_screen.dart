import 'package:admin_panel_vyam/services/maps_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Product Details/Packages/Extra_package.dart';
import 'Product Details/Packages/packages.dart';
import 'Product Details/Trainers/Trainers.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
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
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: GestureDetector(
                    onTap: showAddbox,
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add Product',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("payment")
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
                            // ? DATATABLE
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Amount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Place',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Timestamp',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(label: Text('')), //! For edit pencil
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
    Timestamp timestamp = data['timestamp'];
    String stamp = timestamp.toString();
    return DataRow(cells: [
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['amount'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['place'] ?? "") : Text("")),
      DataCell(data != null ? Text(stamp) : Text("")),
      // DataCell(
      //   const Text(""),
      //   showEditIcon: true,
      //   onTap: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return GestureDetector(
      //           // ? Added Gesture Detecter for popping off update record Card
      //           child: SingleChildScrollView(
      //             child: ProductEditBox(
      //               address: data['address'],
      //               gender: data['gender'],
      //               name: data['name'],
      //               pincode: data['pincode'],
      //               gymId: data['gym_id'],
      //               gymOwner: data['gym_owner'],
      //               landmark: data['landmark'],
      //               location: data['location'],
      //             ),
      //           ),
      //           onTap: () =>
      //               Navigator.pop(context), // ? ontap Property for popping of
      //         );
      //       },
      //     );
      //   },
      // ),
    ]);
  }

  final TextEditingController _addAmount = TextEditingController();
  final TextEditingController _addPlace = TextEditingController();
  final TextEditingController _addName = TextEditingController();
  final TextEditingController _addTimestamp = TextEditingController();

  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                      'Add Records',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    CustomTextField(hinttext: "Name", addcontroller: _addName),
                    CustomTextField(
                        hinttext: "Amount", addcontroller: _addAmount),
                    CustomTextField(
                        hinttext: "Place", addcontroller: _addPlace),
                    CustomTextField(
                        hinttext: "TimeStamp", addcontroller: _addTimestamp),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          FirebaseFirestore.instance.collection("payment").add(
                            {
                              'amount': _addAmount.text,
                              'place': _addPlace.text,
                              'name': _addName.text,
                              'timestamp': _addTimestamp.text,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hinttext,
    required this.addcontroller,
  }) : super(key: key);

  final TextEditingController addcontroller;
  final String hinttext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
          child: TextField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: hinttext),
      )),
    );
  }
}

// *Updating Item list Class

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.amount,
    required this.name,
    required this.place,
    required this.timestamp,
  }) : super(key: key);

  final String name;
  final String amount;
  final String place;
  final Timestamp timestamp;
  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _timeStamp = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amount.text = widget.amount;
    _place.text = widget.place;
    _name.text = widget.name;
    _timeStamp.text = widget.timestamp.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        height: 580,
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
              CustomTextField(hinttext: "Name", addcontroller: _name),
              CustomTextField(hinttext: "Amount", addcontroller: _amount),
              CustomTextField(hinttext: "Place", addcontroller: _place),
              CustomTextField(
                  hinttext: "Time Stamp", addcontroller: _timeStamp),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${_name.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('payment')
                          .doc();
                      Timestamp dataForTimeStamp = Timestamp.now();

                      Map<String, dynamic> data = <String, dynamic>{
                        'amount': _amount.text,
                        'place': _place.text,
                        'name': _name.text,
                        'timestamp': dataForTimeStamp,
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
      ),
    );
  }
}
