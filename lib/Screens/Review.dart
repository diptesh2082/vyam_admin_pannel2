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
      appBar: AppBar(title: Text("Review")),
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
                          rows: _buildlist(context, snapshot.data!.docs),
                        ),
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
                        setState(() {
                          if (start >= 1) page--;

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
    String? reviewId;
    try {
      reviewId = data['review'];
    } catch (e) {
      reviewId = "#ERROR";
    }

    String? userpic;
    try {
      userpic = data['user']['user_pic'];
    } catch (e) {
      userpic = "";
    }

    String? username;
    try {
      username = data['user']['user_name'];
    } catch (e) {
      username = "#ERROR";
    }

    String? experience;
    try {
      experience = data['experience'];
    } catch (e) {
      experience = "#ERROR";
    }

    String? rating;
    try {
      rating = data['rating'];
    } catch (e) {
      rating = "#ERROR";
    }

    String? title;
    try {
      title = data['title'];
    } catch (e) {
      title = "#ERROR";
    }

    String? userId;
    try {
      userId = data['user']['user_id'];
    } catch (e) {
      userId = "#ERROR";
    }

    return DataRow(
      cells: [
        DataCell(
          userpic != null
              ? Image.network(
                  userpic,
                  scale: 0.5,
                  height: 100.0,
                  width: 100.0,
                )
              : const Text(""),
        ),

        DataCell(
          username != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    username,
                  ),
                )
              : const Text(""),
        ),

        DataCell(
          experience != null
              ? SizedBox(
                  width: 400.0,
                  child: Text(experience),
                )
              : const Text(""),
        ),

        DataCell(data != null
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('product_details')
                    .doc(data['gym_id'])
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    print(snapshot.error);
                    return Container();
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Container();
                  }
                  return Text(
                      "${snapshot.data.get('name')} | ${snapshot.data.get('branch').toString().toUpperCase()}");
                })
            : const Text("")),

        DataCell(
          rating != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    rating,
                  ),
                )
              : const Text(""),
        ),

        DataCell(
          title != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    title,
                  ),
                )
              : const Text(""),
        ),
        // .toString().substring(3, 13))
        //   : Text("")),
        DataCell(
          userId != null
              ? SizedBox(
                  width: 200.0,
                  child: Text(
                    userId.toString().substring(3, 13),
                  ),
                )
              : const Text(""),
        ),
        // DataCell(
        //   const Text(''),
        //   showEditIcon: true,
        //   onTap: () {
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return GestureDetector(
        //             child: SingleChildScrollView(
        //               child: ReviewEditBox(
        //                 experience: data['experience'],
        //                 gym_id: data['gym_id'],
        //                 rating: data['rating'],
        //                 review: data['review'],
        //                 title: data['title'],
        //                 user_id: data['user']['user_id'],
        //                 user_name: data['user']['user_name'],
        //               ),
        //             ),
        //             onTap: () {
        //               Navigator.pop(context);
        //             },
        //           );
        //         });
        //   },
        // ),
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

// class ReviewEditBox extends StatefulWidget {
//   const ReviewEditBox({
//     Key? key,
//     required this.gym_id,
//     required this.experience,
//     required this.rating,
//     required this.review,
//     required this.title,
//     required this.user_id,
//     required this.user_name,
//   }) : super(key: key);
//
//   final String gym_id;
//   final String experience;
//   final String rating;
//   final String review;
//   final String title;
//   final String user_id;
//   final String user_name;
//
//   @override
//   State<ReviewEditBox> createState() => _ReviewEditBoxState();
// }
//
// class _ReviewEditBoxState extends State<ReviewEditBox> {
//   final TextEditingController _gym_id = TextEditingController();
//   final TextEditingController _experience = TextEditingController();
//   final TextEditingController _rating = TextEditingController();
//   final TextEditingController _review = TextEditingController();
//   final TextEditingController _title = TextEditingController();
//   final TextEditingController _user_id = TextEditingController();
//   final TextEditingController _user_name = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     _gym_id.text = widget.gym_id;
//     _experience.text = widget.experience;
//     _rating.text = widget.rating;
//     _review.text = widget.review;
//     _title.text = widget.title;
//     _user_id.text = widget.user_id;
//     _user_name.text = widget.user_name;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30))),
//       content: SizedBox(
//         // height: 580,
//         // width: 800,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Update Records for this doc',
//                 style: TextStyle(
//                     fontFamily: 'poppins',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14),
//               ),
//               customTextField(hinttext: "Gym Id", addcontroller: _gym_id),
//               customTextField(hinttext: "Detail", addcontroller: _experience),
//               customTextField(hinttext: "Discount", addcontroller: _rating),
//               customTextField(hinttext: "Review", addcontroller: _review),
//               customTextField(hinttext: "Title", addcontroller: _title),
//               customTextField(hinttext: "UserId", addcontroller: _user_id),
//               customTextField(hinttext: "User Name", addcontroller: _user_name),
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       print("/////");
//                       print('${widget.review}');
//
//                       DocumentReference documentReference = FirebaseFirestore
//                           .instance
//                           .collection('Reviews')
//                           .doc(widget.review);
//                       Map<String, dynamic> data = {
//                         'experience': _experience.text,
//                         'gym_id': _gym_id.text,
//                         'rating': _rating.text,
//                         'review': _review.text,
//                         'title': _title.text,
//                         'user_id': _user_id.text,
//                         'user_name': _user_name.text,
//                       };
//                       await FirebaseFirestore.instance
//                           .collection('Reviews')
//                           .doc(widget.review)
//                           .update(data);
//                       print("after");
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Done'),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
