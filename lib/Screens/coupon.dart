import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../couponscreen.dart';
import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class Coupon extends StatefulWidget {
  const Coupon({
    Key? key,
  }) : super(key: key);

  @override
  State<Coupon> createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  final id =
      FirebaseFirestore.instance.collection('coupon').doc().id.toString();

  CollectionReference? couponStream;
  String searchCoupon = '';
  @override
  void initState() {
    couponStream = FirebaseFirestore.instance.collection("coupon");
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
                      textStyle:
                      const TextStyle(fontSize: 15 ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CouponScreen()));
                    },
                    child:
                    Text('Add Coupon'),

                  ),
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
                            searchCoupon = value.toString();
                          });
                        }
                      },
                      decoration:  InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white12,
                      ),
                    ),
                  ),
                ),






                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: couponStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      var doc = snapshot.data.docs;

                      if (searchCoupon.length > 0) {
                        doc = doc.where((element) {
                          return element
                              .get('code')
                              .toString()
                              .toLowerCase()
                              .contains(searchCoupon.toString())
                              ||element
                                  .get('tag')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchCoupon.toString());
                        }).toList();
                      }



                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Code',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Details',
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
                                  'Maximum Discount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Title',
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
    String couponIdData = data['coupon_id'];
    return DataRow(cells: [
      DataCell(
          data['code'] != null ? Text(data['code'] ?? "") : const Text("")),
      DataCell(
          data['detail'] != null ? Text(data['detail'] ?? "") : const Text("")),
      DataCell(data['discount'] != null
          ? Text(data['discount'] ?? "")
          : const Text("")),

      DataCell(data['max_dis'] != null
          ? Text(data['max_dis'] ?? "")
          : const Text("")),

      DataCell(data['tag'] != null ? Text(data['tag'] ?? "") : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductEditBox(
                    details: data['detail'],
                    discount: data['discount'],
                    title: data['title'],
                    code: data['code'],

                    couponId: data['coupon_id'],
                    max_dis: data['max_dis'])));

      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: couponStream, uniqueDocId: couponIdData);
      }),
    ]);
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

