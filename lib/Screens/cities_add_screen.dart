

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class citiesAdd extends StatefulWidget {
  const citiesAdd({Key? key}) : super(key: key);

  @override
  State<citiesAdd> createState() => _citiesAddState();
}

class _citiesAddState extends State<citiesAdd> {
final _formKey = GlobalKey<FormState>();
  CollectionReference? cityStream;


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
                    noItemsFoundBuilder: (context) => Padding(padding: const EdgeInsets.all(8.0),
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
                          'Address': _addAddress.text,
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
}
