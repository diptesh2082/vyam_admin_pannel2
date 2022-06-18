import 'dart:async';

import 'package:admin_panel_vyam/Screens/map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'request_helper.dart';

import 'globalVar.dart';
import 'map.dart';

class citiesAdd extends StatefulWidget {
  const citiesAdd({Key? key}) : super(key: key);
  @override
  State<citiesAdd> createState() => _citiesAddState();
}

class _citiesAddState extends State<citiesAdd> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference? cityStream;
  MapView mapView = MapView();
  String address1 = '';

  @override
  void initState() {
    cityStream = FirebaseFirestore.instance.collection('Cities');
    super.initState();
  }

  var id = FirebaseFirestore.instance.collection('Cities').doc().id;

  late List<PlacesApiHelperModel>? _list = [];
  FocusNode myFocousNode = FocusNode();

  final TextEditingController _addAddress = TextEditingController();
  final TextEditingController _addIndex = TextEditingController();

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
  Widget build(BuildContext context) {
    bool selectedValue = true;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add Cities'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
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
                const SizedBox(width: 15),

                const Text('Address'),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: Stack(
                        children: [
                          MapView(
                            address_con: _addAddress,
                          ),
                          const Center(
                              child: Icon(
                            Icons.location_on_rounded,
                            size: 40,
                            color: Colors.black,
                          )),
                        ],
                      ),
                    ),

                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: TextFormField(
                    //     controller: _addAddress,
                    //     autofocus: false,
                    //     focusNode: myFocousNode,
                    //     onChanged: (value) async {
                    //       _list =
                    //       await RequestHelper().getPlaces(query: value);
                    //       setState(() {});
                    //       if (value.isEmpty) {
                    //         _list!.clear();
                    //         setState(() {
                    //           _addAddress.text = value;
                    //           print('PRINTING LIST /////////////');
                    //           print(_list);
                    //         });
                    //       }
                    //     },
                    //     style: const TextStyle(
                    //       fontSize: 12,
                    //       fontFamily: 'Poppins',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //     decoration: InputDecoration(
                    //         prefixIcon: const Icon(Icons.abc),
                    //         suffixIcon: IconButton(
                    //           onPressed: () {
                    //             _addAddress.clear();
                    //             FocusScope.of(context)
                    //                 .requestFocus(myFocousNode);
                    //           },
                    //           icon: const Icon(Icons.edit_outlined),
                    //         ),
                    //         // border: InputBorde,
                    //         hintStyle: const TextStyle(
                    //             fontSize: 12,
                    //             fontFamily: 'Poppins',
                    //             fontWeight: FontWeight.w500,
                    //             color: Colors.green),
                    //         hintMaxLines: 2,
                    //         hintText: 'Search your location here'),
                    //   ),
                    // ),
                  ],
                ),
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
                        scrollPadding: EdgeInsets.all(20),
                        cursorWidth: 2.0,
                        controller: _addAddress,
                      ),
                    ),
                  ),
                ),
                // customTextField(
                //     hinttext: "Address", addcontroller: _addAddress),
                // Container(
                //   child: Row(
                //     children: [
                //       const Text('Status :',
                //           style: TextStyle(
                //               fontWeight: FontWeight.w700, fontSize: 15)),
                //       DropdownButton(
                //           value: selectedValue,
                //           items: const [
                //             DropdownMenuItem(
                //               child: Text("TRUE"),
                //               value: true,
                //             ),
                //             DropdownMenuItem(
                //               child: Text("FALSE"),
                //               value: false,
                //             ),
                //           ],
                //           onChanged: (bool? value) {
                //             setState(() {
                //               selectedValue = value!;
                //             });
                //           }),
                //     ],
                //   ),
                // ),
                //customTextField(hinttext: "ID", addcontroller: _addId),
                //customTextField(hinttext: "Index", addcontroller: _addIndex),
// =======
//               ),
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await matchID(
                          newId: id, matchStream: cityStream, idField: 'id');
                      FirebaseFirestore.instance
                          .collection('Cities')
                          .doc(id)
                          .set(
                        {
// <<<<<<< HEAD
//                           'Address': getAddress(),
//                           'Status': true,
                          'Address': _addAddress.text,
                          'Status': true,
// >>>>>>> e2b255f6cfc25eda9d5d8491339e8c2023780f47
                          'id': id,
                          //'index' : _addIndex,
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
      ),
    );
  }

  String getAddress() {
    address1 = address;
    print(address1);
    return address1;
  }
}
