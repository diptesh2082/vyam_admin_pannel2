import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../services/CustomTextFieldClass.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  CollectionReference? paymentStream;
  var dt, d12, ds, dss, d122;
  // late String paymentid;

  final userid = FirebaseFirestore.instance.collection('payment').doc().id;

  @override
  void initState() {
    paymentStream = FirebaseFirestore.instance.collection('payment');
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      setState(() {
                        //from firebase
                        dt = DateTime.fromMillisecondsSinceEpoch(
                            dtime.millisecondsSinceEpoch);
                        d12 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentScreen(d12)));
                    },
                    child: Text('Add Payment'),
                    // Container(
                    //   width: 120,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20.0)),
                    //   child: Row(
                    //     children: const [
                    //       Icon(Icons.add),
                    //       Text('Add Product',
                    //           style: TextStyle(fontWeight: FontWeight.w400)),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: paymentStream!.snapshots(),
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
                                'Vendor Name',
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
                                  'Payment Type',
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
    Timestamp timestamp = data['timestamp'];
    dss = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    d122 = DateFormat('dd/MM/yyyy, HH:mm').format(dss);
    String stamp = timestamp.toString();
    // var dtt = DateTime.fromMillisecondsSinceEpoch(stamp.millisecondsSinceEpoch);
    // var d122 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
    // String paymentID = data['payment_id'];
    // paymentid = paymentID;

    return DataRow(cells: [
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['amount'] ?? "") : Text("")),
      // DataCell(data != null ? Text(data['place'] ?? "") : Text("")),
      DataCell(data != null
          ? Text(data['type'].toString().toUpperCase() )
          : Text("")),
      DataCell(data != null ? Text(d122) : Text("")),
      DataCell(
        const Text(""),
        showEditIcon: true,
        onTap: () {
          // ? Added Gesture Detecter for popping off update record Card
          Get.to(
            () => ProductEditBox(
              amount: data['amount'],
              gym_id: data['gym_id'],
              name: data['name'],
              type: data['type'],
              // paymentid: data['paymentid'],
              place: data['place'],
              timestamp: data['timestamp'],
              userid: data['userid'],
            ),
          );
        },
      ),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: paymentStream, uniqueDocId: userid);
      })
    ]);
  }

  final TextEditingController _addAmount = TextEditingController();
  final TextEditingController _addPlace = TextEditingController();
  final TextEditingController _addName = TextEditingController();
  // final TextEditingController _addTimestamp = TextEditingController();
  late Timestamp dtime = Timestamp.now();

//---> MOVED TO PAYMENTSCREEN///---------------------
}

class PaymentScreen extends StatefulWidget {
  final String d12;

  const PaymentScreen(@required this.d12, {Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CollectionReference? paymentStream;
  var dt, d12, ds;

  // late String paymentid;
  final userid = FirebaseFirestore.instance.collection('payment').doc().id;
  void initState() {
    paymentStream = FirebaseFirestore.instance.collection('payment');
    super.initState();
    d12 = widget.d12;
  }

  DateTime? date;
  TimeOfDay? time;
  DateTime? dateTime;

  final TextEditingController _addAmount = TextEditingController();
  final TextEditingController _addPlace = TextEditingController();
  final TextEditingController _addName = TextEditingController();
  // final TextEditingController _addTimestamp = TextEditingController();
  // late Timestamp dtime = Timestamp.now();
  var selectedValue = "ONLINE";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
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
                    hinttext: "Vendor Name ", addcontroller: _addName),
                customTextField(hinttext: "Amount", addcontroller: _addAmount),
                customTextField(hinttext: "Place", addcontroller: _addPlace),
                // customTextField(
                //     hinttext: "TimeStamp",
                //     addcontroller: _addTimestamp),
                SizedBox(width: 15),

                Container(
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: const Text('Select Date & Time '),
                        onPressed: () => pickDateTime(context),
                      ),
                      SizedBox(width: 15),

                    ],
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      const Text('Payment Type'),
                      const SizedBox(width: 15),

