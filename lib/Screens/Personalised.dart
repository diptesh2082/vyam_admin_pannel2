import 'package:admin_panel_vyam/Screens/push_new_screen.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:admin_panel_vyam/services/image_picker_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import '../services/CustomTextFieldClass.dart';

class Personalised extends StatefulWidget {
  const Personalised({
    Key? key,
  }) : super(key: key);
  @override
  State<Personalised> createState() => _PersonalisedState();
}

class _PersonalisedState extends State<Personalised> {
  CollectionReference? personalisedStream;
  @override
  void initState() {
    personalisedStream =
        FirebaseFirestore.instance.collection("personalised_notification");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personalised Notification")),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      // await  FirebaseMessaging.instance.subscribeToTopic("push_notifications");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => pnew()));
                    },
                    child: Text('Add Personalised Notification'),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: personalisedStream!.snapshots(),
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
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'TimeStamp',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validity',
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
                            rows: _buildlist(context, snapshot.data!.docs)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        page.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Next Page"),
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
    String pushIdData = data.id;
    var millis = data['timestamp'].millisecondsSinceEpoch;
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    var d12 = DateFormat('dd/MMM/yyyy, hh:mm a').format(dt);
    bool not = data['valid'];
    return DataRow(cells: [
      DataCell(data['p_title'] != null
          ? Text(data['p_title'] ?? "")
          : const Text("")),
      DataCell(data['description'] != null
          ? Text(data['description'])
          : const Text("")),
      DataCell(data['timestamp'] != null ? Text(d12) : const Text("")),
      DataCell(ElevatedButton(
        onPressed: () async {
          bool temp = not;
          temp = !temp;
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection('personalised_notification')
              .doc(pushIdData);
          await documentReference
              .update({'valid': temp})
              .whenComplete(() => print("Legitimate toggled"))
              .catchError((e) => print(e));
        },
        child: Text(not ? "Yes" : "No"),
        style:
            ElevatedButton.styleFrom(primary: not ? Colors.green : Colors.red),
      )),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Get.to(() => ProductEditBox(
              title: data['p_title'],
              image: data['image'],
              description: data['description'],
              replacement: data['replacement'],
              id: data.id,
            ));
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: pushStream, uniqueDocId: pushIdData);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: SizedBox(
              height: 170,
              width: 280,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Do you want to delete?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteMethod(
                                  stream: personalisedStream,
                                  uniqueDocId: pushIdData);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Yes'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('No'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ]);
  }
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.title,
    required this.id,
    required this.image,
    required this.description,
    required this.replacement,
  }) : super(key: key);

  final String id;
  final String image;
  final String description;
  final List replacement;
  final String title;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _replacement = TextEditingController();

  late final String ids;
  var image;
  List<dynamic> repla = [];

  @override
  void initState() {
    super.initState();
    ids = widget.id;
    _title.text = widget.title;
    image = widget.image;
    _description.text = widget.description;
    repla = widget.replacement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text('Edit Personalised Push Notification'),
      ),
      body: SingleChildScrollView(
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
            customTextField(hinttext: _title.text, addcontroller: _title),
            customTextField(
                hinttext: _description.text, addcontroller: _description),
            customTextField(
                hinttext: "Add Replacement", addcontroller: _replacement),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        repla.add(_replacement.text);
                        _replacement.text = "";
                      });
                    },
                    child: Text("Add Replacement")),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        repla.removeLast();
                        _replacement.text = "";
                      });
                    },
                    child: Text("Remove Replacement")),
              ],
            ),
            Text(
              repla.toString(),
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            editim(imagea: widget.image, notifyid: widget.id),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    print("/////");
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('personalised_notification')
                        .doc(widget.id);
                    Map<String, dynamic> data = <String, dynamic>{
                      'p_title': _title.text,
                      'description': _description.text,
                      'replacement': repla,
                      'timestamp': DateTime.now(),
                      'image': image8 != null ? image8 : widget.image,
                      // 'id': id,
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
    );
  }
}

