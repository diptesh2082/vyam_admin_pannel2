import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Tracking/TrackingScreen.dart';

class addbookings extends StatefulWidget {
  const addbookings({Key? key}) : super(key: key);

  @override
  State<addbookings> createState() => _addbookingsState();
}

class _addbookingsState extends State<addbookings> {
  final id = FirebaseFirestore.instance.collection('bookings').doc().id;
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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('New Booking'),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                  child: Form(
                key: _formKey,
                child: SizedBox(
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Add Records',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      CustomTextField(
                          hinttext: "Vendor ID", addcontroller: _addvendorid),
                      CustomTextField(
                          hinttext: "User Name", addcontroller: _addusername),
                      CustomTextField(
                          hinttext: "User ID", addcontroller: _adduserid),
                      CustomTextField(
                          hinttext: "Total Price",
                          addcontroller: _addtotalprice),
                      CustomTextField(
                          hinttext: "Total Days", addcontroller: _addtotaldays),
                      CustomTextField(
                          hinttext: "Tax Pay", addcontroller: _addtaxpay),
                      CustomTextField(
                          hinttext: "Plan End Y",
                          addcontroller: _addplanendyear),
                      CustomTextField(
                          hinttext: "Plan End M",
                          addcontroller: _addplanendmonth),
                      CustomTextField(
                          hinttext: "Plan End D",
                          addcontroller: _addplanendday),
                      CustomTextField(
                          hinttext: "Payment Done",
                          addcontroller: _addpaymentdone),
                      CustomTextField(
                          hinttext: "Package Type",
                          addcontroller: _addpackagetype),
                      CustomTextField(
                          hinttext: "Order Date Y",
                          addcontroller: _addorderyear),
                      CustomTextField(
                          hinttext: "Order Date M",
                          addcontroller: _addordermonth),
                      CustomTextField(
                          hinttext: "Order Date D",
                          addcontroller: _addorderday),
                      CustomTextField(
                          hinttext: "Gym Name", addcontroller: _addgymname),
                      CustomTextField(
                          hinttext: "Gym Address",
                          addcontroller: _addgymaddress),
                      CustomTextField(
                          hinttext: "Grand Total",
                          addcontroller: _addgrandtotal),
                      CustomTextField(
                          hinttext: "Discount", addcontroller: _adddiscount),
                      CustomTextField(
                          hinttext: "Days Left", addcontroller: _adddaysletf),
                      CustomTextField(
                          hinttext: "Booking Status",
                          addcontroller: _addbookingstatus),
                      CustomTextField(
                          hinttext: "Booking Price",
                          addcontroller: _addbookingprice),
                      CustomTextField(
                          hinttext: "Booking Plan",
                          addcontroller: _addbookingplan),
                      CustomTextField(
                          hinttext: "booking ID", addcontroller: _addbookingid),
                      CustomTextField(
                          hinttext: "Booking Date Y",
                          addcontroller: _addbookingyear),
                      CustomTextField(
                          hinttext: "Booking Date M",
                          addcontroller: _addbookingmonth),
                      CustomTextField(
                          hinttext: "Booking Date D",
                          addcontroller: _addbookingday),
                      CustomTextField(
                          hinttext: "Booking Accepted",
                          addcontroller: _addbookingaccepted),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                              ),
                              onPressed: () async {
                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection('bookings')
                                        .doc(_addbookingid.text);
                                DateTime endtimedata = DateTime.parse(
                                    '${_addplanendyear.text}-${isLess(_addplanendmonth.text) ? '0' + _addplanendmonth.text : _addplanendday.text}-${isLess(_addplanendday.text) ? '0' + _addplanendday.text : _addplanendday.text} 00:00:04Z');
                                DateTime ordertimedata = DateTime.parse(
                                    '${_addorderyear.text}-${isLess(_addordermonth.text) ? '0' + _addordermonth.text : _addordermonth.text}-${isLess(_addorderday.text) ? '0' + _addorderday.text : _addorderday.text} 00:00:04Z');
                                DateTime bookingtimedata = DateTime.parse(
                                    '${_addbookingyear.text}-${isLess(_addbookingmonth.text) ? '0' + _addbookingmonth.text : _addbookingmonth.text}-${isLess(_addbookingday.text) ? '0' + _addbookingday.text : _addbookingday.text} 00:00:04Z');
                                if (_formKey.currentState!.validate()) {
                                  // await createReview(id);
                                  await FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(id)
                                      .set(
                                    {
                                      'vandorId': _addvendorid.text,
                                      'user_name': _addusername.text,
                                      'userId': _adduserid.text,
                                      'total_price': _addtotalprice.text,
                                      'totalDays': _addtotalprice.text,
                                      'tax_pay': _addtaxpay.text,
                                      'plan_end_duration': endtimedata,
                                      'payment_done':
                                          _addpaymentdone.text == 'true'
                                              ? true
                                              : false,
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
                                          _addbookingaccepted.text == 'true'
                                              ? true
                                              : false,
                                    },
                                  );
                                  //     .then(
                                  //   (snapshot) async {
                                  //     await uploadImageToBanner(image  , id);
                                  //   },
                                  // );

                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Done'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                ),
              ))
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
            ],
          ),
        ),
      ),
    );
  }
}
