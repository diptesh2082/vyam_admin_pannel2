import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  CollectionReference bookingStream =
      FirebaseFirestore.instance.collection('bookings');
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
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .where('booking_status', isEqualTo: 'incomplete')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      // var document=snapshot.data!.docs;
                      //   document = document.where((element) {
                      //     return element
                      //         .get('booking_status')
                      //         .toString()
                      //         .contains("active" || "upcomming");
                      //   }).toList();
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Vendor ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'User Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Total Price',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'Total Days',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'Tax Pay',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Plan End',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Payment done',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Package Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Order Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Gym Name',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'Gym Address',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Grand Total',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Discount',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'Days Left',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Booking Status',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Booking Price',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Booking Plan',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Booking ID',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Booking Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Booking Accepted',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
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
    String bookingId = data['booking_id'];
    bool paymentDoneBool = data['payment_done'];
    bool bookingAccepted = data['booking_accepted'];
    String durationEnd =
        "${data['plan_end_duration'].toDate().year}/${data['plan_end_duration'].toDate().month}/${data['plan_end_duration'].toDate().day}";
    String orderDate =
        "${data['order_date'].toDate().year}/${data['order_date'].toDate().month}/${data['order_date'].toDate().day}";
    String bookingDate =
        "${data['booking_date'].toDate().year}/${data['booking_date'].toDate().month}/${data['booking_date'].toDate().day}";
    return DataRow(cells: [
      DataCell(data["vendorId"] != null
          ? Text(data['vendorId'].toString())
          : const Text("")),
      DataCell(data['user_name'] != null
          ? Text(data['user_name'].toString())
          : const Text("")),
      DataCell(data['userId'] != null
          ? Text(data['userId'].toString())
          : const Text("")),
      // DataCell(data['total_price'] != null
      //     ? Text(data['total_price'].toString())
      //     : const Text("")),
      // DataCell(data['totalDays'] != null
      //     ? Text(data['totalDays'].toString())
      //     : const Text("")),
      // DataCell(data['tax_pay'] != null
      //     ? Text(data['tax_pay'].toString())
      //     : const Text("")),
      DataCell(data['plan_end_duration'] != null
          ? Text(durationEnd)
          : const Text("")),

// <<<<<<< HEAD
//       DataCell(Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             bool temp = paymentDoneBool;
//             temp = !temp;
//             DocumentReference documentReference = FirebaseFirestore.instance
//                 .collection('bookings')
//                 .doc(bookingId);
//             await documentReference
//                 .update({'payment_done': temp})
//                 .whenComplete(() => print("Payment done updated"))
//                 .catchError((e) => print(e));
//           },
//           child: Text(paymentDoneBool.toString()),
//           style: ElevatedButton.styleFrom(
//               primary: paymentDoneBool ? Colors.green : Colors.red),
//         ),
//       )),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {},
            child: data['package_type'] != null
                ? Text(data['package_type'].toString().toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black))
                : const Text(""),
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(245, 190, 0, 1)),
          ),
        ),
        // data['package_type'] != null
        // ? Text(data['package_type'].toString())
        // : const Text("")
      ),