class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.notifyid})
      : super(key: key);
  final String imagea;
  final String notifyid;
  @override
  State<editim> createState() => _editimState();
}

class _editimState extends State<editim> {
  @override
  String i2 = '';
  void initState() {
    // TODO: implement initState
    i2 = widget.imagea;
    super.initState();
  }

// <<<<<<< HEAD
  @override
  bool isloading = false;
  var imagee;
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isloading = true;
              });
              var dic = await chooseImage();
              await addImageToStorage(dic, widget.notifyid);
              setState(() {
                isloading = false;
              });
            },
            child: const Text(
              'Upload Gym Image',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          isloading
              ? Container(
                  height: 200,
                  width: 200,
                  child: const CircularProgressIndicator())
              : image8 != null
                  ? Image(
                      image: NetworkImage(image8.toString()),
                      height: 200,
                      width: 200,
                    )
                  : Image(
                      image: NetworkImage(i2),
                      height: 200,
                      width: 200,
                    )
        ],
      ),
    );
  }

  addImageToStorage(XFile? pickedFile, String? id) async {
    if (kIsWeb) {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child("peronalised_notification")
          .child('$id');
      await _reference
          .putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) async {
          var uploadedPhotoUrl = value;
          setState(() {
            image8 = value;
          });
          print(value);
        });
      });
    }
  }
}

var image8;

class pnew extends StatefulWidget {
  const pnew({
    Key? key,
  }) : super(key: key);
  // final String idd;
  @override
  State<pnew> createState() => _pnewState();
}

class _pnewState extends State<pnew> {
  CollectionReference? personalisedStream;

  @override
  void initState() {
    personalisedStream =
        FirebaseFirestore.instance.collection("personalised_notification");
    super.initState();
  }

  var id = FirebaseFirestore.instance
      .collection('personalised_notification')
      .doc()
      .id
      .toString();
  final TextEditingController _addtitle = TextEditingController();
  final TextEditingController _adddescription = TextEditingController();
  final TextEditingController _addreplacement = TextEditingController();
  List<String> replacement = [];

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('New Push Notification'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
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
                  customTextField3(hinttext: "Title", addcontroller: _addtitle),
                  customTextField3(
                      hinttext: "Description", addcontroller: _adddescription),
                  customTextField(
                      hinttext: "Add Replacement",
                      addcontroller: _addreplacement),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              replacement.add(_addreplacement.text);
                              _addreplacement.text = "";
                            });
                          },
                          child: Text("Add Replacement")),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              replacement.removeLast();
                              _addreplacement.text = "";
                            });
                          },
                          child: Text("Remove Replacement")),
                    ],
                  ),
                  Text(
                    replacement.toString(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  loadimage(id: id),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection('personalised_notification')
                              .doc(id)
                              .set(
                            {
                              ///
                              'p_title': _addtitle.text,
                              'description': _adddescription.text,
                              'replacement': replacement,
                              'image': image7 != null ? image7 : "",
                              'timestamp': DateTime.now(),
                              'valid': false,
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
    );
  }
}

var image7;

class loadimage extends StatefulWidget {
  loadimage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        const Text(
          "User Image",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          child: const Icon(Icons.camera_alt),
          onTap: () async {
            setState(() {
              isloading = true;
            });
            var profileImage = await chooseImage();
            await getUrlImage(profileImage);
            setState(() {
              isloading = false;
            });
          },
        ),
        SizedBox(
          width: 200,
          height: 100,
          child: isloading
              ? Container(
                  height: 100,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : image7 != null
                  ? Container(
                      height: 100,
                      width: 200,
                      child: Image.network(image7),
                    )
                  : Container(
                      height: 100,
                      width: 200,
                      child: Center(child: Text("Please Upload Image")),
                    ),
        ),
      ],
    ));
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage =
          FirebaseStorage.instance.ref().child('personalised_notification');
      Reference _reference =
          _firebaseStorage.child('personalised_notification/${widget.id}');
      await _reference.putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        image7 = imageUrl;
      });
    }
  }
}
