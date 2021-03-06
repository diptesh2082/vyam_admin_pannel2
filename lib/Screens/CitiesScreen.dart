import 'package:admin_panel_vyam/Screens/cities_add_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/deleteMethod.dart';
import 'package:admin_panel_vyam/Screens/map_view.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({Key? key}) : super(key: key);

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  CollectionReference? cityStream;
  @override
  void initState() {
    super.initState();
    cityStream = FirebaseFirestore.instance.collection('Cities');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cities"),
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
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Get.to(() => const citiesAdd());
                    },
                    child: const Text('Add Cities'),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: cityStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowHeight: 65,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Index',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            // DataColumn(
                            //   label: Text(
                            //     'ID',
                            //     style: TextStyle(fontWeight: FontWeight.w600),
                            //   ),
                            // ),
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
                          rows: _buildlist(context, snapshot.data!.docs),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
    // String cityId = data['id'];
    // bool status = data['Status'];
    bool status = false;
    try {
      status = data['Status'];
    } catch (e) {
      status = false;
    }
    String? cityId;
    try {
      cityId = data['id'];
    } catch (e) {
      cityId = '#Error';
    }
    String? Address;
    try {
      Address = data['Address'];
    } catch (e) {
      Address = '#Error';
    }
    return DataRow(cells: [
      DataCell(data != null ? Text(index.toString()) : const Text("")),
      DataCell(
        Address != null ? Text(Address) : const Text(""),
      ),
      DataCell(
        status != null ? Text(status.toString()) : const Text(""),
      ),
      // DataCell(
      //   data['id'] != null ? Text(data['id']) : const Text(""),
      // ),
      DataCell(
        const Text(''),
        showEditIcon: true,
        onTap: () {
          Get.to(() => ProductEditBox(
              address: Address.toString(),
              status: status,
              cityId: cityId.toString()));
        },
      ),
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(
        //     stream: FirebaseFirestore.instance.collection('Cities'),
        //     uniqueDocId: cityId);

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
                                  stream: FirebaseFirestore.instance
                                      .collection('Cities'),
                                  uniqueDocId: cityId);
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

  // showAddbox() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
  //           content: SizedBox(
  //             height: 480,
  //             width: 800,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'Add Records',
  //                     style: TextStyle(
  //                         fontFamily: 'poppins',
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14),
  //                   ),
  //                   customTextField(
  //                       hinttext: "Address", addcontroller: _addAddress),
  //                   customTextField(
  //                       hinttext: "Status", addcontroller: _addStatus),
  //                   customTextField(hinttext: "ID", addcontroller: _addId),
  //                   Center(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         await matchID(
  //                             newId: _addId.text,
  //                             matchStream: cityStream,
  //                             idField: 'id');
  //                         FirebaseFirestore.instance
  //                             .collection('Cities')
  //                             .doc(_addId.text)
  //                             .set(
  //                           {
  //                             'Address': _addAddress.text,
  //                             'Status': _addStatus.text,
  //                             'id': _addId.text,
  //                           },
  //                         );
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Text('Done'),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ));
}

//EDIT FEATURE

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.address,
    required this.status,
    required this.cityId,
  }) : super(key: key);

  final String address;
  final bool status;
  final String cityId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _address = TextEditingController();
// <<<<<<< HEAD
  final TextEditingController _status = TextEditingController();
  final TextEditingController _cityId = TextEditingController();
// =======
//   final TextEditingController _status = TextEditingController();
//   final TextEditingController _cityId = TextEditingController();
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
  final TextEditingController _addAddress = TextEditingController();
  static const cities_list = [
    "New Delhi",
    "Mumbai",
    "Delhi",
    "Bengaluru",
    "Hyderbad",
    "Chennai",
    "Ahmedabad",
  ];
  @override
  void initState() {
    super.initState();
    _address.text = widget.address;
    // _cityId.text = widget.cityId;
  }

  @override
  Widget build(BuildContext context) {
    bool selectedValue = widget.status;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Edit Cities'),
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          height: 800,
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
                const SizedBox(width: 15),
// <<<<<<< HEAD
//                 Text('Address'),
// =======
//
                const Text('Address'),

// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 7,
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    child: TypeAheadFormField(
                      suggestionsCallback: ((pattern) => cities_list.where(
                          (item) => item
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))),
                      itemBuilder: (_, String item) =>
                          ListTile(title: Text(item)),
                      onSuggestionSelected: (String val) {
                        _addAddress.text = val;
                        print(val);
                      },
                      getImmediateSuggestions: true,
                      hideSuggestionsOnKeyboardHide: false,
                      hideOnEmpty: false,
                      noItemsFoundBuilder: (context) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No Item Found'),
                      ),
                      textFieldConfiguration: TextFieldConfiguration(
                        scrollPadding: const EdgeInsets.all(20),
                        cursorWidth: 2.0,
                        controller: _addAddress,
                      ),
                    ),
                  ),
                ),
// <<<<<<< HEAD
                // customTextField3(hinttext: "ID", addcontroller: _cityId),
                Row(
                  children: [
                    const Text('Status :',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    DropdownButton(
                        value: selectedValue,
                        items: const [
                          DropdownMenuItem(
                            child: Text("TRUE"),
                            value: true,
                          ),
                          DropdownMenuItem(
                            child: Text("FALSE"),
                            value: false,
                          ),
                        ],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        }),
                  ],
                ),
// =======
                // customTextField3(hinttext: "Name", addcontroller: _address),
                // customTextField3(hinttext: "Image", addcontroller: _status),
                // customTextField3(hinttext: "ID", addcontroller: _cityId),
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
// <<<<<<< HEAD
                        print("The Gym id is : ${widget.cityId}");
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('Cities')
                            .doc(widget.cityId);
                        Map<String, dynamic> data = <String, dynamic>{
                          // 'Address': _addAddress.text,
                          // 'id': _cityId.text,
                          'Status': selectedValue,
                        };
                        await documentReference
                            .update(data)
// =======
//                         print("The Gym id is : ${_cityId.text}");
//                         DocumentReference documentReference = FirebaseFirestore
//                             .instance
//                             .collection('Cities')
//                             .doc(_cityId.text);
//                         Map<String, dynamic> data = <String, dynamic>{
//                           'Address': _addAddress.text,
//                           'id': _cityId.text,
//                           'Status': _status.text,
//                         };
//                         await documentReference
//                             .set(data)
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
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
      ),
    );
  }
}