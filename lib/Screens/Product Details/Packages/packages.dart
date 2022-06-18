import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(onPrimary: Colors.purple),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addboxx(widget.pGymId)));
                    },
                    child: const Text(
                      'Add Packages',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // Container(
                    //   width: 120,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20.0)),
                    //   child: Row(
                    //     children: const [
                    //       Icon(Icons.add),
                    //       Text('Add Product',
                    //           style: TextStyle(fontWeight: FontWeight.w400)),
                    //     ],
                    //   ),
                    // ),
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
                                'Enable/Disable',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Trending Validity',
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
    bool legit = data['valid'];
    bool legit2 = data['trending'];
    return DataRow(cells: [
      // DataCell(data != null ? Text(data['id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['index'].toString()) : const Text("")),

      DataCell(data != null
          ? Text(data['title'].toString().toUpperCase())
          : const Text("")),
      DataCell(
          data != null ? Text(data['original_price'] ?? "") : const Text("")),
      DataCell(data != null ? Text(data['discount'] ?? "") : const Text("")),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              print(packId);
              print(legit);
              bool temp = legit;
              temp = !temp;
              print(temp);

              await FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(widget.pGymId)
                  .collection('package')
                  .doc("normal_package")
                  .collection("gym")
                  .doc(packId)
                  .update({'valid': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(legit ? "Enable" : "Disable"),
            style: ElevatedButton.styleFrom(
                primary: legit ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              print(packId);
              print(legit2);
              bool temp = legit2;
              temp = !temp;
              print(temp);

              await FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(widget.pGymId)
                  .collection('package')
                  .doc("normal_package")
                  .collection("gym")
                  .doc(packId)
                  .update({'trending': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(legit2 ? "Enable" : "Disable"),
            style: ElevatedButton.styleFrom(
                primary: legit2 ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(data != null
          ? Text(data['type'].toString().toUpperCase())
          : const Text("")),
      // DataCell(data != null ? Text(data['validity'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductEditBox(
                      gym_id: widget.pGymId,
                      type: data['type'],
                      package_type: data['package_type'],
                      index: data['index'],
                      discount: data['discount'],
                      title: data['title'],
                      originalprice: data['original_price'],
                      id: packId,
                      description: data['description'],
                    )));
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: packageStream, uniqueDocId: packId);

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
                                  stream: packageStream, uniqueDocId: packId);
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
      })
    ]);
  }
}

class addboxx extends StatefulWidget {
  final String pGymID;

  const addboxx(this.pGymID, {Key? key}) : super(key: key);

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
  TextEditingController controller = TextEditingController();
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  String descriptionn = 'Description';
  var finalPackID;

  @override
  void initState() {
    // TODO: implement initState
    categoryStream = FirebaseFirestore.instance.collection("category");
    finalPackID = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.pGymID)
        .collection('package')
        .doc("normal_package")
        .collection("gym")
        .doc()
        .id
        .toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Packages"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
            customTextField(hinttext: "Title", addcontroller: _title),

            customTextField(
                hinttext: "Discount Percentage", addcontroller: _discount),
            customTextField(
                hinttext: "original price", addcontroller: _originalprice),
            customTextField(hinttext: "index", addcontroller: _index),
            const SizedBox(
              height: 8,
            ),
            Text("Description"),
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

            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
// >>>>>>> 020d3fb78ac8558cc588ec004fcb0f0492d313ff

            StreamBuilder(
                stream: categoryStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return Container();
                  }
                  print("-----------------------------------");

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
                      .doc(finalPackID)
                      .set(
                    {
                      'discount': _discount.text,
                      "original_price": _originalprice.text,
                      'index': int.parse(_index.text),
                      'title': _title.text,
                      'valid': true,

//                               "type": _type.text,
//                               "id": finalPackID,
//                               "validity": _validity.text,
//                               "price": _price.text,

// =======
                      "type": selectedd,
                      "id": finalPackID,
                      "validity": _validity.text,
                      "price": _price.text,
                      "package_type": selectedvaluee,
                      'description': descriptionn,
                      'trending': true,
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
    required this.description,
  }) : super(key: key);

  final String discount;
  final String originalprice;
  final int index;
  final String title;
  final String type;
  final String id;
  final gym_id;
  final String package_type;
  final String description;

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
  String description = '';
  @override
  CollectionReference? categoryStream;
  TextEditingController controller = TextEditingController();
  List<MarkdownType> actions = const [
    MarkdownType.bold,
    MarkdownType.italic,
    MarkdownType.title,
    MarkdownType.link,
    MarkdownType.list
  ];
  void initState() {
    super.initState();
    categoryStream = FirebaseFirestore.instance.collection("category");

    _discount.text = widget.discount;
    _originalprice.text = widget.originalprice;
    _index.text = widget.index.toString();
    _title.text = widget.title;
    sele = widget.type;
    selectedvaluee = widget.package_type;
    description = widget.description;
    // _type.text = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Box"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
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
              const SizedBox(
                height: 8,
              ),
              Text("Description"),
              MarkdownTextInput(
                (String value) => setState(() => description = value),
                description,
                label: 'Description',
                maxLines: 10,
                actions: actions,
                controller: controller,
              ),
              const SizedBox(
                height: 8,
              ),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return Container();
                    }
                    print("-----------------------------------");

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
                                groupValue: sele,
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
                        'description': description,
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
