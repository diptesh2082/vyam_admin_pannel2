import 'dart:async';
import 'dart:io';
import 'package:admin_panel_vyam/services/MatchIDMethod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/CustomTextFieldClass.dart';
import '../../../services/deleteMethod.dart';
import '../../../services/image_picker_api.dart';
import 'package:path/path.dart' as Path;

String globalGymId = '';
String gymname = '';
String branch = '';

// ignore: must_be_immutable
class TrainerPage extends StatefulWidget {
  TrainerPage(
    this.tGymId,
    this.name,
    this.branch, {
    Key? key,
  }) : super(key: key);
  String name;
  String branch;
  String tGymId;
  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  TextfieldTagsController? _tagsController;
  double? _distanceToField;

  CollectionReference? trainerStream;
  final id = FirebaseFirestore.instance.collection('product_details').doc().id;

  @override
  void didChangeDependencies() {
    _distanceToField = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  var image;
  var imgUrl1;
  @override
  void initState() {
    super.initState();
    _tagsController = TextfieldTagsController();
    globalGymId = widget.tGymId;
    gymname = widget.name;
    branch = widget.branch;
    trainerStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.tGymId)
        .collection('trainer');
  }

  @override
  Widget build(BuildContext context) {
    print("Current Document_id -->${widget.tGymId}"); //Printing for information
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trainers"),
      ),
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
                    style: ElevatedButton.styleFrom(onPrimary: Colors.purple),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowAddbox(
                            gymid: globalGymId,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Add Trainer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: trainerStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        print('No output for trainer');
                        return Container();
                      }
                      print("-----------------------------------");