                      DropdownButton(
                        value: selectedValue,
                        items: const [
                          DropdownMenuItem(
                            child: Text("Online"),
                            value: "ONLINE",
                          ),
                          DropdownMenuItem(
                            child: Text("Cash"),
                            value: "Cash",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        }),
                  ],
                  ),
                ),

                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     'Date And Time: $d12',
                //     style: TextStyle(
                //       fontSize: 14,
                //       fontFamily: 'poppins',
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection("payment")
                            .doc(userid)
                            .set(
                          {
                            'amount': _addAmount.text,
                            'gym_id': _addName.text,
                            'place': _addPlace.text,
                            // 'payment_id': paymentid,
                            'name': _addName.text,
                            'timestamp': dateTime,
                            'userid': userid,
                            'type': selectedValue,
                          },
                        );
                        //     .then((snapshot) async {
                        //   await FirebaseFirestore.instance
                        //       .collection("payment")
                        //       .doc(userid)
                        //       .update({'timestamp': dtime});
                        // }
                        // );
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDateTime(BuildContext context) async {
   final date = await pickDate(context);
   if(date == null) return;

   final time = await pickTime(context);
   if(time == null) return ;

   setState(() {
     dateTime = DateTime(
       date.year,
       date.month,
       date.day,
       time.hour,
       time.minute,
     );
   });
  }


  Future pickDate(BuildContext context) async {
    final intialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: intialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      date = newDate;
    });

    return newDate;
  }

   Future pickTime(BuildContext context) async{
     final intialTime = TimeOfDay(hour: 9,
         minute: 0);
     final newTime = await showTimePicker(context: context,
         initialTime: time ?? intialTime);

     if(newTime == null) return ;

     setState(() {
       time = newTime;
     });

     return newTime;
   }
}

// *Updating Item list Class

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.amount,
    required this.name,
    required this.place,
    required this.type,
    required this.timestamp,
    // required this.paymentid,
    required this.userid,
    required this.gym_id,
  }) : super(key: key);

  final String name;
  final String amount;
  final String place;
  final String type;
  final Timestamp timestamp;
  // final String paymentid;
  final String userid;
  final String gym_id;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _place = TextEditingController();
  // final TextEditingController _timeStamp = TextEditingController();
  var dt, d12;
  late Timestamp dtime = Timestamp.now();
  late Timestamp r;
  // late String _paymentid;
  late String userid;
  late String gym_id;
  var selectedValue = "ONLINE";

  @override
  void initState() {
    super.initState();
    _amount.text = widget.amount;
    _place.text = widget.place;
    _name.text = widget.name;
    r = dtime;
    // _paymentid = widget.paymentid;
    userid = widget.userid;
    gym_id = widget.gym_id;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //from firebase
      dt = DateTime.fromMillisecondsSinceEpoch(dtime.millisecondsSinceEpoch);
      d12 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
    });
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Edit Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
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
                customTextField(hinttext: "Name", addcontroller: _name),
                customTextField(hinttext: "Amount", addcontroller: _amount),
                //customTextField(hinttext: "Place", addcontroller: _place),

                Container(
                  child: Row(

                    children:[
                      Text('Payment Type : '),
                      DropdownButton(
                        value: selectedValue,
                        items: const [
                          DropdownMenuItem(
                            child: Text("Online"),
                            value: "ONLINE",
                          ),
                          DropdownMenuItem(
                            child: Text("Cash"),
                            value: "Cash",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        }),
                  ],
                  ),
                ),

                Text(d12),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          print("The Gym id is : ${_name.text}");
                          FirebaseFirestore.instance
                              .collection('payment')
                              .doc(userid)
                              .update({
                            'amount': _amount.text,
                            'gym_id': _name.text,
                            'name': _name.text,
                            // 'payment_id': _paymentid,
                            'place': _place.text,
                            'timestamp': r,
                            'userid': userid,
                            'type': selectedValue,
                          }).whenComplete(() => print("Update Complete"));

                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
