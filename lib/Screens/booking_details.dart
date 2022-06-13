import 'package:admin_panel_vyam/Screens/Product%20Details/Packages/packages.dart';
import 'package:admin_panel_vyam/Screens/Product%20Details/product_details.dart';
import 'package:admin_panel_vyam/Screens/booking_add.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../services/deleteMethod.dart';

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
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Get.to(const addbookings()); //showAddbox,
                      },
                      child: const Text('Add Booking')),
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
                        if (value.length == 0) {
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
                        .where('booking_status', whereIn: [
                          'completed',
                          'active',
                          'upcoming',
                          'cancelled'
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

                      if (searchVendorId.length > 0) {
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
                              DataColumn(
                                  label: Text(
                                'Vendor Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Category',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Package Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Days',
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
                                  'Plan End',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Discount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Grand Total',
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
                                  'Booking Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking Status',
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
                            rows: _buildlist(context, doc)),
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
      DataCell(data['order_date'] != null ? Text(orderDate) : const Text("")),
      DataCell(data['plan_end_duration'] != null
          ? Text(durationEnd)
          : const Text("")),
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
      DataCell(
          data['booking_date'] != null ? Text(bookingDate) : const Text("")),
      DataCell(
        Center(
          child: Container(
            child: Row(
              children: [
                DropdownButton(
                    hint: Text(data['booking_status'].toString()),
                    value: data['booking_status'].toString(),
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
                          child: Text("Incomplete"), value: "incomplete"),
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
                    }),
              ],
            ),
          ),
        ),
      ),
      // DataCell(data['booking_plan'] != null
      //     ? Text(data['booking_plan'].toString())
      //     : const Text("")),
      // DataCell(data['grand_total'] != null
      //     ? Text('₹${data['grand_total'].toString()}')
      //     : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Get.to(
          () => ProductEditBox(
            vendorid: data['vendorId'],
            username: data['user_name'],
            userid: data['userId'],
            totalprice: data['total_price'].toString(),
            totaldays: data['totalDays'].toString(),
            taxpay: data['tax_pay'].toString(),
            planendyear: data['plan_end_duration'].toDate().year.toString(),
            planendmonth: data['plan_end_duration'].toDate().month.toString(),
            planendday: data['plan_end_duration'].toDate().day.toString(),
            paymentdone: data['payment_done'].toString(),
            packagetype: data['package_type'],
            orderyear: data['order_date'].toDate().year.toString(),
            ordermonth: data['order_date'].toDate().month.toString(),
            orderday: data['order_date'].toDate().day.toString(),
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
            bookingday: data['booking_date'].toDate().day.toString(),
            bookingaccepted: data['booking_accepted'].toString(),
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
  DateTime bookingtimedata = DateTime.now();
  DateTime ordertimedata = DateTime.now();
  DateTime endtimedata = DateTime.now();
  DateTime? date;
  DateTime? plandate;
  TimeOfDay? time;
  TimeOfDay? ptime;
  TimeOfDay? otime;
  DateTime? dateTime;
  DateTime? pdateTime;
  DateTime? orderdate;
  List<String> _bookstatus = ['active', 'upcoming', 'completed'];
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
  @override
  void initState() {
    super.initState();
    _addvendorid.text = widget.vendorid;
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
                  const Center(
                    child: Text(
                      'Update Records for this doc',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 25),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Vendor ID:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                      child: StreamBuilder<QuerySnapshot>(
// // <<<<<<< HEAD
//                     stream: vendorIdStream!.snapshots(),
//                     builder: (context, AsyncSnapshot snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       }
//                       if (snapshot.data == null) {
//                         return Container();
//                       }
//                       print("-----------------------------------");
//                       var doc = snapshot.data.docs;
//                       return Container(
//                         width: 500,
//                         height: 200,
//                         child: ListView.builder(
//                             itemCount: doc.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               bool check = false;
//                               return RadioListTile<String>(
//                                 value: doc[index]["gym_id"],
//                                 groupValue: abc3,
//                                 onChanged: (val) => setState(
//                                   () {
//                                     abc3 = val!;
//                                   },
//                                 ),
//                                 title: Text(doc[index]["gym_id"]),
//                               );
//                               // ListTile(
//                               //   title: Text(doc[index]["name"]),
//                               //   onTap: () {
//                               //     _addgymname.text = doc[index]["name"];
//                               //   },
//                               // );
//                             }),
//                       );
//                     },
//                   )),
//                   const SizedBox(height: 15),
//                   // customTextField(
//                   //     hinttext: "Vendor ID", addcontroller: _addvendorid),
//                   customTextField(
//                       hinttext: "User Name", addcontroller: _addusername),
//                   customTextField(
//                       hinttext: "User ID", addcontroller: _adduserid),
//                   // CustomTextField(
//                   //     hinttext: "Total Price", addcontroller: _addtotalprice),
//                   customTextField(
//                       hinttext: "Total Days", addcontroller: _addtotaldays),
//                   // CustomTextField(
//                   //     hinttext: "Tax Pay", addcontroller: _addtaxpay),
//                   // Container(
//                   //   child: Row(
//                   //     children: [
//                   //       ElevatedButton(
//                   //         child: const Text('Select Date & Time for Plan'),
//                   //         onPressed: () => pickDateTime(context, endtimedata),
//                   //       ),
//                   //       SizedBox(width: 15),
//                   //     ],
//                   //   ),
//                   // ),
//                   Container(
//                     child: Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text('Select Date & Time For Plan:',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               )),
//                         ),
//                         ElevatedButton(
//                           child: const Text('Select Date & Time For Plan'),
//                           onPressed: () => pickplanDateTime(context),
//                         ),
//                         SizedBox(width: 15),
//                       ],
//                     ),
//                   ),
//                   // customTextField(
//                   //     hinttext: "Plan End Y", addcontroller: _addplanendyear),
//                   // customTextField(
//                   //     hinttext: "Plan End M", addcontroller: _addplanendmonth),
//                   // customTextField(
//                   //     hinttext: "Plan End D", addcontroller: _addplanendday),
//                   const SizedBox(height: 15),
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text('Payment Done:',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 15)),
//                   ),
//                   DropdownButton<String>(
//                     isExpanded: true,
//                     hint: Text("Payment Done"),
//                     items: _do.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         this._dropdownValue = newValue!;
//                         _addpaymentdone.text = _dropdownValue;
//                         print(_dropdownValue);
//                       });
//                     },
//                     value: _dropdownValue,
//                   ),
//                   // customTextField(

                    stream: vendorIdStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");
                      var doc = snapshot.data.docs;
                      return Container(
                        width: 500,
                        height: 200,
                        child: ListView.builder(
                            itemCount: doc.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool check = false;
                              return RadioListTile<String>(
                                value: doc[index]["gym_id"],
                                groupValue: abc3,
                                onChanged: (val) => setState(
                                  () {
                                    abc3 = val!;
                                  },
                                ),
                                title: Text(doc[index]["gym_id"]),
                              );
                              // ListTile(
                              //   title: Text(doc[index]["name"]),
                              //   onTap: () {
                              //     _addgymname.text = doc[index]["name"];
                              //   },
                              // );
                            }),
                      );
                    },
                  )),
                  const SizedBox(height: 15),
                  // customTextField(
                  //     hinttext: "Vendor ID", addcontroller: _addvendorid),
                  customTextField(
                      hinttext: "User Name", addcontroller: _addusername),
                  customTextField(
                      hinttext: "User ID", addcontroller: _adduserid),
                  // CustomTextField(
                  //     hinttext: "Total Price", addcontroller: _addtotalprice),
                  customTextField(
                      hinttext: "Total Days", addcontroller: _addtotaldays),
                  // CustomTextField(
                  //     hinttext: "Tax Pay", addcontroller: _addtaxpay),
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       ElevatedButton(
                  //         child: const Text('Select Date & Time for Plan'),
                  //         onPressed: () => pickDateTime(context, endtimedata),
                  //       ),
                  //       SizedBox(width: 15),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Select Date & Time For Plan:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        ElevatedButton(
                          child: const Text('Select Date & Time For Plan'),
                          onPressed: () => pickplanDateTime(context),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                  // customTextField(
                  //     hinttext: "Plan End Y", addcontroller: _addplanendyear),
                  // customTextField(
                  //     hinttext: "Plan End M", addcontroller: _addplanendmonth),
                  // customTextField(
                  //     hinttext: "Plan End D", addcontroller: _addplanendday),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Payment Done:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Payment Done"),
                    items: _do.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        this._dropdownValue = newValue!;
                        _addpaymentdone.text = _dropdownValue;
                        print(_dropdownValue);
                      });
                    },
                    value: _dropdownValue,
                  ),
                  // customTextField(
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                  //     hinttext: "Payment Done", addcontroller: _addpaymentdone),
                  customTextField(
                      hinttext: "Package Type", addcontroller: _addpackagetype),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Package Type:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: categoryStream!.snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.data == null) {
                          return Container();
                        }
                        print("-----------------------------------");
                        var doc = snapshot.data.docs;
                        return Container(
                          width: 400,
                          height: 200,
                          child: ListView.builder(
                              itemCount: doc.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool check = false;
                                return
                                    // RadioBoxx(
                                    //   doc[index]["name"],
                                    //   doc[index]["category_id"],
                                    //   _addpackagetype.text,
                                    // );
                                    RadioListTile<String>(
                                  value: doc[index]["name"],
                                  groupValue: abc,
                                  onChanged: (val) => setState(
                                    () {
                                      abc = val!;
                                    },
                                  ),
                                  title: Text(doc[index]["name"]),
                                );
// =======
                                // RadioBoxx(
                                //   doc[index]["name"],
                                //   doc[index]["category_id"],
                                //   _addpackagetype.text,
                                // );
                                RadioListTile<String>(
                                  value: doc[index]["name"],
                                  groupValue: abc,
                                  onChanged: (val) => setState(
                                    () {
                                      abc = val!;
                                    },
                                  ),
                                  title: Text(doc[index]["name"]),
                                );
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                                //     ListTile(
                                //   tileColor: a,
                                //   title: Text(doc[index]["name"]),
                                //   onTap: () {
                                //     _addpackagetype.text = doc[index]["name"];
                                //     print(doc[index]["name"]);
                                //     setState(() {
                                //       a = Colors.black12;
                                //     });
                                //   },
                                // );
                              }),
                        );
                      },
                    ),
                  ),
                  // )),
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       ElevatedButton(
                  //         child: const Text('Select Date & Time for Order'),
                  //         onPressed: () => pickDateTime(context, ordertimedata),
                  //       ),
                  //       SizedBox(width: 15),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Select Date & Time For Order:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        ElevatedButton(
                          child: const Text('Select Date & Time For Order'),
                          onPressed: () => pickorderDateTime(context),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  // customTextField(
                  //     hinttext: "Order Date Y", addcontroller: _addorderyear),
                  // customTextField(
                  //     hinttext: "Order Date M", addcontroller: _addordermonth),
                  // customTextField(
                  //     hinttext: "Order Date D", addcontroller: _addorderday),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Gym Name:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                      child: StreamBuilder<QuerySnapshot>(
//
                    stream: vendorIdStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");
                      var doc = snapshot.data.docs;
                      return Container(
                        width: 400,
                        height: 300,
                        child: ListView.builder(
                            itemCount: doc.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool check = false;
                              return RadioListTile<String>(
                                value: doc[index]["name"],
                                groupValue: abc2,
                                onChanged: (val) => setState(
                                  () {
                                    abc2 = val!;
                                  },
                                ),
                                title: Text(doc[index]["name"]),
                              );
                              // ListTile(
                              //   title: Text(doc[index]["name"]),
                              //   onTap: () {
                              //     _addgymname.text = doc[index]["name"];
                              //   },
                              // );
                            }),
                      );
                    },
                  )),

                  // customTextField(
                  //     hinttext: "Gym Name", addcontroller: _addgymname),
                  customTextField(
                      hinttext: "Gym Address", addcontroller: _addgymaddress),
                  customTextField(
                      hinttext: "Grand Total (₹)",
                      addcontroller: _addgrandtotal),
                  customTextField(
                      hinttext: "Discount (₹)", addcontroller: _adddiscount),
                  customTextField(
                      hinttext: "Days Left", addcontroller: _adddaysletf),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Booking Status:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
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
                      });
                    },
                  ),
                  // customTextField(
                  //     hinttext: "Booking Status",
                  //     addcontroller: _addbookingstatus),
                  customTextField(
                      hinttext: "Booking Price (₹)",
                      addcontroller: _addbookingprice),
                  customTextField(
                      hinttext: "Booking Plan", addcontroller: _addbookingplan),
                  // CustomTextField(
                  //     hinttext: "booking ID", addcontroller: _addbookingid),

                  Container(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Select Date & Time For Bookings:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        ElevatedButton(
                          child: const Text('Select Date & Time For Bookings'),
                          onPressed: () => pickDateTime(context),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                  // customTextField(
                  //     hinttext: "Booking Date Y",
                  //     addcontroller: _addbookingyear),
                  // customTextField(
                  //     hinttext: "Booking Date M",
                  //     addcontroller: _addbookingmonth),
                  // customTextField(
                  //     hinttext: "Booking Date D",
                  //     addcontroller: _addbookingday),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Booking Accepted:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Booking Accepted"),
                    items: _do.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        this._dropdownValue = newValue!;
                        _addbookingaccepted.text = _dropdownValue;
                        print(_dropdownValue);
                      });
                    },
                    value: _dropdownValue,
                  ),
                  // customTextField(
                  //     hinttext: "Booking Accepted",
                  //     addcontroller: _addbookingaccepted),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              DocumentReference documentReference =
