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
  var catId =
      FirebaseFirestore.instance.collection('category').doc().id;

  @override
  void initState() {
    categoryStream = FirebaseFirestore.instance.collection('category');
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle:
                      const TextStyle(fontSize: 15 ),
                    ),
                    onPressed: (){
                      Get.to(()=>const categoryAddScreen());
                    },
                    child:Text('Add Product'),
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
    String categoryID = data['category_id'];
    String x;
    bool status = data['status'];
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

              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('category')
                  .doc(catId);
              await documentReference
                  .update({'status': temp})
                  .whenComplete(() => print("Legitimate toggled"))
                  .catchError((e) => print(e));
            },
            child: Text( x = status ? 'ENABLED':'DISABLED'),
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
          Get.to(()=>ProductEditBox(name: data['name'], status:data['status'], image: data['image'], categoryId: data['category_id'] , position: data['position']));
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return GestureDetector(
          //         onTap: () => ,
          //         child: SingleChildScrollView(
          //           child: ProductEditBox(
          //             name: data['name'],
          //             status: data['status'],
          //             image: data['image'],
          //             categoryId: data['category_id'],
          //           ),
          //         ),
          //       );
          //     }
          //     );
        },
      ),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: categoryStream, uniqueDocId: categoryID);
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
  var imgUrl1;


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
        title: Text('Edit Category'),
      ),
      body:
      Center(
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
                //customTextField(hinttext: "Image", addcontroller: _image),

                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Text(
                        'Upload Image: ',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          image = await chooseImage();
                          await getUrlImage(image);
                        },
                        child: const Icon(
                          Icons.upload_file_outlined,
                        ),
                      ),

                      SizedBox(
                        width: 300,
                        height: 200,
                        child: Container(
                          child:
                          Image.network((imgUrl1 == null) ? ' ' : imgUrl1,
                            fit: BoxFit.contain,),
                        ),
                      ),
                    ],
                  ),
                ),




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

                            'image': imgUrl1,
                            'name': _name.text,
                            'category_id': categoryId,
                            'position': _position.text,

                          },
                        );
                        //     .then((snapshot) async {
                        //   await uploadImageToBanner(image, categoryId);
                        // });


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

  getUrlImage(XFile? pickedFile) async {
    if (kIsWeb) {
      final _firebaseStorage = FirebaseStorage.instance
          .ref().child("category");

      Reference _reference = _firebaseStorage
          .child('category/${Path.basename(pickedFile!.path)}');
      await _reference
          .putData(
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
