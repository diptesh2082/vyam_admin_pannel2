

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';
import '../services/image_picker_api.dart';

class pushNew extends StatefulWidget {
  const pushNew({Key? key}) : super(key: key);

  @override
  State<pushNew> createState() => _pushNewState();
}

class _pushNewState extends State<pushNew> {
  CollectionReference? pushStream;

  @override
  void initState() {
    pushStream = FirebaseFirestore.instance.collection("push_notifications");
    super.initState();
  }

  var id = FirebaseFirestore.instance
      .collection('push_notifications')
      .doc()
      .id
      .toString();

  final TextEditingController _addtitle = TextEditingController();
  final TextEditingController _adddefiniton = TextEditingController();

  var millis, dt, d12, image;

  date() {
    millis = Timestamp.now().millisecondsSinceEpoch;
    dt = DateTime.fromMillisecondsSinceEpoch(millis);

    d12 = DateFormat('dd/MMM/yyyy, hh:mm a').format(dt);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('New Push Notification'),
      ),

      body:
      Center(
        child: SizedBox(
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
                    hinttext: "Title", addcontroller: _addtitle),
                customTextField(
                    hinttext: "Definition", addcontroller: _adddefiniton),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Upload Image: ',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          image = await chooseImage();
                        },
                        child: Icon(
                          Icons.upload_file_outlined,
                        ),
                      )
                    ],
                  ),
                ),
                // Text(
                //   '$timestamp',
                // ),
                // customTextField(
                //     hinttext: "Discount", addcontroller: _adddiscount),
                // customTextField(
                //     hinttext: "Title", addcontroller: _addtitle),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      date();
                      await matchID(
                          newId: id,
                          matchStream: pushStream,
                          idField: 'id');
                      await FirebaseFirestore.instance
                          .collection('push_notifications')
                          .doc(id)
                          .set(
                        {
                          'title': _addtitle.text,
                          'definition': _adddefiniton.text,
                          // 'image': ,
                          'id': id,
                          'timestamp': d12,
                        },
                      ).then((snapshot) async {
                        await uploadImageToPush(image, id);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}