// <<<<<<< HEAD
//                                   FirebaseFirestore.instance
//                                       .collection('bookings')
//                                       .doc(_addbookingid.text);
// =======
                                  FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(_addbookingid.text);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                              // DateTime endtimedata = DateTime.parse(
                              //     '${_addplanendyear.text}-${isLess(_addplanendmonth.text) ? '0' + _addplanendmonth.text : _addplanendday.text}-${isLess(_addplanendday.text) ? '0' + _addplanendday.text : _addplanendday.text} 00:00:04Z');
                              // DateTime ordertimedata = DateTime.parse(
                              //     '${_addorderyear.text}-${isLess(_addordermonth.text) ? '0' + _addordermonth.text : _addordermonth.text}-${isLess(_addorderday.text) ? '0' + _addorderday.text : _addorderday.text} 00:00:04Z');
                              // DateTime bookingtimedata = DateTime.parse(
                              //     '${_addbookingyear.text}-${isLess(_addbookingmonth.text) ? '0' + _addbookingmonth.text : _addbookingmonth.text}-${isLess(_addbookingday.text) ? '0' + _addbookingday.text : _addbookingday.text} 00:00:04Z');

                              Map<String, dynamic> data = <String, dynamic>{
                                'vandorId': abc3,
                                'user_name': _addusername.text,
                                'userId': _adduserid.text,
                                // 'total_price': _addtotalprice.text,
                                'totalDays': _addtotaldays.text,
                                'tax_pay': _addtaxpay.text,
                                'plan_end_duration': endtimedata,
                                'payment_done': _addpaymentdone.text == 'true'
                                    ? true
                                    : false,
                                'package_type': abc,
                                'order_date': ordertimedata,
                                'gym_name': abc2,
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
// <<<<<<< HEAD
//                                     _addbookingaccepted.text == 'true'
//                                         ? true
//                                         : false,
// =======
                                    _addbookingaccepted.text == 'true'
                                        ? true
                                        : false,
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                              };
                              await documentReference
                                  .update(data)
                                  .whenComplete(() => print("Item Updated"))
                                  .catchError((e) => print(e));
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
    // AlertDialog(
    //   shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(30))),
    //   content: SizedBox(
    //     height: 480,
    //     width: 800,
    //     child: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const Text(
    //             'Update Records for this doc',
    //             style: TextStyle(
    //                 fontFamily: 'poppins',
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 14),
    //           ),
    //           CustomTextField(
    //               hinttext: "Vendor ID", addcontroller: _addvendorid),
    //           CustomTextField(
    //               hinttext: "User Name", addcontroller: _addusername),
    //           CustomTextField(hinttext: "User ID", addcontroller: _adduserid),
    //           CustomTextField(
    //               hinttext: "Total Price", addcontroller: _addtotalprice),
    //           CustomTextField(
    //               hinttext: "Total Days", addcontroller: _addtotaldays),
    //           CustomTextField(hinttext: "Tax Pay", addcontroller: _addtaxpay),
    //           CustomTextField(
    //               hinttext: "Plan End Y", addcontroller: _addplanendyear),
    //           CustomTextField(
    //               hinttext: "Plan End M", addcontroller: _addplanendmonth),
    //           CustomTextField(
    //               hinttext: "Plan End D", addcontroller: _addplanendday),
    //           CustomTextField(
    //               hinttext: "Payment Done", addcontroller: _addpaymentdone),
    //           CustomTextField(
    //               hinttext: "Package Type", addcontroller: _addpackagetype),
    //           CustomTextField(
    //               hinttext: "Order Date Y", addcontroller: _addorderyear),
    //           CustomTextField(
    //               hinttext: "Order Date M", addcontroller: _addordermonth),
    //           CustomTextField(
    //               hinttext: "Order Date D", addcontroller: _addorderday),
    //           CustomTextField(hinttext: "Gym Name", addcontroller: _addgymname),
    //           CustomTextField(
    //               hinttext: "Gym Address", addcontroller: _addgymaddress),
    //           CustomTextField(
    //               hinttext: "Grand Total", addcontroller: _addgrandtotal),
    //           CustomTextField(
    //               hinttext: "Discount", addcontroller: _adddiscount),
    //           CustomTextField(
    //               hinttext: "Days Left", addcontroller: _adddaysletf),
    //           CustomTextField(
    //               hinttext: "Booking Status", addcontroller: _addbookingstatus),
    //           CustomTextField(
    //               hinttext: "Booking Price", addcontroller: _addbookingprice),
    //           CustomTextField(
    //               hinttext: "Booking Plan", addcontroller: _addbookingplan),
    //           CustomTextField(
    //               hinttext: "booking ID", addcontroller: _addbookingid),
    //           CustomTextField(
    //               hinttext: "Booking Date Y", addcontroller: _addbookingyear),
    //           CustomTextField(
    //               hinttext: "Booking Date M", addcontroller: _addbookingmonth),
    //           CustomTextField(
    //               hinttext: "Booking Date D", addcontroller: _addbookingday),
    //           CustomTextField(
    //               hinttext: "Booking Accepted",
    //               addcontroller: _addbookingaccepted),
    //           Padding(
    //             padding: const EdgeInsets.all(12.0),
    //             child: Center(
    //               child: ElevatedButton(
    //                 onPressed: () async {
    //                   DocumentReference documentReference = FirebaseFirestore
    //                       .instance
    //                       .collection('bookings')
    //                       .doc(_addbookingid.text);
    //                   DateTime endtimedata = DateTime.parse(
    //                       '${_addplanendyear.text}-${isLess(_addplanendmonth.text) ? '0' + _addplanendmonth.text : _addplanendday.text}-${isLess(_addplanendday.text) ? '0' + _addplanendday.text : _addplanendday.text} 00:00:04Z');
    //                   DateTime ordertimedata = DateTime.parse(
    //                       '${_addorderyear.text}-${isLess(_addordermonth.text) ? '0' + _addordermonth.text : _addordermonth.text}-${isLess(_addorderday.text) ? '0' + _addorderday.text : _addorderday.text} 00:00:04Z');
    //                   DateTime bookingtimedata = DateTime.parse(
    //                       '${_addbookingyear.text}-${isLess(_addbookingmonth.text) ? '0' + _addbookingmonth.text : _addbookingmonth.text}-${isLess(_addbookingday.text) ? '0' + _addbookingday.text : _addbookingday.text} 00:00:04Z');

    //                   Map<String, dynamic> data = <String, dynamic>{
    //                     'vandorId': _addvendorid.text,
    //                     'user_name': _addusername.text,
    //                     'userId': _adduserid.text,
    //                     'total_price': _addtotalprice.text,
    //                     'totalDays': _addtotalprice.text,
    //                     'tax_pay': _addtaxpay.text,
    //                     'plan_end_duration': endtimedata,
    //                     'payment_done':
    //                         _addpaymentdone.text == 'true' ? true : false,
    //                     'package_type': _addpackagetype.text,
    //                     'order_date': ordertimedata,
    //                     'gym_name': _addgymname.text,
    //                     'gym_address': _addgymaddress.text,
    //                     'grand_total': _addgrandtotal.text,
    //                     'discount': _adddiscount.text,
    //                     'daysLeft': _adddaysletf.text,
    //                     'booking_status': _addbookingstatus.text,
    //                     'booking_price': _addbookingprice.text,
    //                     'booking_plan': _addbookingplan.text,
    //                     'booking_id': _addbookingid.text,
    //                     'booking_date': bookingtimedata,
    //                     'booking_accepted':
    //                         _addbookingaccepted.text == 'true' ? true : false,
    //                   };
    //                   await documentReference
    //                       .update(data)
    //                       .whenComplete(() => print("Item Updated"))
    //                       .catchError((e) => print(e));
    //                   Navigator.pop(context);
    //                 },
    //                 child: const Text('Done'),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  //for 'booking_date'
  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      bookingtimedata = DateTime(
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

  Future pickTime(BuildContext context) async {
// <<<<<<< HEAD
//     final intialTime = TimeOfDay(hour: 9, minute: 0);
//     final newTime =
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// =======
    const intialTime = const TimeOfDay(hour: 9, minute: 0);
    final newTime =
        await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });

    return newTime;
  }

  //for 'plan_end_duration'
  Future pickplanDateTime(BuildContext context) async {
    final plandate = await pickplanDate(context);
    if (plandate == null) return;

    final ptime = await pickplanTime(context);
    if (ptime == null) return;

    setState(() {
      endtimedata = DateTime(
        plandate.year,
        plandate.month,
        plandate.day,
        ptime.hour,
        ptime.minute,
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
// <<<<<<< HEAD
//     final intialTime = TimeOfDay(hour: 9, minute: 0);
//     final newTime =
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// =======
    const intialTime = const TimeOfDay(hour: 9, minute: 0);
    final newTime =
        await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });

    return newTime;
  }

  //for 'order_date'
  Future pickorderDateTime(BuildContext context) async {
    final orderdate = await pickorderDate(context);
    if (orderdate == null) return;

    final otime = await pickorderTime(context);
    if (otime == null) return;

    setState(() {
      ordertimedata = DateTime(
        orderdate.year,
        orderdate.month,
        orderdate.day,
        otime.hour,
        otime.minute,
      );
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
// <<<<<<< HEAD
//         await showTimePicker(context: context, initialTime: time ?? intialTime);
// =======
        await showTimePicker(context: context, initialTime: time ?? intialTime);
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47

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
// <<<<<<< HEAD
// =======
  String? value;
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: RadioListTile<String>(
// <<<<<<< HEAD
              value: widget.name,
              groupValue: check,
// =======
//               value: check,
//               groupValue: value,
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
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
