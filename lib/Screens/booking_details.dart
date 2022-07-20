import 'package:admin_panel_vyam/Screens/Product%20Details/Packages/packages.dart';
import 'package:admin_panel_vyam/Screens/Product%20Details/product_details.dart';
import 'package:admin_panel_vyam/Screens/booking_add.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../services/deleteMethod.dart';
import 'payments_screen.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  CollectionReference bookingStream =
      FirebaseFirestore.instance.collection('bookings');
  String searchVendorId = '';
  var selectedValue = 'active';
  DateTime? date;
  DateTime startDate = DateTime(DateTime.now().year - 5);
  DateTime endDate = DateTime(DateTime.now().year + 5);

  bool showStartDate = false;
  bool showEndDate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
      ),
      body: SafeArea(
        child: Material(
          elevation: 8,
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
                            Get.to(const addbookings()); //showAddbox,
                          },
                          child: const Text('Add Booking')),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    // Row(
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () async {
                                      setState(() async {
                                        showStartDate = true;
                                        startDate = await pickDate(context);
                                      });

                                      print(startDate.toString());
                                    },
                                    icon: const Icon(Icons.date_range),
                                    label: const Text('Start Date')),
                                showStartDate != false
                                    ? Text(
                                        DateFormat("MMM, dd, yyyy")
                                            .format(startDate),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
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
                                      });

                                      print(endDate.toString());
                                    },
                                    icon: const Icon(Icons.date_range),
                                    label: const Text('End Date')),
                                showEndDate != false
                                    ? Text(
                                        DateFormat("MMM ,dd , yyyy")
                                            .format(endDate),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
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
                                  showEndDate = false;
                                  showStartDate = false;
                                  searchVendorId = "";
                                  print(startDate);
                                  print(endDate);
                                });
                              },
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //           Row(children:[
                    //             Text(DateFormat("MMM, dd, yyyy").format(startDate) , style: const TextStyle(fontWeight: FontWeight.bold),),
                    //             const SizedBox(width: 25,),
                    //             Text(DateFormat("MMM, dd, yyyy").format(endDate) , style: const TextStyle(fontWeight: FontWeight.bold),)
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
                                searchVendorId = value.toString();
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
                        stream: FirebaseFirestore.instance
                            .collection('bookings')
                            .where('booking_status', whereIn: [
                              'completed',
                              'active',
                              'upcoming',
                              'cancelled',
                            ])
                            .orderBy("order_date", descending: true)
                            .orderBy("id", descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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

                          if (searchVendorId.isNotEmpty) {
                            doc = doc.where((element) {
                              return element
                                      .get('user_name')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchVendorId.toString()) ||
                                  element
                                      .get('userId')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchVendorId.toString()) ||
                                  element
                                      .get('gym_details')['branch']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchVendorId.toString()) ||
                                  element
                                      .get('gym_details')['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchVendorId.toString()) ||
                                  element
                                      .get('id')
                                      .toString()
                                      .contains(searchVendorId.toString());
                            }).toList();
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                dataRowHeight: 65,
                                columns: const [
                                  DataColumn(
                                      label: Text(
                                    'Booking ID',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )),
                                  // DataColumn(
                                  //
                                  //     label: Text(
                                  //       'Vendor Name',
                                  //       style: TextStyle(fontWeight: FontWeight.w600),
                                  //     )),
                                  DataColumn(
                                    // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
                                    label: Text(
                                      'User Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'User ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                      label: Text(
                                    'Vendor Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )),
                                  DataColumn(
                                    label: Text(
                                      'Category',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Package \n Type',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  // DataColumn(
                                  //   label: Text(
                                  //     'Total Days',
                                  //     style:
                                  //         TextStyle(fontWeight: FontWeight.w600),
                                  //   ),
                                  // ),
                                  DataColumn(
                                    label: Text(
                                      'Start \n Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  DataColumn(
                                    label: Text(
                                      'End \n Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Booking \n Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Total \n Price',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Discount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Grand \n Total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  // <<<<<<< HEAD
                                  // // DataColumn(
                                  // //   label: Text(
                                  // //     'Payment done',
                                  // //     style: TextStyle(fontWeight: FontWeight.w600),
                                  // //   ),
                                  // // ),
                                  // DataColumn(
                                  // label: Text(
                                  // 'Booking Date',
                                  // style: TextStyle(fontWeight: FontWeight.w600),
                                  // ),
                                  // ),
                                  // DataColumn(
                                  // label: Text(
                                  // =======
                                  DataColumn(
                                    label: Text(
                                      // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
                                      'Payment \n Type',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
                                      'Booking \n Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Delete',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                                rows: _buildlist(
                                    context, doc, startDate, endDate)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   child: const Text("Previous Page"),
                        //   onPressed: () {
                        //     setState(() {
                        //       if (start > 0 && end > 0) {
                        //         start = start - 10;
                        //         end = end - 10;
                        //       }
                        //     });
                        //     print("Previous Page");
                        //   },
                        // ),
                        // const SizedBox(width: 20),
                        // ElevatedButton(
                        //   child: const Text("Next Page"),
                        //   onPressed: () {
                        //     setState(() {
                        //       if (end < length) {
                        //         start = start + 10;
                        //         end = end + 10;
                        //       }
                        //     });
                        //     print("Next Page");
                        //   },
                        // ),

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
                            const SizedBox(
                              width: 20,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('bookings')
                                    .where('booking_status', whereIn: [
                                  'completed',
                                  'active',
                                  'upcoming',
                                  'completed',
                                ]).snapshots(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  fd = int.parse(
                                      ((snapshot.data.docs.length / 10).floor())
                                          .toString());
                                  int index2 = 0;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    height: 50,
                                    width: 100,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: int.parse(
                                                ((snapshot.data.docs.length /
                                                            10)
                                                        .floor())
                                                    .toString()) +
                                            1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    color: page == index + 1
                                                        ? Colors.red
                                                        : Colors.teal,
                                                    height: 20,
                                                    width: 20,
                                                    child: Text(
                                                      "${index + 1}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                ],
                                              ),
                                              onTap: () {
                                                // print(
                                                //     "start=${((index + 1) - 1) * 10} end= ${(index + 1) * 10}");
                                                print(index2);
                                                setState(() {
                                                  index2 = index;
                                                  start =
                                                      ((index + 1) - 1) * 10;
                                                  end = (index + 1) * 10;
                                                  page = index + 1;
                                                });
                                                print(index2);
                                              });
                                        }),
                                  );
                                }),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  start = ((fd + 1) - 1) * 10;
                                  end = (fd + 1) * 10;
                                  page = fd + 1;
                                });
                              },
                              child: Container(
                                height: 20,
                                width: 80,
                                color: Colors.teal,
                                child: const Text(
                                  "Last Page",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
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
                        )
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     ElevatedButton(
                        //       child: Text("Previous Page"),
                        //       onPressed: () {
                        //         setState(() {
                        //           if (start >= 1) page--;
                        //
                        //           if (start > 0 && end > 0) {
                        //             start = start - 10;
                        //             end = end - 10;
                        //           }
                        //         });
                        //         print("Previous Page");
                        //       },
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.symmetric(horizontal: 20),
                        //       child: Text(
                        //         page.toString(),
                        //         style: const TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 15,
                        //             color: Colors.teal),
                        //       ),
                        //     ),
                        //     ElevatedButton(
                        //       child: const Text("Next Page"),
                        //       onPressed: () {
                        //         setState(() {
                        //           if (end <= length) page++;
                        //           if (end < length) {
                        //             start = start + 10;
                        //             end = end + 10;
                        //           }
                        //         });
                        //         print("Next Page");
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ]),
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
    // String bookingId = data['booking_id'];
    String? bookingId;
    try {
      bookingId = data['booking_id'];
    } catch (e) {
      bookingId = '#Error';
    }
    // bool paymentDoneBool =
    // bool bookingAccepted = data['booking_accepted'];
    bool paymentDoneBool = false;
    try {
      paymentDoneBool = data['payment_done'];
    } catch (e) {
      paymentDoneBool = false;
    }
    bool bookingAccepted = false;
    try {
      bookingAccepted = data['booking_accepted'];
    } catch (e) {
      bookingAccepted = false;
    }
    String? username;
    try {
      username = data['user_name'];
    } catch (e) {
      username = '#Error';
    }

    String? userId;
    try {
      userId = data['userId'];
    } catch (e) {
      userId = '#Error';
    }

    String? gym_details;
    try {
      gym_details = data['gym_details']['name'];
    } catch (e) {
      gym_details = '#Error';
    }
    String? vendorId;
    try {
      vendorId = data['vendorId'];
    } catch (e) {
      vendorId = '#Error';
    }
    String? gym_address;
    try {
      gym_address = data['gym_address'];
    } catch (e) {
      gym_address = '#Error';
    }
    String? daysLeft;
    try {
      daysLeft = data['daysLeft'];
    } catch (e) {
      daysLeft = '#Error';
    }
    String? gym_branch;
    try {
      gym_branch = data['gym_details']['branch'];
    } catch (e) {
      gym_branch = '#Error';
    }

    String? package_type;
    try {
      package_type = data['package_type'];
    } catch (e) {
      package_type = '#Error';
    }

    String? booking_plan;
    try {
      booking_plan = data['booking_plan'];
    } catch (e) {
      booking_plan = '#Error';
    }

    Timestamp booking_date;
    try {
      booking_date = data['booking_date'];
    } catch (e) {
      booking_date = Timestamp.now();
    }

    Timestamp plan_end_duration;
    try {
      plan_end_duration = data['plan_end_duration'];
    } catch (e) {
      plan_end_duration = Timestamp.now();
    }
    Timestamp order_date;
    try {
      order_date = data['order_date'];
    } catch (e) {
      order_date = Timestamp.now();
    }
    int total_price = 1;
    try {
      total_price = data['total_price'];
    } catch (e) {
      total_price = 0;
    }
    int tax_pay = 1;
    try {
      tax_pay = data['tax_pay'];
    } catch (e) {
      tax_pay = 0;
    }

    int discount = 1;
    try {
      discount = data['discount'];
    } catch (e) {
      discount = 0;
    }
    String? totalDays;
    try {
      totalDays = data['totalDays'];
    } catch (e) {
      totalDays = '#Error';
    }
    // String? gym_address;
    // try {
    //   gym_address = data['gym_address'];
    // } catch (e) {
    //   gym_address = '#Error';
    // }
    String? grand_total;
    try {
      grand_total = data['grand_total'];
    } catch (e) {
      grand_total = '#Error';
    }
    // data['grand_total']
    // data['gym_address']
    String? booking_price;
    try {
      booking_price = data['booking_price'];
    } catch (e) {
      booking_price = '#Error';
    }
    // data['booking_price']
    int id = 1;
    try {
      id = data['id'];
    } catch (e) {
      id = 1;
    }
    String? payment_method;
    try {
      payment_method = data['payment_method'];
    } catch (e) {
      payment_method = '#Error';
    }
    String? booking_status;
    try {
      booking_status = data['booking_status'];
    } catch (e) {
      booking_status = '#Error';
    }

    String durationEnd =
        DateFormat("MMM, dd, yyyy ").format(plan_end_duration.toDate());
    // "${data['plan_end_duration'].toDate().year}/${data['plan_end_duration'].toDate().month}/${data['plan_end_duration'].toDate().day}";
    String orderDate =
        DateFormat("MMM, dd, yyyy hh:mm a").format(order_date.toDate());
    // "${data['order_date'].toDate().year}/${data['order_date'].toDate().month}/${data['order_date'].toDate().day}";
    String bookingDate =
        DateFormat("MMM, dd, yyyy ").format(booking_date.toDate());
    // "${data['booking_date'].toDate().year}/${data['booking_date'].toDate().month}/${data['booking_date'].toDate().day}";
    String x;
    String statement = "";

    return DataRow(cells: [
      DataCell(id != null ? Text(id.toString()) : const Text("")),

      // <<<<<<< HEAD
      // =======
      //
      //
      // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c
      DataCell(username != null ? Text(username.toString()) : const Text("")),
      DataCell(userId != null
          ? Text(userId.toString().substring(3, 13))
          : const Text("")),
      DataCell(gym_details != null
          ? Text(
              '${gym_details.toString().toUpperCase()}\n${gym_branch.toString().toUpperCase()}')
          : const Text("")),

      DataCell(package_type != null
          ? Text(package_type.toString().toUpperCase())
          : const Text("")),
      DataCell(booking_plan != null
          ? Text(booking_plan.toString())
          : const Text("")),

      DataCell(bookingDate != null ? Text(bookingDate) : const Text("")),

      DataCell(plan_end_duration != null ? Text(durationEnd) : const Text("")),
      DataCell(order_date != null ? Text(orderDate) : const Text("")),
      DataCell(total_price != null
          ? Text('₹$total_price'.toString())
          : const Text("")),
      DataCell(
          discount != null ? Text('₹${discount.toString()}') : const Text("")),
      DataCell(grand_total != null
          ? Text('₹${grand_total.toString()}')
          : const Text("")),
      DataCell(payment_method != null
          ? Text(payment_method.toString().toUpperCase())
          : const Text("")),
      // DataCell(Center(
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       bool temp = paymentDoneBool;
      //       temp = !temp;
      //       DocumentReference documentReference = FirebaseFirestore.instance
      //           .collection('bookings')
      //           .doc(bookingId);
      //       await documentReference
      //           .update({'payment_done': temp})
      //           .whenComplete(() => print("Payment done updated"))
      //           .catchError((e) => print(e));
      //     },
      //     child: Text(x = paymentDoneBool ? 'YES' : 'NO'),
      //     style: ElevatedButton.styleFrom(
      //         primary: paymentDoneBool ? Colors.green : Colors.red),
      //   ),
      // )),
      // DataCell(
      //     data['booking_date'] != null ? Text(bookingDate) : const Text("")),

      DataCell(
        Center(
          child: Row(
            children: [
              DropdownButton(
                  hint: Text(booking_status.toString()),
                  value: booking_status.toString(),
                  items: const [
                    DropdownMenuItem(
                      child: Text("Active"),
                      value: "active",
                    ),
                    DropdownMenuItem(
                      child: Text("Upcoming"),
                      value: "upcoming",
                    ),
                    DropdownMenuItem(
                        child: Text("Completed"), value: "completed"),
                    DropdownMenuItem(
                        child: Text("Cancelled"), value: "cancelled"),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      selectedValue = value as String;
                    });

                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .doc(bookingId)
                        .update({'booking_status': value});
                    if (value == "upcoming") {
                      setState(() {
                        statement = "Upcoming Booking";
                      });
                    }
                    if (value == "cancelled") {
                      setState(() {
                        statement = "Cancelled Booking";
                      });
                    }
                    if (value == "active") {
                      setState(() {
                        statement = "Active Booking";
                      });
                    }
                    if (value == "completed") {
                      setState(() {
                        statement = "Completed Booking";
                      });
                    }
                    if (value == "active") {
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(bookingId)
                          .update({'payment_done': true});
                    }
                    // var xps = await FirebaseFirestore.instance
                    //     .collection('booking_notifications')
                    //     .doc()
                    //     .id;

                    await FirebaseFirestore.instance
                        .collection("booking_notifications")
                        .doc()
                        .set({
                      "title": statement,
                      "status": selectedValue,
                      "booking_id": bookingId,
                      // "payment_done": false,
                      // "notification_id": xps.toString(),
                      "branch": gym_branch,
                      "user_id": userId,
                      "user_name": username,
                      "vendor_id": vendorId,
                      "vendor_name": gym_details,

                      'time_stamp': DateTime.now(),
                      'seen': false
                    }).whenComplete(() => const Text('COMPLETED BOOKING'));
                  }),
            ],
          ),
        ),
      ),
// <<<<<<< HEAD
// <<<<<<< HEAD
// =======
// <<<<<<< nihal_new
// >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// =======
//     <<<<<<< HEAD
//     =======
// // <<<<<<< nihal_new
//     >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c
      // DataCell(data['booking_plan'] != null
      //     ? Text(data['booking_plan'].toString())
      //     : const Text("")),
      // DataCell(data['grand_total'] != null
      //     ? Text('₹${data['grand_total'].toString()}')
      //     : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Get.to(
          () => ProductEditBox(
            branch: gym_branch.toString(),
            ids: id.toString(),
            payment_method: payment_method.toString(),
            vendorname: gym_details.toString(),
            vendorid: vendorId.toString(),
            ordertimestamp: order_date,
            username: username.toString(),
            userid: userId.toString(),
            totalprice: total_price.toString(),
            totaldays: totalDays.toString(),
            taxpay: tax_pay.toString(),
            planendyear: plan_end_duration.toDate().year.toString(),
            planendmonth: plan_end_duration.toDate().month.toString(),
            planendday: plan_end_duration.toDate().day.toString(),
            planedate: plan_end_duration.toDate().toString(),
            // planedatehour: data['plan_end_duration'].toHour().toString(),
            paymentdone: paymentDoneBool.toString(),
            packagetype: package_type.toString(),
            orderyear: order_date.toDate().year.toString(),
            ordermonth: order_date.toDate().month.toString(),
            orderday: order_date.toDate().day.toString(),
            orderdate: order_date.toDate().toString(),
            gymname: gym_details.toString(),
            gymaddress: gym_address.toString(),
            grandtotal: grand_total.toString(),
            discount: discount.toString(),
            daysleft: daysLeft.toString(),
            bookingstatus: booking_status.toString(),
            bookingprice: booking_price.toString(),
            bookingplan: booking_plan.toString(),
            bookingid: bookingId.toString(),
            bookingyear: booking_date.toDate().year.toString(),
            bookingmonth: booking_date.toDate().month.toString(),
            bookingdate: booking_date.toDate().toString(),
            bookingday: booking_date.toDate().day.toString(),
            bookingaccepted: bookingAccepted.toString(),
          ),
        );
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return SingleChildScrollView(
        //         child: ProductEditBox(
        //           vendorid: data['vendorId'],
        //           username: data['user_name'],
        //           userid: data['userId'],
        //           totalprice: data['total_price'].toString(),
        //           totaldays: data['totalDays'].toString(),
        //           taxpay: data['tax_pay'].toString(),
        //           planendyear:
        //               data['plan_end_duration'].toDate().year.toString(),
        //           planendmonth:
        //               data['plan_end_duration'].toDate().month.toString(),
        //           planendday: data['plan_end_duration'].toDate().day.toString(),
        //           paymentdone: data['payment_done'].toString(),
        //           packagetype: data['package_type'],
        //           orderyear: data['order_date'].toDate().year.toString(),
        //           ordermonth: data['order_date'].toDate().month.toString(),
        //           orderday: data['order_date'].toDate().day.toString(),
        //           gymname: data["gym_details"]['name'],
        //           gymaddress: data['gym_address'].toString(),
        //           grandtotal: data['grand_total'].toString(),
        //           discount: data['discount'].toString(),
        //           daysleft: data['daysLeft'],
        //           bookingstatus: data['booking_status'],
        //           bookingprice: data['booking_price'].toString(),
        //           bookingplan: data['booking_plan'],
        //           bookingid: data['booking_id'],
        //           bookingyear: data['booking_date'].toDate().year.toString(),
        //           bookingmonth: data['booking_date'].toDate().month.toString(),
        //           bookingday: data['booking_date'].toDate().day.toString(),
        //           bookingaccepted: data['booking_accepted'].toString(),
        //         ),
        //       );
        // }
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: bookingStream, uniqueDocId: bookingId);

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
                                  stream: bookingStream,
                                  uniqueDocId: bookingId);
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

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.hinttext,
    required this.addcontroller,
  }) : super(key: key);

  final TextEditingController addcontroller;
  final String hinttext;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
          child: TextField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: widget.addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: widget.hinttext),
      )),
    );
  }
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.vendorid,
    required this.username,
    required this.userid,
    required this.totalprice,
    required this.totaldays,
    required this.taxpay,
    required this.planendyear,
    required this.planendmonth,
    required this.planendday,
    required this.paymentdone,
    required this.packagetype,
    required this.orderyear,
    required this.ordermonth,
    required this.orderday,
    required this.gymname,
    required this.gymaddress,
    required this.grandtotal,
    required this.discount,
    required this.daysleft,
    required this.bookingstatus,
    required this.bookingprice,
    required this.bookingplan,
    required this.bookingid,
    required this.bookingyear,
    required this.bookingmonth,
    required this.bookingday,
    required this.bookingaccepted,
    required this.planedate,
    required this.orderdate,
    required this.bookingdate,
    required this.vendorname,
    required this.payment_method,
    required this.ids,
    required this.ordertimestamp,
    required this.branch,
  }) : super(key: key);

  final String vendorid;
  final String branch;
  // final String planedatehour;
  final String username;

  final Timestamp ordertimestamp;
  final String ids;
  final String vendorname;
  final String planedate;
  final String orderdate;
  final String bookingdate;
  final String userid;
  final String totalprice;
  final String totaldays;
  final String taxpay;
  final String planendyear;
  final String planendmonth;
  final String planendday;
  final String paymentdone;
  final String packagetype;
  final String orderyear;
  final String ordermonth;
  final String orderday;
  final String gymname;
  final String payment_method;
  final String gymaddress;
  final String grandtotal;
  final String discount;
  final String daysleft;
  final String bookingstatus;
  final String bookingprice;
  final String bookingplan;
  final String bookingid;
  final String bookingyear;
  final String bookingmonth;
  final String bookingday;
  final String bookingaccepted;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _addvendorid = TextEditingController();
  final TextEditingController _addusername = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();
  final TextEditingController _addvendorname = TextEditingController();

  //final TextEditingController _addtotalprice = TextEditingController();
  final TextEditingController _addtotaldays = TextEditingController();
  final TextEditingController _addtaxpay = TextEditingController();
  final TextEditingController _addplanendyear = TextEditingController();
  final TextEditingController _addplanendmonth = TextEditingController();
  final TextEditingController _addplanendday = TextEditingController();
  final TextEditingController _addpaymentdone = TextEditingController();
  final TextEditingController _addpackagetype = TextEditingController();
  final TextEditingController _addorderyear = TextEditingController();
  final TextEditingController _addordermonth = TextEditingController();
  final TextEditingController _addorderday = TextEditingController();
  final TextEditingController _addgymname = TextEditingController();
  final TextEditingController _addgymaddress = TextEditingController();
  final TextEditingController _addgrandtotal = TextEditingController();
  final TextEditingController _adddiscount = TextEditingController();
  final TextEditingController _adddaysletf = TextEditingController();
  final TextEditingController _addbookingstatus = TextEditingController();
  final TextEditingController _addbookingprice = TextEditingController();
  final TextEditingController _addbookingplan = TextEditingController();
  final TextEditingController _addbookingid = TextEditingController();
  final TextEditingController _addbookingyear = TextEditingController();
  final TextEditingController _addbookingmonth = TextEditingController();
  final TextEditingController _addbookingday = TextEditingController();
  final TextEditingController _addbookingaccepted = TextEditingController();
  final TextEditingController _addpayment_method = TextEditingController();

  var ots, dss;
  // DateTime bookingtimedata = DateTime.now();
  // DateTime ordertimedata = DateTime.now();
  // DateTime endtimedata = DateTime.now();
  // DateTime bookingdate = DateTime.now();
  // DateTime orderdatee = DateTime.now();
  DateTime? date;
  DateTime? plandate;
  DateTime? bookingdate;
  DateTime? orderdate;
  TimeOfDay? time;
  TimeOfDay? ptime;
  TimeOfDay? otime;
  DateTime? dateTime;
  DateTime? pdateTime;
  List<String> _bookstatus = ['active', 'upcoming', 'completed', 'cancelled'];
  List<String> _do = ['true', 'false'];
  String _dropdownValue = 'true';
  String dropdownstatusvalue = 'active';
  CollectionReference? categoryStream;
  CollectionReference? vendorIdStream;
  String catdropdown = 'calisthenics';
  String dropdownvalue = "select";
  String abc = 'false';
  String abc2 = 'false';
  String abc3 = 'false';
  String? value;
  Color a = Colors.white;
  String idss = '';
  DateTime? datetimee;
  DateTime? datetimee2;
  DateTime? d1;
  DateTime? d2;
  DateTime? d3;
  String statement = "";
  @override
  void initState() {
    super.initState();
    _addvendorid.text = widget.vendorid;
    _addvendorname.text = widget.vendorname;
    _addusername.text = widget.username;
    _adduserid.text = widget.userid;
    // _addtotalprice.text = widget.totalprice;
    _addtotaldays.text = widget.totaldays;
    _addtaxpay.text = widget.taxpay;
    _addplanendyear.text = widget.planendyear;
    _addplanendmonth.text = widget.planendmonth;
    _addplanendday.text = widget.planendday;
    _addpaymentdone.text = widget.paymentdone;
    _addpackagetype.text = widget.packagetype;
    _addorderyear.text = widget.orderyear;
    _addordermonth.text = widget.ordermonth;
    _addorderday.text = widget.orderday;
    _addgymname.text = widget.gymname;
    _addgymaddress.text = widget.gymaddress;
    _addgrandtotal.text = widget.grandtotal;
    _adddiscount.text = widget.discount;
    _adddaysletf.text = widget.daysleft;
    _addbookingstatus.text = widget.bookingstatus;
    _addbookingprice.text = widget.bookingprice;
    _addbookingplan.text = widget.bookingplan;
    _addbookingid.text = widget.bookingid;
    _addbookingyear.text = widget.bookingyear;
    _addbookingmonth.text = widget.bookingmonth;
    _addbookingday.text = widget.bookingday;
    _addbookingaccepted.text = widget.bookingaccepted;
    _addpayment_method.text = widget.payment_method;
    idss = widget.ids;
    bookingdate = DateTime(
      int.parse(_addbookingyear.text),
      int.parse(_addbookingmonth.text),
      int.parse(_addbookingday.text),
    );
    datetimee2 = DateTime(
      int.parse(_addorderyear.text),
      int.parse(_addordermonth.text),
      int.parse(_addorderday.text),
    );
    plandate = DateTime(
      int.parse(_addplanendyear.text),
      int.parse(_addplanendmonth.text),
      int.parse(_addplanendday.text),
    );
    dss = DateTime.fromMillisecondsSinceEpoch(
        widget.ordertimestamp.millisecondsSinceEpoch);
    ots = DateFormat('dd/MM/yyyy, HH:mm').format(dss);

    // print(widget.address);
    // _address.text = widget.address;
    // _gender.text = widget.gender;
    // _name.text = widget.name;
    // _pincode.text = widget.pincode;
    // _gymiid.text = widget.gymId;
    // _gymowner.text = widget.gymOwner;
    // _landmark.text = widget.landmark;
    // _location.text = "${widget.location.latitude}, ${widget.location.latitude}";
    // _latitudeController.text = widget.location.latitude.toString();
    // _longitudeController.text = widget.location.longitude.toString();
    // print(widget.location.latitude);
    categoryStream = FirebaseFirestore.instance.collection("category");
    vendorIdStream = FirebaseFirestore.instance.collection("product_details");
  }

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Booking'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Center(
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Booking ID: $idss',
                        style: const TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  // Container(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           'Vendor ID:',
                  //           style: TextStyle(
                  //             fontSize: 20,
                  //             fontFamily: 'poppins',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Text(widget.vendorid,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.bold, fontSize: 15)),
                  //       ],
                  //     ),
                  //   ),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(width: 0.5, color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "User Name: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addusername.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "User ID:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(widget.userid,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Gym Name:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(widget.gymname,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Gym Address:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addgymaddress.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Total Days:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addtotaldays.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // customTextField(
                  //     hinttext: "Days Left", addcontroller: _adddaysletf),
                  // Container(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           "Days Left:",
                  //           style: TextStyle(
                  //             fontSize: 20,
                  //             fontFamily: 'poppins',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Text(_adddaysletf.text,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.bold, fontSize: 15)),
                  //       ],
                  //     ),
                  //   ),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(width: 0.5, color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Payment Type:',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(widget.payment_method.toString().toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Package Type:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addpackagetype.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Booking Plan",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addbookingplan.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Booking Price (₹)",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addbookingprice.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Discount (₹):",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_adddiscount.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Grand Total (₹):",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(_addgrandtotal.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Booking Status:',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 20),
                          DropdownButton(
                            hint: Text(_addbookingstatus.text),
                            value: _addbookingstatus.text,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: _bookstatus.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownstatusvalue = newValue!;
                                _addbookingstatus.text = dropdownstatusvalue;
                                check = true;
                              });
                              if (_addbookingstatus.text == "upcoming") {
                                setState(() {
                                  statement = "Upcoming Booking";
                                });
                              }
                              if (_addbookingstatus.text == "cancelled") {
                                setState(() {
                                  statement = "Cancelled Booking";
                                });
                              }
                              if (_addbookingstatus.text == "active") {
                                setState(() {
                                  statement = "Active Booking";
                                });
                              }
                              if (_addbookingstatus.text == "completed") {
                                setState(() {
                                  statement = "Completed Booking";
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Booking Date:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(width: 40),
                      Text(
                        ots.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(width: 40),
                      // ElevatedButton(
                      //     child: const Text('Edit'),
                      //     onPressed: () {
                      //       print(datetimee);
                      //       pickorderDateTime(context);
                      //       print(datetimee2);
                      //     }),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Start Date:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(width: 40),
                      Text(DateFormat.yMMMd().format(bookingdate!).toString()),
                      const SizedBox(width: 40),
                      ElevatedButton(
                          child: const Text('Edit'),
                          onPressed: () {
                            // DateFormat("MMM, dd, yyyy")
                            //     .format(data["booking_date"].toDate());
                            // print(_addbookingyear);

                            print(bookingdate);
                            pickDateTime(context);
                          }),
                      const SizedBox(width: 15),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('End Date:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(width: 40),
                      Text(DateFormat.yMMMd().format(plandate!).toString()),
                      const SizedBox(width: 40),
                      ElevatedButton(
                          child: const Text('Edit'),
                          onPressed: () {
                            print(plandate);
                            pickplanDateTime(context);
                          }),
                      const SizedBox(width: 15),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(_addbookingid.text);

                              FirebaseFirestore.instance
                                  .collection('bookings')
                                  .doc(_addbookingid.text);

                              Map<String, dynamic> data = <String, dynamic>{
                                'plan_end_duration': d2 ?? plandate,

                                'order_date': datetimee2,

                                'booking_status': _addbookingstatus.text,

                                'booking_date': d1 ?? bookingdate,

                                // 'booking_accepted':
                                //     _addbookingaccepted.text == 'true'
                                //         ? true
                                //         : false,
                              };
                              await documentReference
                                  .update(data)
                                  .whenComplete(() => print("Item Updated"))
                                  .catchError((e) => print(e));
                              if (check = true) {
                                await FirebaseFirestore.instance
                                    .collection("booking_notifications")
                                    .doc()
                                    .set({
                                  "title": statement,
                                  "status": _addbookingstatus.text,
                                  "booking_id": widget.bookingid,
                                  // "payment_done": false,
                                  // "notification_id": xps.toString(),
                                  "user_id": _adduserid.text,
                                  "user_name": _addusername.text,
                                  "vendor_id": _addvendorid.text,
                                  "vendor_name": _addvendorname.text,
                                  'time_stamp': DateTime.now(),
                                  'branch': widget.branch,
                                  'seen': false
                                }).whenComplete(
                                        () => const Text('COMPLETED BOOKING'));

                                // var x = await FirebaseFirestore.instance
                                //     .collection("booking_notifications")
                                //     .doc()
                                //     .id;
                                // await FirebaseFirestore.instance
                                //     .collection("booking_notifications")
                                //     .doc(x)
                                //     .set({
                                //   "title": "Booking Details",
                                //   "status": _addbookingstatus.text,
                                //   // "payment_done": false,
                                //   "notification_id": x.toString(),
                                //   "user_id": _adduserid.text,
                                //   "user_name": _addusername.text,
                                //   "vendor_id": _addvendorid.text,
                                //   "vendor_name": _addvendorname.text,
                                //   'time': DateTime.now()
                                // });
                                setState(() {
                                  check = false;
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: const Text('Done'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // );
  }

  //for 'booking_date'
  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      bookingdate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
    d1 = bookingdate;
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
// <<<<<<< HEAD
// <<<<<<< HEAD
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
// =======
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// =======
//         / <<<<<<< HEAD
        await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
//     =======
//     await showTimePicker(context: context, initialTime: time ?? intialTime);
//     >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });

    return newTime;
  }

  //for 'plan_end_duration'
  Future pickplanDateTime(BuildContext context) async {
    var plandate = await pickplanDate(context);
    if (plandate == null) return;

    final ptime = await pickplanTime(context);
    if (ptime == null) return;

    setState(() {
      plandate = DateTime(plandate.year, plandate.month, plandate.day,
          ptime.hour, ptime.minute);
    });
    d2 = plandate;
  }

  Future pickplanDate(BuildContext context) async {
    final intialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: intialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      plandate = newDate;
    });

    return newDate;
  }

  Future pickplanTime(BuildContext context) async {
    const intialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime =
// <<<<<<< HEAD
// <<<<<<< HEAD
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
// =======
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// =======
        // <<<<<<< HEAD
        await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
//     =======
//     await showTimePicker(context: context, initialTime: time ?? intialTime);
//     >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });

    return newTime;
  }

  //for 'order_date'
  Future pickorderDateTime(BuildContext context) async {
    var orderdate = await pickorderDate(context);
    if (orderdate == null) return;

    final otime = await pickorderTime(context);
    if (otime == null) return;

    setState(() {
      datetimee = DateTime(
        orderdate.year,
        orderdate.month,
        orderdate.day,
        otime.hour,
        otime.minute,
      );
      datetimee2 = datetimee;
    });
  }

  Future pickorderDate(BuildContext context) async {
    final intialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: intialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      orderdate = newDate;
    });

    return newDate;
  }

  Future pickorderTime(BuildContext context) async {
    final intialTime = const TimeOfDay(hour: 9, minute: 0);
    final newTime =
        await showTimePicker(context: context, initialTime: time ?? intialTime);

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });

    return newTime;
  }
}

