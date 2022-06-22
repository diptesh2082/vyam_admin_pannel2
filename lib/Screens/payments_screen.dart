import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
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
  CollectionReference? productStream;

  var dt, d12, ds, dss, d122;
  // late String paymentid;

  final userid = FirebaseFirestore.instance.collection('payment').doc().id;

  @override
  void initState() {
    paymentStream = FirebaseFirestore.instance.collection('payment');
    productStream = FirebaseFirestore.instance.collection("product_details");

    super.initState();
  }

  String searchGymName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
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
                    child: const Text('Add Payment'),
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
                Container(
                  width: 400,
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
                        FocusScope.of(context).unfocus(); // <<<<<<< HEAD
                      },

                      onChanged: (value) {
                        if (value.isEmpty) {}
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
    Timestamp timestamp = data['timestamp'];
    var ds;
    var z = FirebaseFirestore.instance
        .collection('product_details')
        .doc(data['name'])
        .get()
        .then((d) {
      ds = d['name'];
    });
    dss = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    d122 = DateFormat('dd/MM/yyyy, HH:mm').format(dss);
    String stamp = timestamp.toString();
    String id = data['userid'];
    // var dtt = DateTime.fromMillisecondsSinceEpoch(stamp.millisecondsSinceEpoch);
    // var d122 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
    // String paymentID = data['payment_id'];
    // paymentid = paymentID;

    return DataRow(cells: [
      DataCell(data != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(data['name'])
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data == null) {
                  print(snapshot.error);
                  return Container();
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Container();
                }

                return Text(
                    "${snapshot.data.get('name')} | ${snapshot.data.get('branch').toString().toUpperCase()}");
              })
          : const Text("")),
      DataCell(data != null ? Text(data['amount'] ?? "") : const Text("")),
      // DataCell(data != null ? Text(data['place'] ?? "") : Text("")),
      DataCell(data != null
          ? Text(data['type'].toString().toUpperCase())
          : const Text("")),
      DataCell(data != null ? Text(d122) : const Text("")),
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
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: paymentStream, uniqueDocId: data['userid']);

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
                                  stream: paymentStream,
                                  uniqueDocId: data['userid']);
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

  final TextEditingController _addAmount = TextEditingController();
  final TextEditingController _addPlace = TextEditingController();
  final TextEditingController _addName = TextEditingController();
  // final TextEditingController _addTimestamp = TextEditingController();
  late Timestamp dtime = Timestamp.now();

//---> MOVED TO PAYMENTSCREEN///---------------------
}

class PaymentScreen extends StatefulWidget {
  final String d12;

