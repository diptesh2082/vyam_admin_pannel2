import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
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
                        .collectionGroup('user_booking')
                        .snapshots(),
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
                                'Vendor ID',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                              DataColumn(
                                label: Text(
                                  'User Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Price',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Days',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tax Pay',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Plan End',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Payment done',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Package Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Order Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Gym Address',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Grand Total',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Discount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Days Left',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking Status',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking Price',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking Plan',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Booking Accepted',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(label: Text(''))
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
    String durationEnd =
        "${data['plan_end_duration'].toDate().year}/${data['plan_end_duration'].toDate().month}/${data['plan_end_duration'].toDate().day}";
    String orderDate =
        "${data['order_date'].toDate().year}/${data['order_date'].toDate().month}/${data['order_date'].toDate().day}";
    String bookingDate =
        "${data['booking_date'].toDate().year}/${data['booking_date'].toDate().month}/${data['booking_date'].toDate().day}";
    return DataRow(cells: [
      DataCell(data["vendorId"] != null
          ? Text(data['vendorId'].toString())
          : const Text("")),
      DataCell(data['user_name'] != null
          ? Text(data['user_name'].toString())
          : const Text("")),
      DataCell(data['userId'] != null
          ? Text(data['userId'].toString())
          : const Text("")),
      DataCell(data['total_price'] != null
          ? Text(data['total_price'].toString())
          : const Text("")),
      DataCell(data['totalDays'] != null
          ? Text(data['totalDays'].toString())
          : const Text("")),
      DataCell(data['tax_pay'] != null
          ? Text(data['tax_pay'].toString())
          : const Text("")),
      DataCell(data['plan_end_duration'] != null
          ? Text(durationEnd)
          : const Text("")),
      DataCell(data['payment_done'] != null
          ? Text(data['payment_done'].toString())
          : const Text("")),
      DataCell(data['package_type'] != null
          ? Text(data['package_type'].toString())
          : const Text("")),
      DataCell(data['order_date'] != null ? Text(orderDate) : const Text("")),
      DataCell(data['gym_name'] != null
          ? Text(data['gym_name'].toString())
          : const Text("")),
      DataCell(data['gym_address'] != null
          ? Text(data['gym_address'].toString())
          : const Text("")),
      DataCell(data['grand_total'] != null
          ? Text(data['grand_total'].toString())
          : const Text("")),
      DataCell(data['discount'] != null
          ? Text(data['discount'].toString())
          : const Text("")),
      DataCell(data['daysLeft'] != null
          ? Text(data['daysLeft'].toString())
          : const Text("")),
      DataCell(data['booking_status'] != null
          ? Text(data['booking_status'].toString())
          : const Text("")),
      DataCell(data['booking_price'] != null
          ? Text(data['booking_price'].toString())
          : const Text("")),
      DataCell(data['booking_plan'] != null
          ? Text(data['booking_plan'].toString())
          : const Text("")),
      DataCell(data['booking_id'] != null
          ? Text(data['booking_id'].toString())
          : const Text("")),
      DataCell(
          data['booking_date'] != null ? Text(bookingDate) : const Text("")),
      DataCell(data['booking_accepted'] != null
          ? Text(data['booking_accepted'].toString())
          : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
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
              );
            });
      }),
    ]);
  }

  final TextEditingController _addvendorid = TextEditingController();
  final TextEditingController _addusername = TextEditingController();
  final TextEditingController _adduserid = TextEditingController();
  final TextEditingController _addtotalprice = TextEditingController();
  final TextEditingController _addtotaldays = TextEditingController();
  final TextEditingController _addtaxpay = TextEditingController();
  final TextEditingController _addplanendyear = TextEditingController();
  final TextEditingController _addplanendmonth = TextEditingController();
  final TextEditingController _addplanendday = TextEditingController();
  final TextEditingController _addpaymentdone = TextEditingController();
  final TextEditingController _addpackagetype = TextEditingController();
  final TextEditingController _addorderyear = TextEditingController();
  final TextEditingController _addordermonth = TextEditingController();
  final TextEditingController _addorderday = TextEditingController();
  final TextEditingController _addgymname = TextEditingController();
  final TextEditingController _addgymaddress = TextEditingController();
  final TextEditingController _addgrandtotal = TextEditingController();
  final TextEditingController _adddiscount = TextEditingController();
  final TextEditingController _adddaysletf = TextEditingController();
  final TextEditingController _addbookingstatus = TextEditingController();
  final TextEditingController _addbookingprice = TextEditingController();
  final TextEditingController _addbookingplan = TextEditingController();
  final TextEditingController _addbookingid = TextEditingController();
  final TextEditingController _addbookingyear = TextEditingController();
  final TextEditingController _addbookingmonth = TextEditingController();
  final TextEditingController _addbookingday = TextEditingController();
  final TextEditingController _addbookingaccepted = TextEditingController();

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
                    CustomTextField(
                        hinttext: "Vendor ID", addcontroller: _addvendorid),
                    CustomTextField(
                        hinttext: "User Name", addcontroller: _addusername),
                    CustomTextField(
                        hinttext: "User ID", addcontroller: _adduserid),
                    CustomTextField(
                        hinttext: "Total Price", addcontroller: _addtotalprice),
                    CustomTextField(
                        hinttext: "Total Days", addcontroller: _addtotaldays),
                    CustomTextField(
                        hinttext: "Tax Pay", addcontroller: _addtaxpay),
                    CustomTextField(
                        hinttext: "Plan End Y", addcontroller: _addplanendyear),
                    CustomTextField(
                        hinttext: "Plan End M",
                        addcontroller: _addplanendmonth),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addplanendday),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addpaymentdone),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addpackagetype),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addorderyear),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addordermonth),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addorderday),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addgymname),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addgymaddress),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addgrandtotal),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _adddiscount),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _adddaysletf),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingstatus),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingprice),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingplan),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingid),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingyear),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingmonth),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingday),
                    CustomTextField(
                        hinttext: "Name", addcontroller: _addbookingaccepted),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final querySnapshot = FirebaseFirestore.instance
                              .collection('bookings')
                              .doc("'data['userId']'")
                              .collection('user_booking')
                              .doc("data['booking_id']");
                          querySnapshot.update({'booking_price': 20});
                          // FirebaseFirestore.instance
                          //     .collectionGroup('user_booking')
                          //     .doc(_addgymId.text)
                          //     .set(
                          //   {
                          //     // 'address': _addaddress.text,
                          //     // 'gender': _addgender.text,
                          //     // 'name': _addname.text,
                          //     // 'pincode': _addpincode.text,
                          //     // 'location': _addlocation.text,
                          //     // 'gym_id': _addlandmark.text,
                          //     // 'gym_owner': _addgymowner.text,
                          //     // 'landmark': _addlandmark.text
                          //   },
                          // );
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
        height: 480,
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
                      print("/////");
                      print("The Gym id is : ${_gymiid.text}");
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('product_details')
                          .doc('T@gmail.com');

                      GeoPoint dataForGeoPint = GeoPoint(
                          double.parse(_latitudeController.text),
                          double.parse(_longitudeController.text));
                      print(widget.location.latitude);
                      print(widget.location.longitude);
                      print(widget.location.latitude.runtimeType);
                      print(widget.location.longitude.runtimeType);
                      print("////////////////////////");
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
