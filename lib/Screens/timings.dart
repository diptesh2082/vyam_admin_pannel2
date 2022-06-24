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
        title: Text('Timings'),
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
                          builder: (context) => ShowAddBox(),
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
    String timeId = data['timing_id'];
    print(timeId);
    return DataRow(cells: [
      DataCell(data != null ? Text(data["timing_id"] ?? "") : Text("")),
      DataCell(data != null ? Text(data["Morning"] ?? "") : Text("")),
      DataCell(data != null ? Text(data['Evening'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['closed'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['morning_days'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['evening_days'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['position'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductEditBox(
                  gymId: widget.pGymId,
                  typeId: timeId,
                  closed: data['closed'],
                  eveninging_days: data['evening_days'],
                  morning: data["Morning"],
                  morning_days: data['morning_days'],
                  evening: data['Evening'],
                  position: data['position']),
            ));
      }),
      DataCell(Icon(Icons.delete), onTap: () {
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
  @override
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
  final TextEditingController typecon = TextEditingController();
  final TextEditingController morning = TextEditingController();
  final TextEditingController evening = TextEditingController();
  final TextEditingController closed = TextEditingController();
  final TextEditingController morning_days = TextEditingController();
  final TextEditingController evening_days = TextEditingController();
  final TextEditingController position = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Timings"),
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
                hinttext: "Closed : Saturday and Sunday",
                addcontroller: closed),
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
                      "closed": closed.text,
                      "morning_days": morning_days.text,
                      "evening_days": evening_days.text,
                      'timing_id': typecon.text,
                      'position': position.text
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
  }) : super(key: key);

  final String morning;
  final String evening;
  final String closed;
  final String morning_days;
  final String eveninging_days;
  final String typeId;
  final String gymId;
  final String position;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController typecon = TextEditingController();
  final TextEditingController morning = TextEditingController();
  final TextEditingController evening = TextEditingController();
  final TextEditingController closed = TextEditingController();
  final TextEditingController morning_days = TextEditingController();
  final TextEditingController evening_days = TextEditingController();
  final TextEditingController position = TextEditingController();

  @override
  void initState() {
    super.initState();
    typecon.text = widget.typeId;
    morning.text = widget.morning;
    evening.text = widget.evening;
    closed.text = widget.closed;
    morning_days.text = widget.morning_days;
    evening_days.text = widget.eveninging_days;
    position.text = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    print("The Gym id is : ${typecon.text}");
    print("The Gym id is : ${widget.gymId}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
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
                  hinttext: "Closed : Saturday and Sunday",
                  addcontroller: closed),
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
                        "closed": closed.text,
                        "morning_days": morning_days.text,
                        "evening_days": evening_days.text,
                        'timing_id': typecon.text,
                        'position': position.text,
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

// import 'package:admin_panel_vyam/dashboard.dart';
// import 'package:admin_panel_vyam/services/deleteMethod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../services/CustomTextFieldClass.dart';
// import '../services/MatchIDMethod.dart';
//
// class Timings extends StatefulWidget {
//   final gymId;
//   const Timings({Key? key,required this.gymId}) : super(key: key);
//
//   @override
//   State<Timings> createState() => _TimingsState();
// }
//
// class _TimingsState extends State<Timings> {
//   DocumentReference? TimeStream;
//   final catId =
//   FirebaseFirestore.instance.collection('product_details').doc().id.toString();
//
//   @override
//   void initState() {
//     TimeStream = FirebaseFirestore.instance.collection('product_details').doc(widget.gymId);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(20.0)),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 8.0),
//                   child: GestureDetector(
//                     onTap: showAddbox,
//                     child: Container(
//                       width: 120,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20.0)),
//                       child: Row(
//                         children: const [
//                           Icon(Icons.add),
//                           Text('Add Product',
//                               style: TextStyle(fontWeight: FontWeight.w400)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: StreamBuilder<DocumentSnapshot>(
//                     stream: TimeStream!.snapshots(),
//                     builder: (context, AsyncSnapshot snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       }
//                       if (snapshot.data == null) {
//                         return Container();
//                       }
//                       var doc=snapshot.data;
//                         print(doc);
//                       if (snapshot.data.get("timings")==null){
//                         return Container();
//                       }
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           dataRowHeight: 65,
//                           columns: const [
//                             DataColumn(
//                               label: Text(
//                                 'Evening',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Morning',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Closed',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Evening_Days',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Morning_days',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Edit',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             // DataColumn(
//                             //   label: Text(
//                             //     'Delete',
//                             //     style: TextStyle(fontWeight: FontWeight.w600),
//                             //   ),
//                             // ),
//                           ],
//                           rows: _buildlist(context, [doc],"gym"),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<DataRow> _buildlist(
//       BuildContext context, List<DocumentSnapshot> snapshot,String type) {
//     return snapshot.map((data) => _buildListItem(context, data)).toList();
//   }
//
//   DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
//
//     String gymId= data["gym_id"].toString();
//     String type= data["timings"][0].toString();
//     return DataRow(cells: [
//       DataCell(
//         data.get("timings")["${type}"]['Evening'] != null ? Text(data.get("timings")["${type}"]['Evening'] ?? "") : const Text(""),
//       ),
//       DataCell(
//           data.get("timings")["${type}"]['Morning'] != null ? Text(data.get("timings")["${type}"]['Morning'] ?? "") : const Text(""),
//       ),
//       DataCell(
//         data.get("timings")["${type}"]['Morning'] != null ? Text(data.get("timings")["${type}"]['Morning'] ?? "") : const Text(""),
//       ),
//       DataCell(
//         data.get("timings")["${type}"]['closed'] != null ? Center(child: Text(data.get("timings")["${type}"]['closed'].toString() )) : const Text(""),
//       ),
//       DataCell(
//         data.get("timings")["${type}"]['evening_days'] != null ? Text(data.get("timings")["${type}"]['evening_days'] ?? "") : const Text(""),
//       ),
//       DataCell(
//         data.get("timings")["${type}"]['morning_days'] != null ? Text(data.get("timings")["${type}"]['morning_days'] ?? "") : const Text(""),
//       ),
//       DataCell(
//         const Text(""),
//         showEditIcon: true,
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: SingleChildScrollView(
//                   child: ProductEditBox(Morning: _Morning, evening_days: _evening_days,
//                     Evening: _Evening,morning_days: _morning_days, Closed: _Closed,id: gymId,
//
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       // DataCell(const Icon(Icons.delete), onTap: () {
//       //   deleteMethod(stream: TimeStream, uniqueDocId: gymId);
//       // })
//     ]);
//   }
//
//   final TextEditingController _Evening = TextEditingController();
//   final TextEditingController _Morning = TextEditingController();
//   final TextEditingController _Closed = TextEditingController();
//   final TextEditingController _evening_days = TextEditingController();
//   final TextEditingController _morning_days = TextEditingController();
//   showAddbox() => showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30))),
//       content: SizedBox(
//         height: 480,
//         width: 800,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Add Records',
//                 style: TextStyle(
//                     fontFamily: 'poppins',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14),
//               ),
//               customTextField(hinttext: "Evening Time", addcontroller: _Evening),
//               customTextField(
//                   hinttext: "Evening Time", addcontroller: _Morning),
//               customTextField(hinttext: "Closed day", addcontroller: _Closed),
//               customTextField(hinttext: "Closed day", addcontroller: _evening_days),
//               customTextField(hinttext: "Closed day", addcontroller: _morning_days),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await
//                     FirebaseFirestore.instance
//                         .collection('product_details')
//                         .doc(widget.gymId)
//                         .update(
//                       {
//                         "timings":{
//                         "gym": {
//
//                           'Evening': _Evening.text,
//                           'Morning': _Morning.text,
//                           'closed': _Closed.text,
//                           'evening_days': _evening_days.text,
//                           'morning_days':  _morning_days.text    ,
//                         }
//                       }
//                       },
//
//
//                     );
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Done'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// // EDIT FEATURE
// class ProductEditBox extends StatefulWidget {
//   const ProductEditBox({
//     Key? key,required this.Evening,required this.Morning,required this.Closed,required this.evening_days,required this.morning_days,required this.id,
//
//   }) : super(key: key);
//
//   final Evening ;
//   final Morning ;
//   final Closed ;
//   final evening_days;
//   final  morning_days;
//   final id;
//
//   @override
//   _ProductEditBoxState createState() => _ProductEditBoxState();
// }
//
// class _ProductEditBoxState extends State<ProductEditBox> {
//   final TextEditingController _Evening = TextEditingController();
//   final TextEditingController _Morning = TextEditingController();
//   final TextEditingController _Closed = TextEditingController();
//   final TextEditingController _evening_days = TextEditingController();
//   final TextEditingController _morning_days = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30))),
//       content: SizedBox(
//         height: 580,
//         width: 800,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Update Records for this doc',
//                 style: TextStyle(
//                     fontFamily: 'poppins',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14),
//               ),
//               customTextField(hinttext: "Evening Time", addcontroller: _Evening),
//               customTextField(
//                   hinttext: "Evening Time", addcontroller: _Morning),
//               customTextField(hinttext: "Closed day", addcontroller: _Closed),
//               customTextField(hinttext: "Closed day", addcontroller: _evening_days),
//               customTextField(hinttext: "Closed day", addcontroller: _morning_days),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       await
//                       FirebaseFirestore.instance
//                           .collection('product_details')
//                           .doc(widget.id)
//                           .update(
//                         {
//                           "timings":{
//                             "gym": {
//
//                               'Evening': _Evening.text,
//                               'Morning': _Morning.text,
//                               'closed': _Closed.text,
//                               'evening_days': _evening_days.text,
//                               'morning_days':  _morning_days.text    ,
//                             }
//                           }
//                         },
//
//
//                       );
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Done'),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
