import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/CustomTextFieldClass.dart';
import '../../../services/MatchIDMethod.dart';

String globalGymId = '';

class PackagesPage extends StatefulWidget {
  String pGymId;
  PackagesPage({Key? key, required this.pGymId}) : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  CollectionReference? packageStream;

  @override
  void initState() {
    super.initState();
    packageStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.pGymId)
        .collection('package')
    .doc("normal_package")
    .collection("gym")

    ;
    globalGymId = widget.pGymId;
  }

  final finalPackID =
      FirebaseFirestore.instance.collection('product_details').doc().id;

  @override
  Widget build(BuildContext context) {
    print(finalPackID);
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
                    stream: packageStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        print('No output for package');
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
                                'package id',
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
                                  'index',
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
    String packId = data['id'];
    return DataRow(cells: [
      DataCell(data != null ? Text(data['discount'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['index'].toString() ) : Text("")),
      DataCell(data != null ? Text(data['original_price'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['title'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['type'] ?? "") : Text("")),
      // DataCell(data != null ? Text(data['validity'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    gym_id: widget.pGymId,
                    type: data['type'], index: data['index'], discount: data['discount'], title:  data['title'], originalprice: data['original_price'], id: packId,
                  ),
                ),
              );
            });
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: packageStream, uniqueDocId: packId);
      })
    ]);
  }

  final TextEditingController _discount = TextEditingController();
  final TextEditingController _originalprice = TextEditingController();
  final TextEditingController _index= TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _validity = TextEditingController();
  final TextEditingController _price = TextEditingController();

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
                    customTextField(hinttext: "discount", addcontroller: _discount),
                    customTextField(hinttext: "original price", addcontroller: _originalprice),
                    customTextField(hinttext: "index", addcontroller: _index),
                    customTextField(
                        hinttext: "title", addcontroller: _title),
                    customTextField(
                        hinttext: "type", addcontroller: _type),
                    customTextField(
                        hinttext: "validity", addcontroller: _validity),
                    customTextField(
                        hinttext: "price", addcontroller: _price),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {

                          await
                          FirebaseFirestore.instance
                              .collection('product_details')
                              .doc(widget.pGymId)
                              .collection('package')
                              .doc("normal_package")
                          .collection("gym")
                          .doc(finalPackID)
                              .set(
                            {
                              'discount': _discount.text,
                              "original_price": _originalprice.text,
                              'index': int.parse(_index.text),
                              'title': _title.text,
                              "type":_type.text,
                              "id":finalPackID,
                              "validity":_validity.text,
                              "price":_price.text,
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

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.discount,
    required this.originalprice,
    required this.index,
    required this.title,
    required this.type,required this.id,required this.gym_id,
  }) : super(key: key);

  final String discount;
  final String originalprice;
  final int index;
  final String title;
  final String type;
  final String id;
  final gym_id;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _originalprice = TextEditingController();
  final TextEditingController _index= TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _type = TextEditingController();
  @override
  void initState() {
    super.initState();
    _discount.text = widget.discount;
    _originalprice.text = widget.originalprice;
    _index.text = widget.index.toString();
    _title.text = widget.title;
    _type.text=widget.type;
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
              customTextField(hinttext: "discount", addcontroller: _discount),
              customTextField(hinttext: "original price", addcontroller: _originalprice),
              customTextField(hinttext: "index", addcontroller: _index),
              customTextField(
                  hinttext: "title", addcontroller: _title),
              customTextField(
                  hinttext: "type", addcontroller: _type),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print(widget.id);
                      print(widget.gym_id);
                      // print("The Gym id is : ${widget.}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc(widget.gym_id)
                          .collection('package')
                          .doc("normal_package")
                          .collection("gym")
                          .doc(widget.id);
                      Map<String, dynamic> data = <String, dynamic>{
                        'discount': _discount.text,
                        "original_price": _originalprice.text,
                        'index': int.parse(_index.text),
                        'title': _title.text,
                        "type":_type.text
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
