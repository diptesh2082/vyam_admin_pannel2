import 'package:admin_panel_vyam/Screens/Collection_info.dart';
import 'package:admin_panel_vyam/Screens/Product%20Details/Trainers/Trainers.dart';
import 'package:admin_panel_vyam/Screens/banners.dart';
import 'package:admin_panel_vyam/Screens/category_screen.dart';
import 'package:admin_panel_vyam/Screens/perday.dart';
import 'package:admin_panel_vyam/Screens/todaybook.dart';
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
            child: Carddb(title: 'Per Day', collectionId: 'bookings'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => perday()));
            },
          );
        }
        if (i == 3) {
          return GestureDetector(
            child: Cardd(title: 'Banner', collectionId: 'banner_details'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BannerPage()));
            },
          );
        }
        if (i == 4) {
          return GestureDetector(
            child: Cardd(
              title: 'Total Bookings',
              collectionId: 'bookings',
              s: ['active', 'upcoming', 'completed', 'cancelled'],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingDetails()));
            },
          );
        }

        if (i == 5) {
          return GestureDetector(
            child: Cardd(
                title: 'Upcoming Bookings',
                collectionId: 'bookings',
                s: ['upcoming']),
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
            child: Cardd(
              title: 'Total Active',
              collectionId: 'bookings',
              s: ['active'],
            ),
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
            child: Cardd(
                title: 'Total Complete',
                s: ['completed'],
                collectionId: 'bookings'),
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
            child: Cardd(
              title: 'Total Cancel',
              collectionId: 'bookings',
              s: ['cancelled'],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const BookingDetails1(st: 'cancelled')));
            },
          );
        }
        if (i == 9) {
          return GestureDetector(
            child: Cardd(
              title: 'Total Users',
              collectionId: 'user_details',
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserInformation()));
            },
          );
        }
        if (i == 10) {
          return GestureDetector(
            child: cardss(
              title: 'Today Bookings',
              collectionId: 'bookings',
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => today()));
            },
          );
        }
        return Spacer();
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 10 / 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
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
    return FutureBuilder(
        future: iss != false
            ? FirebaseFirestore.instance
                .collection(collectionID!)
                .where('booking_status', isEqualTo: state)
                .get()
            : FirebaseFirestore.instance.collection(collectionID!).get(),
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
                color:
                    count!.isEven ? Colors.red : Colors.lightBlueAccent, //TODO
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
                  FittedBox(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          child: const DashBoardScreen(),
        ),
        const SizedBox(height: 100),
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
                        .orderBy("id", descending: true)
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
                            border: TableBorder.all(
                              width: 2.0,
                            ),
                            showBottomBorder: true,
                            dividerThickness: 5,
                            // decoration: BoxDecoration(
                            //   border:Border(
                            //       right: Divider.createBorderSide(context, width: 5.0),
                            //       left: Divider.createBorderSide(context, width: 5.0)
                            //   ),
                            //   // color: AppColors.secondaryColor,
                            // ),
                            dataRowHeight: 65,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Booking ID',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'User Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Mobile',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Booking \nPlan',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Vendor \n Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Start \n Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'End \n Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Booking \n Status',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //       ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Payment \n Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     ""
                              //   ),
                              // ),
                              DataColumn(
                                label: Text(
                                  'Grand \n Total',
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
    String statement = "";

    return DataRow(cells: [
      DataCell(
          data["id"] != null ? Text(data['id'].toString()) : const Text("")),
      // const DataCell(VerticalDivider()),
      DataCell(data["user_name"] != null
          ? Text(data['user_name'].toString())
          : const Text("")),
      // const DataCell(VerticalDivider()),
      DataCell(data['userId'] != null
          ? Text(data['userId'].toString().substring(3, 13))
          : Text("")),
      // const DataCell(VerticalDivider()),
      DataCell(data['booking_plan'] != null
          ? Text(data['booking_plan'].toString())
          : const Text("")),
      // const DataCell(VerticalDivider()),
      DataCell(data['gym_details']['name'] != null
          ? Text(
              '${data['gym_details']['name']}\n ${data['gym_details']['branch']}'
                  .toString())
          : const Text('')),
      // const DataCell(VerticalDivider()),
      DataCell(data['booking_date'] != null
          ? Text(DateFormat('dd MMM , yyyy')
              .format(data['booking_date'].toDate())
              .toString())
          : const Text("")),
      // const DataCell(VerticalDivider()),
      DataCell(data['plan_end_duration'] != null
          ? Text(DateFormat('dd MMM , yyyy')
              .format(data['plan_end_duration'].toDate())
              .toString())
          : const Text("")),
      // const DataCell(VerticalDivider()),
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

                      if (selectedValue == "upcoming") {
                        setState(() {
                          statement = "Upcoming Booking";
                        });
                      }
                      if (selectedValue == "cancelled") {
                        setState(() {
                          statement = "Cancelled Booking";
                        });
                      }
                      if (selectedValue == "active") {
                        setState(() {
                          statement = "Active Booking";
                        });
                      }
                      if (selectedValue == "completed") {
                        setState(() {
                          statement = "Completed Booking";
                        });
                      }
                      await FirebaseFirestore.instance
                          .collection("booking_notifications")
                          .doc()
                          .set({
                        "title": statement,
                        "status": selectedValue,
                        "booking_id": data['booking_id'],
                        // "payment_done": false,
                        "user_id": data['userId'],
                        "user_name": data["user_name"],
                        "vendor_id": data['vendorId'],
                        "vendor_name": data['gym_details']['name'],
                        'time': DateTime.now()
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
      // const DataCell(VerticalDivider()),

      DataCell(data["payment_method"] != null
          ? Text(data['payment_method'].toString().toUpperCase())
          : const Text("")),

      // const DataCell(VerticalDivider()),

      DataCell(data["grand_total"] != null
          ? Text('₹${data['grand_total']}'.toString().toUpperCase())
          : const Text("")),
    ]);
  }
}

class Cardd extends StatelessWidget {
  Cardd({Key? key, this.title, this.collectionId, this.color, this.s})
      : super(key: key);
  final title;
  final collectionId;
  final color;
  final s;
  bool isHovering = false;

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
          int count = snapshot.data.docs.length.toInt();
          return InkWell(
            hoverColor: isHovering == true ? Colors.green : Colors.amber,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: color != null
                    ? color
                    : (count % 2 == 0)
                        ? Colors.red
                        : Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.trending_up,
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

class cardss extends StatelessWidget {
  cardss({Key? key, this.title, this.collectionId, this.color, this.s})
      : super(key: key);
  final title;
  final collectionId;
  final color;
  final s;
  bool isHovering = false;

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
  var tdate = DateTime.now().day.toString();
  var tmonth = DateTime.now().month.toString();
  var tyear = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collectionId).where(
            'booking_status',
            whereIn: ['upcoming', 'active']).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var docs = snapshot.data.docs;
          List<DocumentSnapshot> doc = [];
// <<<<<<< HEAD
          docs.forEach((element) {
            if (element.get('order_date').toDate().day.toString() == tdate &&
                element.get('order_date').toDate().month.toString() == tmonth &&
                element.get('order_date').toDate().year.toString() == tyear) {
              doc.add(element);
            }
          });
          int count = doc.length.toInt();
          return InkWell(
            hoverColor: isHovering == true ? Colors.green : Colors.amber,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: color != null
                    ? color
                    : (count % 2 == 0)
                        ? Colors.red
                        : Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.trending_up,
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

class Carddb extends StatelessWidget {
  Carddb({Key? key, this.title, this.collectionId, this.color})
      : super(key: key);
  final title;
  final collectionId;
  final color;
  bool isHovering = false;

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
            .where('booking_plan', whereIn: [
          "Pay per Day",
          "pay per session",
          "Pay Per Session",
          "PAY PER SESSION"
        ]).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          int count = snapshot.data.docs.length;
          print(count);
          return InkWell(
            hoverColor: isHovering == true ? Colors.green : Colors.amber,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: color ?? (count % 2 == 0) ? Colors.red : Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.trending_up,
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
                            count.toString(),
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
