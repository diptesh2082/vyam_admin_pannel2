import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import '../../../services/CustomTextFieldClass.dart';
import '../../../services/image_picker_api.dart';

String globalGymId = '';
String name = '';

// ignore: must_be_immutable
class PackagesPage extends StatefulWidget {
  String pGymId;
  String o, land;

  PackagesPage(
      {Key? key, required this.pGymId, required this.o, required this.land})
      : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

String? print_type = "Select Coupon type";

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
    return Scaffold(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("Previous Page"),
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
    String packId = data['id'];
    bool legit = data['valid'];
    bool legit2 = data['trending'];
    return DataRow(cells: [
      // DataCell(data != null ? Text(data['id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['index'].toString()) : const Text("")),

      DataCell(data['title'] != null
          ? Text(data['title'].toString().toUpperCase())
          : const Text("")),
      DataCell(data['original_price'] != null
          ? Text(data['original_price'] ?? "")
          : const Text("")),
      DataCell(data['discount'] != null
          ? Text(data['discount'] ?? "")
          : const Text("")),
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
      DataCell(data['type'] != null
          ? Text(data['type'].toString().toUpperCase())
          : const Text("")),
      // DataCell(data != null ? Text(data['validity'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductEditBox(
                    validity: data['validity'],
                    gym_id: widget.pGymId,
                    price: data["price"],
                    type: data['type'],
                    package_type: data['package_type'],
                    index: data['index'],
                    discount: data['discount'],
                    title: data['title'],
                    originalprice: data['original_price'],
                    id: packId,
                    description: data['description'],
                    ptype: data['ptype'],
                    banner: data['banner'],
                    trending_img: data['trending_img'].toString(),
                    t_describe: data['tdescribe'])));
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
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('product_details')
                                  .doc(widget.pGymId)
                                  .update({
                                'service':
                                    FieldValue.arrayRemove([data['type']])
                              });
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

// ignore: camel_case_types
class addboxx extends StatefulWidget {
  final String pGymID;

  const addboxx(this.pGymID, {Key? key}) : super(key: key);

  @override
  State<addboxx> createState() => _addboxxState();
}

// ignore: camel_case_types
class _addboxxState extends State<addboxx> {
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _originalprice = TextEditingController();
  final TextEditingController _index = TextEditingController();
  final TextEditingController _title = TextEditingController();
  // final TextEditingController _type = TextEditingController();
  final TextEditingController _validity = TextEditingController();
  final TextEditingController _banner = TextEditingController();
  final TextEditingController _tdescribe = TextEditingController();

  // final TextEditingController _price = TextEditingController();
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
  void dropDowntype(bool? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      packagetype = selecetValue;
      if (selecetValue == true) {
        print_type = "Percentage";
      }
      if (selecetValue == false) {
        print_type = "Flat";
      }
    });
    // }
  }

  // String? print_type = "Select Coupon type";
  bool? packagetype = false;

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
                hinttext: "Original price", addcontroller: _originalprice),
            customTextField(hinttext: "Index", addcontroller: _index),
            customTextField(hinttext: "Banner", addcontroller: _banner),
            customTextField(
                hinttext: "Trending Description", addcontroller: _tdescribe),

            const SizedBox(
              height: 8,
            ),
            loadimage(id: finalPackID),
            const SizedBox(
              height: 8,
            ),
            const Text("Description"),
            MarkdownTextInput(
              (String value) => setState(() => descriptionn = value),
              descriptionn,
              label:
                  'Note - if you book for an off-day, dont worry it will get adjusted.',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Select Package type",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
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
            customTextField(hinttext: "validity", addcontroller: _validity),
            // customTextField(hinttext: "price", addcontroller: _price),

            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
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
                      "validity": _validity.text,
//                               "price": _price.text,
                      "type": selectedd,
                      "id": finalPackID,
                      // "validity": _validity.text,
                      "price": "0",
                      "package_type": selectedvaluee,
                      'description': descriptionn,
                      'trending': true,
                      'ptype': packagetype,
                      'banner': _banner.text,
                      'tdescribe': _tdescribe.text,
                      'trending_img': image12 ?? ""
                    },
                  );
                  await FirebaseFirestore.instance
                      .collection('product_details')
                      .doc(widget.pGymID)
                      .update({
                    'service': FieldValue.arrayUnion([selectedd])
                  });
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: prefer_typing_uninitialized_variables
var image12;

// ignore: camel_case_types
class loadimage extends StatefulWidget {
  loadimage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Trending Icon",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          child: const Icon(Icons.camera_alt),
          onTap: () async {
            try {
              var profileImage = await chooseImage();
              if (profileImage != null) {
                setState(() {
                  isloading = true;
                });
              }

              await getUrlImage(profileImage);
              setState(() {
                isloading = false;
              });
            } finally {
              print("++++++++++++++++++");
              setState(() {
                isloading = false;
              });
            }
            setState(() {
              isloading = false;
            });
          },
        ),
        SizedBox(
          width: 200,
          height: 100,
          child: isloading && image12 == null
              ? const SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : image12 != null && isloading == false
                  ? SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.network(image12),
                    )
                  : const SizedBox(
                      height: 100,
                      width: 200,
                      child: Center(child: Text("Please Upload Image")),
                    ),
        ),
      ],
    );
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance
          .ref()
          .child('product_details')
          .child('packages');

      Reference _reference = _firebaseStorage.child('packages/${widget.id}');
      await _reference.putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        image12 = imageUrl;
      });
    }
  }
}

