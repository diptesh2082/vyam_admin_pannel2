import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelationPage extends StatefulWidget {
  const CancelationPage({Key? key}) : super(key: key);

  @override
  State<CancelationPage> createState() => _CancelationPageState();
}

class _CancelationPageState extends State<CancelationPage> {
  CollectionReference? cancellationStream;
  final Id = FirebaseFirestore.instance
      .collection('Cancellation Data')
      .doc()
      .id
      .toString();

  @override
  void initState() {
    cancellationStream =
        FirebaseFirestore.instance.collection("Cancellation Data");
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
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: cancellationStream?.snapshots(),
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
<<<<<<< HEAD

=======
>>>>>>> 19382c55703e8d18447396a2ff0347af09f359ae
                            // DataColumn(
                            //   label: Text(
                            //     'User Name',
                            //     style: TextStyle(fontWeight: FontWeight.w600),
                            //   ),
                            // ),

                            DataColumn(
                              label: Text(
                                'Cancel Choice',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Cancel Remark',
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
                          rows: _buildlist(context, snapshot.data!.docs),
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
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String Id = data['Id'];
    return DataRow(
      cells: [
        DataCell(
          data['cancel_choice'] != null
              ? SizedBox(
                  width: 400.0,
                  child: Text(data['cancel_choice'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['cancel_remark'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['cancel_remark'],
                  ),
                )
              : const Text(""),
        ),
        DataCell(
          const Text(''),
          showEditIcon: true,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    child: SingleChildScrollView(
                      child: CancelationEditBox(
                        cancel_choice: data['cancel_choice'],
                        cancel_remark: data['cancel_remark'],
                        Id: data['Id'],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                });
          },
        ),
        DataCell(
          Icon(Icons.delete),
          onTap: () {
            deleteMethod(stream: cancellationStream, uniqueDocId: Id);
          },
        ),
      ],
    );
  }
}

class CancelationEditBox extends StatefulWidget {
  const CancelationEditBox({
    Key? key,
    required this.Id,
    required this.cancel_choice,
    required this.cancel_remark,
  }) : super(key: key);

  final String cancel_choice;
  final String cancel_remark;
  final String Id;

  @override
  State<CancelationEditBox> createState() => _CancelationEditBoxState();
}

class _CancelationEditBoxState extends State<CancelationEditBox> {
  final TextEditingController _cancel_choice = TextEditingController();
  final TextEditingController _cancel_remark = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cancel_choice.text = widget.cancel_choice;
    _cancel_remark.text = widget.cancel_remark;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      content: SizedBox(
        // height: 580,
        // width: 800,
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
                  controller: _cancel_choice,
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
                  controller: _cancel_remark,
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");
                      print('${widget.Id}');

                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('Cancellation Data')
                          .doc(widget.Id);
                      Map<String, dynamic> data = {
                        'cancel_choice': _cancel_choice.text,
                        'cancel_remark': _cancel_remark.text,
                      };
                      await FirebaseFirestore.instance
                          .collection('Cancellation Data')
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
