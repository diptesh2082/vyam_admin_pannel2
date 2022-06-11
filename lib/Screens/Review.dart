import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPage();
}

class _ReviewPage extends State<ReviewPage> {
  CollectionReference? reviewStream;
  final reviewId =
      FirebaseFirestore.instance.collection('Reviews').doc().id.toString();

  @override
  void initState() {
    reviewStream = FirebaseFirestore.instance.collection("Reviews");
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
                    stream: reviewStream?.snapshots(),
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
                          dataRowHeight: 75.0,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'User Pic',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'User Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Experience',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Gym Id',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Rating',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            // DataColumn(
                            //   label: Text(
                            //     'Review',
                            //     style: TextStyle(fontWeight: FontWeight.w600),
                            //   ),
                            // ),
                            DataColumn(
                              label: Text(
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'User Id',
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
    String reviewId = data['gym_id'];
    return DataRow(
      cells: [
        DataCell(
          data['user']['user_pic'] != null
              ? Image.network(
                  data['user']['user_pic'] ?? "",
                  scale: 0.5,
                  height: 100.0,
                  width: 100.0,
                )
              : const Text(""),
        ),
        DataCell(
          data['user']['user_name'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['user']['user_name'],
                  ),
                )
              : const Text(""),
        ),
        DataCell(
          data['experience'] != null
              ? SizedBox(
                  width: 400.0,
                  child: Text(data['experience'] ?? ""),
                )
              : const Text(""),
        ),
        DataCell(
          data['gym_id'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['gym_id'],
                  ),
                )
              : const Text(""),
        ),
        DataCell(
          data['rating'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['rating'],
                  ),
                )
              : const Text(""),
        ),
        // DataCell(
        //   data['review'] != null
        //       ? SizedBox(
        //           width: 200.0,
        //           child: Text(
        //             data['review'],
        //           ),
        //         )
        //       : const Text(""),
        // ),
        DataCell(
          data['title'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['title'],
                  ),
                )
              : const Text(""),
        ),
        DataCell(
          data['user']['user_id'] != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    data['user']['user_id'],
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
                      child: ReviewEditBox(
                        experience: data['experience'],
                        gym_id: data['gym_id'],
                        rating: data['rating'],
                        review: data['review'],
                        title: data['title'],
                        user_id: data['user']['user_id'],
                        user_name: data['user']['user_name'],
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
            deleteMethod(stream: reviewStream, uniqueDocId: reviewId);
          },
        ),
      ],
    );
  }
}

class ReviewEditBox extends StatefulWidget {
  const ReviewEditBox({
    Key? key,
    required this.gym_id,
    required this.experience,
    required this.rating,
    required this.review,
    required this.title,
    required this.user_id,
    required this.user_name,
  }) : super(key: key);

  final String gym_id;
  final String experience;
  final String rating;
  final String review;
  final String title;
  final String user_id;
  final String user_name;

  @override
  State<ReviewEditBox> createState() => _ReviewEditBoxState();
}

class _ReviewEditBoxState extends State<ReviewEditBox> {
  final TextEditingController _gym_id = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  final TextEditingController _review = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _user_id = TextEditingController();
  final TextEditingController _user_name = TextEditingController();
  @override
  void initState() {
    super.initState();
    _gym_id.text = widget.gym_id;
    _experience.text = widget.experience;
    _rating.text = widget.rating;
    _review.text = widget.review;
    _title.text = widget.title;
    _user_id.text = widget.user_id;
    _user_name.text = widget.user_name;
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
              customTextField(hinttext: "Gym Id", addcontroller: _gym_id),
              customTextField(hinttext: "Detail", addcontroller: _experience),
              customTextField(hinttext: "Discount", addcontroller: _rating),
              customTextField(hinttext: "Review", addcontroller: _review),
              customTextField(hinttext: "Title", addcontroller: _title),
              customTextField(hinttext: "UserId", addcontroller: _user_id),
              customTextField(hinttext: "User Name", addcontroller: _user_name),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("/////");
                      print('${widget.review}');

                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('Reviews')
                          .doc(widget.review);
                      Map<String, dynamic> data = {
                        'experience': _experience.text,
                        'gym_id': _gym_id.text,
                        'rating': _rating.text,
                        'review': _review.text,
                        'title': _title.text,
                        'user_id': _user_id.text,
                        'user_name': _user_name.text,
                      };
                      await FirebaseFirestore.instance
                          .collection('Reviews')
                          .doc(widget.review)
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