                      var document = snapshot.data.docs;
                      int documentLength = snapshot.data.docs.length;
                      // for (int i = 0; i <= documentLength - 1; i++) {
                      //   print(document[i]['name']);
                      // }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            // ? DATATABLE
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Image',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              // DataColumn(
                              //     label: Text(
                              //   'Trainer Id',
                              //   style: TextStyle(fontWeight: FontWeight.w600),
                              // )),
                              DataColumn(
                                  label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Branch',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                  label: Text(
                                'Place',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Experience',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                  label: Text(
                                'User InstaID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'About',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              DataColumn(
                                  label: Text(
                                'Enable/Disable',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              // DataColumn(
                              //   label: Text(
                              //     'Certification',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //     label: Text(
                              //   'Specialization',
                              //   style: TextStyle(fontWeight: FontWeight.w600),
                              // )),
                              DataColumn(
                                label: Text(
                                  'Position',
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
                      child: const Text("Previous Page"),
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
    // String imageUrl = data['image'].toString();
    // bool tvalid = data['eligible'];

    bool tvalid = false;
    try {
      tvalid = data['eligible'];
    } catch (e) {
      tvalid = false;
    }

    // String trainerId = data['trainer_id'];

    String? image;
    try {
      image = data['image'].toString();
    } catch (e) {
      image = "#ERROR";
    }

    String? name;
    try {
      name = data['name'].toString();
    } catch (e) {
      name = "#ERROR";
    }
    String? branch;
    try {
      branch = data['branch'].toString();
    } catch (e) {
      branch = "#ERROR";
    }

    String? place;
    try {
      place = data['place'].toString();
    } catch (e) {
      place = "#ERROR";
    }

    String? experience;
    try {
      experience = data['experience'].toString();
    } catch (e) {
      experience = "#ERROR";
    }

    String? about;
    try {
      about = data['about'].toString();
    } catch (e) {
      about = "#ERROR";
    }

    // String? clients;
    // try {
    //   clients = data['clients'].toString();
    // } catch (e) {
    //   clients = "#ERROR";
    // }

    String position = '';
    try {
      position = data['position'].toString();
    } catch (e) {
      position = "#ERROR";
    }

    String? instaId;
    try {
      instaId = data['insta_id'].toString();
    } catch (e) {
      instaId = "#ERROR";
    }
    String? user_instaid;
    try {
      user_instaid = data['user_instaid'].toString();
    } catch (e) {
      user_instaid = "#ERROR";
    }

    String trainerid = '';
    try {
      trainerid = data['trainer_id'];
    } catch (e) {
      trainerid = "#ERROR";
    }

    List<dynamic> certi = [];
    try {
      certi = data['certification'];
    } catch (e) {
      certi = ["Null"];
    }

    List<dynamic> spec = [];
    try {
      spec = data['specialization'];
    } catch (e) {
      spec = ["Null"];
    }

    // List<dynamic> certif

    // var cert = data['certification'];
    // String gymid = data['gym_id'];
    return DataRow(cells: [
      DataCell(image != "null"
          ? CircleAvatar(backgroundImage: NetworkImage(image))
          : const Text("Image Not Uploaded")),
      // DataCell(data != null ? Text(trainerId) : Text("")),
      DataCell(name != null ? Text(name) : const Text("")),
      DataCell(branch != null ? Text(branch) : const Text("")),
      DataCell(place != null ? Text(place) : const Text("")),
      DataCell(experience != null ? Text(experience) : const Text("")),
      DataCell(user_instaid != null ? Text(user_instaid) : const Text("")),
      DataCell(about != null
          ? SingleChildScrollView(
              child: SizedBox(width: 400, height: 300, child: Text(about)),
            )
          : const Text("")),
      // DataCell(clients != null ? Text(clients) : const Text("")),

      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = tvalid;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product_details')
                  .doc(globalGymId)
                  .collection('trainer')
                  .doc(trainerid);
              await documentReference
                  .update({'eligible': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
// <<<<<<< HEAD
//             child: Text(y = legit ? 'YES' : 'NO'),
// =======
            child: Text(tvalid ? 'Enable' : 'Disable'),
// >>>>>>> cf1997613ff877c63a56c61e3009bdfe3639ccfa
            style: ElevatedButton.styleFrom(
                primary: tvalid ? Colors.green : Colors.red),
          ),
        ),
      ),

      DataCell(position != null ? Text(position) : const Text("")),

      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductEditBox(
                  images: image.toString(),
                  name: name.toString(),
                  about: about.toString(),
                  experience: experience.toString(),
                  social_link: instaId.toString(),
                  // clients: clients.toString(),
                  certification: certi.toList(),
                  specialization: spec.toList(),
                  trainerId: trainerid,
                  position: position,
                  user_instaid: user_instaid.toString()),
            ));
      }),

      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: trainerStream, uniqueDocId: trainerId);

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
                                  stream: trainerStream,
                                  uniqueDocId: trainerid);
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

  List<String> tagList = [];
  List<String> multiimages = [];
  late Future<List<FirebaseFile>> futurefiles;

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Widget buildFile(BuildContext context, FirebaseFile file) =>
      CachedNetworkImage(
        height: 128,
        width: 127,
        imageUrl: file.url,
      );

  Future<List<XFile>> multiimagepicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage(imageQuality: 50);
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  // Future<List<String>> multiimageuploader(List<XFile> list) async {
  //   List<String> _path = [];
  //   for (XFile _image in list) {
  //     _path.add(await uploadimage(_image));
  //   }
  //   return _path;
  // }

  // Future<String> uploadimage(XFile image) async {
  //   Reference db = FirebaseStorage.instance
  //       .ref("/gyms/FitnessFantasy2.0/Images/trainers${getImageName(image)}");
  //   await db.putFile(File(image.path));
  //   return await db.getDownloadURL();
  // }

  // Future creatUserImage(String url)async{
  //   final docUser = FirebaseFirestore.instance
  //       .collection("user_details")
  //       .doc(number);
  //   await docUser.update(
  //       {
  //         "image": url
  //       }
  //   );
  // }
  //
  // File? image;
  //
  //
  // final ref =  FirebaseStorage.instance.ref().child("user_images").child(number+".jpg");
  // await ref.putFile(image!);
  // final url = await ref.getDownloadURL();

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance
          .ref()
          .child('product_details')
          .child('trainers');

      Reference _reference =
          _firebaseStorage.child('trainers/${Path.basename(pickedFile!.path)}');
      await _reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        imgUrl1 = imageUrl;
      });
    }
  }
}

class StorageDatabase {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);
    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final file = FirebaseFile(ref: ref, url: url);
          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}

class FirebaseFile {
  final Reference ref;
  final String url;

  const FirebaseFile({required this.ref, required this.url});
}

var image3;

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
              ? const SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : image3 != null
                  ? SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.network(image3),
                    )
                  : const SizedBox(
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
      final _firebaseStorage = FirebaseStorage.instance
          .ref()
          .child('product_details')
          .child('trainers');

      Reference _reference =
          _firebaseStorage.child('trainers/${Path.basename(pickedFile!.path)}');
      await _reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        image3 = imageUrl;
      });
    }
  }
}

class ShowAddbox extends StatefulWidget {
  final String gymid;
  const ShowAddbox({required this.gymid, Key? key}) : super(key: key);

  @override
  State<ShowAddbox> createState() => _ShowAddboxState();
}

class _ShowAddboxState extends State<ShowAddbox> {
  final _formKey = GlobalKey<FormState>();

  var image;
  var imgUrl1;
  final id = FirebaseFirestore.instance.collection('product_details').doc().id;

