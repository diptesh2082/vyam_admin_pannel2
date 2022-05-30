import 'package:admin_panel_vyam/dashboard.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:admin_panel_vyam/services/image_picker_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                  child: GestureDetector(
                    onTap: showAddbox,
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          Text('Add Product',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
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
        data['status'] == 'true'
            ? const Text("Enabled")
            : const Text("Disabled"),
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
          showDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SingleChildScrollView(
                    child: ProductEditBox(
                      name: data['name'],
                      status: data['status'],
                      image: data['image'],
                      categoryId: data['category_id'],
                    ),
                  ),
                );
              });
        },
      ),
      DataCell(Icon(Icons.delete), onTap: () {
        deleteMethod(stream: categoryStream, uniqueDocId: categoryID);
      })
    ]);
  }

  final TextEditingController _addName = TextEditingController();
   bool _addStatus = true ;
  final TextEditingController  _addPosition = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var image;
  String? selectedType;
  String? print_type = 'Status';

  showAddbox() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {

          void dropDowntype(bool? selecetValue) {
            // if(selecetValue is String){
            setState(() {
              selectedType = selecetValue.toString();
              if (selecetValue == true) {
                print_type = "TRUE";
              }
              if (selecetValue == false) {
                print_type = "FALSE";
              }
            });
            // }
          }


          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: Form(
              key: _formKey, //Changed
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
                      customTextField3(
                          hinttext: "Name", addcontroller: _addName),
                      // customTextField3(
                      //     hinttext: "Status", addcontroller: _addStatus),
                      customTextField3(
                          hinttext: "Position", addcontroller: _addPosition),

                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Text(
                              'Upload Image: ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                image = await chooseImage();
                              },
                              child: const Icon(
                                Icons.upload_file_outlined,
                              ),
                            )
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w100),
                          ),
                          Container(
                            color: Colors.white10,
                            width: 120,
                            child: DropdownButton(
                                hint: Text('$print_type'),
                                items: const [
                                  DropdownMenuItem(
                                    child: Text("TRUE"),
                                    value: true,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("FALSE"),
                                    value: false,
                                  ),
                                ],
                                onChanged: dropDowntype),
                          ),
                        ],
                      ),



                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await matchID(
                                  newId: catId,
                                  matchStream: categoryStream,
                                  idField: 'category_id');
                              await FirebaseFirestore.instance
                                  .collection('category')
                                  .doc(catId)
                                  .set(
                                {
                                  'status': _addStatus,
                                  //'image': _addImage.text,
                                  'name': _addName.text,
                                  'category_id': catId,
                                  'position': _addPosition.text,
                                },
                              ).then(
                                    (snapshot) async {
                                  await uploadImageToCateogry(image, catId);
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
        }),
      );
}

// EDIT FEATURE
class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.name,
    required this.status,
    required this.image,
    required this.categoryId,
  }) : super(key: key);

  final String name;
  final bool status;
  final String image;
  final String categoryId;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  //final TextEditingController _status = TextEditingController();
 // final TextEditingController _image = TextEditingController();
  var categoryId;
  var image;
  bool status = true;

  @override
  void initState() {
    super.initState();
    image = widget.image;
    categoryId = widget.categoryId;
    _name.text = widget.name;
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
              customTextField(hinttext: "Name", addcontroller: _name),
             // customTextField(hinttext: "Status", addcontroller: _status),
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
                          fontSize: 15),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        image = await chooseImage();
                      },
                      child: const Icon(
                        Icons.upload_file_outlined,
                      ),
                    )
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

                          'status': status,
                          //'image': _addImage.text,
                          'name': _name.text,
                          'category_id': categoryId,
                          'position': categoryId,

                        },
                      ).then((snapshot) async {
                        await uploadImageToBanner(image, categoryId);
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
    );
  }
}
