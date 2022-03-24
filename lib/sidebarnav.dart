import 'package:admin_panel_vyam/booking_details.dart';
import 'package:admin_panel_vyam/coupon.dart';
import 'package:admin_panel_vyam/database_info.dart';
import 'package:admin_panel_vyam/faq_details.dart';
import 'package:admin_panel_vyam/feedback_dateils.dart';
import 'package:admin_panel_vyam/review_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'database_info.dart';
import 'product_details.dart';
import 'booking_details.dart';

class SideNavBar1 extends StatefulWidget {
  const SideNavBar1({Key? key}) : super(key: key);

  @override
  _SideNavBar1State createState() => _SideNavBar1State();
}

class _SideNavBar1State extends State<SideNavBar1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();
    List<Widget> _list = [
      ProductDetails(),
      CollectionInfo(),
      BookingDetails(),
      Coupon(),
      FeedBackInfo(),
      ReviewInfo(),
      FaqDetails()
    ];
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height,
            width: 201.0,
            decoration: BoxDecoration(
              color: Colors.amber.shade300,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Positioned(
            top: 50,
            left: 50,
            child: InkWell(
              child: const Text(
                'Product Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () {
                _controller.jumpToPage(0);
              },
            ),
          ),
          Positioned(
              top: 100,
              left: 50,
              child: InkWell(
                child: const Text(
                  'User Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onTap: () {
                  _controller.jumpToPage(1);
                },
              )),
          Positioned(
              top: 150,
              left: 50,
              child: InkWell(
                child: const Text(
                  'Booking Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onTap: () {
                  _controller.jumpToPage(2);
                },
              )),
          Positioned(
              top: 200,
              left: 50,
              child: InkWell(
                child: const Text(
                  'Coupon',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onTap: () {
                  _controller.jumpToPage(3);
                },
              )),
          Positioned(
              top: 250,
              left: 50,
              child: InkWell(
                child: const Text(
                  'Feedback',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onTap: () {
                  _controller.jumpToPage(4);
                },
              )),
          Positioned(
              top: 300,
              left: 50,
              child: InkWell(
                child: const Text(
                  'Reviews',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onTap: () {
                  _controller.jumpToPage(5);
                },
              )),
          Positioned(
              top: 350,
              left: 50,
              child: InkWell(
                child: const Text(
                  'FAQs',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onTap: () {
                  _controller.jumpToPage(6);
                },
              )),
          Positioned(
            top: 400,
            left: 50,
            child: InkWell(
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 230.0, top: 20),
              child: SizedBox(
                child: PageView.builder(
                  itemCount: 7,
                  itemBuilder: (_, int idx) {
                    return _list[idx];
                  },
                  controller: _controller,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
