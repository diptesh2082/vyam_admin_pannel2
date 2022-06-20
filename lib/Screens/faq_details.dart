import 'package:admin_panel_vyam/services/MatchIDMethod.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/CustomTextFieldClass.dart';

class FaqDetails extends StatefulWidget {
  const FaqDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<FaqDetails> createState() => _FaqDetailsState();
}

class _FaqDetailsState extends State<FaqDetails> {
  final id = FirebaseFirestore.instance.collection('faq').doc().id.toString();
  CollectionReference? faqStream;

  @override
  void initState() {
    super.initState();
    faqStream = FirebaseFirestore.instance.collection("faq");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add FAQ',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: faqStream!.snapshots(),
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
                                'Question',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Answer',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Gym ID',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'User ID',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Edit',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Delete',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            rows: _buildlist(context, snapshot.data!.docs)),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Previous Page"),
                      onPressed: () {
                        if (start >= 1) page--;

                        setState(() {
                          if (start > 0 && end > 0) {
                            start = start - 10;
                            end = end - 10;
                          }
                        });
                        print("Previous Page");
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        page.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Next Page"),
                      onPressed: () {
                        setState(() {
                          if (end <= length) page++;
                          if (end < length) {
                            start = start + 10;
                            end = end + 10;
                          }
                        });
                        print("Next Page");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var start = 0;
  var page = 1;
  var end = 10;
  var length;

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    var d = 1;
    var s = start + 1;
    var snap = [];
    length = snapshot.length;
    snapshot.forEach((element) {
      if (end >= d++ && start <= d) {
        snap.add(element);
      }
    });
    return snap
        .map((data) => _buildListItem(context, data, s++, start, end))
        .toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data, int index,
      int start, int end) {
    String idData = data['id'];
    return DataRow(cells: [
      DataCell(data['question'] != null
          ? Text(data['question'] ?? "")
          : const Text("")),
      DataCell(
          data['answer'] != null ? Text(data['answer'] ?? "") : const Text("")),
      // DataCell(
      //     data['gym_id'] != null ? Text(data['gym_id'] ?? "") : const Text("")),
      // DataCell(data['user_id'] != null
      //     ? Text(data['user_id'] ?? "")
      //     : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditBox(
                userid: data['user_id'],
                answer: data['answer'],
                gymid: data['gym_id'],
                question: data['question'],
                id: data['id'],
              ),
            ));
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: faqStream, uniqueDocId: idData);
      })
    ]);
  }

  final TextEditingController _addaquestion = TextEditingController();
  final TextEditingController _addanswer = TextEditingController();
  final TextEditingController _addgymid = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();

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
                        hinttext: "Question", addcontroller: _addaquestion),
                    customTextField(
                        hinttext: "Answer", addcontroller: _addanswer),
                    // customTextField(
                    //     hinttext: "Gym ID", addcontroller: _addgymid),
                    // customTextField(
                    //     hinttext: "User ID", addcontroller: _adduserid),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await matchID(
                              newId: id, matchStream: faqStream, idField: 'id');
                          await FirebaseFirestore.instance
                              .collection('faq')
                              .doc(id)
                              .set(
                            {
                              'question': _addaquestion.text,
                              'answer': _addanswer.text,
                              'gym_id': _addgymid.text,
                              'user_id': _adduserid.text,
                              'id': id,
                            },
                          );
                        },
                        child: const Text('Done'),
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
    required this.question,
    required this.answer,
    required this.gymid,
    required this.userid,
    required this.id,
  }) : super(key: key);

  final String question;
  final String answer;
  final String gymid;
  final String userid;
  final String id;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  final TextEditingController _question = TextEditingController();
  final TextEditingController _answer = TextEditingController();
  final TextEditingController _gymid = TextEditingController();
  final TextEditingController _userid = TextEditingController();

  @override
  void initState() {
    super.initState();
    _question.text = widget.question;
    _answer.text = widget.answer;
    _gymid.text = widget.gymid;
    _userid.text = widget.userid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Edit Booking'),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
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
                SizedBox(
                  height: 70,
                  child: Card(
                      child: TextField(
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    controller: _question,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        hintMaxLines: 2,
                        hintText: 'Question'),
                  )),
                ),
                SizedBox(
                  height: 70,
                  child: Card(
                      child: TextField(
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    controller: _answer,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        hintMaxLines: 2,
                        hintText: 'Answer'),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("/////");

                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('faq')
                            .doc(widget.id);
                        Map<String, dynamic> data = <String, dynamic>{
                          'question': _question.text,
                          'answer': _answer.text,
                          'gym_id': _gymid.text,
                          'user_id': _userid.text,
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
        ));
  }
}
