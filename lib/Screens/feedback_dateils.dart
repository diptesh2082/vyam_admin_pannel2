import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';

class FeedBackInfo extends StatefulWidget {
  const FeedBackInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedBackInfo> createState() => _FeedBackInfoState();
}

class _FeedBackInfoState extends State<FeedBackInfo> {
  final id =
      FirebaseFirestore.instance.collection('Feedback').doc().id.toString();

  matchID(String nid) {
    final match = FirebaseFirestore.instance.collection('Feedback');
    match.doc(nid).set({'feedback_id': nid});
  }

  CollectionReference? feedbackStream;
  @override
  void initState() {
    feedbackStream = FirebaseFirestore.instance.collection("Feedback");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: GestureDetector(
                    onTap: showAddbox,
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add Feedback',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: feedbackStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Feedback Review',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Feedback Suggestion',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(label: Text('')),
                              DataColumn(label: Text(''))
                            ],
                            rows: _buildlist(context, snapshot.data!.docs)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String feedbackId = data['feedback_id'];
    return DataRow(cells: [
      DataCell(data != null ? Text(data['feedback_review'] ?? "") : Text("")),
      DataCell(
          data != null ? Text(data['feedback_suggestion'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['user_id'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SingleChildScrollView(
                  child: EditBox(
                    feedbackid: data['feedback_id'],
                    userId: data['user_id'],
                    freview: data['feedback_review'],
                    fsuggestion: data['feedback_suggestion'],
                  ),
                ),
              );
            });
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: feedbackStream, uniqueDocId: feedbackId);
      })
    ]);
  }

  TextEditingController _addfeedbackreview = TextEditingController();
  TextEditingController _addfeedbacksuggestion = TextEditingController();
  TextEditingController _adduserid = TextEditingController();
  TextEditingController _addvendorid = TextEditingController();

  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: SizedBox(
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
                        hinttext: "Feedback Review",
                        addcontroller: _addfeedbackreview),
                    customTextField(
                        hinttext: "Feedback Suggestion",
                        addcontroller: _addfeedbacksuggestion),
                    customTextField(
                        hinttext: "User ID", addcontroller: _adduserid),
                    customTextField(
                        hinttext: "Vendor ID", addcontroller: _addvendorid),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await matchID(id);
                          await FirebaseFirestore.instance
                              .collection('Feedback')
                              .doc(id)
                              .update(
                            {
                              'feedback_review': _addfeedbackreview.text,
                              'feedback_suggestion':
                                  _addfeedbacksuggestion.text,
                              'user_id': _adduserid.text,
                              'vendor_id': _addvendorid.text,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: Text('Done'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    required this.freview,
    required this.fsuggestion,
    required this.userId,
    required this.feedbackid,
  }) : super(key: key);

  final String freview;
  final String fsuggestion;
  final String userId;
  final String feedbackid;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  TextEditingController _feedbackReview = TextEditingController();
  TextEditingController _feedbackSuggestion = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackReview.text = widget.freview;
    _feedbackSuggestion.text = widget.fsuggestion;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        height: 580,
        width: 800,
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
              customTextField(
                  hinttext: "Feedback Review", addcontroller: _feedbackReview),
              customTextField(
                  hinttext: "Feedback Suggestion",
                  addcontroller: _feedbackSuggestion),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");

                      DocumentReference documentReference =
                          FirebaseFirestore.instance
                              .collection('Feedback')
                              //change _number to _userid
                              .doc(widget.feedbackid);

                      Map<String, dynamic> data = <String, dynamic>{
                        'feedback_review': _feedbackReview.text,
                        'feedback_suggestion': _feedbackSuggestion.text,
                      };
                      await documentReference
                          .update(data)
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
    );
  }
}
