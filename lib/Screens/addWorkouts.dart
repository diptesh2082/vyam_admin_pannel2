import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class addWorkouts extends StatefulWidget {
  const addWorkouts({Key? key}) : super(key: key);

  @override
  State<addWorkouts> createState() => _addWorkoutsState();
}

class _addWorkoutsState extends State<addWorkouts> {
  CollectionReference? couponStream;
  final id =
      FirebaseFirestore.instance.collection('workouts').doc().id.toString();

  @override
  void initState() {
    super.initState();
    couponStream = FirebaseFirestore.instance.collection("workouts");
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addWorkout = TextEditingController();
  final TextEditingController _addId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add Workouts'),
      ),
      body: Column(
        children: [
          Center(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: 800,
                height: 600,
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
                      customTextField3(hinttext: "ID", addcontroller: _addId),
                      customTextField3(
                          hinttext: "Name", addcontroller: _addWorkout),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await matchID(
                                  newId: id,
                                  matchStream: couponStream,
                                  idField: 'id');
                              await FirebaseFirestore.instance
                                  .collection('workouts')
                                  .doc(id)
                                  .set(
                                {
                                  'type': _addWorkout.text,
                                  'gym_id': _addId.text,
                                  'id': id,
                                },
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
