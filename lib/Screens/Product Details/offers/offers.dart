import 'package:admin_panel_vyam/Screens/Product%20Details/product_details.dart';
import 'package:admin_panel_vyam/services/CustomTextFieldClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/deleteMethod.dart';

String globalOfferId = '';
String globalName = '';

class offersPage extends StatefulWidget {
  String offerId;
  String name;
  var landmark;

  offersPage(
      {Key? key,
      required this.offerId,
      required this.name,
      required this.landmark})
      : super(key: key);

  @override
  State<offersPage> createState() => _offersPageState();
}

class _offersPageState extends State<offersPage> {
  CollectionReference? offersStream;
  var landmark;

  @override
  void initState() {
    // TODO: implement initState

    offersStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.offerId)
        .collection('offers');

    globalOfferId = widget.offerId;
    globalName = widget.name;
    landmark = widget.landmark;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Center(
          child: Text(
            '${globalName.toString().toUpperCase()}\n ${landmark.toString().toUpperCase()}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(onPrimary: Colors.purple),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => addboxx(
                                  id: widget.offerId,
                                )));
                  },
                  child: const Text(
                    'Add Offers',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('product_details')
                      .doc(widget.offerId)
                      .collection('offers')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      print('No output for offer');
                      print("///////''''''''''''...");
                      print(widget.offerId);
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
                                'Index',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Description',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataColumn(
                                label: Text(
                              'Offer',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              'Offer Type',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text("Previous Page"),
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
            ]),
          ),
        ),
      ),
    );
  }

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
    return DataRow(cells: [
      DataCell(data != null ? Text(index.toString()) : const Text("")),
      DataCell(data != null
          ? Text(data['title'].toString().toUpperCase())
          : const Text("")),
      DataCell(data != null
          ? Text(data['description'].toString().toUpperCase())
          : const Text("")),
      DataCell(data != null
          ? Text(data['offer'].toString().toUpperCase())
          : const Text("")),
      DataCell(data != null
          ? Text(data['offer_type'].toString().toUpperCase())
          : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OffersEditBox(
                      gym_id: globalOfferId,
                      id: data.id,
                      title: data['title'],
                      description: data['description'],
                      offer: data['offer'],
                      offer_type: data['offer_type'],
                    )));
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        // deleteMethod(stream: paymentStream, uniqueDocId: data['userid']);

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
                                  stream: offersStream, uniqueDocId: data.id);
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

var start = 0;
var page = 1;
var end = 10;
var length;

class addboxx extends StatefulWidget {
  var id;
  addboxx({Key? key, required this.id}) : super(key: key);

  @override
  State<addboxx> createState() => _addboxxState();
}

class _addboxxState extends State<addboxx> {
  CollectionReference? offersStream;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _offer = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _offer_type = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    offersStream = FirebaseFirestore.instance
        .collection('product_details')
        .doc(widget.id)
        .collection('offers');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Offers'),
      ),
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Add Records',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              customTextField(hinttext: "Title", addcontroller: _title),
              customTextField(
                  hinttext: 'Description', addcontroller: _description),
              customTextField(hinttext: "Offer", addcontroller: _offer),
              customTextField(
                  hinttext: "Offer Type", addcontroller: _offer_type),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('product_details')
                        .doc(widget.id)
                        .collection('offers')
                        .doc()
                        .set(
                      {
                        'title': _title.text,
                        'description': _description.text,
                        'offer': _offer.text,
                        'offer_type': _offer_type.text,
                      },
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          ),
        ),
      ),
    );
  }
}

class OffersEditBox extends StatefulWidget {
  var title;
  var offer_type;
  var offer;
  var description;
  var id;
  var gym_id;

  OffersEditBox(
      {Key? key,
      required this.title,
      required this.description,
      required this.offer,
      required this.offer_type,
      required this.id,
        required this.gym_id})
      : super(key: key);

  @override
  State<OffersEditBox> createState() => _OffersEditBoxState();
}

class _OffersEditBoxState extends State<OffersEditBox> {
  CollectionReference? offerStream;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _offer = TextEditingController();
  final TextEditingController _offer_type = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    offerStream = FirebaseFirestore.instance.collection('product_details').doc(widget.id).collection('offers');
    _title.text = widget.title;
    _description.text = widget.description;
    _offer_type.text = widget.offer_type;
    _offer.text = widget.offer;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Offers'),
      ),
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Column(
          children:  [
            const Text('Update Offers' , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),),

            customTextField(hinttext: 'Title' , addcontroller: _title),
            customTextField(hinttext: 'Description' , addcontroller: _description),
            customTextField(hinttext: 'Offer' , addcontroller: _offer),
            customTextField(hinttext: 'Offer Type' , addcontroller: _offer_type),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    print(widget.id);
                    print(widget.gym_id);
                    // print("The Gym id is : ${widget.}");
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('product_details')
                        .doc(widget.gym_id )
                        .collection('offers')
                        .doc(widget.id);
                    Map<String, dynamic> data = <String, dynamic>{
                      'title': _title.text,
                      'description': _description.text,
                      'offer': _offer.text,
                      'offer_type': _offer_type.text,
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
            ),
          ],
        ),
      ),
    );
  }
}
