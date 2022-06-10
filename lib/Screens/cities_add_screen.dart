


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
  var id =
      FirebaseFirestore.instance.collection('Cities').doc().id;

  final TextEditingController _addAddress = TextEditingController();
  final TextEditingController _addStatus = TextEditingController();
  //final TextEditingController _addId = TextEditingController();
  final TextEditingController _addIndex = TextEditingController();


  static const cities_list =[

    "New Delhi",
    "Mumbai",
    "Delhi",
    "Bengaluru",
    "Hyderbad",
    "Chennai",
    "Ahmedabad",

  ];
  // Completer<GoogleMapController> _controller = Completer();
  // geocoding.Location? _currentPosition;
  // LatLng? _latLong;
  // bool? _locating = false;
  // geocoding.Placemark? _placeMark;

// getUserAddress() async {
//   List<geocoding.Placemark> placemarks = await geocoding
//       .placemarkFromCoordinates(_latLong!.latitude, _latLong!.longitude);
//   setState(() {
//     _placeMark = placemarks.first;
//   });
// }
//
//
// static const CameraPosition _kGooglePlex = CameraPosition(
//   target: LatLng(37.42796133580664, -122.085749655962),
//   zoom: 14.4746,
// );

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add Cities'),
      ),
      body:
      Center(
        child: SizedBox(
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
              SizedBox(width: 15),

              Text('Address'),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      decoration: const BoxDecoration(
                          border:
                          const Border(bottom: BorderSide(color: Colors.grey))),
                      child: Stack(
                        children: [
                          MapView(),
                          const Center(
                              child: Icon(
                                Icons.location_on_rounded,
                                size: 40,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
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
                    suggestionsCallback: ((pattern) => cities_list.where((item) => item.toLowerCase().contains(pattern.toLowerCase()))),
                    itemBuilder: (_ , String item) => ListTile(title: Text(item)),
                    onSuggestionSelected: (String val) {
                     _addAddress.text = val ;
                      print(val);
                    },
                    getImmediateSuggestions: true,
                    hideSuggestionsOnKeyboardHide: false,
                    hideOnEmpty: false,
                    noItemsFoundBuilder: (context) => const Padding(padding: EdgeInsets.all(8.0),
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
                customTextField(
                    hinttext: "Status", addcontroller: _addStatus),
               //customTextField(hinttext: "ID", addcontroller: _addId),
                //customTextField(hinttext: "Index", addcontroller: _addIndex),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await matchID(
                          newId: id,
                          matchStream: cityStream,
                          idField: 'id');
                      FirebaseFirestore.instance
                          .collection('Cities')
                          .doc(id)
                          .set(
                        {
                          'Address': getAddress(),
                          'Status': _addStatus.text,
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

String getAddress()
{
  address1 = address;
  print(address1);
  return address1;

}
}
