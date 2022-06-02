

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class citiesAdd extends StatefulWidget {
  const citiesAdd({Key? key}) : super(key: key);

  @override
  State<citiesAdd> createState() => _citiesAddState();
}

class _citiesAddState extends State<citiesAdd> {

  CollectionReference? cityStream;

  @override
  void initState() {
    super.initState();
    cityStream = FirebaseFirestore.instance.collection('Cities');
  }

  final TextEditingController _addAddress = TextEditingController();
  final TextEditingController _addStatus = TextEditingController();
  final TextEditingController _addId = TextEditingController();


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
                customTextField(
                    hinttext: "Address", addcontroller: _addAddress),
                customTextField(
                    hinttext: "Status", addcontroller: _addStatus),
                customTextField(hinttext: "ID", addcontroller: _addId),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await matchID(
                          newId: _addId.text,
                          matchStream: cityStream,
                          idField: 'id');
                      FirebaseFirestore.instance
                          .collection('Cities')
                          .doc(_addId.text)
                          .set(
                        {
                          'Address': _addAddress.text,
                          'Status': _addStatus.text,
                          'id': _addId.text,
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
