import 'package:admin_panel_vyam/services/maps_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExtraPackagesPage extends StatefulWidget {
  const ExtraPackagesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExtraPackagesPage> createState() => _ExtraPackagesPageState();
}

class _ExtraPackagesPageState extends State<ExtraPackagesPage> {
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
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
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
                    stream: FirebaseFirestore.instance
                        .collection("product_details")
                        .doc("mahtab5752@gmail.com")
                        .collection("package")
                        .doc("normal_package")
                        .collection("gym")
                        .snapshots(),
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
                              // DataColumn(label: Text('')), //! For edit pencil
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
    return DataRow(cells: [
      DataCell(data != null ? Text(data['discount'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['original_price'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['price'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['title'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['type'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['validity'] ?? "") : Text("")),
      // DataCell(
      //   const Text(""),
      //   showEditIcon: true,
      //   onTap: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return GestureDetector(
      //           // ? Added Gesture Detecter for popping off update record Card
      //           child: SingleChildScrollView(
      //             child: ProductEditBox(
      //               address: data['address'],
      //               gender: data['gender'],
      //               name: data['name'],
      //               pincode: data['pincode'],
      //               gymId: data['gym_id'],
      //               gymOwner: data['gym_owner'],
      //               landmark: data['landmark'],
      //               location: data['location'],
      //             ),
      //           ),
      //           onTap: () =>
      //               Navigator.pop(context), // ? ontap Property for popping of
      //         );
      //       },
      //     );
      //   },
      // ),
    ]);
  }

  final TextEditingController _addDiscount = TextEditingController();
  final TextEditingController _addOriginalPrice = TextEditingController();
  final TextEditingController _addPrice = TextEditingController();
  final TextEditingController _addTitle = TextEditingController();
  final TextEditingController _addType = TextEditingController();
  final TextEditingController _addValidity = TextEditingController();
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
                    CustomTextField(
                        hinttext: "Discount", addcontroller: _addDiscount),
                    CustomTextField(
                        hinttext: "OriginalPrice",
                        addcontroller: _addOriginalPrice),
                    CustomTextField(
                        hinttext: "Price", addcontroller: _addPrice),
                    CustomTextField(
                        hinttext: "Title", addcontroller: _addTitle),
                    CustomTextField(hinttext: "Type", addcontroller: _addType),
                    CustomTextField(
                        hinttext: "Validity", addcontroller: _addValidity),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('product_details')
                              .doc("mahtab5752@gmail.com")
                              .collection("package")
                              .doc("normal_package")
                              .collection("gym")
                              .add(
                            {
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hinttext,
    required this.addcontroller,
  }) : super(key: key);

  final TextEditingController addcontroller;
  final String hinttext;

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
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: hinttext),
      )),
    );
  }
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
  }) : super(key: key);

  final String discount;
  final String originalPrice;
  final String price;
  final String title;
  final String type;
  final String validity;

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

  @override
  void initState() {
    super.initState();
    _discount.text = widget.discount;
    _originalPrice.text = widget.originalPrice;
    _price.text = widget.price;
    _title.text = widget.title;
    _type.text = widget.type;
    _validity.text = widget.validity;
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
              CustomTextField(hinttext: "Discount", addcontroller: _discount),
              CustomTextField(
                  hinttext: "Original Price", addcontroller: _originalPrice),
              CustomTextField(hinttext: "Price", addcontroller: _price),
              CustomTextField(hinttext: "Title", addcontroller: _title),
              CustomTextField(hinttext: "Type", addcontroller: _type),
              CustomTextField(hinttext: "Validity", addcontroller: _validity),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${_discount.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc("mahtab5752@gmail.com")
                          .collection("package")
                          .doc("normal_package")
                          .collection("gym")
                          .doc();
                      Map<String, dynamic> data = <String, dynamic>{
                        'discount': _discount.text,
                        'originalPrice': _originalPrice.text,
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