  bool imagecheck = false;

  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addimages = TextEditingController();
  final TextEditingController _addabout = TextEditingController();
  final TextEditingController _addcertifications = TextEditingController();
  final TextEditingController _addexperience = TextEditingController();
  // final TextEditingController _addclients = TextEditingController();
  final TextEditingController _addreview = TextEditingController();
  final TextEditingController _addspecialization = TextEditingController();
  final TextEditingController social = TextEditingController();
  final TextEditingController user_insta = TextEditingController();
  final TextEditingController postion = TextEditingController();

  List<String> certification = [];
  List<String> specialization = [];
  // final TextEditingController _addCertification = TextEditingController();
  CollectionReference? trainerStream;
  @override
  void initState() {
    // TODO: implement initState
    trainerStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.gymid)
        .collection('trainer');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Trainer"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
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
                customTextField3(hinttext: "position", addcontroller: postion),
                customTextField3(hinttext: "name", addcontroller: _addname),
                customTextField3(hinttext: "about", addcontroller: _addabout),
                customTextField3(
                    hinttext: "experience", addcontroller: _addexperience),
                // customTextField3(
                //     hinttext: "clients", addcontroller: _addclients),
                customTextField3(
                    hinttext: "Social Media Link", addcontroller: social),
                customTextField(
                    hinttext: "Insta Username", addcontroller: user_insta),
                customTextField(
                    hinttext: "Add Specialization",
                    addcontroller: _addspecialization),
                Row(children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          specialization.add(_addspecialization.text);
                          _addspecialization.text = "";
                        });
                        print(specialization);
                      },
                      child: const Text("Add Specialization")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          specialization.removeLast();
                          _addspecialization.text = "";
                        });
                        print(specialization);
                      },
                      child: const Text("Remove Specialization")),
                ]),
                Text(
                  "$specialization",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                customTextField(
                    hinttext: "Add Certification and Click Add",
                    addcontroller: _addcertifications),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          certification.add(_addcertifications.text);
                          _addcertifications.text = "";
                        });
                        print(certification);
                      },
                      child: const Text("Add Certification")),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          certification.removeLast();
                          _addcertifications.text = "";
                        });
                        print(certification);
                      },
                      child: const Text("Remove Certification")),
                ]),
                Text(
                  "$certification",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                loadimage(id: id),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await matchID(
                            newId: id,
                            matchStream: trainerStream,
                            idField: 'trainer_id');
                        FirebaseFirestore.instance
                            .collection('product_details')
                            .doc(widget.gymid)
                            .collection('trainer')
                            .doc(id)
                            .set(
                          {
                            'position': postion.text,
                            'trainer_id': id,
                            'name': _addname.text,
                            'branch': gymname,
                            'place': branch,
                            'image': image3 != null ? image3 : "",
                            'experience': _addexperience.text,
                            'about': _addabout.text,
                            'certification': certification,
                            'specialization': specialization,
                            // 'clients': _addclients.text,
                            'insta_id': social.text,
                            'eligible': true,
                            'user_instaid': user_insta.text
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
    );
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance
          .ref()
          .child('product_details')
          .child('trainers');

      Reference _reference =
          _firebaseStorage.child('trainers/${Path.basename(pickedFile!.path)}');
      await _reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        image3 = imageUrl;
      });
    }
  }
}

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.images,
    required this.name,
    required this.about,
    // required this.certifications,
    required this.experience,
    // required this.clients,
    required this.specialization,
    required this.trainerId,
    required this.certification,
    required this.social_link,
    required this.position,
    required this.user_instaid,
  }) : super(key: key);
  final String social_link;
  final String name;
  final String images;
  final String about;
  final List certification;
  final String experience;
  // final String clients;
  // final String review;
  final List specialization;
  // final String socialMedia;
  final String trainerId;
  final String position;
  final String user_instaid;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _images = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final TextEditingController _social = TextEditingController();
  final TextEditingController _certification = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  // final TextEditingController _clients = TextEditingController();
  final TextEditingController _review = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _socialMedia = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController user_instaid = TextEditingController();

  List<dynamic> cert = [];
  List<dynamic> spec = [];
  var imgUrl11;

  @override
  void initState() {
    super.initState();
    print(widget.name);
    imgUrl11 = widget.images;
    _name.text = widget.name;
    _about.text = widget.about;
    cert = widget.certification;
    _experience.text = widget.experience;
    // _clients.text = widget.clients;
    // _review.text = widget.review;
    spec = widget.specialization;
    _social.text = widget.social_link;
    _position.text = widget.position;
    user_instaid.text = widget.user_instaid;

    // _socialMedia.text = widget.socialMedia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Box")),
      body: Container(
          padding: const EdgeInsets.all(30),
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
                // customTextField(hinttext: "Image", addcontroller: _images),
                customTextField(hinttext: "Position", addcontroller: _position),
                customTextField(hinttext: "Name", addcontroller: _name),
                customTextField(hinttext: "About", addcontroller: _about),
                // CustomTextField(hinttext: "Certifications", addcontroller: _certifications),
                customTextField(
                    hinttext: "Experience", addcontroller: _experience),
                // customTextField(hinttext: "Client", addcontroller: _clients),
                customTextField(
                    hinttext: "Social Media Link", addcontroller: _social),
                customTextField(
                    hinttext: "Insta User Name", addcontroller: user_instaid),
                customTextField(
                    hinttext: "Specialization", addcontroller: _specialization),

                Row(children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          spec.add(_specialization.text);
                          _specialization.text = "";
                        });
                        print(spec);
                      },
                      child: const Text("Add Specialization")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          spec.removeLast();
                          _specialization.text = "";
                        });
                        print(spec);
                      },
                      child: const Text("Remove Specialization")),
                ]),
                Text(
                  "$spec",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                customTextField(
                    hinttext: "Certificaiton", addcontroller: _certification),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          cert.add(_certification.text);
                          _certification.text = "";
                        });
                        print(cert);
                      },
                      child: const Text("Add Certification")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          cert.removeLast();
                          _certification.text = "";
                        });
                        print(cert);
                      },
                      child: const Text("Remove Certification")),
                ]),
                Text(
                  "$cert",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 150,
                //       child: ListTile(
                //         leading: Icon(
                //           Icons.file_upload_outlined,
                //           size: 20,
                //         ),
                //         trailing: InkWell(
                //           child: const Text("Add photos",
                //               style: TextStyle(
                //                   color: Colors.black,
                //                   fontFamily: 'Poppins',
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.w600)),
                //           onTap: () async {
                //             var image = await chooseImage();
                //             await getUrlImage(image);
                //
                //             // String res = await ImagePickerAPI()
                //             //     .pickImage(ImageSource.gallery);
                //             // File file = File.fromUri(Uri.file(res));
                //             // print(file.path);
                //           },
                //           // onTap: ()async {
                //           //   String res = await ImagePickerAPI().pickImage(ImageSource.gallery);
                //           //   File file = File.fromUri(Uri.file(res));
                //           //   print(file.path);
                //           // },
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 300,
                //       height: 200,
                //       child: Container(
                //           child: imgUrl11 != null
                //               ? Image.network(
                //                   imgUrl11 != null ? imgUrl11 : " ",
                //                   fit: BoxFit.contain,
                //                 )
                //               : Container(
                //                   child: Center(
                //                     child: Text(
                //                       'Please Upload Image',
                //                       style: TextStyle(
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 20),
                //                     ),
                //                   ),
                //                 )),
                //     ),
                //   ],
                // ),
                editim(imagea: widget.images, gymid: widget.trainerId),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print(globalGymId);
                        print("The Gym id is : ${widget.trainerId}");
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('product_details')
                            .doc(globalGymId)
                            .collection('trainer')
                            .doc(widget.trainerId);
                        Map<String, dynamic> data = <String, dynamic>{
                          'name': _name.text,
                          'about': _about.text,
                          'experience': _experience.text,
                          // 'clients': _clients.text,
                          'certification': cert,
                          'specialization': spec,
                          'insta_id': _social.text,
                          'user_instaid': user_instaid.text,
// <<<<<<< someshwar

                          'position': _position.text,
// =======
                          'image': image2 != null ? image2 : imgUrl11,
// >>>>>>> Diptesh
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
          )),
    );
  }
}

class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.gymid})
      : super(key: key);
  final String imagea;
  final String gymid;
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
              await addImageToStorage(dic, widget.gymid);
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
              ? const SizedBox(
                  height: 200, width: 200, child: CircularProgressIndicator())
              : image2 != null
                  ? Image(
                      image: NetworkImage(image2.toString()),
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
          .child("product_image")
          .child('trainer/$id');
      await _reference
          .putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) async {
          var uploadedPhotoUrl = value;
          setState(() {
            image2 = value;
          });
          print(value);
          await FirebaseFirestore.instance
              .collection('product_details')
              .doc(globalGymId)
              .collection('trainer')
              .doc(id)
              .update({'image': image2});
// =======
//       reader.readAsDataUrl(file!);
//       reader.onLoadEnd.listen((event) async {
//         var snapshot =
//         await fs.ref().child('product_image/${widget.gymId}').putBlob(file);
//         String downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           image = downloadUrl;
// >>>>>>> 21d9c030cebb9d9fd030fc57983203910f0655fa
        });
      });
    } else {
//write a code for android or ios
    }
  }
}

var image2;
