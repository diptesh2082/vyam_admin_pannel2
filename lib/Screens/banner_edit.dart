import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/image_picker_api.dart';
import 'package:admin_panel_vyam/Screens/banners.dart';

class editBanner extends StatefulWidget {
  const editBanner({Key? key}) : super(key: key);

  @override
  State<editBanner> createState() => _editBannerState();
}

class _editBannerState extends State<editBanner> {
  final TextEditingController _name = TextEditingController();
  var id;
  var image;
  bool access = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Column(children: <Widget>[
        CustomTextField(hinttext: "Name", addcontroller: _name),
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
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                print("/////");

                FirebaseFirestore.instance
                    .collection('banner_details')
                    .doc(id)
                    .update(
                  {
                    'name': _name.text,
                    //'image': image,
                    'id': id,
                    'access': access,
                  },
                ).then((snapshot) async {
                  await uploadImageToBanner(image, id);
                });
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ),
        )
      ]),
    );
  }
}
