import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/CustomTextFieldClass.dart';
import '../../../services/MatchIDMethod.dart';

String globalGymId = '';

class PackagesPage extends StatefulWidget {
  String pGymId;
  PackagesPage({Key? key, required this.pGymId}) : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  CollectionReference? packageStream;

  @override
  void initState() {
    super.initState();
    packageStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.pGymId)
        .collection('package');
    globalGymId = widget.pGymId;
  }

  final finalPackID =
      FirebaseFirestore.instance.collection('product_details').doc().id;

  @override
  Widget build(BuildContext context) {
    print(finalPackID);
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
                    stream: packageStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        print('No output for package');
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
                                '1 month',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                '3 month',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  '6 month',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'pay per session',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(label: Text('')), // ! For edit pencil
                              DataColumn(label: Text('')), // ! For delete
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
    String packId = data['pack_id'];
    return DataRow(cells: [
      DataCell(data != null ? Text(data['1_month'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['3_month'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['6_month'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['pay_per_session'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    oneMonth: data['1_month'],
                    threeMonth: data['3_month'],
                    sixMonth: data['6_month'],
                    payPerSession: data['pay_per_session'],
                    packId: data['pack_id'],
                  ),
                ),
              );
            });
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: packageStream, uniqueDocId: packId);
      })
    ]);
  }

  final TextEditingController _add1Month = TextEditingController();
  final TextEditingController _add3Month = TextEditingController();
  final TextEditingController _add6Month = TextEditingController();
  final TextEditingController _addPayPerSession = TextEditingController();

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
                    customTextField(
                        hinttext: "1 month", addcontroller: _add1Month),
                    customTextField(
                        hinttext: "3 month", addcontroller: _add3Month),
                    customTextField(
                        hinttext: "6 month", addcontroller: _add6Month),
                    customTextField(
                        hinttext: "pay per day",
                        addcontroller: _addPayPerSession),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await matchID(
                              newId: finalPackID,
                              matchStream: packageStream,
                              idField: 'pack_id');
                          FirebaseFirestore.instance
                              .collection('product_details')
                              .doc(widget.pGymId)
                              .collection('package')
                              .doc(finalPackID)
                              .set(
                            {
                              '1_month': _add1Month.text,
                              '3_month': _add3Month.text,
                              '6_month': _add6Month.text,
                              'pay_per_session': _addPayPerSession.text,
                              'pack_id': finalPackID,
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

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.oneMonth,
    required this.threeMonth,
    required this.sixMonth,
    required this.payPerSession,
    required this.packId,
  }) : super(key: key);

  final String oneMonth;
  final String threeMonth;
  final String sixMonth;
  final String payPerSession;
  final String packId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _oneMonth = TextEditingController();
  final TextEditingController _threeMonth = TextEditingController();
  final TextEditingController _sixMonth = TextEditingController();
  final TextEditingController _payPerSession = TextEditingController();
  @override
  void initState() {
    super.initState();
    _oneMonth.text = widget.oneMonth;
    _threeMonth.text = widget.threeMonth;
    _sixMonth.text = widget.sixMonth;
    _payPerSession.text = widget.payPerSession;
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
              customTextField(hinttext: "1 month", addcontroller: _oneMonth),
              customTextField(hinttext: "3 month", addcontroller: _threeMonth),
              customTextField(hinttext: "6 month", addcontroller: _sixMonth),
              customTextField(
                  hinttext: "pay per session", addcontroller: _payPerSession),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${widget.packId}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc(globalGymId)
                          .collection('package')
                          .doc(widget.packId);
                      Map<String, dynamic> data = <String, dynamic>{
                        '1_month': _oneMonth.text,
                        '3_month': _threeMonth.text,
                        '6_month': _sixMonth.text,
                        'pay_per_session': _payPerSession.text,
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
