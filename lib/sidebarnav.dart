import 'package:admin_panel_vyam/Screens/booking_details.dart';
import 'package:admin_panel_vyam/Screens/coupon.dart';
import 'package:admin_panel_vyam/Screens/database_info.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'Screens/database_info.dart';
import 'Screens/product_details.dart';
import 'Screens/booking_details.dart';

class SideNavBar1 extends StatefulWidget {
  const SideNavBar1({Key? key}) : super(key: key);

  @override
  _SideNavBar1State createState() => _SideNavBar1State();
}

class _SideNavBar1State extends State<SideNavBar1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle kTextStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300);

  int? index = 0;

  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();

    List<bool> _boolArray = [];

    List _list = [
      const ProductDetails(),
      const CollectionInfo(),
      const BookingDetails(),
      const Coupon(),
      const DashBoardScreen(),
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: const Text('VYAM'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            UserAccountsDrawerHeader(
              accountName: Text('VYAM Admin'),
              accountEmail: Text('admin@vyam.co.in'),
              arrowColor: Colors.lightBlueAccent,
              currentAccountPicture: Image.asset(
                "Assets/vyam.png",
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                'Dashboard',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 0;
                });
              },
            ),
            ListTile(
              title: Text(
                'Product Details',
                style: kTextStyle,
              ),
              onTap: () {
                index = 1;
                setState(() {});
              },
            ),
            ListTile(
              title: Text(
                'Collection Details',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 2;
                });
              },
            ),
            ListTile(
              title: Text(
                'Booking Details',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 3;
                });
              },
            ),
            ListTile(
              title: Text(
                'Cupon',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 4;
                });
              },
            ),
            ListTile(
              title: Text(
                'Feedback',
                style: kTextStyle,
              ),
              onTap: () {
                // index = 1;
                // setState(() {});
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 5;
                });
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          index == 0 ? DashBoardScreen() : Container(),
          index == 1 ? CollectionInfo() : Container(),
          index == 2 ? BookingDetails() : Container(),
          index == 4 ? Coupon() : Container(),
        ],
      ),
    );
  }
}

class SetScreenForHome extends StatefulWidget {
  const SetScreenForHome({Key? key, this.index}) : super(key: key);

  final int? index;

  @override
  State<SetScreenForHome> createState() => _SetScreenForHomeState();
}

class _SetScreenForHomeState extends State<SetScreenForHome> {
  @override
  Widget build(BuildContext context) {
    if (widget.index == 1) {
      return CollectionInfo();
    }

    return Container();
  }
}
// import 'package:admin_panel_vyam/booking_details.dart';
// import 'package:admin_panel_vyam/coupon.dart';
// import 'package:admin_panel_vyam/database_info.dart';
// import 'package:admin_panel_vyam/faq_details.dart';
// import 'package:admin_panel_vyam/feedback_dateils.dart';
// import 'package:admin_panel_vyam/review_details.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'database_info.dart';
// import 'product_details.dart';
// import 'booking_details.dart';
//
// class SideNavBar1 extends StatefulWidget {
//   const SideNavBar1({Key? key}) : super(key: key);
//
//   @override
//   _SideNavBar1State createState() => _SideNavBar1State();
// }
//
// class _SideNavBar1State extends State<SideNavBar1> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     PageController _controller = PageController();
//     List<Widget> _list = [
//       ProductDetails(),
//       CollectionInfo(),
//       BookingDetails(),
//       Coupon(),
//       FeedBackInfo(),
//       ReviewInfo(),
//       FaqDetails()
//     ];
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.white,
//           ),
//           Container(
//             margin: const EdgeInsets.all(8.0),
//             height: MediaQuery.of(context).size.height,
//             width: 201.0,
//             decoration: BoxDecoration(
//               color: Colors.amber.shade300,
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             left: 50,
//             child: InkWell(
//               child: const Text(
//                 'Product Details',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               onTap: () {
//                 _controller.jumpToPage(0);
//               },
//             ),
//           ),
//           Positioned(
//               top: 100,
//               left: 50,
//               child: InkWell(
//                 child: const Text(
//                   'User Details',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 onTap: () {
//                   _controller.jumpToPage(1);
//                 },
//               )),
//           Positioned(
//               top: 150,
//               left: 50,
//               child: InkWell(
//                 child: const Text(
//                   'Booking Details',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 onTap: () {
//                   _controller.jumpToPage(2);
//                 },
//               )),
//           Positioned(
//               top: 200,
//               left: 50,
//               child: InkWell(
//                 child: const Text(
//                   'Coupon',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 onTap: () {
//                   _controller.jumpToPage(3);
//                 },
//               )),
//           Positioned(
//               top: 250,
//               left: 50,
//               child: InkWell(
//                 child: const Text(
//                   'Feedback',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 onTap: () {
//                   _controller.jumpToPage(4);
//                 },
//               )),
//           Positioned(
//               top: 300,
//               left: 50,
//               child: InkWell(
//                 child: const Text(
//                   'Reviews',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 onTap: () {
//                   _controller.jumpToPage(5);
//                 },
//               )),
//           Positioned(
//               top: 350,
//               left: 50,
//               child: InkWell(
//                 child: const Text(
//                   'FAQs',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 onTap: () {
//                   _controller.jumpToPage(6);
//                 },
//               )),
//           Positioned(
//             top: 400,
//             left: 50,
//             child: InkWell(
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               onTap: () {
//                 FirebaseAuth.instance.signOut();
//               },
//             ),
//           ),
//           Align(
//             alignment: Alignment(0, 0),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 230.0, top: 20),
//               child: SizedBox(
//                 child: PageView.builder(
//                   itemCount: 7,
//                   itemBuilder: (_, int idx) {
//                     return _list[idx];
//                   },
//                   controller: _controller,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
