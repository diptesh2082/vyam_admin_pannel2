import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/CustomTextFieldClass.dart';
import '../../../services/MatchIDMethod.dart';

String globalGymId = '';

class Timings extends StatefulWidget {
  String pGymId;
  Timings({Key? key, required this.pGymId}) : super(key: key);

  @override
  State<Timings> createState() => _TimingsState();
}

class _TimingsState extends State<Timings> {
  CollectionReference? packageStream;

  @override
  void initState() {
    super.initState();
    packageStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.pGymId)
        .collection('timings');
    globalGymId = widget.pGymId;
  }

  final finalPackID =
      FirebaseFirestore.instance.collection('product_details').doc().id;

  @override
  Widget build(BuildContext context) {
    print(finalPackID);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timings'),
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
                    style: ElevatedButton.styleFrom(onPrimary: Colors.purple),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShowAddBox(),
                        ),
                      );
                    },
                    child: const Text(
                      'Add Timing',
                      style: TextStyle(
                        color: Colors.white,
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
                                'Type',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Morning Timings',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Evening Timings',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Closed',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Closed Day Comment',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Morning Days',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Evening Days',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Position',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("Previous Page"),
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
    // String timeId = data['timing_id'];

    // print(timeId);
    String? timeId;
    try {
      timeId = data['timing_id'];
    } catch (e) {
      timeId = '#ERROR';
    }
    String? Evening;
    try {
      Evening = data['Evening'];
    } catch (e) {
      Evening = '#ERROR';
    }
    String? Morning;
    try {
      Morning = data['Morning'];
    } catch (e) {
      Morning = '#ERROR';
    }
    String? original_price;
    try {
      original_price = data['original_price'];
    } catch (e) {
      original_price = '#ERROR';
    }
    List closed = [];
    try {
      closed = data['closed'];
    } catch (e) {
      closed = [];
    }
    String? morning_days;
    try {
      morning_days = data['morning_days'];
    } catch (e) {
      morning_days = '#ERROR';
    }
    String? closed_day;
    try {
      closed_day = data['closed_day'];
    } catch (e) {
      closed_day = '#ERROR';
    }
    String? evening_days;
    try {
      evening_days = data['evening_days'];
    } catch (e) {
      evening_days = '#ERROR';
    }
    String? position;
    try {
      position = data['position'];
    } catch (e) {
      position = '#ERROR';
    }

    return DataRow(cells: [
      DataCell(timeId != null ? Text(timeId) : const Text("")),
      DataCell(Morning != null ? Text(Morning) : const Text("")),
      DataCell(Evening != null ? Text(Evening.toString()) : const Text("")),
      DataCell(closed != null ? Text(closed.toString()) : const Text("")),
      DataCell(
          closed_day != null ? Text(closed_day.toString()) : const Text("")),
      DataCell(morning_days != null ? Text(morning_days) : const Text("")),
      DataCell(evening_days != null ? Text(evening_days) : const Text("")),
      DataCell(position != null ? Text(position) : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductEditBox(
                    gymId: widget.pGymId,
                    typeId: timeId.toString(),
                    closed: closed,
                    eveninging_days: evening_days.toString(),
                    morning: Morning.toString(),
                    morning_days: morning_days.toString(),
                    evening: Evening.toString(),
                    position: position.toString(),
                    closed_day: closed_day.toString())));
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: packageStream, uniqueDocId: timeId);
      })
    ]);
  }
}

class ShowAddBox extends StatefulWidget {
  const ShowAddBox({Key? key}) : super(key: key);

  @override
  State<ShowAddBox> createState() => _ShowAddBoxState();
}

class _ShowAddBoxState extends State<ShowAddBox> {
  // var idd;
  // Future<void> initState() async {
  //   // TODO: implement initState
  //   idd= await FirebaseFirestore.instance
  //       .collection('product_details')
  //       .doc(globalGymId)
  //       .collection('timings').id;
  //
  //   super.initState();
  // }
  List<String> closed = [];
  final TextEditingController typecon = TextEditingController();
  final TextEditingController morning = TextEditingController();
  final TextEditingController evening = TextEditingController();
  // final TextEditingController closed = TextEditingController();
  final TextEditingController morning_days = TextEditingController();
  final TextEditingController closed_day = TextEditingController();

