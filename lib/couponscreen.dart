import 'dart:html';
import 'dart:math';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
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
  final TextEditingController description = TextEditingController();

  final TextEditingController price = TextEditingController();
  final TextEditingController tag = TextEditingController();
  final TextEditingController max_dis = TextEditingController();
  final TextEditingController munimum_cart_value = TextEditingController();
  final TextEditingController offer_type = TextEditingController();
  // final TextEditingController package_type = TextEditingController();
  // DateTime date=DateTime.now();
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  DateTime? date;
  String? packageType;
  String? Select_Package_type = "Select Package type";
  bool? coupontype = false;
  String? print_type = "Select Coupon type";
  final id =
      FirebaseFirestore.instance.collection('coupon').doc().id.toString();
  CollectionReference? couponStream;
  String descriptionn = 'My great package';
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  TextEditingController controller = TextEditingController();
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
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Records',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),

              Image.asset(
                'Assets/images/coupon.png',
                height: 400,
                width: 400,
                alignment: Alignment.topRight,
              ),

              customTextField(hinttext: "Code", addcontroller: _addCode),
              const SizedBox(
                height: 8,
              ),
              customTextField(hinttext: "Details", addcontroller: _adddetails),
              const SizedBox(
                height: 8,
              ),
              customTextField(
                  hinttext: "Discount", addcontroller: _adddiscount),
              const SizedBox(
                height: 8,
              ),
              // customTextField(
              //     hinttext: "Description", addcontroller: description),
              const SizedBox(
                height: 8,
              ),
              MarkdownTextInput(
                (String value) => setState(() => descriptionn = value),
                descriptionn,
                label: 'Description',
                maxLines: 10,
                actions: actions,
                controller: controller,
              ),
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
                  hinttext: "minimum_cart_value",
                  addcontroller: munimum_cart_value),
              const SizedBox(
                height: 8,
              ),
              customTextField(hinttext: "max_dis", addcontroller: max_dis),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            ElevatedButton(
                              child: const Text('Select Start Date '),
                              onPressed: () async {
                                start_date = await pickDate(context);
                              },
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            ElevatedButton(
                              child: const Text('Select End Date '),
                              onPressed: () async {
                                end_date = await pickDate(context);
                              },
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
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
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
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
                  const SizedBox(
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
                              "end_date": end_date,
                              "start_date": start_date,
                              "max_dis": max_dis.text,
                              "minimum_cart_value": munimum_cart_value.text,
                              "offer_type": coupontype,
                              "package_type": packageType!.trim().toUpperCase(),
                              "price": price.text,
                              "tag": tag.text,
                              "user_id": [],
                              "validity": true,
                              'description': descriptionn,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                      const SizedBox(
                        width: 30,
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
            ],
          ),
        ),
      ),
    );
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
}
