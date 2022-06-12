import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/CustomTextFieldClass.dart';
import '../../../services/MatchIDMethod.dart';

String globalGymId = '';
String name = '';

class PackagesPage extends StatefulWidget {
  String pGymId;
  String o, land;

  PackagesPage(
      {Key? key, required this.pGymId, required this.o, required this.land})
      : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  CollectionReference? packageStream;
  var catagory;
  var drop = [];
  var catagory_type;
  void dropDownPackage(String? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      catagory_type = selecetValue;
    });
    // }
  }

  // bool loadig=true;
  // catagoryStream()async{
  //   await FirebaseFirestore.instance.collection("category").snapshots()
  //       .listen((event) {
  //         if(event.docs.isNotEmpty){
  //           catagory=event.docs;
  //           catagory.forEach((event){
  //             drop.add( event["name"].toString().toLowerCase());
  //             setState(() {
  //               loadig=false;
  //             });
  //             // DropdownMenuItem(child: Text(event["name"].toString()),value: event["name"].toString().toLowerCase(),),
  //           });
  //         }
  //   });
  // }
  var landmark;
  @override
  void initState() {
    super.initState();
    // catagoryStream();
    packageStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.pGymId)
        .collection('package')
        .doc("normal_package")
        .collection("gym");
    globalGymId = widget.pGymId;
    name = widget.o;
    landmark = widget.land;
  }

  final finalPackID =
      FirebaseFirestore.instance.collection('product_details').doc().id;

  @override
  Widget build(BuildContext context) {
    print(finalPackID);
    return
      // loadig?
      //   const Center(child: CircularProgressIndicator())
      //   :
      Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              '${name.toUpperCase()}, ${landmark.toString().toUpperCase()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
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
                                // DataColumn(
                                //     label: Text(
                                //   'package id',
                                //   style: TextStyle(fontWeight: FontWeight.w600),
                                // )),
                                DataColumn(
                                  label: Text(
                                    'Index',
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
                                    'Original Price',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                    label: Text(
                                      'Discount',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    )),

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
      // DataCell(data != null ? Text(data['id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['index'].toString()) : Text("")),

      DataCell(data != null
          ? Text(data['title'].toString().toUpperCase())
          : Text("")),
      DataCell(data != null ? Text(data['original_price'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['discount'] ?? "") : Text("")),
      DataCell(data != null
          ? Text(data['type'].toString().toUpperCase())
          : Text("")),
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
                    type: data['type'],
                    index: data['index'],
                    discount: data['discount'],
                    title: data['title'],
                    originalprice: data['original_price'],
                    id: packId,
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
  final TextEditingController _index = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _validity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  var selectedvaluee = 'pay per session';

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
                customTextField(
                    hinttext: "discount", addcontroller: _discount),
                customTextField(
                    hinttext: "original price",
                    addcontroller: _originalprice),
                customTextField(hinttext: "index", addcontroller: _index),
                customTextField(hinttext: "title", addcontroller: _title),
                Container(
                  child: Row(
                    children: [
                      Text('Type:',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton(
                          value: selectedvaluee,
                          items: [
                            DropdownMenuItem(
                              child: Text("pay per session"),
                              value: "pay per session",
                            ),
                            DropdownMenuItem(
                              child: Text("package"),
                              value: "package",
                            ),
                          ],
                          onChanged: (value) {
                            print(selectedvaluee);
                            setState(() {
                              selectedvaluee = value as String;
                            });
                          }),
                    ],
                  ),
                ),
                customTextField(
                    hinttext: "validity", addcontroller: _validity),
                customTextField(hinttext: "price", addcontroller: _price),
                // Container(
                //   color: Colors.yellowAccent,
                //   width: 280,
                //   child: DropdownButton(
                //       hint: Text("bgg"),
                //       items: catagory.map<DropdownMenuItem<String>>((DocumentSnapshot value){
                //         return DropdownMenuItem(child: Text(value["name"]),value:value["name"],);
                //       }).toList(),
                //       // const [
                //       //   DropdownMenuItem(child: Text("pay per session"),value: "pay per session",),
                //       //   DropdownMenuItem(child: Text("package"),value: "package",),
                //       // ],
                //       onChanged:dropDownPackage ),
                // ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
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
// <<<<<<< HEAD
//                               "type": _type.text,
//                               "id": finalPackID,
//                               "validity": _validity.text,
//                               "price": _price.text,
// =======
                          "type": selectedvaluee,
                          "id": finalPackID,
                          "validity": _validity.text,
                          "price": _price.text,
// >>>>>>> cf1997613ff877c63a56c61e3009bdfe3639ccfa
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
    required this.gym_id,
    required this.type,
    required this.index,
    required this.discount,
    required this.title,
    required this.originalprice,
    required this.id,
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
  final TextEditingController _index = TextEditingController();
  final TextEditingController _title = TextEditingController();
  // final TextEditingController _type = TextEditingController();
  var selectedvaluee;
  @override
  void initState() {
    super.initState();
    _discount.text = widget.discount;
    _originalprice.text = widget.originalprice;
    _index.text = widget.index.toString();
    _title.text = widget.title;
    selectedvaluee = widget.type;
    // _type.text = widget.type;
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
              customTextField(
                  hinttext: "original price", addcontroller: _originalprice),
              customTextField(hinttext: "index", addcontroller: _index),
              customTextField(hinttext: "title", addcontroller: _title),
              // customTextField(hinttext: "type", addcontroller: _type),
              Container(
                child: Row(
                  children: [
                    Text('Type:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                        value: selectedvaluee,
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
                        onChanged: (value) {
                          print(selectedvaluee);
                          setState(() {
                            selectedvaluee = value as String;
                          });
                        }),
                  ],
                ),
              ),
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

//                         "type": _type.text
// =======
                        "type": selectedvaluee,
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