var start = 0;
var page = 1;
var end = 10;
var length;

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.price,
    required this.gym_id,
    required this.type,
    required this.index,
    required this.discount,
    required this.title,
    required this.originalprice,
    required this.id,
    required this.package_type,
    required this.description,
    required this.validity,
    required this.ptype,
    required this.banner,
    required this.trending_img,
    required this.t_describe,
  }) : super(key: key);

  final String discount;
  final String validity;
  final String originalprice;
  final int index;
  final String price;
  final String title;
  final String type;
  final String id;
  final String banner;
  final gym_id;
  final String package_type;
  final String description;
  final bool ptype;
  final String trending_img;
  final String t_describe;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _originalprice = TextEditingController();
  final TextEditingController _index = TextEditingController();
  final TextEditingController _title = TextEditingController();
  // final TextEditingController _price = TextEditingController();
  final TextEditingController _validity = TextEditingController();
  final TextEditingController _banner = TextEditingController();
  final TextEditingController _tdescribe = TextEditingController();

  // final TextEditingController _type = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var selectedvaluee;
  // ignore: prefer_typing_uninitialized_variables
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
  bool packagetype = false;
  String ptypee = '';
  void dropDowntype(bool? selecetValue) {
    // if(selecetValue is String){
    setState(() {
      packagetype = selecetValue!;
      if (selecetValue == true) {
        ptypee = "Percentage";
      }
      if (selecetValue == false) {
        ptypee = "Flat";
      }
    });
    // }
  }

  void initState() {
    super.initState();
    categoryStream = FirebaseFirestore.instance.collection("category");
    _banner.text = widget.banner;
    _discount.text = widget.discount;
    _validity.text = widget.validity;
    _originalprice.text = widget.originalprice;
    _index.text = widget.index.toString();
    _title.text = widget.title;
    sele = widget.type;
    selectedvaluee = widget.package_type;
    description = widget.description;
    packagetype = widget.ptype;
    ptypee = widget.ptype ? "Percentage" : "Flat";
    _tdescribe.text = widget.t_describe;

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
              customTextField(hinttext: "title", addcontroller: _title),
              customTextField(hinttext: "discount", addcontroller: _discount),
              customTextField(
                  hinttext: "original price", addcontroller: _originalprice),
              customTextField(hinttext: "index", addcontroller: _index),
              customTextField(hinttext: "Banner", addcontroller: _banner),
              customTextField(
                  hinttext: "Description", addcontroller: _tdescribe),
              const SizedBox(
                height: 8,
              ),
              editim(imagea: widget.trending_img, gymid: widget.id),
              const SizedBox(
                height: 8,
              ),
              const Text("Description"),
              MarkdownTextInput(
                (String value) => setState(() => description = value),
                description,
                label:
                    'Note - if you book for an off-day, dont worry it will get adjusted.',
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
              Column(
                children: [
                  const Text(
                    "Select Package type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 280,
                    child: DropdownButton(
                        hint: Text("${ptypee}"),
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
              customTextField(hinttext: "validity", addcontroller: _validity),
              const Text('Category:',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(
                width: 20,
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
                        // 'price': _price.text,
//                         "type": _type.text
                        "package_type": selectedvaluee,
                        'validity': _validity.text,
                        "type": sele,
                        'ptype': packagetype,
                        'banner': _banner.text,
                        'tdescribe': _tdescribe.text,
                        'trending_img': image12 ?? widget.trending_img
                      };
                      await documentReference
                          .update(data)
                          .whenComplete(() => print("Item Updated"))
                          .catchError((e) => print(e));
                      await FirebaseFirestore.instance
                          .collection('product_details')
                          .doc(widget.gym_id)
                          .update({
                        'service': FieldValue.arrayUnion([sele])
                      });
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

class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.gymid})
      : super(key: key);
  final String imagea;
  final String gymid;
  @override
  State<editim> createState() => _editimState();
}

var image13;

class _editimState extends State<editim> {
  @override
  String i2 = '';
  @override
  void initState() {
    // TODO: implement initState
    i2 = widget.imagea;
    super.initState();
  }

// <<<<<<< HEAD
  bool isloading = false;
  var imagee;
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isloading = true;
              });
              var dic = await chooseImage();
              await addImageToStorage(dic, widget.gymid);
              setState(() {
                isloading = false;
              });
            },
            child: const Text(
              'Upload Trending Icon',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          isloading
              ? Container(
                  height: 200,
                  width: 200,
                  child: const CircularProgressIndicator())
              : image13 != null
                  ? Image(
                      image: NetworkImage(image13.toString()),
                      height: 200,
                      width: 200,
                    )
                  : Image(
                      image: NetworkImage(i2),
                      height: 200,
                      width: 200,
                    )
        ],
      ),
    );
  }

  addImageToStorage(XFile? pickedFile, String? id) async {
    if (kIsWeb) {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child("product_details")
          .child('trending/$id');
      await _reference
          .putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) async {
          var uploadedPhotoUrl = value;
          setState(() {
            image13 = value;
          });
          print(value);
          await FirebaseFirestore.instance
              .collection('product_details')
              .doc(globalGymId)
              .collection('package')
              .doc("normal_package")
              .collection("gym")
              .doc(id)
              .update({'image': image13});
// =======
//       reader.readAsDataUrl(file!);
//       reader.onLoadEnd.listen((event) async {
//         var snapshot =
//         await fs.ref().child('product_image/${widget.gymId}').putBlob(file);
//         String downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           image = downloadUrl;
// >>>>>>> 21d9c030cebb9d9fd030fc57983203910f0655fa
        });
      });
    } else {
//write a code for android or ios
    }
  }
}
