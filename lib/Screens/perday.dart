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

class perday extends StatefulWidget {
  const perday({Key? key}) : super(key: key);

  @override
  State<perday> createState() => _perdayState();
}

bool showEndDate = false;
bool showStartDate = false;

class _perdayState extends State<perday> {
  CollectionReference bookingStream =
      FirebaseFirestore.instance.collection('bookings');
  String searchVendorId = '';
  var selectedValue = 'active';
  DateTime? date;
  DateTime startDate = DateTime(DateTime.now().year - 5);
  DateTime endDate = DateTime(DateTime.now().year + 5);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: SafeArea(
// <<<<<<< HEAD
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
// <<<<<<< HEAD
// =======
                  ),
                  SizedBox(
                    height: 30,
                  ),
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
                  Container(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.date_range,
                    ),
                  ),
                  Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bookings')
                          .where('booking_plan', whereIn: [
                        'Pay per Day',
                        'pay per session',
                        'PAY PER SESSION',
                        'Pay per session'
                      ]).snapshots(),
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

// <<<<<<< HEAD
                        if (searchVendorId.isNotEmpty) {
                          doc = doc.where((element) {
                            return element
// <<<<<<< HEAD
//                                   .get('user_name')
// =======

                                    .get('user_name')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchVendorId.toString()) ||
                                element
                                    .get('userId')

// >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchVendorId.toString()) ||
                                element
                                    .get('grand_total')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchVendorId.toString()) ||
                                element
                                    .get('grand_total')
                                    .toString()
                                    .toLowerCase()
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
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'User ID',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                    label: Text(
                                  'Vendor Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )),
                                DataColumn(
                                  label: Text(
                                    'Category',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Package Type',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Total Days',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Start Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),

                                DataColumn(
                                  label: Text(
                                    'End Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Booking Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Discount',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Grand Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
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

                                // DataColumn(
                                //   label: Text(
                                //     // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
                                //     'Booking Status',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.w600),
                                //   ),
                                // ),
                                DataColumn(
                                  label: Text(
                                    'Edit',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Delete',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                              rows:
                                  _buildlist(context, doc, startDate, endDate)),
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
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          page.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.teal),
                        ),
                      ),
                      ElevatedButton(
                        child: Text("Next Page"),
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
// =======
        // var y = endDate.difference(startDate).inDays;
        // <<<<<<< HEAD
        // print('XXXXXXXXXXXXXXXXXXX???????????????????////////////');
        // print(x);
        // if (x.isAfter(startDate) && x.isBefore(endDate) ||
        // x == startDate ||
        // x == endDate) {
        // d.add(element);
        // }
        // print('/////////////////DDDDDDDDDDDDDDDDDDDD???????????????');
        // print(d);
        // =======
        // print('XXXXXXXXXXXXXXXXXXX???????????????????////////////');
        // print(x);
//       if (x.isAfter(startDate) && x.isBefore(endDate) ||
//           x == startDate ||
//           x == endDate) {
//         d.add(element);
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c
      }
      // print('/////////////////DDDDDDDDDDDDDDDDDDDD???????????????');
      // print(d);
      // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
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

      // <<<<<<< HEAD
      // =======
      //
      //
      // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c
      DataCell(data['user_name'] != null
          ? Text(data['user_name'].toString())
          : const Text("")),
      DataCell(data['userId'] != null
          ? Text(data['userId'].toString().substring(3, 13))
          : Text("")),
      DataCell(data["gym_details"] != null
          ? Text(
              '${data['gym_details']['name'].toString().toUpperCase()}|${data['gym_details']['branch'].toString().toUpperCase()}')
          : const Text("")),

      DataCell(data['package_type'] != null
          ? Text(data['package_type'].toString().toUpperCase())
          : const Text("")),
      DataCell(data['booking_plan'] != null
          ? Text(data['booking_plan'].toString())
          : const Text("")),
      DataCell(data['totalDays'] != null
          ? Text(data['totalDays'].toString())
          : const Text("")),

      // DataCell(data['order_date'] != null ? Text(orderDate) : const Text("")),
      // =======
      DataCell(data['booking_date'] != null ? Text(orderDate) : const Text("")),

      // >>>>>>> e7a2f855481cf7af1fb6b535cb09e976cfd11949
// >>>>>>> ae7259e7ba6e19ed4976a35667cb3a762fe66e2c
      DataCell(data['plan_end_duration'] != null
          ? Text(durationEnd)
          : const Text("")),
      DataCell(data['order_date'] != null ? Text(orderDate) : const Text("")),
      DataCell(data['discount'] != null
          ? Text('₹${data['discount'].toString()}')
          : const Text("")),
      DataCell(data['grand_total'] != null
          ? Text('₹${data['grand_total'].toString()}')
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

      // DataCell(
      //   Center(
      //     child: Container(
      //       child: Row(
      //         children: [
      //           DropdownButton(
      //               hint: Text(data['booking_status'].toString()),
      //               value: data['booking_status'].toString(),
      //               items: const [
      //                 DropdownMenuItem(
      //                   child: Text("Active"),
      //                   value: "active",
      //                 ),
      //                 DropdownMenuItem(
      //                   child: Text("Upcoming"),
      //                   value: "upcoming",
      //                 ),
      //                 DropdownMenuItem(
      //                     child: Text("Completed"), value: "completed"),
      //                 DropdownMenuItem(
      //                     child: Text("Cancelled"), value: "cancelled"),
      //               ],
      //               onChanged: (value) async {
      //                 setState(() {
      //                   selectedValue = value as String;
      //                 });
      //                 await FirebaseFirestore.instance
      //                     .collection('bookings')
      //                     .doc(bookingId)
      //                     .update({'booking_status': value});
      //
      //                 if (value == "active") {
      //                   await FirebaseFirestore.instance
      //                       .collection('bookings')
      //                       .doc(bookingId)
      //                       .update({'payment_done': true});
      //                   await FirebaseFirestore.instance
      //                       .collection("booking_notifications")
      //                       .doc()
      //                       .set({
      //                     "title": "Booking Details",
      //                     "status": selectedValue,
      //                     // "payment_done": false,
      //                     "user_id": data['userId'],
      //                     "user_name": data["user_name"],
      //                     "vendor_id": data['vendorId'],
      //                     "vendor_name": data['gym_details']['name'],
      //                   });
      //                 }
      //               }),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
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
        Get.to(() => ProductEditBox(
              vendorname: data['gym_details']['name'],
              vendorid: data['vendorId'],
              username: data['user_name'],
              userid: data['userId'],
              totalprice: data['total_price'].toString(),
              totaldays: data['totalDays'].toString(),
              taxpay: data['tax_pay'].toString(),
              planendyear: data['plan_end_duration'].toDate().year.toString(),
              planendmonth: data['plan_end_duration'].toDate().month.toString(),
              planendday: data['plan_end_duration'].toDate().day.toString(),
              planedate: data['plan_end_duration'].toDate().toString(),
              paymentdone: data['payment_done'].toString(),
              packagetype: data['package_type'],
              orderyear: data['order_date'].toDate().year.toString(),
              ordermonth: data['order_date'].toDate().month.toString(),
              orderday: data['order_date'].toDate().day.toString(),
              orderdate: data['order_date'].toDate().toString(),
              gymname: data["gym_details"]['name'],
              gymaddress: data['gym_address'].toString(),
              grandtotal: data['grand_total'].toString(),
              discount: data['discount'].toString(),
              daysleft: data['daysLeft'],
              bookingstatus: data['booking_status'],
              bookingprice: data['booking_price'].toString(),
              bookingplan: data['booking_plan'],
              bookingid: data['booking_id'],
              bookingyear: data['booking_date'].toDate().year.toString(),
              bookingmonth: data['booking_date'].toDate().month.toString(),
              bookingdate: data['booking_date'].toDate().toString(),
              bookingday: data['booking_date'].toDate().day.toString(),
              bookingaccepted: data['booking_accepted'].toString(),
              payment_method: data['payment_method'],
              ids: data['id'].toString(),
              ordertimestamp: data['order_date'],
            ));
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: bookingStream, uniqueDocId: bookingId);
      })
    ]);
  }

