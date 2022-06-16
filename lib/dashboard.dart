import 'package:admin_panel_vyam/Screens/Product%20Details/Trainers/Trainers.dart';
import 'package:admin_panel_vyam/Screens/banners.dart';
import 'package:admin_panel_vyam/Screens/category_screen.dart';
import 'package:admin_panel_vyam/services/deleteMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Screens/Product Details/product_details.dart';
import 'Screens/booking_details.dart';
import 'bookfilter.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool isHovering = false;
  CollectionReference? categoryStream;
  CollectionReference? productStream;
  CollectionReference? bannerStream;
  CollectionReference? bookingStream;

  @override
  void initState() {
    // TODO: implement initState
    categoryStream = FirebaseFirestore.instance.collection("category");
    productStream = FirebaseFirestore.instance.collection("product_details");
    bannerStream = FirebaseFirestore.instance.collection("banner_details");
    bookingStream = FirebaseFirestore.instance.collection("bookings");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 11,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          //Intial Commit
          return InkWell(
            hoverColor: Colors.blue,
            splashColor: Colors.amber,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryInfoScreen()));
            },
            child: Cardd(
              title: "Categories",
              collectionId: "category",
              color: Colors.teal,
            ),
          );
        }
        if (i == 1) {
          return GestureDetector(
            child: Cardd(
              title: 'Vendor',
              collectionId: 'product_details',
              color: Colors.red,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductDetails()));
            },
          );
        }
        if (i == 2) {
          return GestureDetector(
            child: buildDashBoardCard(title: 'Per Day', count: 16),
            onTap: () {
              // Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => ProductDetails()));
            },
          );
        }
        if (i == 3) {
          return GestureDetector(
            child: buildDashBoardCard(
                title: 'Banner', collectionID: 'banner_details'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BannerPage()));
            },
          );
        }
        if (i == 4) {
          return GestureDetector(
            child: buildDashBoardCard(
                title: 'Total Bookings', collectionID: 'bookings'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingDetails()));
            },
          );
        }

        if (i == 5) {
          return GestureDetector(
            child: buildDashBoardCard(
                title: 'Upcoming Bookings',
                collectionID: 'bookings',
                iss: true,
                state: 'upcoming'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingDetails1(st: 'upcoming')));
            },
          );
        }
        if (i == 6) {
          return GestureDetector(
            child: buildDashBoardCard(
                title: 'Total Active',
                collectionID: 'bookings',
                state: 'active',
                iss: true),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingDetails1(st: 'active')));
            },
          );
        }
        if (i == 7) {
          return GestureDetector(
            child: buildDashBoardCard(
                title: 'Total Complete',
                iss: true,
                state: 'completed',
                collectionID: 'bookings'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingDetails1(st: 'completed')));
            },
          );
        }
        if (i == 8) {
          return GestureDetector(
            child: buildDashBoardCard(
                title: 'Total Cancel',
                count: 4,
                collectionID: 'bookings',
                state: 'cancelled',
                iss: true),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingDetails1(st: 'cancelled')));
            },
          );
        }
        if (i == 9) {
          return GestureDetector(
            child: buildDashBoardCard(
              title: 'Total Bookings',
              collectionID: 'bookings',
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingDetails()));
            },
          );
        }
        return buildDashBoardCard();
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 10 / 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }

  card({
    String? title,
    IconData? iconData,
    String? collectionID,
    int? count,
    Color? colour,
    List? s,
  }
      // bool? iss = false,
      // String? state,
      ) {
    return StreamBuilder(
        stream: collectionID == "bookings"
            ? FirebaseFirestore.instance
                .collection(collectionID!)
                .where('booking_status', whereIn: s)
                .snapshots()
            : FirebaseFirestore.instance
                .collection(collectionID!)
                // .where('booking_status', whereIn: s)
                .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return InkWell(
            hoverColor: isHovering == true ? Colors.green : Colors.amber,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: count!.isEven ? Colors.red : Colors.lightBlueAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      iconData!,
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            snapshot.data.docs.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildDashBoardCard({
    String? title = "Categories",
    IconData? iconData = Icons.abc_outlined,
    String? collectionID = "category",
    int? count = 0,
    Color? colour,
    bool? iss = false,
    String? state,
  }) {
    var check = [];
    return FutureBuilder(
        future: iss != false
            ? FirebaseFirestore.instance
                .collection(collectionID!)
                .where('booking_status', isEqualTo: state)
                .get()
            : FirebaseFirestore.instance
                .collection(collectionID!)
                .where('booking_status', whereIn: [
                'active',
                'upcoming',
                'completed',
                'cancelled'
              ]).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return InkWell(
            hoverColor: isHovering == true ? Colors.green : Colors.amber,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: count!.isEven ? Colors.red : Colors.lightBlueAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      iconData!,
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            snapshot.data.docs.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class showLatestBooking extends StatefulWidget {
  const showLatestBooking({
    Key? key,
  }) : super(key: key);

  @override
  State<showLatestBooking> createState() => _showLatestBookingState();
}

class _showLatestBookingState extends State<showLatestBooking> {
  CollectionReference bookingStream =
      FirebaseFirestore.instance.collection('bookings');
  String searchVendorId = '';
  DateTime? now;

  String x = '';
  bool y = false;
  var selectedValue = 'active';
  var selectedValue1 = 'offline';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width,
          child: DashBoardScreen(),
        ),
        SizedBox(height: 100),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest Bookings',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .where('booking_status', whereIn: [
                          'upcoming',
                          'active',
                          'completed',
                          'cancelled'
                        ])
                        .orderBy("order_date", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        print(snapshot.error);
                        return Container();
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Container();
                      }

                      var doc = snapshot.data.docs;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Booking ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Mobile',
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
                                  'Vendor Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Start Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'End Date',
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
                                  'Booking Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            rows: _buildlist(context, doc)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  List<DataRow> _buildlist(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    var d = [];
    int count = 0;
    snapshot.forEach((element) {
      count += 1;
      if (count <= 10) {
        d.add(element);
      }
    });
    return d.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    String bookingId = data['booking_id'];
    bool bookingAccepted = data["booking_accepted"];

    return DataRow(cells: [
      DataCell(
          data["id"] != null ? Text(data['id'].toString()) : const Text("")),
      DataCell(data["user_name"] != null
          ? Text(data['user_name'].toString())
          : const Text("")),
      DataCell(data['userId'] != null
          ? Text(data['userId'].toString().substring(3, 13))
          : Text("")),
      DataCell(data['booking_plan'] != null
          ? Text(data['booking_plan'].toString())
          : const Text("")),
      DataCell(data['gym_details']['name'] != null
          ? Text(
              '${data['gym_details']['name']}|| ${data['gym_details']['branch']}'
                  .toString())
          : const Text("")),
      DataCell(data['booking_date'] != null
          ? Text(DateFormat('dd MMM , yyyy')
              .format(data['booking_date'].toDate())
              .toString())
          : const Text("")),
      DataCell(data['plan_end_duration'] != null
          ? Text(DateFormat('dd MMM , yyyy')
              .format(data['plan_end_duration'].toDate())
              .toString())
          : const Text("")),
      DataCell(
        Center(
          child: Container(
            child: Row(
              children: [
                DropdownButton(
                    hint: Text(data['booking_status'].toString()),
                    value: data['booking_status'].toString(),
                    items: const [
                      DropdownMenuItem(
                        child: Text("Active"),
                        value: "active",
                      ),
                      DropdownMenuItem(
                        child: Text("Upcoming"),
                        value: "upcoming",
                      ),
                      DropdownMenuItem(
                          child: Text("Completed"), value: "completed"),
                      DropdownMenuItem(
                          child: Text("Cancelled"), value: "cancelled"),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        selectedValue = value as String;
                      });
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(bookingId)
                          .update({'booking_status': value});
                    }),
              ],
            ),
          ),
        ),
      ),
      DataCell(data["payment_method"] != null
          ? Text(data['payment_method'].toString().toUpperCase())
          : const Text("")),
    ]);
  }
}

class Cardd extends StatelessWidget {
  Cardd(
      {Key? key,
      required this.title,
      required this.collectionId,
      this.color,
      this.s})
      : super(key: key);
  final title;
  final collectionId;
  final color;
  final s;
  bool isHovering = false;
  CollectionReference? categoryStream;
  CollectionReference? productStream;
  CollectionReference? bannerStream;
  CollectionReference? bookingStream;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   categoryStream = FirebaseFirestore.instance.collection("category");
  //   productStream = FirebaseFirestore.instance.collection("product_details");
  //   bannerStream = FirebaseFirestore.instance.collection("banner_details");
  //   bookingStream = FirebaseFirestore.instance.collection("bookings");
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionId)
            .where('booking_status', whereIn: s)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return InkWell(
            hoverColor: isHovering == true ? Colors.green : Colors.amber,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            snapshot.data.docs.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
