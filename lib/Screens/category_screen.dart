import 'package:admin_panel_vyam/Screens/category_add_screen.dart';
import 'package:admin_panel_vyam/dashboard.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:admin_panel_vyam/services/image_picker_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '../services/CustomTextFieldClass.dart';
import '../services/MatchIDMethod.dart';

class CategoryInfoScreen extends StatefulWidget {
  const CategoryInfoScreen({Key? key}) : super(key: key);

  @override
  State<CategoryInfoScreen> createState() => _CategoryInfoScreenState();
}

class _CategoryInfoScreenState extends State<CategoryInfoScreen> {
  CollectionReference? categoryStream;
  var catId = FirebaseFirestore.instance.collection('category').doc().id;
  String searchCateogryName = '';

  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('category');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
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
                      Get.to(() => const categoryAddScreen());
                    },
                    child: const Text('Add Product'),
                    // Container(
                    //   width: 120,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20.0)),
                    //   child: Row(
                    //     children: const [
                    //       Icon(Icons.add),
                    //       Text('Add Product',
                    //           style: TextStyle(fontWeight: FontWeight.w400)),
                    //     ],
                    //   ),
                    // ),
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
                        if (value.length == 0) {
                          // _node.canRequestFocus=false;
                          // FocusScope.of(context).unfocus();
                        }
                        if (mounted) {
                          setState(() {
                            searchCateogryName = value.toString();
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
                    stream: categoryStream!.snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }

                      var doc = snapshot.data.docs;

                      if (searchCateogryName.length > 0) {
                        doc = doc.where((element) {
                          return element
                              .get('name')
                              .toString()
                              .toLowerCase()
                              .contains(searchCateogryName.toString());
                        }).toList();
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowHeight: 65,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Images',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
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
                          rows: _buildlist(context, doc),
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
    String categoryID = data['category_id'];
    String x;
    bool status = data['status'];
    String img = data['image'];
    return DataRow(cells: [
      DataCell(
        data['name'] != null ? Text(data['name'] ?? "") : const Text(""),
      ),
      DataCell(
        data['image'] != null
            ? Image.network(
                data['image'] ?? "",
                scale: 0.5,
                height: 150,
                width: 150,
              )
            : const Text(""),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () async {
              bool temp = status;
              temp = !temp;

// <<<<<<< dewansh_new
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('category')
                  .doc(data.id);
// =======
//               DocumentReference documentReference =
//               FirebaseFirestore.instance.collection('category').doc(data.id);
// >>>>>>> Diptesh
              await documentReference
                  .update({'status': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text(x = status ? 'ENABLED' : 'DISABLED'),
            style: ElevatedButton.styleFrom(
                primary: status ? Colors.green : Colors.red),
          ),
        ),
      ),
      DataCell(
        data['position'] != null
            ? Center(child: Text(data['position'].toString()))
            : const Text(""),
      ),
      DataCell(
        const Text(''),
        showEditIcon: true,
        onTap: () {
          Get.to(() => ProductEditBox(
              name: data['name'],
              status: data['status'],
              image: data['image'],
              categoryId: data['category_id'],
              position: data['position']));
        },
      ),
      DataCell(const Icon(Icons.delete), onTap: () {
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
                              deleteMethodI(
                                  stream: categoryStream,
                                  uniqueDocId: data['category_id'],
                                  imagess: img);
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
      })
    ]);
  }

//MOVED TO ANOTHER FILE category_add_screen//

}

// EDIT FEATURE
class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.name,
    required this.status,
    required this.image,
    required this.categoryId,
    required this.position,
  }) : super(key: key);

  final String name;
  final bool status;
  final String image;
  final String categoryId;
  final String position;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _position = TextEditingController();
  // final TextEditingController _image = TextEditingController();
  var categoryId;
  var image;
  @override
  void initState() {
    super.initState();
    image = widget.image;
    categoryId = widget.categoryId;
    _name.text = widget.name;
    _position.text = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Edit Category'),
      ),
      body: Center(
        child: SizedBox(
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
                customTextField(hinttext: "Name", addcontroller: _name),
                customTextField(hinttext: "Position", addcontroller: _position),
                editim(imagea: image, catid: categoryId),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("The Gym id is : ${widget.categoryId}");

                        FirebaseFirestore.instance
                            .collection('category')
                            .doc(categoryId)
                            .update(
                          {
                            'image': image3,
                            'name': _name.text,
                            'category_id': categoryId,
                            'position': _position.text,
                          },
                        ).whenComplete(() {
                          image3 = null;
                        });

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
      ),
    );
  }
}

class editim extends StatefulWidget {
  const editim({Key? key, required this.imagea, required this.catid})
      : super(key: key);
  final String imagea;
  final String catid;
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
              });
              var dic = await chooseImage();
              await addImageToStorage(dic, widget.catid);
              setState(() {
                isloading = false;
                i2 = image3;
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
                  child: Center(
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
          FirebaseStorage.instance.ref().child("category").child('images/$id');
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
              .collection("category")
              .doc(id)
              .update({"image": value});
        });
      });
    } else {
//write a code for android or ios
    }
  }
}