class dropdownvaluena extends StatefulWidget {
  const dropdownvaluena({
    required this.name,
    required this.id,
    Key? key,
  }) : super(key: key);
  final String name;
  final String id;

  @override
  State<dropdownvaluena> createState() => _dropdownvaluenaState();
}

class _dropdownvaluenaState extends State<dropdownvaluena> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      value: widget.id,
      child: Text(widget.name),
    );
  }
}

bool isLess(String txt) {
  if (txt == '0') {
    return true;
  } else if (txt == '1') {
    return true;
  } else if (txt == '2') {
    return true;
  } else if (txt == '3') {
    return true;
  } else if (txt == '4') {
    return true;
  } else if (txt == '5') {
    return true;
  } else if (txt == '6') {
    return true;
  } else if (txt == '7') {
    return true;
  } else if (txt == '8') {
    return true;
  } else if (txt == '9') {
    return true;
  } else {
    return false;
  }
}

class RadioBoxx extends StatefulWidget {
  final String name;
  final String id;
  String? cat;

  RadioBoxx(this.name, this.id, this.cat, {Key? key}) : super(key: key);

  @override
  _RadioBoxxState createState() => _RadioBoxxState();
}

class _RadioBoxxState extends State<RadioBoxx> {
  String check = "calisthenics";
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RadioListTile<String>(
            value: widget.name,
            groupValue: check,
            onChanged: (String? abcd) {
              widget.cat = abcd;
              print(abcd);
            },
            title: Text(widget.name),
          ),
        ],
      ),
    );
  }
}
