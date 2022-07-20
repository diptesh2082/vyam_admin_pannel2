import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ReviewInfo extends StatefulWidget {
  const ReviewInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<ReviewInfo> createState() => _ReviewInfoState();
}

class _ReviewInfoState extends State<ReviewInfo> {
  final id =
      FirebaseFirestore.instance.collection('Reviews').doc().id.toString();

  createReview(String nid) {
    final review = FirebaseFirestore.instance.collection('Reviews');
    review.doc(nid).set({'review_id': nid});
  }

  @override
  void initState() {
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
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add Review',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Reviews")
                        .snapshots(),
                    // .collection('T@gmail.com')
                    // .snapshots(),
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
                                'Experience',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Rating',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Title',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'UserID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Edit',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
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
      DataCell(data['experience'] != null
          ? Text(data['experience'] ?? "")
          : const Text("")),
      DataCell(
          data['rating'] != null ? Text(data['rating'] ?? "") : const Text("")),
      DataCell(
          data['title'] != null ? Text(data['title'] ?? "") : const Text("")),
      DataCell(data['user_id'] != null
          ? Text(data['user_id'] ?? "")
          : const Text("")),
      // DataCell(const Text(""), showEditIcon: true, onTap: () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => EditBox(
      //           reviewid: data['review_id'],
      //           userid: data['user_id'],
      //           title: data['title'],
      //           experience: data['experience'],
      //           rating: data['rating'],
      //         ),
      //       ));
      // }),
      const DataCell(
        const Icon(Icons.delete),
      ),
    ]);
  }

  // final TextEditingController _addrating = TextEditingController();
  // final TextEditingController _adduserid = TextEditingController();
  // final TextEditingController _addgymid = TextEditingController();

  // showAddbox() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
  //           content: SizedBox(
  //             height: 480,
  //             width: 800,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'Add Records',
  //                     style: TextStyle(
  //                         fontFamily: 'poppins',
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14),
  //                   ),
  //                   CustomTextField(
  //                       hinttext: "Experience", addcontroller: _addexperience),
  //                   CustomTextField(
  //                       hinttext: "Rating", addcontroller: _addrating),
  //                   CustomTextField(
  //                       hinttext: "Title", addcontroller: _addtitle),
  //                   CustomTextField(
  //                       hinttext: "UserID", addcontroller: _adduserid),
  //                   CustomTextField(
  //                       hinttext: "Gym ID", addcontroller: _addgymid),
  //                   Center(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         await createReview(id);
  //                         await FirebaseFirestore.instance
  //                             .collection('Reviews')
  //                             .doc(id)
  //                             .update(
  //                           {
  //                             'experience': _addexperience.text,
  //                             'rating': _addrating.text,
  //                             'title': _addtitle.text,
  //                             'user_id': _adduserid.text,
  //                             'gym_id': _addgymid.text
  //                           },
  //                         );
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text('Done'),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ));
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
      height: 70,
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
            contentPadding: const EdgeInsets.all(20),
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

// class EditBox extends StatefulWidget {
//   const EditBox(
//       {Key? key,
//       required this.experience,
//       required this.rating,
//       required this.title,
//       required this.userid,
//       required this.reviewid})
//       : super(key: key);
//
//   final String experience;
//   final String rating;
//   final String title;
//   final String userid;
//   final String reviewid;
//
//   @override
//   _EditBoxState createState() => _EditBoxState();
// }
//
// class _EditBoxState extends State<EditBox> {
//   TextEditingController _experience = TextEditingController();
//   TextEditingController _rating = TextEditingController();
//   TextEditingController _title = TextEditingController();
//   TextEditingController _userid = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _experience.text = widget.experience;
//     _rating.text = widget.rating;
//     _title.text = widget.title;
//     _userid.text = widget.userid;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Edit Box")),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Update Records for this doc',
//             style: TextStyle(
//                 fontFamily: 'poppins',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14),
//           ),
//           CustomTextField(hinttext: "Experience", addcontroller: _experience),
//           CustomTextField(hinttext: "Rating", addcontroller: _rating),
//           CustomTextField(hinttext: "Title", addcontroller: _title),
//           CustomTextField(hinttext: "User ID", addcontroller: _userid),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   print("/////");
//
//                   DocumentReference documentReference = FirebaseFirestore
//                       .instance
//                       .collection('Reviews')
//                       .doc(widget.reviewid);
//
//                   Map<String, dynamic> data = <String, dynamic>{
//                     'experience': _experience.text,
//                     'rating': _rating.text,
//                     'title': _title.text,
//                     'user_id': _userid.text,
//                   };
//                   await documentReference
//                       .update(data)
//                       .whenComplete(() => print("Item Updated"))
//                       .catchError((e) => print(e));
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Done'),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }