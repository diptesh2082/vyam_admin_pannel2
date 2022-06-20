import 'dart:io';

import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/CustomTextFieldClass.dart';
import '../services/image_picker_api.dart';
import 'package:path/path.dart' as Path;

class UserInformation extends StatefulWidget {
  const UserInformation({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  CollectionReference? userDetailStream;
  String searchUser = '';
  @override
  void initState() {
    userDetailStream = FirebaseFirestore.instance.collection("user_details");
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
  var xs = "Yes";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
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
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => detailsadd()));
                    },
                    child: const Text('Add User'),
                  ),
                ),
                Container(
                  width: 500,
                  height: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      // focusNode: _node,

                      autofocus: false,
                      textAlignVertical: TextAlignVertical.bottom,
                      onSubmitted: (value) async {
                        FocusScope.of(context).unfocus();
                      },
                      // controller: searchController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          // _node.canRequestFocus=false;
                          // FocusScope.of(context).unfocus();
                        }
                        if (mounted) {
                          setState(() {
                            searchUser = value.toString();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white12,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: userDetailStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      print("-----------------------------------");

                      var doc = snapshot.data.docs;

                      if (searchUser.isNotEmpty) {
                        doc = doc.where((element) {
                          return element
                                  .get('name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString()) ||
                              element
                                  .get('gender')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString()) ||
                              element
                                  .get('address')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString()) ||
                              element
                                  .get('userId')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchUser.toString());
                        }).toList();
                      }

                      print(snapshot.data.docs);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'S.No',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Profile Image',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //     label: Text(
                              //   'UserId',
                              //   style: TextStyle(fontWeight: FontWeight.w600),
                              // )),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gender',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Locality',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     'Sub Locality',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Pincode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validity of User',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              // DataColumn(
                              //   label: Text(
                              //     'Latitude',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // DataColumn(
                              //   label: Text(
                              //     'Longitude',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
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
                              )
                            ],
                            rows: _buildlist(context, doc)),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("Previous Page"),
                      onPressed: () {
                        if (start > 0) page--;
                        setState(() {
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
    String userIDData = data['userId'];
    String profileImage = data['image'];
    bool legit = data['legit'];

    return DataRow(cells: [
      DataCell(data != null ? Text(index.toString()) : Text("")),

      DataCell(
        profileImage != "null" || profileImage != null
            ? CircleAvatar(
                child: CachedNetworkImage(
                  imageUrl: profileImage,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            : const CircleAvatar(
                backgroundColor: Colors.black,
                child: Text('Null'),
              ),
      ),
      // DataCell(data != null ? Text(userIDData) : Text("")),
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['email'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gender'] ?? "") : Text("")),
      DataCell(data != null
          ? Text((data['number'])
              .toString()
              .substring(3, data['number'].toString().length))
          : Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['locality'] ?? "") : Text("")),
      // DataCell(data != null ? Text(data['subLocality'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['pincode'].toString()) : Text("")),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = legit;
              temp = !temp;
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('user_details')
                  .doc(userIDData);
              await documentReference
                  .update({'legit': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(legit ? "Yes" : "No"),
            style: ElevatedButton.styleFrom(
                primary: legit ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (conext) => EditBox(
                imageurl: data['image'],
                address: data['address'],
                gender: data['gender'],
                email: data['email'],
                // latitude: data['lat'].toString(),
                // longitude: data['long'].toString(),
                locality: data['locality'],
                number: data['number'],
                subLocality: data['subLocality'],
                userid: data['userId'],
                name: data['name'],
                pincode: data['pincode'],
              ),
            ));
      }),
      DataCell(Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: userDetailStream, uniqueDocId: userIDData);

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
                                  stream: userDetailStream,
                                  uniqueDocId: userIDData);
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

  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addemail = TextEditingController();
  // final TextEditingController _addlatitude = TextEditingController();
  // final TextEditingController _addlongitude = TextEditingController();
  final TextEditingController _addlocality = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addnumber = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addsublocality = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();
  var profileImage;
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    required this.address,
    required this.gender,
    required this.email,
    required this.imageurl,
    // required this.latitude,
    // required this.longitude,
    required this.locality,
    required this.name,
    required this.number,
    required this.pincode,
    required this.subLocality,
    required this.userid,
  }) : super(key: key);

  final String address;
  final String gender;
  final String email;
  final String imageurl;
  // final String latitude;
  // final String longitude;
  final String locality;
  final String name;
  final String number;
  final String pincode;
  final String subLocality;
  final String userid;

  @override
  _EditBoxState createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  TextEditingController _address = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _email = TextEditingController();
  // TextEditingController _latitude = TextEditingController();
  // TextEditingController _longitude = TextEditingController();
  TextEditingController _locality = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _sublocality = TextEditingController();
  TextEditingController _userid = TextEditingController();
  var img;
  @override
  var x;
  void initState() {
    super.initState();
    print(widget.address);
    _address.text = widget.address;
    _gender.text = widget.gender;
    _email.text = widget.email;
    // _latitude.text = widget.latitude.toString();
    // _longitude.text = widget.longitude.toString();
    _locality.text = widget.locality;
    _number.text = widget.number.substring(3, widget.number.length);
    _name.text = widget.name;
    _pincode.text = widget.pincode;
    _sublocality.text = widget.subLocality;
    _userid.text = widget.userid;
    x = widget.userid;
    img = widget.imageurl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit User Details'),
          ),
          backgroundColor: Colors.white10,
          body: Container(
            padding: const EdgeInsets.all(20),
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
                      controller: _name,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Name'),
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
                      controller: _email,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'email'),
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
                      controller: _gender,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Gender'),
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
                      controller: _number,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintMaxLines: 2,
                          hintText: 'Phone Number'),
                    )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  editim(imagea: img.toString(), gymid: x),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print("/////");

                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('user_details')
                                    //change _number to _userid
                                    .doc("${x}");
                            Map<String, dynamic> data = <String, dynamic>{
                              // 'address':'',
                              'gender': _gender.text,
                              'image': image3,
                              'name': _name.text,
                              'email': _email.text,
                              'number': '+91${_number.text}',
                            };
                            await documentReference
                                .update(data)
                                .whenComplete(() {
                              print("Item Updated");
                              print(ds);
                              setState(() {
                                image3 = "";
                              });
                              print("value:$ds");
                            }).catchError((e) => print(e));
                            Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child('Users/${Path.basename(pickedFile!.path)}');
      await _reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        var imgUrl1 = imageUrl;
        ds = imgUrl1;
      });
    }
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

var image3;

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
                i2 = image3;
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
              ? Container(
                  height: 100,
                  width: 200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: 100,
                  width: 200,
                  child: Image.network(i2),
                ),
        ],
      ),
    );
  }

  addImageToStorage(XFile? pickedFile, String? id) async {
    if (kIsWeb) {
      Reference _reference =
          FirebaseStorage.instance.ref().child("Users").child('images/$id');
      await _reference
          .putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) async {
          var uploadedPhotoUrl = value;
          setState(() {
            image3 = value;
          });
          print(value);
          await FirebaseFirestore.instance
              .collection("user_details")
              .doc(id)
              .update({"image": value});
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

class detailsadd extends StatefulWidget {
  const detailsadd({Key? key}) : super(key: key);

  @override
  State<detailsadd> createState() => _detailsaddState();
}

var profileImage;
String gender = "Not Specified";
var ds;

class _detailsaddState extends State<detailsadd> {
  final TextEditingController _addaddress = TextEditingController();
  // final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addemail = TextEditingController();
  // final TextEditingController _addlatitude = TextEditingController();
  // final TextEditingController _addlongitude = TextEditingController();
  final TextEditingController _addlocality = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addnumber = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addsublocality = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Add User Details'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
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
                customTextField3(
                    hinttext: "Contact Number", addcontroller: _addnumber),
                customTextField3(hinttext: "Name", addcontroller: _addname),
                customTextField3(hinttext: "Email", addcontroller: _addemail),
                Row(
                  children: [
                    const Text(
                      "Gender: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                        value: gender,
                        items: const [
                          DropdownMenuItem(
                            child: Text("Not Specified"),
                            value: "Not Specified",
                          ),
                          DropdownMenuItem(
                            child: Text("Male"),
                            value: "male",
                          ),
                          DropdownMenuItem(
                            child: Text("Female"),
                            value: "female",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            gender = value as String;
                          });
                        }),
                  ],
                ),
                loadimage(id: "+91${_addnumber.text}"),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection('user_details')
                              .doc("+91${_addnumber.text}")
                              .set(
                            {
                              'address': "",
                              'userId': "+91${_addnumber.text}",
                              'name': _addname.text,
                              'email': _addemail.text,
                              'gender': gender,
                              'image': ds,
                              'number': "+91${_addnumber.text}",
                              'locality': "",
                              'subLocality': "",
                              'pincode': "",
                              'long': " ",
                              'lat': " ",
                              'legit': true
                              // 'image': ""
                            },
                          ).whenComplete(() {
                            print("Item Updated");
                            print(ds);
                            setState(() {
                              ds = "";
                            });
                            print("value:$ds");
                          }).catchError((e) => print(e));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Done'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class loadimage extends StatefulWidget {
  loadimage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool isloading = false;
  var imgUrl1;
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
            profileImage = await chooseImage();
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
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ds != null
                  ? Container(
                      height: 100,
                      width: 200,
                      child: Image.network(ds),
                    )
                  : Container(
                      height: 100,
                      width: 200,
                      child: const Text("Please Upload Image"),
                    ),
        ),
      ],
    ));
  }

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage =
          FirebaseStorage.instance.ref().child("user_details");

      Reference _reference = _firebaseStorage
          .child('user_details/${Path.basename(pickedFile!.path)}');
      await _reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String imageUrl = await _reference.getDownloadURL();

      setState(() {
        imgUrl1 = imageUrl;
        ds = imgUrl1;
      });
    }
  }
}
