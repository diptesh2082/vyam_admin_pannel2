import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addQuestion extends StatefulWidget {
  const addQuestion({Key? key}) : super(key: key);

  @override
  State<addQuestion> createState() => _addQuestionState();
}

class _addQuestionState extends State<addQuestion> {
  CollectionReference? userStream;
  final id =
      FirebaseFirestore.instance.collection('cancelation question').doc().id;
  final TextEditingController _addquestion = TextEditingController();
  final TextEditingController _addindex = TextEditingController();
  String abc = 'false';
  CollectionReference? questionStream;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance.collection("user_details");
  }

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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('User Name:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: userStream!.snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == null) {
                            return Container();
                          }
                          print("-----------------------------------");
                          var doc = snapshot.data.docs;
                          return Container(
                            width: 400,
                            height: 200,
                            child: ListView.builder(
                                itemCount: doc.length,
                                itemBuilder: (BuildContext context, int index) {
                                  bool check = false;
                                  return RadioListTile<String>(
                                    value: doc[index]["name"],
                                    groupValue: abc,
                                    onChanged: (val) => setState(
                                      () {
                                        abc = val!;
                                      },
                                    ),
                                    title: Text(doc[index]["name"]),
                                  );
                                }),
                          );
                        },
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
                                  'user_id': abc,
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