  final TextEditingController evening_days = TextEditingController();
  final TextEditingController position = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Timings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Timings Records',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            customTextField(hinttext: "Timing Type", addcontroller: typecon),
            customTextField(
                hinttext: "Morning timings :6.00AM-12.00PM ",
                addcontroller: morning),
            customTextField(
                hinttext: "Evening Timings : 5.00PM-10.00PM",
                addcontroller: evening),
            customTextField(
                hinttext: "Closed Day Comment", addcontroller: closed_day),
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Text(
                    "ADD Closed Days",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Sunday");
                            });
                          },
                          child: const Text("Sunday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Monday");
                            });
                          },
                          child: const Text("Monday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Tuesday");
                            });
                          },
                          child: const Text("Tuesday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Wednesday");
                            });
                          },
                          child: const Text("Wednesday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Thursday");
                            });
                          },
                          child: const Text("Thursday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Friday");
                            });
                          },
                          child: const Text("Friday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("Saturday");
                            });
                          },
                          child: const Text("Saturday")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.removeLast();
                            });
                          },
                          child: const Text("Remove Last")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              closed.add("None");
                            });
                          },
                          child: const Text("None")),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    closed.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),

            // customTextField(
            //     hinttext: "Closed : Saturday and Sunday",
            //     addcontroller: closed),
            customTextField(
              addcontroller: morning_days,
              hinttext: "Morning Days : Morning(mon-fri)",
            ),
            customTextField(
                hinttext: "Evening Days : Evening(mon-fri)",
                addcontroller: evening_days),
            customTextField(hinttext: "Position", addcontroller: position),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('product_details')
                      .doc(globalGymId)
                      .collection('timings')
                      .doc(typecon.text)
                      .set(
                    {
                      "Morning": morning.text,
                      "Evening": evening.text,
                      "closed": closed,
                      "morning_days": morning_days.text,
                      "evening_days": evening_days.text,
                      'timing_id': typecon.text,
                      'position': position.text,
                      'closed_day': closed_day.text
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
    );
  }
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.morning,
    required this.evening,
    required this.closed,
    required this.morning_days,
    required this.eveninging_days,
    required this.typeId,
    required this.gymId,
    required this.position,
    required this.closed_day,
  }) : super(key: key);

  final String morning;
  final String evening;
  final List<dynamic> closed;
  final String morning_days;
  final String eveninging_days;
  final String typeId;
  final String gymId;
  final String position;
  final String closed_day;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController typecon = TextEditingController();
  final TextEditingController morning = TextEditingController();
  final TextEditingController evening = TextEditingController();
  final TextEditingController closed_day = TextEditingController();
  final TextEditingController morning_days = TextEditingController();
  final TextEditingController evening_days = TextEditingController();
  final TextEditingController position = TextEditingController();
  List<dynamic> closed = [];
  @override
  void initState() {
    super.initState();
    typecon.text = widget.typeId;
    morning.text = widget.morning;
    evening.text = widget.evening;
    closed = widget.closed;
    morning_days.text = widget.morning_days;
    evening_days.text = widget.eveninging_days;
    position.text = widget.position;
    closed_day.text = widget.closed_day;
  }

  @override
  Widget build(BuildContext context) {
    print("The Gym id is : ${typecon.text}");
    print("The Gym id is : ${widget.gymId}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
      ),
      body: Container(
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
              // customTextField(hinttext: "Timing Type", addcontroller: typecon),
              customTextField(
                  hinttext: "Morning timings :6.00AM-12.00PM ",
                  addcontroller: morning),
              customTextField(
                  hinttext: "Evening Timings : 5.00PM-10.00PM",
                  addcontroller: evening),
              customTextField(
                  hinttext: "Closed Day Comment", addcontroller: closed_day),
              Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Text(
                      "ADD Closed Days",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Sunday");
                              });
                            },
                            child: const Text("Sunday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Monday");
                              });
                            },
                            child: const Text("Monday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Tuesday");
                              });
                            },
                            child: const Text("Tuesday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Wednesday");
                              });
                            },
                            child: const Text("Wednesday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Thursday");
                              });
                            },
                            child: const Text("Thursday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Friday");
                              });
                            },
                            child: const Text("Friday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("Saturday");
                              });
                            },
                            child: const Text("Saturday")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.add("None");
                              });
                            },
                            child: const Text("None")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                closed.removeLast();
                              });
                            },
                            child: const Text("Remove Last")),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      closed.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
              ),
              // customTextField(
              //     hinttext: "Closed : Saturday and Sunday",
              //     addcontroller: closed),
              customTextField(
                addcontroller: morning_days,
                hinttext: "Morning Days : Morning(mon-fri)",
              ),
              customTextField(
                  hinttext: "Evening Days : Evening(mon-fri)",
                  addcontroller: evening_days),
              customTextField(hinttext: "Position", addcontroller: position),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${typecon.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc(widget.gymId)
                          .collection('timings')
                          .doc(typecon.text);
                      Map<String, dynamic> data = <String, dynamic>{
                        "Morning": morning.text,
                        "Evening": evening.text,
                        "closed": closed,
                        "morning_days": morning_days.text,
                        "evening_days": evening_days.text,
                        'timing_id': typecon.text,
                        'position': position.text,
                        'closed_day': closed_day.text
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
