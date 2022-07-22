import 'package:admin_panel_vyam/Screens/Product%20Details/product_details.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/deleteMethod.dart';

class simpl extends StatefulWidget {
  const simpl({Key? key}) : super(key: key);

  @override
  State<simpl> createState() => _simplState();
}

class _simplState extends State<simpl> {
  bool status = false;
  @override
  void initState() {
    // TODO: implement initState
    // simplStream = FirebaseFirestore.instance.collection('simpl');
    final DocumentReference document =
        FirebaseFirestore.instance.collection("simpl").doc('simpl');

    document.snapshots().listen((snapshot) {
      status = snapshot['eligable'];
      print(snapshot);
    });
    print("++++++++++++$status");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          title: Center(
            child: Text(
              'Simpl',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Simpl Activation",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                bool temp = status;
                setState(() {
                  temp = !status;
                });
                await FirebaseFirestore.instance
                    .collection('simpl')
                    .doc('simpl')
                    .update({'eligable': temp})
                    .whenComplete(() => print("Legitimate toggled"))
                    .catchError((e) => print(e));
              },
              child: Text(
                status ? "Disable" : "Enable",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  primary: status ? Colors.red : Colors.green),
            )
          ]),
        ));
  }
}

// class simpl extends StatefulWidget {
//   const simpl({Key? key}) : super(key: key);
//
//   @override
//   State<simpl> createState() => _simplState();
// }
//
// // List offersRules = [];
//
// class _simplState extends State<simpl> {
//
//   dynamic data;
//
//   @override
//   Future<void> initState() async {
//     // TODO: implement initState
//
//     //
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
