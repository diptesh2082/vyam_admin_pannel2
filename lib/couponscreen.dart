import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/image_picker_api.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  CollectionReference? productStream;
  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addlandmark = TextEditingController();
  final TextEditingController _addgymownerid = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();
  final TextEditingController _numberCon = TextEditingController();
  var dic;
  var vall = File([], '');
  void dropDownPackage(String? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      packageType = selecetValue;
      Select_Package_type = selecetValue;
    });
    // }
  }

  void dropDowntype(bool? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      coupontype = selecetValue;
      if (selecetValue == true) {
        print_type = "Percentage";
      }
      if (selecetValue == false) {
        print_type = "Flat";
      }
    });
    // }
  }

  final TextEditingController _addCode = TextEditingController();
  final TextEditingController _adddetails = TextEditingController();
  final TextEditingController _adddiscount = TextEditingController();
  // final TextEditingController _addtitle = TextEditingController();
  final TextEditingController brief = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController tag = TextEditingController();
  final TextEditingController max_dis = TextEditingController();
  final TextEditingController munimum_cart_value = TextEditingController();
  final TextEditingController offer_type = TextEditingController();
  // final TextEditingController package_type = TextEditingController();
  // DateTime date=DateTime.now();
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  String? packageType;
  String? Select_Package_type = "Select Package type";
  bool? coupontype = false;
  String? print_type = "Select Coupon type";
  final id =
      FirebaseFirestore.instance.collection('coupon').doc().id.toString();
  CollectionReference? couponStream;
  @override
  void initState() {
    couponStream = FirebaseFirestore.instance.collection("coupon");
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
        appBar: AppBar(
          title: Text('Add Coupon'),
        ),
        body: Container(
      padding: EdgeInsets.all(50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Records',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            customTextField(hinttext: "Code", addcontroller: _addCode),
            const SizedBox(
              height: 8,
            ),
            customTextField(hinttext: "Details", addcontroller: _adddetails),
            const SizedBox(
              height: 8,
            ),
            customTextField(hinttext: "Discount", addcontroller: _adddiscount),
            const SizedBox(
              height: 8,
            ),

            customTextField(hinttext: "brief", addcontroller: brief),
            const SizedBox(
              height: 8,
            ),
            customTextField(hinttext: "price", addcontroller: price),
            const SizedBox(
              height: 8,
            ),
            customTextField(hinttext: "tag", addcontroller: tag),
            // const SizedBox(
            //   height: 8,
            // ),
            // customTextField(
            //     hinttext: "package_type", addcontroller: package_type),
            const SizedBox(
              height: 8,
            ),
            customTextField(
                hinttext: "munimum_cart_value",
                addcontroller: munimum_cart_value),
            const SizedBox(
              height: 8,
            ),
            customTextField(hinttext: "max_dis", addcontroller: max_dis),
            const SizedBox(
              height: 8,
            ),
            // Column(
            //   children: [
            //     const Text(
            //       "Select Start Date",
            //       style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
            //     ),
            //     CalendarDatePicker(
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime.utc(2022, 5, 18),
            //       lastDate: DateTime.utc(DateTime.now().year + 1),
            //       onDateChanged: (DateTime value) {
            //         setState(() {
            //           start_date = value;
            //         });
            //       },
            //     ),
            //     Text(
            //       DateFormat("dd,MMM, yyyy").format(start_date),
            //       style: const TextStyle(
            //           fontSize: 36, fontWeight: FontWeight.w500),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Text('Start Date:'),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    child: Text("Select"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              content: SizedBox(
                                  // =======
                                  // >>>>>>> 39301b603a430fc9803df29ba70b59135c783388
                                  height:
                                      MediaQuery.of(context).size.height * .90,
                                  width:
                                      MediaQuery.of(context).size.width * .92,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CalendarDatePicker(
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.utc(2022, 5, 18),
                                          lastDate: DateTime.utc(
                                              DateTime.now().year + 1),
                                          onDateChanged: (DateTime value) {
                                            setState(() {
                                              start_date = value;
                                            });
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Selected Date: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              DateFormat("dd,MMM, yyyy")
                                                  .format(start_date),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Done'))
                                      ],
                                    ),
                                  ))));
                    }),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text('End Date:'),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    child: Text("Select"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              content: SizedBox(
                                  // =======
                                  // >>>>>>> 39301b603a430fc9803df29ba70b59135c783388
                                  height:
                                      MediaQuery.of(context).size.height * .90,
                                  width:
                                      MediaQuery.of(context).size.width * .92,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Select End Date",
                                          style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        CalendarDatePicker(
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.utc(2022, 5, 18),
                                          lastDate: DateTime.utc(
                                              DateTime.now().year + 1),
                                          onDateChanged: (DateTime value) {
                                            setState(() {
                                              end_date = value;
                                            });
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Selected Date: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              DateFormat("dd,MMM, yyyy")
                                                  .format(end_date),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Done'))
                                      ],
                                    ),
                                  ))));
                    }),
              ],
            ),
            // Column(
            //   children: [
            //     const Text(
            //       "Select End Date",
            //       style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
            //     ),
            //     CalendarDatePicker(
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime.utc(2022, 5, 18),
            //       lastDate: DateTime.utc(DateTime.now().year + 1),
            //       onDateChanged: (DateTime value) {
            //         setState(() {
            //           end_date = value;
            //         });
            //       },
            //     ),
            //     Text(
            //       DateFormat("dd,MMM, yyyy").format(end_date),
            //       style: const TextStyle(
            //           fontSize: 36, fontWeight: FontWeight.w500),
            //     ),
            //   ],
            // ),

            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    print(start_date);
                  },
                  child: const Text(
                    "Select Package type",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  color: Colors.yellowAccent,
                  width: 280,
                  child: DropdownButton(
                      hint: Text("${Select_Package_type}"),
                      items: const [
                        DropdownMenuItem(
                          child: Text("pay per session"),
                          value: "pay per session",
                        ),
                        DropdownMenuItem(
                          child: Text("package"),
                          value: "package",
                        ),
                      ],
                      onChanged: dropDownPackage),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                const Text(
                  "Select Coupon type",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                Container(
                  color: Colors.yellowAccent,
                  width: 280,
                  child: DropdownButton(
                      hint: Text("${print_type}"),
                      items: const [
                        DropdownMenuItem(
                          child: Text("Percentage"),
                          value: true,
                        ),
                        DropdownMenuItem(
                          child: Text("Flat"),
                          value: false,
                        ),
                      ],
                      onChanged: dropDowntype),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await matchID(
                        newId: id,
                        matchStream: couponStream,
                        idField: 'coupon_id');
                    await FirebaseFirestore.instance
                        .collection('coupon')
                        .doc(id)
                        .set(
                      {
                        "coupon_id": id,
                        'code': _addCode.text.toUpperCase(),
                        'detail': _adddetails.text,
                        'discount': _adddiscount.text,
                        'coupon_id': id,
                        "brief": brief.text,
                        "end_date": end_date,
                        "start_date": start_date,
                        "max_dis": max_dis.text,
                        "minimum_cart_value": munimum_cart_value.text,
                        "offer_type": coupontype,
                        "package_type": packageType!.trim(),
                        "price": price.text,
                        "tag": tag.text,
                        "user_id": [],
                      },
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
                SizedBox(
                  width: 30,
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
    ));
  }
}
