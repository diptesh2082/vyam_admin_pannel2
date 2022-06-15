import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addappdetail extends StatefulWidget {
  const addappdetail({Key? key}) : super(key: key);

  @override
  State<addappdetail> createState() => _addappdetailState();
}

class _addappdetailState extends State<addappdetail> {
  final id = FirebaseFirestore.instance.collection('app details').doc().id;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add App Details'),
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
                                  .collection('app details')
                                  .doc(id)
                                  .set(
                                {
                                  'id': id,
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
