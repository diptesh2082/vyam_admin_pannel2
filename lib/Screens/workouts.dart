import 'package:admin_panel_vyam/Screens/addWorkouts.dart';
import 'package:admin_panel_vyam/Screens/banners.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/deleteMethod.dart';

class workoutsGym extends StatefulWidget {
  const workoutsGym({Key? key}) : super(key: key);

  @override
  State<workoutsGym> createState() => _workoutsGymState();
}

class _workoutsGymState extends State<workoutsGym> {
  CollectionReference? couponStream;
  final id =
      FirebaseFirestore.instance.collection('workouts').doc().id.toString();

  @override
  void initState() {
    super.initState();
    couponStream = FirebaseFirestore.instance.collection("workouts");
  }

  String searchWorkout = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Workouts'),
      // backgroundColor: Colors.white10,
      // ),
      appBar: AppBar(title: const Text("Workouts")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const addWorkouts(),
                        ));
                      },
                      child: const Text('Add Workout'),
                    ),
                  ),
                  const Spacer(),
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
                              searchWorkout = value.toString();
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
                ],
              ),
              Center(
                  child: StreamBuilder<QuerySnapshot>(
                stream: couponStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return Container();
                  }
                  print("-----------------------------------");

                  var doc = snapshot.data.docs;

                  if (searchWorkout.length > 0) {
                    doc = doc.where((element) {
                      return element
                              .get('type')
                              .toString()
                              .toLowerCase()
                              .contains(searchWorkout.toString()) ||
                          element
                              .get('gym_id')
                              .toString()
                              .toLowerCase()
                              .contains(searchWorkout.toString());
                    }).toList();
                  }
                  print(snapshot.data.docs);

                  return SingleChildScrollView(
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
                              'ID',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
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
                        rows: _buildlist(context, doc)),
                  );
                },
              )),
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
    String? name;
    try {
      name = data['type'];
    } catch (e) {
      name = "#ERROR";
    }

    String? gymId;
    try {
      gymId = data['gym_id'];
    } catch (e) {
      gymId = "#ERROR";
    }

    String? id1;
    try {
      id1 = data['id'];
    } catch (e) {
      id1 = "#ERROR";
    }

    return DataRow(cells: [
      DataCell(index != null ? Text(index.toString()) : const Text("")),
      DataCell(gymId != null ? Text(gymId.toString()) : const Text("")),
      DataCell(name != null ? Text(name.toString()) : const Text("")),
      DataCell(const Text(""), showEditIcon: true, onTap: () {
        //TODO: Create Edit PAge
        Get.to(() => EditBox(
            gymId: gymId.toString(),
            type: name.toString(),
            id: id1.toString()));
      }),
      DataCell(const Icon(Icons.delete), onTap: () {
        deleteMethod(stream: couponStream, uniqueDocId: id1);
      })
    ]);
  }
}

class EditBox extends StatefulWidget {
  const EditBox({
    Key? key,
    required this.gymId,
    required this.type,
    required this.id,
  }) : super(key: key);

  final String type;
  final String gymId;
  final String id;
  @override
  State<EditBox> createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  final TextEditingController _type = TextEditingController();
  // final TextEditingController _id = TextEditingController();
  final TextEditingController _gymId = TextEditingController();
  var _id;
  @override
  void initState() {
    super.initState();

    _type.text = widget.type;
    _id = widget.id;
    _gymId.text = widget.gymId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Edit Workouts'),
      ),
      body: Center(
        child: SizedBox(
          height: 600,
          width: 800,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Update Records for this doc',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                CustomTextField(hinttext: "Name", addcontroller: _type),
                CustomTextField(hinttext: "Gym_Id", addcontroller: _gymId),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("/////");

                        await FirebaseFirestore.instance
                            .collection('workouts')
                            .doc(_id)
                            .update(
                          {
                            'type': _type.text,
                            'id': _id,
                            'gym_id': _gymId.text,
                          },
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