//   showAddbox() => showDialog(
//         context: context,
//         builder: (context) => StatefulBuilder(builder: (context, setState) {
//           void dropDownPackage(String? selecetValue) {
//             // if(selecetValue is String){
//             setState(() {
//               packageType = selecetValue;
//               Select_Package_type = selecetValue;
//             });
//             // }
//           }
//
//           void dropDowntype(bool? selecetValue) {
//             // if(selecetValue is String){
//             setState(() {
//               coupontype = selecetValue;
//               if (selecetValue == true) {
//                 print_type = "Percentage";
//               }
//               if (selecetValue == false) {
//                 print_type = "Flat";
//               }
//             });
//             // }
//           }
//
//           return AlertDialog(
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(30))),
//             content: SizedBox(
//               // height: 480,
//               width: MediaQuery.of(context).size.width * .92,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Add Records',
//                       style: TextStyle(
//                           fontFamily: 'poppins',
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20),
//                     ),
//                     customTextField(hinttext: "Code", addcontroller: _addCode),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     customTextField(
//                         hinttext: "Details", addcontroller: _adddetails),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     customTextField(
//                         hinttext: "Discount", addcontroller: _adddiscount),
//                     const SizedBox(
//                       height: 8,
//                     ),
//
//                     customTextField(hinttext: "brief", addcontroller: brief),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     customTextField(hinttext: "price", addcontroller: price),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     customTextField(hinttext: "tag", addcontroller: tag),
//                     // const SizedBox(
//                     //   height: 8,
//                     // ),
//                     // customTextField(
//                     //     hinttext: "package_type", addcontroller: package_type),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     customTextField(
//                         hinttext: "munimum_cart_value",
//                         addcontroller: munimum_cart_value),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     customTextField(
//                         hinttext: "max_dis", addcontroller: max_dis),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Column(
//                       children: [
//                         const Text(
//                           "Select Start Date",
//                           style: TextStyle(
//                               fontSize: 36, fontWeight: FontWeight.w500),
//                         ),
//                         CalendarDatePicker(
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.utc(2022, 5, 18),
//                           lastDate: DateTime.utc(DateTime.now().year + 1),
//                           onDateChanged: (DateTime value) {
//                             setState(() {
//                               start_date = value;
//                             });
//                           },
//                         ),
//                         Text(
//                           DateFormat("dd,MMM, yyyy").format(start_date),
//                           style: const TextStyle(
//                               fontSize: 36, fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Column(
//                       children: [
//                         const Text(
//                           "Select End Date",
//                           style: TextStyle(
//                               fontSize: 36, fontWeight: FontWeight.w500),
//                         ),
//                         CalendarDatePicker(
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.utc(2022, 5, 18),
//                           lastDate: DateTime.utc(DateTime.now().year + 1),
//                           onDateChanged: (DateTime value) {
//                             setState(() {
//                               end_date = value;
//                             });
//                           },
//                         ),
//                         Text(
//                           DateFormat("dd,MMM, yyyy").format(end_date),
//                           style: const TextStyle(
//                               fontSize: 36, fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             print(start_date);
//                           },
//                           child: const Text(
//                             "Select Package type",
//                             style: TextStyle(
//                                 fontSize: 30, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         Container(
//                           color: Colors.yellowAccent,
//                           width: 280,
//                           child: DropdownButton(
//                               hint: Text("${Select_Package_type}"),
//                               items: const [
//                                 DropdownMenuItem(
//                                   child: Text("pay per session"),
//                                   value: "pay per session",
//                                 ),
//                                 DropdownMenuItem(
//                                   child: Text("package"),
//                                   value: "package",
//                                 ),
//                               ],
//                               onChanged: dropDownPackage),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Column(
//                       children: [
//                         const Text(
//                           "Select Coupon type",
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.w500),
//                         ),
//                         Container(
//                           color: Colors.yellowAccent,
//                           width: 280,
//                           child: DropdownButton(
//                               hint: Text("${print_type}"),
//                               items: const [
//                                 DropdownMenuItem(
//                                   child: Text("Percentage"),
//                                   value: true,
//                                 ),
//                                 DropdownMenuItem(
//                                   child: Text("Flat"),
//                                   value: false,
//                                 ),
//                               ],
//                               onChanged: dropDowntype),
//                         ),
//                       ],
//                     ),
//
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           await matchID(
//                               newId: id,
//                               matchStream: couponStream,
//                               idField: 'coupon_id');
//                           await FirebaseFirestore.instance
//                               .collection('coupon')
//                               .doc(id)
//                               .set(
//                             {
//                               "coupon_id": id,
//                               'code': _addCode.text.toUpperCase(),
//                               'detail': _adddetails.text,
//                               'discount': _adddiscount.text,
//                               'coupon_id': id,
//                               "brief": brief.text,
//                               "end_date": end_date,
//                               "start_date": start_date,
//                               "max_dis": max_dis.text,
//                               "minimum_cart_value": munimum_cart_value.text,
//                               "offer_type": coupontype,
//                               "package_type": packageType!.trim(),
//                               "price": price.text,
//                               "tag": tag.text,
//                               "user_id": [],
//                             },
//                           );
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Done'),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       );
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox(
      {Key? key,
      required this.details,
      required this.discount,
      required this.title,
      required this.code,
      required this.couponId,
      required this.max_dis})
      : super(key: key);

  final String details;
  final String discount;
  final String title;
  final String code;
  final String couponId;
  final String max_dis;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _code = TextEditingController();
  final TextEditingController _detail = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _max_dis = TextEditingController();

  @override
  void initState() {
    super.initState();
    _code.text = widget.code;
    _detail.text = widget.details;
    _discount.text = widget.discount;
    _title.text = widget.title;
    _max_dis.text = widget.max_dis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Edit Coupon'),
      ),
      body: SingleChildScrollView(
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
            customTextField(hinttext: "Code", addcontroller: _code),
            customTextField(hinttext: "Detail", addcontroller: _detail),
            customTextField(hinttext: "Discount", addcontroller: _discount),
            customTextField(hinttext: "Title", addcontroller: _title),

            customTextField(hinttext: "Max Discount", addcontroller: _max_dis),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("/////");
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('coupon')
                            .doc(widget.couponId);
                        Map<String, dynamic> data = <String, dynamic>{
                          'code': _code.text,
                          'detail': _detail.text,
                          'discount': _discount.text,
                          'title': _title.text,
                          'tag': _title.text,
                          'coupon_id': widget.couponId,

                          'max_dis': _max_dis.text,

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
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