  const PaymentScreen(this.d12, {Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CollectionReference? paymentStream;
  CollectionReference? productStream;

  var dt, d12, ds;

  // late String paymentid;
  final userid = FirebaseFirestore.instance.collection('payment').doc().id;
  void initState() {
    paymentStream = FirebaseFirestore.instance.collection('payment');
    productStream = FirebaseFirestore.instance.collection("product_details");

    super.initState();
    d12 = widget.d12;
  }

  final _formKey = GlobalKey<FormState>();
  DateTime? date;
  TimeOfDay? time;
  DateTime? dateTime;
  String searchGymName = '';
  bool showDate = false;
  DateTime? sdate = DateTime.now();

  final TextEditingController _addAmount = TextEditingController();
  // final TextEditingController _addPlace = TextEditingController();
  // final TextEditingController _addName = TextEditingController();
  // final TextEditingController _addTimestamp = TextEditingController();
  // late Timestamp dtime = Timestamp.now();
  var selectedValue = "ONLINE";
  String namee = "edgefitness.kestopur@vyam.com";
  String place = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
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
                  const Text("Choose Vendor"),
                  Container(
                    width: 400,
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
                          FocusScope.of(context).unfocus(); // <<<<<<< HEAD
                        },

                        onChanged: (value) {
                          if (value.isEmpty) {}
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
                  SizedBox(
                      height: 400,
                      width: 400,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: productStream!.snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          String check = "Jee";
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == null) {
                            return Container();
                          }
                          var doc = snapshot.data.docs;

                          if (searchGymName.isNotEmpty) {
                            doc = doc.where((element) {
                              return element
                                      .get('name')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchGymName.toString()) ||
                                  element
                                      .get('gym_id')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchGymName.toString()) ||
                                  element
                                      .get('address')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchGymName.toString());
                            }).toList();
                          }
                          print("-----------------------------------");
                          print(snapshot.data.docs);
                          return ListView.builder(
                            itemCount: doc.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile<String>(
                                  value: doc[index]['gym_id'],
                                  title: Text(
                                      "${doc[index]['name'].toString()} || ${doc[index]['branch']}"),
                                  groupValue: namee,
                                  onChanged: (String? valuee) {
                                    setState(() {
                                      namee = valuee!;
                                      place = doc[index]['branch'];
                                    });
                                    print(namee);
                                  });
                            },
                          );
                        },
                      )),
                  customTextField3(
                      hinttext: "Amount", addcontroller: _addAmount),
                  // customTextField(hinttext: "Place", addcontroller: _addPlace),
                  // customTextField(
                  //     hinttext: "TimeStamp",
                  //     addcontroller: _addTimestamp),
                  const SizedBox(width: 15),

                  Container(
                    child: Row(
                      children: [
                        ElevatedButton(
                            child: const Text('Select Date & Time '),
                            onPressed: () async {
                              setState(() async {
                                showDate = true;
                                sdate = await pickDateTime(context);
                              });
                            }),
                        const SizedBox(width: 15),
                        showDate != false
                            ? Text(
                                DateFormat('dd/MMM/yyyy, hh:mm a')
                                    .format(sdate!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                            : const SizedBox(),
                      ],
                    ),
                  ),

                  Row(
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
                          if (_formKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection("payment")
                                .doc(userid)
                                .set(
                              {
                                'amount': _addAmount.text,
                                'gym_id': namee,
                                'place': place,
                                // 'payment_id': paymentid,
                                'name': namee,
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
                          }
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
                          child: const Text('Close'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    return dateTime;
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

  Future pickTime(BuildContext context) async {
    const intialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime =
        await showTimePicker(context: context, initialTime: time ?? intialTime);

    if (newTime == null) return;

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
  String namee = "Fitness Break";
  String place = "";
  String searchGymName = '';
  CollectionReference? productStream;

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
    productStream = FirebaseFirestore.instance.collection("product_details");
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
        padding: const EdgeInsets.all(20),
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
                const Text("Choose Vendor"),
                Container(
                  width: 400,
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
                        FocusScope.of(context).unfocus(); // <<<<<<< HEAD
                      },

                      onChanged: (value) {
                        if (value.isEmpty) {}
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
                SizedBox(
                    height: 400,
                    width: 400,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: productStream!.snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        String check = "Jee";
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.data == null) {
                          return Container();
                        }
                        print("-----------------------------------");
                        var doc = snapshot.data.docs;
                        if (searchGymName.isNotEmpty) {
                          doc = doc.where((element) {
                            return element
                                    .get('name')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchGymName.toString()) ||
                                element
                                    .get('gym_id')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchGymName.toString()) ||
                                element
                                    .get('address')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchGymName.toString());
                          }).toList();
                        }
                        print(snapshot.data.docs);
                        return ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RadioListTile<String>(
                                value: doc[index]['gym_id'],
                                title: Text(doc[index]['name'].toString()),
                                groupValue: gym_id,
                                onChanged: (String? valuee) {
                                  setState(() {
                                    gym_id = valuee!;
                                    _place.text = doc[index]['branch'];
                                  });
                                  print(gym_id.toString());
                                });
                          },
                        );
                      },
                    )),
                customTextField(hinttext: "Amount", addcontroller: _amount),
                //customTextField(hinttext: "Place", addcontroller: _place),

                Container(
                  child: Row(
                    children: [
                      const Text('Payment Type : '),
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
                            'gym_id': gym_id,
                            'name': gym_id,
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
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Close'),
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
