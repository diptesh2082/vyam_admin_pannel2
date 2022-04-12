import 'package:admin_panel_vyam/Packages/packages.dart';
import 'package:admin_panel_vyam/Trainers/Trainers.dart';
import 'package:admin_panel_vyam/services/maps_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
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
                    stream: FirebaseFirestore.instance
                        .collection("product_details")
                        .snapshots(),
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
                            // ? DATATABLE
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym Owner',
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
                                  'Location',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Landmark',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Pincode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(label: Text('')), //! For edit pencil
                              DataColumn(
                                  label: Text('Trainers')), //! For trainer
                              DataColumn(
                                  label: Text('Packages')), //!For Package
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

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    GeoPoint loc = data['location'];
    String loctext = "${loc.latitude},${loc.longitude}";
    return DataRow(cells: [
      DataCell(data != null ? Text(data['name'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['address'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gym_id'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gym_owner'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['gender'] ?? "") : Text("")),
      DataCell(data != null
          ? GestureDetector(
              onTap: () async {
                await MapsLaucherApi().launchMaps(loc.latitude, loc.longitude);
              },
              child: Text(loctext))
          : Text("")),
      DataCell(data != null ? Text(data['landmark'] ?? "") : Text("")),
      DataCell(data != null ? Text(data['pincode'] ?? "") : Text("")),
      DataCell(
        const Text(""),
        showEditIcon: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                // ? Added Gesture Detecter for popping off update record Card
                child: SingleChildScrollView(
                  child: ProductEditBox(
                    address: data['address'],
                    gender: data['gender'],
                    name: data['name'],
                    pincode: data['pincode'],
                    gymId: data['gym_id'],
                    gymOwner: data['gym_owner'],
                    landmark: data['landmark'],
                    location: data['location'],
                  ),
                ),
                onTap: () =>
                    Navigator.pop(context), // ? ontap Property for popping of
              );
            },
          );
        },
      ),
      DataCell(const Text('Trainer'), onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TrainerPage(),
        ));
      })),
      DataCell(const Text('Package '), onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PackagesPage(),
        ));
      })
    ]);
  }

  final TextEditingController _addaddress = TextEditingController();
  final TextEditingController _addgender = TextEditingController();
  final TextEditingController _addname = TextEditingController();
  final TextEditingController _addpincode = TextEditingController();
  final TextEditingController _addlocation = TextEditingController();
  final TextEditingController _addlandmark = TextEditingController();
  final TextEditingController _addgymowner = TextEditingController();
  final TextEditingController _addgymId = TextEditingController();
  showAddbox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: SizedBox(
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
                    CustomTextField(hinttext: "Name", addcontroller: _addname),
                    CustomTextField(
                        hinttext: "Address", addcontroller: _addaddress),
                    CustomTextField(
                        hinttext: "Gym ID", addcontroller: _addgymId),
                    CustomTextField(
                        hinttext: "Gym Owner", addcontroller: _addgymowner),
                    CustomTextField(
                        hinttext: "Gender", addcontroller: _addgender),
                    CustomTextField(
                        hinttext: "Location", addcontroller: _addlocation),
                    CustomTextField(
                        hinttext: "Landmark", addcontroller: _addlandmark),
                    CustomTextField(
                      addcontroller: _addpincode,
                      hinttext: "Pincode",
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('product_details')
                              .doc(_addgymId.text)
                              .set(
                            {
                              'address': _addaddress.text,
                              'gender': _addgender.text,
                              'name': _addname.text,
                              'pincode': _addpincode.text,
                              'location': _addlocation.text,
                              'gym_id': _addlandmark.text,
                              'gym_owner': _addgymowner.text,
                              'landmark': _addlandmark.text
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
          ));
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hinttext,
    required this.addcontroller,
  }) : super(key: key);

  final TextEditingController addcontroller;
  final String hinttext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
          child: TextField(
        autofocus: true,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
        controller: addcontroller,
        maxLines: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: 2,
            hintText: hinttext),
      )),
    );
  }
}

// *Updating Item list Class

class ProductEditBox extends StatefulWidget {
  const ProductEditBox({
    Key? key,
    required this.address,
    required this.name,
    required this.gymId,
    required this.gymOwner,
    required this.gender,
    required this.location,
    required this.landmark,
    required this.pincode,
  }) : super(key: key);

  final String name;
  final String address;
  final String gymId;
  final String gymOwner;
  final String gender;
  final GeoPoint location;
  final String landmark;
  final String pincode;

  @override
  _ProductEditBoxState createState() => _ProductEditBoxState();
}

class _ProductEditBoxState extends State<ProductEditBox> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _gymiid = TextEditingController();
  final TextEditingController _gymowner = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _pincode = TextEditingController();

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.address);
    _address.text = widget.address;
    _gender.text = widget.gender;
    _name.text = widget.name;
    _pincode.text = widget.pincode;
    _gymiid.text = widget.gymId;
    _gymowner.text = widget.gymOwner;
    _landmark.text = widget.landmark;
    _location.text = "${widget.location.latitude}, ${widget.location.latitude}";
    _latitudeController.text = widget.location.latitude.toString();
    _longitudeController.text = widget.location.longitude.toString();
    print(widget.location.latitude);
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
              CustomTextField(hinttext: "Name", addcontroller: _name),
              CustomTextField(hinttext: "Address", addcontroller: _address),
              CustomTextField(hinttext: "Gym ID", addcontroller: _gymiid),
              CustomTextField(hinttext: "Gym Owner", addcontroller: _gymowner),
              CustomTextField(hinttext: "Gender", addcontroller: _gender),
              CustomTextField(hinttext: "Location", addcontroller: _location),
              CustomTextField(
                  hinttext: 'Latitude', addcontroller: _latitudeController),
              CustomTextField(
                  hinttext: 'Longitude', addcontroller: _longitudeController),
              CustomTextField(hinttext: "Landmark", addcontroller: _landmark),
              CustomTextField(hinttext: "Pincode", addcontroller: _pincode),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print("The Gym id is : ${_gymiid.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc('T@gmail.com');

                      GeoPoint dataForGeoPint = GeoPoint(
                          double.parse(_latitudeController.text),
                          double.parse(_longitudeController.text));

                      Map<String, dynamic> data = <String, dynamic>{
                        'address': _address.text,
                        'gender': _gender.text,
                        'name': _name.text,
                        'pincode': _pincode.text,
                        'location': dataForGeoPint,
                        'gym_id': _gymiid.text,
                        'gym_owner': _gymowner.text,
                        'landmark': _landmark.text
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