//
// showAddbox() => showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(30))),
//           content: SizedBox(
//             height: 480,
//             width: 800,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Add Records',
//                     style: TextStyle(
//                         fontFamily: 'poppins',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14),
//                   ),
//                   CustomTextField(
//                       hinttext: "Vendor ID", addcontroller: _addvendorid),
//                   CustomTextField(
//                       hinttext: "User Name", addcontroller: _addusername),
//                   CustomTextField(
//                       hinttext: "User ID", addcontroller: _adduserid),
//                   CustomTextField(
//                       hinttext: "Total Price", addcontroller: _addtotalprice),
//                   CustomTextField(
//                       hinttext: "Total Days", addcontroller: _addtotaldays),
//                   CustomTextField(
//                       hinttext: "Tax Pay", addcontroller: _addtaxpay),
//                   CustomTextField(
//                       hinttext: "Plan End Y", addcontroller: _addplanendyear),
//                   CustomTextField(
//                       hinttext: "Plan End M",
//                       addcontroller: _addplanendmonth),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addplanendday),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addpaymentdone),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addpackagetype),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addorderyear),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addordermonth),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addorderday),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addgymname),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addgymaddress),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addgrandtotal),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _adddiscount),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _adddaysletf),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingstatus),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingprice),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingplan),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingid),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingyear),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingmonth),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingday),
//                   CustomTextField(
//                       hinttext: "Name", addcontroller: _addbookingaccepted),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         final querySnapshot = FirebaseFirestore.instance
//                             .collection('bookings')
//                             .doc("'data['userId']'")
//                             .collection('user_booking')
//                             .doc("data['booking_id']");
//                         querySnapshot.update({'booking_price': 20});
//                         // FirebaseFirestore.instance
//                         //     .collectionGroup('user_booking')
//                         //     .doc(_addgymId.text)
//                         //     .set(
//                         //   {
//                         //     // 'address': _addaddress.text,
//                         //     // 'gender': _addgender.text,
//                         //     // 'name': _addname.text,
//                         //     // 'pincode': _addpincode.text,
//                         //     // 'location': _addlocation.text,
//                         //     // 'gym_id': _addlandmark.text,
//                         //     // 'gym_owner': _addgymowner.text,
//                         //     // 'landmark': _addlandmark.text
//                         //   },
//                         // );
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Done'),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));

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
// <<<<<<< HEAD
//         autofocus: true,
//         style: const TextStyle(
//           fontSize: 20,
//           fontFamily: 'poppins',
//           fontWeight: FontWeight.w400,
//         ),
//         controller: widget.addcontroller,
//         maxLines: 3,
//         decoration: InputDecoration(
//             border: InputBorder.none,
//             hintStyle: const TextStyle(
// =======
        autofocus: true,
        style: const TextStyle(
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
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
  }) : super(key: key);

  final String vendorid;
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
  DateTime bookingtimedata = DateTime.now();
  DateTime ordertimedata = DateTime.now();
  DateTime endtimedata = DateTime.now();
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
        title: Text('Edit Booking'),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Center(
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Booking ID: ${idss}',
                        style: TextStyle(
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
                          Text(
                            "User Name: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addusername.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "User ID:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(widget.userid,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Gym Name:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(widget.gymname,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Gym Address:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addgymaddress.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Total Days:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addtotaldays.text,
                              style: TextStyle(
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Payment Type:',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(widget.payment_method.toString().toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Package Type:",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addpackagetype.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Booking Plan",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addbookingplan.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Booking Price (₹)",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addbookingprice.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Discount (₹):",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_adddiscount.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Grand Total (₹):",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(_addgrandtotal.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Booking Status:',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 20),
                          DropdownButton(
                            value: dropdownstatusvalue,
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

                  SizedBox(
                    height: 20,
                  ),
                  // CustomTextField(
                  //     hinttext: "booking ID", addcontroller: _addbookingid),

                  // Container(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Row(
                  //       children: [
                  //         Text('Booking Accepted By GYM Owner:',
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //               fontFamily: 'poppins',
                  //               fontWeight: FontWeight.w400,
                  //             )),
                  //         SizedBox(width: 20),
                  //         Text(_addbookingaccepted.text.toUpperCase(),
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

                  Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Booking Date:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(width: 40),
                        Text(
                          ots.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(width: 40),
                        // ElevatedButton(
                        //     child: const Text('Edit'),
                        //     onPressed: () {
                        //       print(datetimee);
                        //       pickorderDateTime(context);
                        //       print(datetimee2);
                        //     }),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Start Date:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(width: 40),
                        Text(
                            DateFormat.yMMMd().format(bookingdate!).toString()),
                        SizedBox(width: 40),
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
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('End Date:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(width: 40),
                        Text(DateFormat.yMMMd().format(plandate!).toString()),
                        SizedBox(width: 40),
                        ElevatedButton(
                            child: const Text('Edit'),
                            onPressed: () {
                              print(plandate);
                              pickplanDateTime(context);
                            }),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                  SizedBox(
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
                                'plan_end_duration': plandate,

                                'order_date': datetimee2,

                                'booking_status': _addbookingstatus.text,

                                'booking_date': bookingdate,

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
                                  "title": "Booking Details",
                                  "status": _addbookingstatus.text,
                                  // "payment_done": false,
                                  "user_id": _adduserid.text,
                                  "user_name": _addusername.text,
                                  "vendor_id": _addvendorid.text,
                                  "vendor_name": _addvendorname.text,
                                  'time': DateTime.now()
                                });
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
      bookingdate = DateTime(
        date.year,
        date.month,
        date.day,
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

  Future pickTime(BuildContext context) async {
    const intialTime = const TimeOfDay(hour: 9, minute: 0);
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
      plandate = DateTime(
        plandate.year,
        plandate.month,
        plandate.day,
      );
    });
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
    final intialTime = TimeOfDay(hour: 9, minute: 0);
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
          Container(
            child: RadioListTile<String>(
              value: widget.name,
              groupValue: check,
              onChanged: (String? abcd) {
                widget.cat = abcd;
                print(abcd);
              },
              title: Text(widget.name),
            ),
          ),
        ],
      ),
    );
  }
}