// =======

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
      //     child: Text(paymentDoneBool.toString()),
      //     style: ElevatedButton.styleFrom(
      //         primary: paymentDoneBool ? Colors.green : Colors.red),
      //   ),
      // ),
      // ),

      DataCell(data['order_date'] != null ? Text(orderDate) : const Text("")),
      // DataCell(data['gym_details']['name'] != null
      //     ? Text(data['gym_details']['name'].toString())
      //     : const Text("")),
      // DataCell(data['gym_address'] != null
      //     ? Text(data['gym_address'].toString())
      //     : const Text("")),
      DataCell(data['grand_total'] != null
          ? Text(data['grand_total'].toString())
          : const Text("")),
      // DataCell(data['discount'] != null
      //     ? Text(data['discount'].toString())
      //     : const Text("")),
      // DataCell(data['daysLeft'] != null
      //     ? Text(data['daysLeft'].toString())
      //     : const Text("")),
      DataCell(data['booking_status'] != null
          ? Text(data['booking_status'].toString())
          : const Text("")),
      // DataCell(data['booking_price'] != null
      //     ? Text(data['booking_price'].toString())
      //     : const Text("")),
      DataCell(data['booking_plan'] != null
          ? Text(data['booking_plan'].toString())
          : const Text("")),
      // DataCell(data['booking_id'] != null
      //     ? Text(data['booking_id'].toString())
      //     : const Text("")),
      DataCell(
          data['booking_date'] != null ? Text(bookingDate) : const Text("")),
      // DataCell(Center(
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       bool temp = bookingAccepted;
      //       temp = !temp;
      //       DocumentReference documentReference = FirebaseFirestore.instance
      //           .collection('bookings')
      //           .doc(bookingId);
      //       await documentReference
      //           .update({'booking_accepted': temp})
      //           .whenComplete(() => print("booking accepted updated"))
      //           .catchError((e) => print(e));
      //     },
      //     child: Text(bookingAccepted.toString()),
      //     style: ElevatedButton.styleFrom(
      //         primary: bookingAccepted ? Colors.green : Colors.red),
      //   ),
      // )),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: ProductEditBox(
                  vendorid: data['vendorId'],
                  username: data['user_name'],
                  userid: data['userId'],
                  totalprice: data['total_price'].toString(),
                  totaldays: data['totalDays'].toString(),
                  taxpay: data['tax_pay'].toString(),
                  planendyear:
                      data['plan_end_duration'].toDate().year.toString(),
                  planendmonth:
                      data['plan_end_duration'].toDate().month.toString(),
                  planendday: data['plan_end_duration'].toDate().day.toString(),
                  paymentdone: data['payment_done'].toString(),
                  packagetype: data['package_type'],
                  orderyear: data['order_date'].toDate().year.toString(),
                  ordermonth: data['order_date'].toDate().month.toString(),
                  orderday: data['order_date'].toDate().day.toString(),
                  gymname: data['gym_name'],
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
                  bookingday: data['booking_date'].toDate().day.toString(),
                  bookingaccepted: data['booking_accepted'].toString(),
                ),
              );
            });
      }),
      DataCell(Icon(Icons.delete), onTap: () {
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
          fontSize: 14,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: widget.addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 14,
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
  }) : super(key: key);

  final String vendorid;
  final String username;
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
  final TextEditingController _addtotalprice = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _addvendorid.text = widget.vendorid;
    _addusername.text = widget.username;
    _adduserid.text = widget.userid;
    _addtotalprice.text = widget.totalprice;
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
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                'Update Records for this doc',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              CustomTextField(
                  hinttext: "Vendor ID", addcontroller: _addvendorid),
              CustomTextField(
                  hinttext: "User Name", addcontroller: _addusername),
              CustomTextField(hinttext: "User ID", addcontroller: _adduserid),
              CustomTextField(
                  hinttext: "Total Price", addcontroller: _addtotalprice),
              CustomTextField(
                  hinttext: "Total Days", addcontroller: _addtotaldays),
              CustomTextField(hinttext: "Tax Pay", addcontroller: _addtaxpay),
              CustomTextField(
                  hinttext: "Plan End Y", addcontroller: _addplanendyear),
              CustomTextField(
                  hinttext: "Plan End M", addcontroller: _addplanendmonth),
              CustomTextField(
                  hinttext: "Plan End D", addcontroller: _addplanendday),
              CustomTextField(
                  hinttext: "Payment Done", addcontroller: _addpaymentdone),
              CustomTextField(
                  hinttext: "Package Type", addcontroller: _addpackagetype),
              CustomTextField(
                  hinttext: "Order Date Y", addcontroller: _addorderyear),
              CustomTextField(
                  hinttext: "Order Date M", addcontroller: _addordermonth),
              CustomTextField(
                  hinttext: "Order Date D", addcontroller: _addorderday),
              CustomTextField(hinttext: "Gym Name", addcontroller: _addgymname),
              CustomTextField(
                  hinttext: "Gym Address", addcontroller: _addgymaddress),
              CustomTextField(
                  hinttext: "Grand Total", addcontroller: _addgrandtotal),
              CustomTextField(
                  hinttext: "Discount", addcontroller: _adddiscount),
              CustomTextField(
                  hinttext: "Days Left", addcontroller: _adddaysletf),
              CustomTextField(
                  hinttext: "Booking Status", addcontroller: _addbookingstatus),
              CustomTextField(
                  hinttext: "Booking Price", addcontroller: _addbookingprice),
              CustomTextField(
                  hinttext: "Booking Plan", addcontroller: _addbookingplan),
              CustomTextField(
                  hinttext: "booking ID", addcontroller: _addbookingid),
              CustomTextField(
                  hinttext: "Booking Date Y", addcontroller: _addbookingyear),
              CustomTextField(
                  hinttext: "Booking Date M", addcontroller: _addbookingmonth),
              CustomTextField(
                  hinttext: "Booking Date D", addcontroller: _addbookingday),
              CustomTextField(
                  hinttext: "Booking Accepted",
                  addcontroller: _addbookingaccepted),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('bookings')
                          .doc(_addbookingid.text);
                      DateTime endtimedata = DateTime.parse(
                          '${_addplanendyear.text}-${isLess(_addplanendmonth.text) ? '0' + _addplanendmonth.text : _addplanendday.text}-${isLess(_addplanendday.text) ? '0' + _addplanendday.text : _addplanendday.text} 00:00:04Z');
                      DateTime ordertimedata = DateTime.parse(
                          '${_addorderyear.text}-${isLess(_addordermonth.text) ? '0' + _addordermonth.text : _addordermonth.text}-${isLess(_addorderday.text) ? '0' + _addorderday.text : _addorderday.text} 00:00:04Z');
                      DateTime bookingtimedata = DateTime.parse(
                          '${_addbookingyear.text}-${isLess(_addbookingmonth.text) ? '0' + _addbookingmonth.text : _addbookingmonth.text}-${isLess(_addbookingday.text) ? '0' + _addbookingday.text : _addbookingday.text} 00:00:04Z');

                      Map<String, dynamic> data = <String, dynamic>{
                        'vandorId': _addvendorid.text,
                        'user_name': _addusername.text,
                        'userId': _adduserid.text,
                        'total_price': _addtotalprice.text,
                        'totalDays': _addtotalprice.text,
                        'tax_pay': _addtaxpay.text,
                        'plan_end_duration': endtimedata,
                        'payment_done':
                            _addpaymentdone.text == 'true' ? true : false,
                        'package_type': _addpackagetype.text,
                        'order_date': ordertimedata,
                        'gym_name': _addgymname.text,
                        'gym_address': _addgymaddress.text,
                        'grand_total': _addgrandtotal.text,
                        'discount': _adddiscount.text,
                        'daysLeft': _adddaysletf.text,
                        'booking_status': _addbookingstatus.text,
                        'booking_price': _addbookingprice.text,
                        'booking_plan': _addbookingplan.text,
                        'booking_id': _addbookingid.text,
                        'booking_date': bookingtimedata,
                        'booking_accepted':
                            _addbookingaccepted.text == 'true' ? true : false,
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
