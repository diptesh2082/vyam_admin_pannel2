import 'package:admin_panel_vyam/Screens/globalVar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class overview extends StatefulWidget {
  const overview({Key? key}) : super(key: key);

  @override
  State<overview> createState() => _overviewState();
}

String namee = "edgefitness.kestopur@vyam.com";

class _overviewState extends State<overview> {
  @override
  CollectionReference? productStream;
  String searchVendor = '';
  // String namee = "edgefitness.kestopur@vyam.com";
  String place = "";
  String search = '';
  bool showStartDate = false;
  bool showEndDate = false;

  calculation() async {
    var booking;
    if (namee == 'all') {
      FirebaseFirestore.instance
          .collection('bookings')
          .where('booking_status',
              whereIn: ['active', 'upcoming', 'completed', 'cancelled'])
          // .where('vendorId', isEqualTo: namee)
          .snapshots()
          .listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              booking = snapshot.docs;
              print("Hellow 2");
              booking.forEach((element) {
                var x = element['booking_date'].toDate();

                if (['upcoming', "completed", "active", "cancelled"]
                        .contains(element['booking_status']) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalbookings.value =
                      1 + Get.find<calculator>().totalbookings.value;
                }

                if (['upcoming', "completed", "active"]
                        .contains(element['booking_status']) &&
                    (element['booking_plan'].toString().toLowerCase().trim() ==
                            'pay per day' ||
                        element['booking_plan']
                                .toString()
                                .toLowerCase()
                                .trim() ==
                            'pay per session') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalperday.value =
                      1 + Get.find<calculator>().totalperday.value;
                }
                // if ((['active', 'completed', 'upcoming'].contains(
                //         element['booking_status']
                //             .toString()
                //             .toLowerCase()
                //             .trim())) &&
                //     (x.isAfter(startDate) && x.isBefore(endDate) ||
                //         x == startDate ||
                //         x == endDate)) {
                //   Get.find<calculator>().totalconfirm.value =
                //       1 + Get.find<calculator>().totalconfirm.value;
                // }
                if ((['active'].contains(element['booking_status']
                        .toString()
                        .toLowerCase()
                        .trim())) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalactive.value =
                      1 + Get.find<calculator>().totalactive.value;
                }
                if ((element['booking_status']
                            .toString()
                            .toLowerCase()
                            .trim() ==
                        'upcoming') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalupcoming.value =
                      1 + Get.find<calculator>().totalupcoming.value;
                }
                if ((['completed'].contains(element['booking_status']
                        .toString()
                        .toLowerCase()
                        .trim())) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalcomplete.value =
                      1 + Get.find<calculator>().totalcomplete.value;
                }
                if ((['cancelled'].contains(element['booking_status']
                        .toString()
                        .toLowerCase()
                        .trim())) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalcancelled.value =
                      1 + Get.find<calculator>().totalcancelled.value;
                }
                if ((["upcoming", "active", "completed"]
                            .contains(element['booking_status']) &&
                        element['payment_method'].toString().toLowerCase() ==
                            "offline") &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().cash.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().cash.value;
                }
                if ((["upcoming", "active", "completed"]
                            .contains(element['booking_status']) &&
                        ["online", "offline"]
                            .contains(element['payment_method'])) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalamount.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().totalamount.value;
                }
                if (["active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['payment_done'] == true &&
                        element['payment_method'].toString().toLowerCase() ==
                            'offline') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalcash_p.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().totalcash_p.value;
                }
                if (["active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['payment_done'] == true &&
                        element['payment_method'].toString().toLowerCase() ==
                            'online') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalo_p.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().totalo_p.value;
                }
                if (["upcoming", "active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['payment_method'].toString().toLowerCase() ==
                        'online') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().online.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().online.value;
                }
                if (['upcoming', "active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['booking_plan'].toString().toLowerCase().trim() !=
                        'pay per day') &&
                    ['upcoming', "active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['booking_plan'].toString().toLowerCase().trim() !=
                        'pay per session') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalpackages.value =
                      1 + Get.find<calculator>().totalpackages.value;
                }

                print(Get.find<calculator>().totalbookings.value);
              });
            }
          });
    } else {
      await FirebaseFirestore.instance
          .collection('bookings')
          .where('booking_status',
              whereIn: ['active', 'upcoming', 'completed', 'cancelled'])
          .where('vendorId', isEqualTo: namee)
          .snapshots()
          .listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              booking = snapshot.docs;
              print("Hellow 2");
              booking.forEach((element) {
                var x = element['booking_date'].toDate();
                if (['upcoming', "completed", "active", "cancelled"]
                        .contains(element['booking_status']) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalbookings.value =
                      1 + Get.find<calculator>().totalbookings.value;
                }
                if (['upcoming', "completed", "active"]
                        .contains(element['booking_status']) &&
                    (element['booking_plan'].toString().toLowerCase().trim() ==
                            'pay per day' ||
                        element['booking_plan']
                                .toString()
                                .toLowerCase()
                                .trim() ==
                            'pay per session') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalperday.value =
                      1 + Get.find<calculator>().totalperday.value;
                }
                // if ((['active', 'completed', 'upcoming'].contains(
                //         element['booking_status']
                //             .toString()
                //             .toLowerCase()
                //             .trim())) &&
                //     (x.isAfter(startDate) && x.isBefore(endDate) ||
                //         x == startDate ||
                //         x == endDate)) {
                //   Get.find<calculator>().totalconfirm.value =
                //       1 + Get.find<calculator>().totalconfirm.value;
                // }
                if ((['active'].contains(element['booking_status']
                        .toString()
                        .toLowerCase()
                        .trim())) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalactive.value =
                      1 + Get.find<calculator>().totalactive.value;
                }
                if ((element['booking_status']
                            .toString()
                            .toLowerCase()
                            .trim() ==
                        'upcoming') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalupcoming.value =
                      1 + Get.find<calculator>().totalupcoming.value;
                }
                if ((['completed'].contains(element['booking_status']
                        .toString()
                        .toLowerCase()
                        .trim())) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalcomplete.value =
                      1 + Get.find<calculator>().totalcomplete.value;
                }
                if ((['cancelled'].contains(element['booking_status']
                        .toString()
                        .toLowerCase()
                        .trim())) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalcancelled.value =
                      1 + Get.find<calculator>().totalcancelled.value;
                }
                if ((["upcoming", "active", "completed"]
                            .contains(element['booking_status']) &&
                        element['payment_method'].toString().toLowerCase() ==
                            "offline") &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().cash.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().cash.value;
                }
                if ((["upcoming", "active", "completed"]
                            .contains(element['booking_status']) &&
                        ["online", "offline"]
                            .contains(element['payment_method'])) &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalamount.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().totalamount.value;
                }
                if (["active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['payment_done'] == true &&
                        element['payment_method'].toString().toLowerCase() ==
                            'offline') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalcash_p.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().totalcash_p.value;
                }
                if (["active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['payment_done'] == true &&
                        element['payment_method'].toString().toLowerCase() ==
                            'online') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalo_p.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().totalo_p.value;
                }
                if (["upcoming", "active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['payment_method'].toString().toLowerCase() ==
                        'online') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().online.value =
                      int.parse(element['grand_total'].toString()) +
                          Get.find<calculator>().online.value;
                }
                if (['upcoming', "active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['booking_plan'].toString().toLowerCase().trim() !=
                        'pay per day') &&
                    ['upcoming', "active", "completed"]
                        .contains(element['booking_status']) &&
                    (element['booking_plan'].toString().toLowerCase().trim() !=
                        'pay per session') &&
                    (x.isAfter(startDate) && x.isBefore(endDate) ||
                        x == startDate ||
                        x == endDate)) {
                  Get.find<calculator>().totalpackages.value =
                      1 + Get.find<calculator>().totalpackages.value;
                }

                print(Get.find<calculator>().totalbookings.value);
              });
            }
          });
    }

    var vendor;

    // FirebaseFirestore.instance
    //     .collection('product_details')
    //     .doc(namee)
    //     .collection('package')
    //     .doc("normal_package")
    //     .collection("gym")
    //     .snapshots()
    //     .listen((snapshot) {
    //   if (snapshot.docs.isNotEmpty) {
    //     vendor = snapshot.docs;
    //     vendor.forEach((element) {
    //
    //     });
    //   }
    // });
    // print(booking);
    // print("++++++++++++++++++++++++++++++++++");
    // print(vendor);
  }

  payment() {
    var paya;
    if (namee == 'all') {
      FirebaseFirestore.instance
          .collection('payment')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          paya = snapshot.docs;
        }
        paya.forEach((element) {
          var x = element['timestamp'].toDate();
          if (["cash"].contains(element['type'].toString().toLowerCase()) &&
              (x.isAfter(startDate) && x.isBefore(endDate) ||
                  x == startDate ||
                  x == endDate)) {
            Get.find<calculator>().ven_c.value =
                int.parse(element['amount'].toString()) +
                    Get.find<calculator>().ven_c.value;
          }
          if (["online"].contains(element['type'].toString().toLowerCase()) &&
              (x.isAfter(startDate) && x.isBefore(endDate) ||
                  x == startDate ||
                  x == endDate)) {
            Get.find<calculator>().ven_o.value =
                int.parse(element['amount'].toString()) +
                    Get.find<calculator>().ven_o.value;
          }
          if ((["cash", "online"].contains(element['type'])) &&
              (x.isAfter(startDate) && x.isBefore(endDate) ||
                  x == startDate ||
                  x == endDate)) {
            Get.find<calculator>().ven_t.value =
                int.parse(element['amount'].toString()) +
                    Get.find<calculator>().ven_t.value;
          }
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('payment')
          .where('gym_id', isEqualTo: namee)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          paya = snapshot.docs;
        }
        paya.forEach((element) {
          var x = element['timestamp'].toDate();
          if (["cash"].contains(element['type'].toString().toLowerCase()) &&
              (x.isAfter(startDate) && x.isBefore(endDate) ||
                  x == startDate ||
                  x == endDate)) {
            Get.find<calculator>().ven_c.value =
                int.parse(element['amount'].toString()) +
                    Get.find<calculator>().ven_c.value;
          }
          if (["online"].contains(element['type'].toString().toLowerCase()) &&
              (x.isAfter(startDate) && x.isBefore(endDate) ||
                  x == startDate ||
                  x == endDate)) {
            Get.find<calculator>().ven_o.value =
                int.parse(element['amount'].toString()) +
                    Get.find<calculator>().ven_o.value;
          }
          // if ((["Cash", "ONLINE"].contains(element['type'])) &&
          //     (x.isAfter(startDate) && x.isBefore(endDate) ||
          //         x == startDate ||
          //         x == endDate)) {
          //   Get.find<calculator>().ven_t.value =
          //       int.parse(element['amount'].toString()) +
          //           Get.find<calculator>().ven_t.value;
          // }
        });
      });
    }
  }

  void initState() {
    calculation();

    productStream = FirebaseFirestore.instance.collection('product_details');

    super.initState();
  }

  DateTime? date;
  DateTime startDate = DateTime(DateTime.now().year - 5);
  DateTime endDate = DateTime(DateTime.now().year + 5);
  Future pickDate(BuildContext context) async {
    final intialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: intialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) DateTime.now();
    setState(() {
      date = newDate;
    });
    return newDate;
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  if (value.isEmpty) {
                    // _node.canRequestFocus=false;
                    // FocusScope.of(context).unfocus();
                  }
                  if (mounted) {
                    setState(() {
                      search = value.toString();
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Vendor',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white12,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Select Vendor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              height: 400,
              width: 400,
              child: StreamBuilder<QuerySnapshot>(
                stream: productStream!.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  String check = "Jee";
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return Container();
                  }
                  print("-----------------------------------");
                  var doc = snapshot.data.docs;
                  if (search.isNotEmpty) {
                    doc = doc.where((element) {
                      return element
                              .get('name')
                              .toString()
                              .toLowerCase()
                              .contains(search.toString()) ||
                          element
                              .get('gym_id')
                              .toString()
                              .toLowerCase()
                              .contains(search.toString()) ||
                          element
                              .get('address')
                              .toString()
                              .toLowerCase()
                              .contains(search.toString());
                    }).toList();
                  }
                  print(snapshot.data.docs);
                  return ListView.builder(
                    itemCount: doc.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index + 1 <= doc.length) {
                        return RadioListTile<String>(
                            value: doc[index]['gym_id'],
                            title: Text(
                                "${doc[index]['name'].toString()} || ${doc[index]['branch'].toString().toUpperCase()}."),
                            groupValue: namee,
                            onChanged: (String? valuee) {
                              setState(() {
                                namee = valuee!;
                                search = namee;
                                place = doc[index]['branch'];
                              });
                              calculation();
                              payment();

                              print(namee);
                            });
                      }
                      return RadioListTile<String>(
                          value: "all",
                          title: const Text("all"),
                          groupValue: namee,
                          onChanged: (String? valuee) {
                            setState(() {
                              namee = valuee!;
                              search = namee;
                              // place = doc[index]['branch'];
                            });
                            calculation();
                            payment();

                            print(namee);
                          });
                    },
                  );
                },
              )),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() async {
                        showStartDate = true;
                        startDate = await pickDate(context);
                        print(startDate);
                      });
                    },
                    icon: const Icon(Icons.date_range),
                    label: const Text('Start Date'),
                  ),
                  showStartDate != false
                      ? Text(DateFormat("MMM, dd, yyyy").format(startDate),
                          style: const TextStyle(fontWeight: FontWeight.bold))
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() async {
                        showEndDate = true;
                        endDate = await pickDate(context);
                        print(endDate);
                      });
                    },
                    icon: const Icon(Icons.date_range),
                    label: const Text('End Date'),
                  ),
                  showEndDate != false
                      ? Text(DateFormat("MMM ,dd , yyyy").format(endDate),
                          style: const TextStyle(fontWeight: FontWeight.bold))
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    startDate = DateTime(DateTime.now().year - 5);
                    endDate = DateTime(DateTime.now().year + 5);
                    search = "";
                    showStartDate = false;
                    showEndDate = false;
                    Get.find<calculator>().totalbookings.value = 0;
                    Get.find<calculator>().totalperday.value = 0;
                    Get.find<calculator>().totalactive.value = 0;
                    // Get.find<calculator>().totalconfirm.value = 0;
                    Get.find<calculator>().totalcancelled.value = 0;
                    Get.find<calculator>().totalupcoming.value = 0;
                    Get.find<calculator>().totalcash_p.value = 0;
                    Get.find<calculator>().cash.value = 0;
                    Get.find<calculator>().totalamount.value = 0;
                    Get.find<calculator>().totalo_p.value = 0;
                    Get.find<calculator>().totalamount.value = 0;
                    Get.find<calculator>().online.value = 0;
                    Get.find<calculator>().totalpackages.value = 0;
                    Get.find<calculator>().totalcomplete.value = 0;
                    Get.find<calculator>().ven_c.value = 0;
                    Get.find<calculator>().ven_o.value = 0;
                    Get.find<calculator>().ven_t.value = 0;

                    // Get.find<calculator>().totalconfirm.value=0;

                    print(startDate);
                    print(endDate);
                    print(search);
                    print(namee);
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              "Overview",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: 15,
            itemBuilder: (ctx, i) {
              if (i == 0) {
                return Obx(
                  () => Cards(
                    title: 'Total Bookings',
                    count:
                        Get.find<calculator>().totalbookings.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }
              if (i == 1) {
                return Obx(
                  () => Cards(
                    title: 'Total Per Day',
                    count: Get.find<calculator>().totalperday.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }
              if (i == 2) {
                return Obx(
                  () => Cards(
                    title: 'Total Packages',
                    count:
                        Get.find<calculator>().totalpackages.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }
              // if (i == 3) {
              //   return Obx(
              //     () => Cards(
              //       title: 'Total Confirm',
              //       count: Get.find<calculator>().totalconfirm.value.toString(),
              //       icons: const Icon(Icons.trending_up),
              //     ),
              //   );
              // }
              if (i == 3) {
                return Obx(
                  () => Cards(
                    title: 'Total Active',
                    count: Get.find<calculator>().totalactive.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }
              if (i == 4) {
                return Obx(
                  () => Cards(
                    title: 'Total Upcoming',
                    count:
                        Get.find<calculator>().totalupcoming.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }

              if (i == 5) {
                return Obx(
                  () => Cards(
                    title: 'Total Completed',
                    count:
                        Get.find<calculator>().totalcomplete.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }
              if (i == 6) {
                return Obx(
                  () => Cards(
                    title: 'Total Cancelled',
                    count:
                        Get.find<calculator>().totalcancelled.value.toString(),
                    icons: const Icon(Icons.trending_up),
                  ),
                );
              }
              if (i == 7) {
                return Obx(
                  () => Cards(
                    title: 'Total Amount',
                    count:
                        "₹ ${Get.find<calculator>().totalamount.value.toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }
              if (i == 8) {
                return Obx(
                  () => Cards(
                    title: 'Cash',
                    count: "₹ ${Get.find<calculator>().cash.value.toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }
              if (i == 9) {
                return Obx(
                  () => Cards(
                    title: 'Online',
                    count:
                        "₹ ${Get.find<calculator>().online.value.toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }
              if (i == 10) {
                return Obx(
                  () => Cards(
                    title: 'Online (Paid)',
                    count:
                        "₹ ${Get.find<calculator>().totalo_p.value.toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }
              if (i == 11) {
                return Obx(
                  () => Cards(
                    title: 'Cash (Paid)',
                    count:
                        "₹ ${Get.find<calculator>().totalcash_p.value.toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }

              if (i == 12) {
                return Obx(
                  () => Cards(
                    title: 'Cash (Vendor)',
                    count: "₹ ${Get.find<calculator>().ven_c.value.toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }
              if (i == 13) {
                return Obx(
                  () => Cards(
                    title: 'Online (Vendor)',
                    count:
                        "₹ ${(Get.find<calculator>().ven_o.value.toString())}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }
              if (i == 14) {
                return Obx(
                  () => Cards(
                    title: 'Total Due',
                    count:
                        "₹ ${(Get.find<calculator>().totalamount.value - Get.find<calculator>().ven_c.value - Get.find<calculator>().ven_o.value).toString()}",
                    icons: const Icon(Icons.calculate),
                  ),
                );
              }

              return const Spacer();
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 10 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class Cards extends StatefulWidget {
  final String title;
  final String count;
  final Icon icons;

  const Cards(
      {Key? key, required this.title, required this.count, required this.icons})
      : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: 300,
        height: 100,
        decoration: const BoxDecoration(color: Colors.red),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: widget.icons,
              radius: 30,
            ),
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.title}",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.count,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        print("New World");
      },
    );
  }

// class Card1 extends StatefulWidget {
//   final String title;
//   final String stream;
//   final Icon icons;
//
//   const Card1(
//       {Key? key,
//       required this.title,
//       required this.stream,
//       required this.icons})
//       : super(key: key);
//   State<Card1> createState() => _Card1State();
// }
//
// class _Card1State extends State<Card1> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('bookings')
//             .where('booking_status', whereIn: [
//           'completed',
//           'active',
//           'upcoming',
//         ]).snapshots(),
//         builder: (context, AsyncSnapshot snapshot) {
//           var docss = snapshot.data.docs;
//           List dao = [];
//           docss.forEach((element) {
//             if (element.get('vendorId') == namee &&
//                 element.get('booking_status') == "active") {
//               dao.add(element);
//             }
//           });
//           return InkWell(
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               width: 300,
//               height: 100,
//               decoration: BoxDecoration(color: Colors.red),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: widget.icons,
//                     radius: 30,
//                   ),
//                   FittedBox(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "${widget.title}",
//                           style: TextStyle(color: Colors.white, fontSize: 14),
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Text(
//                           dao.length.toString(),
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             onTap: () {
//               print("New World");
//             },
//           );
//         });
//   }
}
