import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
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

bool showStartDate = false;
bool showEndDate = false;

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
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CouponScreen()));
                    },
                    child: const Text('Add Coupon'),
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
                        if (value.isEmpty) {
                          // _node.canRequestFocus=false;
                          // FocusScope.of(context).unfocus();
                        }
                        if (mounted) {
                          setState(() {
                            searchCoupon = value.toString();
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

                      if (searchCoupon.isNotEmpty) {
                        doc = doc.where((element) {
                          return element
                                  .get('code')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchCoupon.toString()) ||
                              element
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
                                'Type',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Tag',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                  label: Text(
                                'Promocode',
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
                                  'Description',
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
                                  'Enable/Disable',
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
                SizedBox(height: 20),
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
    String couponIdData = data['coupon_id'];
    bool validity = data['validity'];
    String start =
        DateFormat("MMM, dd, yyyy").format(data["start_date"].toDate());
    String end = DateFormat("MMM, dd, yyyy").format(data["end_date"].toDate());
    return DataRow(cells: [
      DataCell(data['package_type'] != null
          ? Text(data['package_type'] ?? "")
          : const Text("")),
      DataCell(data['tag'] != null ? Text(data['tag'] ?? "") : const Text("")),
      DataCell(
          data['code'] != null ? Text(data['code'] ?? "") : const Text("")),
      DataCell(
          data['detail'] != null ? Text(data['detail'] ?? "") : const Text("")),
      DataCell(data['description'] != null
          ? Text(data['description'] ?? "")
          : const Text("")),
      DataCell(start != null ? Text(start) : const Text("")),
      DataCell(end != null ? Text(end) : const Text("")),
      DataCell(data['discount'] != null
          ? Text(data['discount'] ?? "")
          : const Text("")),
      DataCell(data['max_dis'] != null
          ? Text(data['max_dis'] ?? "")
          : const Text("")),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = validity;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('coupon')
                  .doc(couponIdData);
              await documentReference
                  .update({'validity': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(validity ? "Enable" : "Disable"),
            style: ElevatedButton.styleFrom(
                primary: validity ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductEditBox(
                    details: data['detail'],
                    discount: data['discount'],
                    title: data['tag'],
                    code: data['code'],
                    couponId: data['coupon_id'],
                    max_dis: data['max_dis'],
                    // price: data['price'],
                    tag: data['tag'],
                    minimum_cart_value: data['minimum_cart_value'],
                    start_date: data['start_date'].toDate(),
                    end_date: data['end_date'].toDate(),
                    selectedPackagetype: data['package_type'],
                    offer_type: data['offer_type'])));
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: couponStream, uniqueDocId: couponIdData);

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
                                  stream: couponStream,
                                  uniqueDocId: couponIdData);
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

  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  String? packageType;
  String? Select_Package_type = "Select Package type";
  bool? coupontype = false;
  String? print_type = "Select Coupon type";
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.details,
    required this.discount,
    required this.title,
    required this.code,
    required this.couponId,
    required this.max_dis,
    // required this.price,
    required this.tag,
    required this.minimum_cart_value,
    required this.end_date,
    required this.start_date,
    required this.selectedPackagetype,
    required this.offer_type,
  }) : super(key: key);

  final String details;
  final String discount;
  final String title;
  final String code;
  final String couponId;
  final String max_dis;
  // final String price;
  final bool offer_type;
  final String tag;
  final DateTime end_date;
  final DateTime start_date;
  final String minimum_cart_value;
  final String selectedPackagetype;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _code = TextEditingController();
  final TextEditingController _detail = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _title = TextEditingController();
  // final TextEditingController _price = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  final TextEditingController _minimum_cart_value = TextEditingController();

  final TextEditingController _max_dis = TextEditingController();
  TextEditingController controller = TextEditingController();
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  DateTime? date;
  String? packageType;
  String? Select_Package_type = "Select Package type";
  bool? coupontype = false;
  String? print_type = "Select Coupon type";

  @override
  void initState() {
    super.initState();
    _code.text = widget.code;
    _detail.text = widget.details;
    _discount.text = widget.discount;
    _title.text = widget.title;
    _max_dis.text = widget.max_dis;
    // _price.text = widget.price;
    _tag.text = widget.tag;
    _minimum_cart_value.text = widget.minimum_cart_value;
    start_date = widget.start_date;
    end_date = widget.end_date;
    Select_Package_type = widget.selectedPackagetype;
    coupontype = widget.offer_type;
  }

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

  CollectionReference? couponStream;
  String descriptionn = 'Add Description';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Edit Coupon'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
              Image.asset(
                'Assets/images/coupon.png',
                height: 400,
                width: 400,
                alignment: Alignment.topRight,
              ),

              customTextField(hinttext: "Code", addcontroller: _code),
              const SizedBox(
                height: 8,
              ),
              customTextField(hinttext: "Details", addcontroller: _detail),
              const SizedBox(
                height: 8,
              ),
              customTextField(hinttext: "Discount", addcontroller: _discount),
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

              // customTextField(hinttext: "price", addcontroller: _price),
              const SizedBox(
                height: 8,
              ),
              customTextField(hinttext: "tag", addcontroller: _tag),
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
                  addcontroller: _minimum_cart_value),
              const SizedBox(
                height: 8,
              ),
              customTextField(hinttext: "max_dis", addcontroller: _max_dis),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                ElevatedButton(
                                  child: const Text('Select Start Date '),
                                  onPressed: () async {
                                    setState(() async {
                                      showStartDate = true;
                                      start_date = await pickDate(context);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Text(showStartDate != false
                              ? DateFormat("MMM ,dd , yyyy")
                                  .format(start_date)
                                  .toString()
                              : ""),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                ElevatedButton(
                                  child: const Text('Select End Date '),
                                  onPressed: () async {
                                    setState(() async {
                                      showEndDate = true;
                                      end_date = await pickDate(context);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Text(showStartDate != false
                              ? DateFormat("MMM ,dd , yyyy")
                                  .format(end_date)
                                  .toString()
                              : "")
                        ],
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 280,
                        child: DropdownButton(
                            hint: Text(
                                coupontype == true ? "Percentage" : "Flat"),
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              print("/////");
                              print(start_date);
                              print(end_date);
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('coupon')
                                      .doc(widget.couponId);
                              Map<String, dynamic> data = <String, dynamic>{
                                // 'code': _code.text,
                                // 'detail': _detail.text,
                                // 'discount': _discount.text,
                                // // 'title': _title.text,
                                // 'tag': _title.text,
                                // 'coupon_id': widget.couponId,
                                // 'max_dis': _max_dis.text,
                                'code': _code.text.toUpperCase(),
                                'detail': _detail.text,
                                'discount': _discount.text,
                                "end_date": end_date,
                                "start_date": start_date,
                                "max_dis": _max_dis.text,
                                "minimum_cart_value": _minimum_cart_value.text,
                                "offer_type": coupontype,
                                "package_type": Select_Package_type!.trim(),
                                // "price": _price.text,
                                "tag": _tag.text,
                                'description': descriptionn,
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
