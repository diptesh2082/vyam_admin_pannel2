import 'dart:async';
import 'dart:io';
import 'package:admin_panel_vyam/services/MatchIDMethod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
        title: Text("Trainer"),
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
                      for (int i = 0; i <= documentLength - 1; i++) {
                        print(document[i]['name']);
                      }
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
                                  'About',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                  label: Text(
                                'Clients',
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

  List certificationList = ['HI', 'NOOB', 'bye'];

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String imageUrl = data['image'];
    String trainerId = data['trainer_id'];
    // var cert = data['certification'];
    // String gymid = data['gym_id'];
    return DataRow(cells: [
      DataCell(data != null
          ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
          : Text("")),
      // DataCell(data != null ? Text(trainerId) : Text("")),
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['branch'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['place'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['experience'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['about'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['clients'] ?? "") : Text("")),
      // DataCell(ListView.builder(
      //     itemCount: cert.length,
      //     itemBuilder: (context, int index) {
      //       return Text(cert[index]);
      //     })),
      // DataCell(
      //     data != null ? Text(data['specialisation'].toString()) : Text("")),

      // DataCell(data != null
      //     ? IconButton(
      //         onPressed: () {
      //           launch(data['social_media']);
      //         },
      //         icon: Icon(FontAwesome.instagram))
      //     : Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    images: data['image'],
                    name: data['name'],
                    about: data['about'],
                    experience: data['experience'],
                    clients: data['clients'],
                    certification: data['certification'],
                    specialization: data['specialization'],
                    trainerId: data['trainer_id'],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            });
      }),
      DataCell(Icon(Icons.delete), onTap: () {
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
                                  uniqueDocId: trainerId);
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

  Future<List<String>> multiimageuploader(List<XFile> list) async {
    List<String> _path = [];
    for (XFile _image in list) {
      _path.add(await uploadimage(_image));
    }
    return _path;
  }

  Future<String> uploadimage(XFile image) async {
    Reference db = FirebaseStorage.instance
        .ref("/gyms/FitnessFantasy2.0/Images/trainers${getImageName(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

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

class ShowAddbox extends StatefulWidget {
  final String gymid;
  const ShowAddbox({required this.gymid, Key? key}) : super(key: key);

  @override
  State<ShowAddbox> createState() => _ShowAddboxState();
}

class _ShowAddboxState extends State<ShowAddbox> {
  var image;
  var imgUrl1;
  final id = FirebaseFirestore.instance.collection('product_details').doc().id;

  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addimages = TextEditingController();
  final TextEditingController _addabout = TextEditingController();
  final TextEditingController _addcertifications = TextEditingController();
  final TextEditingController _addexperience = TextEditingController();
  final TextEditingController _addclients = TextEditingController();
  final TextEditingController _addreview = TextEditingController();
  final TextEditingController _addspecialization = TextEditingController();
  final TextEditingController social = TextEditingController();

  List<String> certification = [];
  List<String> specialization = [];
  // final TextEditingController _addCertification = TextEditingController();
  @override
  CollectionReference? trainerStream;
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
        title: Text("Add Trainer"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
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

              customTextField(hinttext: "name", addcontroller: _addname),
              customTextField(hinttext: "about", addcontroller: _addabout),
              customTextField(
                  hinttext: "experience", addcontroller: _addexperience),
              customTextField(hinttext: "clients", addcontroller: _addclients),
              customTextField(
                  hinttext: "Social Media Link", addcontroller: social),
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
                    child: Text("Add Specialization")),
                SizedBox(
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
                    child: Text("Remove Specialization")),
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
                    child: Text("Remove Certification")),
              ]),
              Text(
                "$certification",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: ListTile(
                      leading: Icon(
                        Icons.file_upload_outlined,
                        size: 20,
                      ),
                      trailing: InkWell(
                        child: const Text("Add photos",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        onTap: () async {
                          image = await chooseImage();
                          await getUrlImage(image);
                          // String res = await ImagePickerAPI()
                          //     .pickImage(ImageSource.gallery);
                          // File file = File.fromUri(Uri.file(res));
                          // print(file.path);
                        },
                        // onTap: ()async {
                        //   String res = await ImagePickerAPI().pickImage(ImageSource.gallery);
                        //   File file = File.fromUri(Uri.file(res));
                        //   print(file.path);
                        // },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 200,
                    child: Container(
                        child: imgUrl1 != null
                            ? Image.network(
                                imgUrl1 != null ? imgUrl1 : " ",
                                fit: BoxFit.contain,
                              )
                            : Container(
                                child: Text(
                                  'Please Upload Image',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )),
                  ),
                ],
              ),

              // TextFieldTags(
              //   textEditingController: _addcertifications,
              //   textfieldTagsController: _tagsController,
              //   initialTags: const [
              //     'Hello',
              //     'Namaste',
              //     'Get Lost',
              //   ],
              //   textSeparators: const ['\n', ','],
              //   validator: (String tag) {
              //     if (tag == 'php') {
              //       return 'No, please just no';
              //     } else if (_tagsController!.getTags!.contains(tag)) {
              //       return 'you already entered that';
              //     }
              //     return null;
              //   },
              //   inputfieldBuilder:
              //       (context, tec, fn, error, onChanged, onSubmitted) {
              //     return (context, sc, tags, onTagDelete) {
              //       // return Padding(
              //       //   padding: const EdgeInsets.all(10.0),
              //       //   child: TextField(
              //       //     controller: tec,
              //       //     focusNode: fn,
              //       //     decoration: InputDecoration(
              //       //       isDense: true,
              //       //       border: const OutlineInputBorder(
              //       //         borderSide: BorderSide(
              //       //           color: Color.fromARGB(255, 74, 137, 92),
              //       //           width: 3.0,
              //       //         ),
              //       //       ),
              //       //       focusedBorder: const OutlineInputBorder(
              //       //         borderSide: BorderSide(
              //       //           color: Color.fromARGB(255, 74, 137, 92),
              //       //           width: 3.0,
              //       //         ),
              //       //       ),
              //       //       helperText: 'Enter language...',
              //       //       helperStyle: const TextStyle(
              //       //         color: Color.fromARGB(255, 74, 137, 92),
              //       //       ),
              //       //       hintText:
              //       //       _tagsController!.hasTags ? '' : 'Enter tags:',
              //       //       errorText: 'error',
              //       //       prefixIconConstraints: BoxConstraints(
              //       //           maxWidth: _distanceToField! * 0.74),
              //       //       prefixIcon: tags.isNotEmpty
              //       //           ? SingleChildScrollView(
              //       //         controller: sc,
              //       //         scrollDirection: Axis.horizontal,
              //       //         child: Row(
              //       //             children: tags.map((String tag) {
              //       //               return Container(
              //       //                 decoration: const BoxDecoration(
              //       //                   borderRadius: BorderRadius.all(
              //       //                     Radius.circular(20.0),
              //       //                   ),
              //       //                   color: Color.fromARGB(
              //       //                       255, 74, 137, 92),
              //       //                 ),
              //       //                 margin: const EdgeInsets.symmetric(
              //       //                     horizontal: 5.0),
              //       //                 padding: const EdgeInsets.symmetric(
              //       //                     horizontal: 10.0, vertical: 5.0),
              //       //                 child: Row(
              //       //                   mainAxisAlignment:
              //       //                   MainAxisAlignment.spaceBetween,
              //       //                   children: [
              //       //                     InkWell(
              //       //                       child: Text(
              //       //                         '#$tag',
              //       //                         style: const TextStyle(
              //       //                             color: Colors.white),
              //       //                       ),
              //       //                       onTap: () {
              //       //                         print("$tag selected");
              //       //                       },
              //       //                     ),
              //       //                     const SizedBox(width: 4.0),
              //       //                     InkWell(
              //       //                       child: const Icon(
              //       //                         Icons.cancel,
              //       //                         size: 14.0,
              //       //                         color: Color.fromARGB(
              //       //                             255, 233, 233, 233),
              //       //                       ),
              //       //                       onTap: () {
              //       //                         onTagDelete(tag);
              //       //                       },
              //       //                     )
              //       //                   ],
              //       //                 ),
              //       //               );
              //       //             }).toList()),
              //       //       )
              //       //           : null,
              //       //     ),
              //       //     onChanged: onChanged,
              //       //     onSubmitted: (tag) {
              //       //       tagList.add(tag);
              //       //       print(tagList);
              //       //     },
              //       //   ),
              //       // );
              //     };
              //   },
              // ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(
              //       const Color.fromARGB(255, 74, 137, 92),
              //     ),
              //   ),
              //   onPressed: () {
              //     _tagsController!.clearTags();
              //   },
              //   child: const Text('CLEAR TAGS'),
              // ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
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
                        'trainer_id': id,
                        'name': _addname.text,
                        'branch': gymname,
                        'place': branch,
                        'image': imgUrl1,
                        'experience': _addexperience.text,
                        'about': _addabout.text,
                        'certification': certification,
                        'specialization': specialization,
                        'clients': _addclients.text,
                      },
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              )
            ],
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
        imgUrl1 = imageUrl;
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
    required this.clients,
    required this.specialization,
    required this.trainerId,
    required this.certification,
  }) : super(key: key);

  final String name;
  final String images;
  final String about;
  final List certification;
  final String experience;
  final String clients;
  // final String review;
  final List specialization;
  // final String socialMedia;
  final String trainerId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _images = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final TextEditingController _certification = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _clients = TextEditingController();
  final TextEditingController _review = TextEditingController();
  final TextEditingController _specialization =
      TextEditingController(); //todo: later
  final TextEditingController _socialMedia = TextEditingController();
  List<dynamic> cert = [];
  List<dynamic> spec = [];
  @override
  void initState() {
    super.initState();
    print(widget.name);
    _images.text = widget.images;
    _name.text = widget.name;
    _about.text = widget.about;
    cert = widget.certification;
    _experience.text = widget.experience;
    _clients.text = widget.clients;
    // _review.text = widget.review;
    spec = widget.specialization;
    // _socialMedia.text = widget.socialMedia;
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
              // customTextField(hinttext: "Image", addcontroller: _images),
              customTextField(hinttext: "Name", addcontroller: _name),
              customTextField(hinttext: "About", addcontroller: _about),
              // CustomTextField(hinttext: "Certifications", addcontroller: _certifications),
              customTextField(
                  hinttext: "Experience", addcontroller: _experience),
              customTextField(hinttext: "Client", addcontroller: _clients),

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
                    child: Text("Add Specialization")),
                SizedBox(
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

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
                        'clients': _clients.text,
                        'certification': cert,
                        'specialization': spec,
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
