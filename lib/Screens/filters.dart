import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class filters extends StatefulWidget {
  const filters({Key? key}) : super(key: key);

  @override
  State<filters> createState() => _filtersState();
}

class _filtersState extends State<filters> {
  CollectionReference? bookingStream;
  CollectionReference? productStream;
  String searchVendor = '';
  String namee = "edgefitness.kestopur@vyam.com";
  String place = "";
  String search = '';
  bool showStartDate = false;
  bool showEndDate = false;

  @override
  void initState() {
    bookingStream = FirebaseFirestore.instance.collection('bookings');
    productStream = FirebaseFirestore.instance.collection('product_details');
    super.initState();
  }

  DateTime? date;
  DateTime startDate = DateTime(DateTime.now().year - 5);
  DateTime endDate = DateTime(DateTime.now().year + 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filters")),
      backgroundColor: Colors.white10,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 500,
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
                      FocusScope.of(context).unfocus();
                    },
                    // controller: searchController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // _node.canRequestFocus=false;
                        // FocusScope.of(context).unfocus();
                      }
                      if (mounted) {
                        setState(() {
                          search = value.toString();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Vendor',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white12,
                    ),
                  ),
                ),
              ),
              const Text(
                "Select Vendor",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
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
                          print(snapshot.data.docs);
                          return ListView.builder(
                            itemCount: doc.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile<String>(
                                  value: doc[index]['gym_id'],
                                  title: Text(
                                      "${doc[index]['name'].toString()} || ${doc[index]['branch'].toString().toUpperCase()}."),
                                  groupValue: namee,
                                  onChanged: (String? valuee) {
                                    setState(() {
                                      namee = valuee!;
                                      search = namee;
                                      place = doc[index]['branch'];
                                    });
                                    print(namee);
                                  });
                            },
                          );
                        },
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() async {
                            showStartDate = true;
                            startDate = await pickDate(context);
                            print(startDate);
                          });
                        },
                        icon: const Icon(Icons.date_range),
                        label: const Text('Start Date'),
                      ),
                      showStartDate != false
                          ? Text(DateFormat("MMM, dd, yyyy").format(startDate),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() async {
                            showEndDate = true;
                            endDate = await pickDate(context);
                            print(endDate);
                          });
                        },
                        icon: const Icon(Icons.date_range),
                        label: const Text('End Date'),
                      ),
                      showEndDate != false
                          ? Text(DateFormat("MMM ,dd , yyyy").format(endDate),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        startDate = DateTime(DateTime.now().year - 5);
                        endDate = DateTime(DateTime.now().year + 5);
                        search = "";
                        showStartDate = false;
                        showEndDate = false;
                        print(startDate);
                        print(endDate);
                        print(search);
                        print(namee);
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                ],
              ),
              // Row(children:[
              //   Text(DateFormat("MMM, dd, yyyy").format(startDate) , style: const TextStyle(fontWeight: FontWeight.bold),),
              //   Text(DateFormat("MMM, dd, yyyy").format(endDate) , style: const TextStyle(fontWeight: FontWeight.bold),),
              //   const SizedBox(width: 25,),
              //
              // ]),
              Container(
                width: 500,
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
                      FocusScope.of(context).unfocus();
                    },
                    // controller: searchController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // _node.canRequestFocus=false;
                        // FocusScope.of(context).unfocus();
                      }
                      if (mounted) {
                        setState(() {
                          searchVendor = value.toString();
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
              Material(
                elevation: 8,
                child: Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .where('booking_status', whereIn: [
                          'completed',
                          'active',
                          'upcoming',
                          'cancelled',
                        ])
                        .orderBy("order_date", descending: true)
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
                      var doc = snapshot.data.docs;

                      if (search.isNotEmpty) {
                        doc = doc.where((element) {
                          return element
                              .get('vendorId')
                              .toString()
                              .toLowerCase()
                              .contains(search.toString());
                        }).toList();
                      }

                      if (searchVendor.isNotEmpty) {
                        doc = doc.where((element) {
                          return element
                                  .get('vendorId')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchVendor.toString()) ||
                              element
                                  .get('userId')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchVendor.toString()) ||
                              element
                                  .get('grand_total')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchVendor.toString()) ||
                              element
                                  .get('id')
                                  .toString()
                                  .contains(searchVendor.toString()) ||
                              element
                                  .get('gym_details')['name']
                                  .toString()
                                  .contains(searchVendor.toString()) ||
                              element
                                  .get('user_name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchVendor.toString());
                        }).toList();
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Order ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Order Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                  label: Text(
                                'Per Day \n Packages Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Vendor',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Mobile',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Start Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'End Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Total Days',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Amount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            rows: _buildlist(context, doc, startDate, endDate)),
                      );
                    },
                  ),
                ),
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
                  const SizedBox(width: 20),
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
        ),
      ),
    );
  }

  var start = 0;
  var page = 1;
  var end = 10;
  var length;
  List<DataRow> _buildlist(BuildContext context,
      List<DocumentSnapshot> snapshot, DateTime startDate, DateTime endDate) {
    var d = [];
    var ds = 1;
    var s = start + 1;
    var snap = [];
    length = snapshot.length;
    snapshot.forEach((element) {});
    snapshot.forEach((element) {
      var x = element['booking_date'].toDate();
// <<<<<<< HEAD
      if (x.isAfter(startDate) && x.isBefore(endDate) ||
          x == startDate ||
          x == endDate) {
        if (end >= ds++ && start <= ds) {
          d.add(element);
        }
      }
    });
    return d
        .map((data) => _buildListItem(context, data, s, start, end))
        .toList();
  }

  DataRow _buildListItem(
      BuildContext context, DocumentSnapshot data, int s, int start, int end) {
    String bookingId = data['booking_id'];
    bool paymentDoneBool = data['payment_done'];
    bool bookingAccepted = data['booking_accepted'];
    String durationEnd =
        DateFormat("MMM, dd, yyyy").format(data["plan_end_duration"].toDate());
    // "${data['plan_end_duration'].toDate().year}/${data['plan_end_duration'].toDate().month}/${data['plan_end_duration'].toDate().day}";
    String orderDate =
        DateFormat("MMM, dd, yyyy").format(data["order_date"].toDate());
    // "${data['order_date'].toDate().year}/${data['order_date'].toDate().month}/${data['order_date'].toDate().day}";
    String bookingDate =
        DateFormat("MMM, dd, yyyy").format(data["booking_date"].toDate());
    // "${data['booking_date'].toDate().year}/${data['booking_date'].toDate().month}/${data['booking_date'].toDate().day}";
    String x;
    return DataRow(cells: [
      DataCell(
          data["id"] != null ? Text(data['id'].toString()) : const Text("")),
      DataCell(data['booking_plan'] != null
          ? Text(data['booking_plan'].toString())
          : const Text("")),
      DataCell(data['user_name'] != null
          ? Text(data['user_name'].toString())
          : const Text("")),
      DataCell(data['package_type'] != null
          ? Text(data['package_type'].toString().toUpperCase())
          : const Text("")),
      DataCell(data["gym_details"] != null
          ? Text(
              '${data['gym_details']['name'].toString().toUpperCase()}\n${data['gym_details']['branch'].toString().toUpperCase()}')
          : const Text("")),
      DataCell(data['userId'] != null
          ? Text(data['userId'].toString())
          : const Text("")),
      DataCell(data['booking_date'] != null ? Text(orderDate) : const Text("")),
      DataCell(data['plan_end_duration'] != null
          ? Text(durationEnd)
          : const Text("")),
      // DataCell(data['totalDays'] != null
      //     ? Text(data['totalDays'].toString())
      //     : const Text("")),
      DataCell(data['grand_total'] != null
          ? Text('₹${data['grand_total'].toString()}')
          : const Text("")),
    ]);
  }

  Future pickDate(BuildContext context) async {
    final intialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: intialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) DateTime.now();
    setState(() {
      date = newDate;
    });
    return newDate;
  }
}
