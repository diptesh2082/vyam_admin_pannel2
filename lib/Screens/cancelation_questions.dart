import 'package:admin_panel_vyam/Screens/add_question.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class CancelationQuestion extends StatefulWidget {
  const CancelationQuestion({Key? key}) : super(key: key);

  @override
  State<CancelationQuestion> createState() => _CancelationQuestionState();
}

class _CancelationQuestionState extends State<CancelationQuestion> {
  CollectionReference? questionStream;
  final Id = FirebaseFirestore.instance
      .collection('cancelation question')
      .doc()
      .id
      .toString();

  @override
  void initState() {
    questionStream =
        FirebaseFirestore.instance.collection('cancelation question');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Get.to(const addQuestion()); //showAddbox,
                      },
                      child: Text('Add Question')),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: questionStream?.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // dataRowHeight: 75.0,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Index',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                              label: Text(
                                'Question',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
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
                          rows: _buildlist(context, snapshot.data.docs),
                        ),
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
    var d = 1;
    return snapshot.map((data) => _buildListItem(context, data, d++)).toList();
  }

  DataRow _buildListItem(
      BuildContext context, DocumentSnapshot data, int index) {
    String Id = data['id'];
    return DataRow(
      cells: [
        DataCell(data != null ? Text(index.toString()) : const Text("")),
        DataCell(
          data['question'] != null
              ? SizedBox(
                  width: 100.0,
                  child: Text(data['question'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(const Text(''), showEditIcon: true, onTap: () {
          Get.to(
            () => QuestionEditBox(
              question: data['question'],
              index: data['index'],
              Id: data['id'],
            ),
          );
          onTap:
          () {
            Navigator.pop(context);
          };
        }),
        DataCell(
          Icon(Icons.delete),
          onTap: () {
            deleteMethod(stream: questionStream, uniqueDocId: Id);
          },
        ),
      ],
    );
  }
}

class QuestionEditBox extends StatefulWidget {
  const QuestionEditBox({
    Key? key,
    required this.index,
    required this.question,
    required this.Id,
  }) : super(key: key);

  final String question;
  final String index;
  final String Id;
  @override
  State<QuestionEditBox> createState() => _QuestionEditBoxState();
}

class _QuestionEditBoxState extends State<QuestionEditBox> {
  CollectionReference? userStream;
  final TextEditingController question = TextEditingController();
  final TextEditingController _index = TextEditingController();

  @override
  void initState() {
    super.initState();
    question.text = widget.question;
    _index.text = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit cancelation questions"),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Records for this doc',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
              customTextField(hinttext: "Question", addcontroller: question),
              customTextField(hinttext: "Index", addcontroller: _index),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");
                      print('${widget.Id}');

                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('cancelation question')
                          .doc(widget.Id);
                      Map<String, dynamic> data = {
                        'question': question.text,
                        'index': _index.text,
                      };
                      await FirebaseFirestore.instance
                          .collection('cancelation question')
                          .doc(widget.Id)
                          .update(data);
                      print("after");
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
