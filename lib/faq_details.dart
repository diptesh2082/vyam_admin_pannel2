import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class FaqDetails extends StatefulWidget {
  const FaqDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<FaqDetails> createState() => _FaqDetailsState();
}

class _FaqDetailsState extends State<FaqDetails> {
  @override
  final id = FirebaseFirestore.instance.collection('faq').doc().id.toString();

  createReview(String nid) {
    final review = FirebaseFirestore.instance.collection('faq');
    review.doc(nid).set({'id': nid});
  }

  void initState() {
    super.initState();
    // _address = TextEditingController();
    // _pincode = TextEditingController();
    // _gender = TextEditingController();
    // _gymid = TextEditingController();
    // _addaddress = TextEditingController();
    // _addgender = TextEditingController();
    // _gymowner = TextEditingController();
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
                    stream: FirebaseFirestore.instance
                        .collection("faq")
                        .snapshots(),
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
                              DataColumn(
                                label: Text(
                                  'Gym ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
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
    return DataRow(cells: [
      DataCell(data != null ? Text(data['question'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['answer'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gym_id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['user_id'] ?? "") : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: EditBox(
                  userid: data['user_id'],
                  answer: data['answer'],
                  gymid: data['gym_id'],
                  id: data['id'],
                  question: data['question'],
                ),
              );
            });
      }),
    ]);
  }

  TextEditingController _addaquestion = TextEditingController();
  TextEditingController _addanswer = TextEditingController();
  TextEditingController _addgymid = TextEditingController();
  TextEditingController _adduserid = TextEditingController();

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
                    CustomTextField(
                        hinttext: "Question", addcontroller: _addaquestion),
                    CustomTextField(
                        hinttext: "Answer", addcontroller: _addanswer),
                    CustomTextField(
                        hinttext: "Gym ID", addcontroller: _addgymid),
                    CustomTextField(
                        hinttext: "User ID", addcontroller: _adduserid),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await createReview(id);
                          await FirebaseFirestore.instance
                              .collection('faq')
                              .doc(id)
                              .update(
                            {
                              'question': _addaquestion.text,
                              'answer': _addanswer.text,
                              'gym_id': _addgymid.text,
                              'user_id': _adduserid.text
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hinttext,
    required this.addcontroller,
  }) : super(key: key);

  final TextEditingController addcontroller;
  final String hinttext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
          child: TextField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: hinttext),
      )),
    );
  }
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    required this.question,
    required this.answer,
    required this.gymid,
    required this.id,
    required this.userid,
  }) : super(key: key);

  final String question;
  final String answer;
  final String gymid;
  final String id;
  final String userid;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  TextEditingController _question = TextEditingController();
  TextEditingController _answer = TextEditingController();
  TextEditingController _gymid = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _userid = TextEditingController();

  @override
  void initState() {
    super.initState();
    _question.text = widget.question;
    _answer.text = widget.answer;
    _gymid.text = widget.gymid;
    _id.text = widget.id;
    _userid.text = widget.userid;
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
              SizedBox(
                height: 50,
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
                height: 50,
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
              SizedBox(
                height: 50,
                child: Card(
                    child: TextField(
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  controller: _gymid,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'Gym ID'),
                )),
              ),
              SizedBox(
                height: 50,
                child: Card(
                    child: TextField(
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  controller: _id,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'ID'),
                )),
              ),
              SizedBox(
                height: 50,
                child: Card(
                    child: TextField(
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  controller: _userid,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                      hintText: 'User ID'),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");

                      DocumentReference documentReference =
                          FirebaseFirestore.instance
                              .collection('faq')
                              //change _number to _userid
                              .doc(_id.text);

                      Map<String, dynamic> data = <String, dynamic>{
                        'question': _question.text,
                        'answer': _answer.text,
                        'gym_id': _gymid.text,
                        'id': _id.text,
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
      ),
    );
  }
}
