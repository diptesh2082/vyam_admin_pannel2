import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addQuestion extends StatefulWidget {
  const addQuestion({Key? key}) : super(key: key);

  @override
  State<addQuestion> createState() => _addQuestionState();
}

class _addQuestionState extends State<addQuestion> {
  final id =
      FirebaseFirestore.instance.collection('cancelation question').doc().id;
  final TextEditingController _addquestion = TextEditingController();
  final TextEditingController _addindex = TextEditingController();
  CollectionReference? questionStream;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Question'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 600,
                width: 800,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Add Records',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 25),
                        ),
                      ),
                      customTextField(
                          hinttext: "Question", addcontroller: _addquestion),
                      customTextField(
                          hinttext: "Index", addcontroller: _addindex),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // await createReview(id);
                              await FirebaseFirestore.instance
                                  .collection('cancelation question')
                                  .doc(id)
                                  .set(
                                {
                                  'id': id,
                                  'index': _addindex.text,
                                  'question': _addquestion.text,
                                },
                              );

                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Done'),
                        ),
                      )
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
