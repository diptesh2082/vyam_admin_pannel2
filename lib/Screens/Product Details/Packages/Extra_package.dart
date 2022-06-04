import 'package:admin_panel_vyam/services/maps_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/CustomTextFieldClass.dart';

String globalGymId = '';

class ExtraPackagesPage extends StatefulWidget {
  String pGymId;
  ExtraPackagesPage({required this.pGymId});

  @override
  State<ExtraPackagesPage> createState() => _ExtraPackagesPageState();
}

class _ExtraPackagesPageState extends State<ExtraPackagesPage> {
  CollectionReference? extraPackageStream;

  @override
  void initState() {
    super.initState();

    globalGymId = widget.pGymId;
    extraPackageStream = FirebaseFirestore.instance
        .collection("product_details")
        .doc(widget.pGymId)
        .collection("package")
        .doc("normal_package")
        .collection("gym");
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
                  child: GestureDetector(
                    onTap: showAddbox,
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.add)),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.add),
                          Text('Add Product',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: extraPackageStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Discount',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Original Price',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Price',
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
                                  'Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validity',
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
    String docId = data['doc_id'];
    Future<void> deleteMethod() {
      return extraPackageStream!
          .doc(docId)
          .delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return DataRow(cells: [
      DataCell(data != null ? Text(docId) : Text("")),
      DataCell(data != null ? Text(data['discount'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['original_price'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['price'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['title'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['type'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['validity'] ?? "") : Text("")),
      DataCell(
        const Text(""),
        showEditIcon: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                // ? Added Gesture Detecter for popping off update record Card
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    discount: data['discount'],
                    originalPrice: data['original_price'],
                    price: data['price'],
                    title: data['title'],
                    type: data['type'],
                    validity: data['validity'],
                    docId: data['doc_id'],
                  ),
                ),
                onTap: () =>
                    Navigator.pop(context), // ? ontap Property for popping of
              );
            },
          );
        },
      ),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod();
      })
    ]);
  }

  final TextEditingController _addDiscount = TextEditingController();
  final TextEditingController _addOriginalPrice = TextEditingController();
  final TextEditingController _addPrice = TextEditingController();
  final TextEditingController _addTitle = TextEditingController();
  final TextEditingController _addType = TextEditingController();
  final TextEditingController _addValidity = TextEditingController();
  final TextEditingController _addDocId = TextEditingController();
  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                      'Add Records',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    customTextField(hinttext: "ID", addcontroller: _addDocId),
                    customTextField(
                        hinttext: "Discount", addcontroller: _addDiscount),
                    customTextField(
                        hinttext: "OriginalPrice",
                        addcontroller: _addOriginalPrice),
                    customTextField(
                        hinttext: "Price", addcontroller: _addPrice),
                    customTextField(
                        hinttext: "Title", addcontroller: _addTitle),
                    customTextField(hinttext: "Type", addcontroller: _addType),
                    customTextField(
                        hinttext: "Validity", addcontroller: _addValidity),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          extraPackageStream!.add(
                            {
                              'doc_id': _addDocId.text,
                              'discount': _addDiscount.text,
                              'original_price': _addOriginalPrice.text,
                              'price': _addPrice.text,
                              'title': _addTitle.text,
                              'type': _addType.text,
                              'validity': _addValidity.text,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}

// *Updating Item list Class

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.discount,
    required this.originalPrice,
    required this.price,
    required this.title,
    required this.type,
    required this.validity,
    required this.docId,
  }) : super(key: key);

  final String discount;
  final String originalPrice;
  final String price;
  final String title;
  final String type;
  final String validity;
  final String docId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _originalPrice = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _validity = TextEditingController();
  final TextEditingController _docId = TextEditingController();

  @override
  void initState() {
    super.initState();
    _discount.text = widget.discount;
    _originalPrice.text = widget.originalPrice;
    _price.text = widget.price;
    _title.text = widget.title;
    _type.text = widget.type;
    _validity.text = widget.validity;
    _docId.text = widget.docId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        height: 580,
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
              customTextField(hinttext: "Discount", addcontroller: _discount),
              customTextField(
                  hinttext: "Original Price", addcontroller: _originalPrice),
              customTextField(hinttext: "Price", addcontroller: _price),
              customTextField(hinttext: "Title", addcontroller: _title),
              customTextField(hinttext: "Type", addcontroller: _type),
              customTextField(hinttext: "Validity", addcontroller: _validity),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${_docId.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc(globalGymId)
                          .collection("package")
                          .doc("normal_package")
                          .collection("gym")
                          .doc(_docId.text);
                      Map<String, dynamic> data = <String, dynamic>{
                        'discount': _discount.text,
                        'original_price': _originalPrice.text,
                        'price': _price.text,
                        'title': _title.text,
                        'type': _type,
                        'validity': _validity.text,
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
