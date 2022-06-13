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
  CollectionReference? categoryStream;

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
    categoryStream = FirebaseFirestore.instance.collection("category");

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
            style: const TextStyle(fontWeight: FontWeight.bold),
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  addboxx(widget.pGymId, finalPackID)));
                    },
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
      DataCell(data != null ? Text(data['index'].toString()) : const Text("")),

      DataCell(data != null
          ? Text(data['title'].toString().toUpperCase())
          : const Text("")),
      DataCell(
          data != null ? Text(data['original_price'] ?? "") : const Text("")),
      DataCell(data != null ? Text(data['discount'] ?? "") : const Text("")),
      DataCell(data != null
          ? Text(data['type'].toString().toUpperCase())
          : const Text("")),
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
                    package_type: data['package_type'],
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
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: packageStream, uniqueDocId: packId);
      })
    ]);
  }
}

class addboxx extends StatefulWidget {
  final String pGymID;
  final String finalPackID;

  const addboxx(this.pGymID, this.finalPackID, {Key? key}) : super(key: key);

  @override
  State<addboxx> createState() => _addboxxState();
}

class _addboxxState extends State<addboxx> {
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _originalprice = TextEditingController();
  final TextEditingController _index = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _validity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  var selectedvaluee = 'pay per session';
  var selectedd = 'gym';
  CollectionReference? categoryStream;
  @override
  void initState() {
    // TODO: implement initState
    categoryStream = FirebaseFirestore.instance.collection("category");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            customTextField(
                hinttext: "original price", addcontroller: _originalprice),
            customTextField(hinttext: "index", addcontroller: _index),
            customTextField(hinttext: "title", addcontroller: _title),
            Row(
              children: [
                const Text('Type:',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(
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
            customTextField(hinttext: "validity", addcontroller: _validity),
            customTextField(hinttext: "price", addcontroller: _price),
            StreamBuilder(
                stream: categoryStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  var doc = snapshot.data.docs;
                  return SizedBox(
                    width: 400,
                    height: 400,
                    child: ListView.builder(
                        itemCount: doc.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RadioListTile<String>(
                              value: doc[index]['name'],
                              title: Text(doc[index]['name'].toString()),
                              groupValue: selectedd,
                              onChanged: (String? v) {
                                setState(() {
                                  selectedd = v!;
                                });
                                print(selectedd);
                              });
                        }),
                  );
                }),
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
                      .doc(widget.pGymID)
                      .collection('package')
                      .doc("normal_package")
                      .collection("gym")
                      .doc(widget.finalPackID)
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
                      "type": selectedd,
                      "id": widget.finalPackID,
                      "validity": _validity.text,
                      "price": _price.text,
                      "package_type": selectedvaluee,

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
    );
  }
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
    required this.package_type,
  }) : super(key: key);

  final String discount;
  final String originalprice;
  final int index;
  final String title;
  final String type;
  final String id;
  final gym_id;
  final String package_type;

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
  var sele;
  @override
  CollectionReference? categoryStream;
  void initState() {
    super.initState();
    categoryStream = FirebaseFirestore.instance.collection("category");

    _discount.text = widget.discount;
    _originalprice.text = widget.originalprice;
    _index.text = widget.index.toString();
    _title.text = widget.title;
    sele = widget.type;
    selectedvaluee = widget.package_type;
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

              Row(
                children: [
                  const Text('Type:',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(
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
              StreamBuilder(
                  stream: categoryStream!.snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    var doc = snapshot.data.docs;
                    return SizedBox(
                      width: 400,
                      height: 400,
                      child: ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RadioListTile<String>(
                                value: doc[index]['name'],
                                title: Text(doc[index]['name'].toString()),
                                groupValue: widget.type,
                                onChanged: (String? v) {
                                  setState(() {
                                    sele = v!;
                                  });
                                  print(sele);
                                });
                          }),
                    );
                  }),

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
                        "package_type": selectedvaluee,

                        "type": sele,
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
