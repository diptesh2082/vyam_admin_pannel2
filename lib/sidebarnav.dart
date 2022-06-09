import 'dart:io';

import 'package:admin_panel_vyam/Screens/CitiesScreen.dart';
import 'package:admin_panel_vyam/Screens/Review.dart';
import 'package:admin_panel_vyam/Screens/Tracking/TrackingScreen.dart';
import 'package:admin_panel_vyam/Screens/booking_details.dart';
import 'package:admin_panel_vyam/Screens/cancelation_page.dart';
import 'package:admin_panel_vyam/Screens/category_screen.dart';
import 'package:admin_panel_vyam/Screens/AmenetiesScreen.dart';
import 'package:admin_panel_vyam/Screens/coupon.dart';
import 'package:admin_panel_vyam/Screens/banners.dart';

import 'package:admin_panel_vyam/Screens/faq_details.dart';
import 'package:admin_panel_vyam/Screens/feedback_dateils.dart';
import 'package:admin_panel_vyam/Screens/payments_screen.dart';
import 'package:admin_panel_vyam/Screens/push_n.dart';

import 'package:admin_panel_vyam/services/image_picker_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'Screens/workouts.dart';
import 'dashboard.dart';

import 'Screens/Product Details/product_details.dart';
import 'Screens/booking_details.dart';

import 'Screens/Collection_info.dart';

class SideNavBar1 extends StatefulWidget {
  const SideNavBar1({Key? key}) : super(key: key);

  @override
  _SideNavBar1State createState() => _SideNavBar1State();
}

class _SideNavBar1State extends State<SideNavBar1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle kTextStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300);

  int? index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String res = await ImagePickerAPI().pickImage(ImageSource.gallery);
          File file = File.fromUri(Uri.file(res));
          print(file.path);
        },
        child: FittedBox(
            fit: BoxFit.fill,
            child: const Text(
              'Pick\nImage',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            )),
      ),
      appBar: AppBar(
        elevation: 0,
        title: const Text('VYAM'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(),
        child: ListView(
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
              accountName: const Text('VYAM Admin'),
              accountEmail: const Text('admin@vyam.co.in'),
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
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Vendor Details',
                style: kTextStyle,
              ),
              onTap: () {
                index = 2;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'User Details',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Booking Details',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Coupon',
                style: kTextStyle,
              ),
              onTap: () {
                setState(() {
                  index = 5;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Feedback',
                style: kTextStyle,
              ),
              onTap: () {
                index = 6;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Category',
                style: kTextStyle,
              ),
              onTap: () {
                index = 7;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Ameneties',
                style: kTextStyle,
              ),
              onTap: () {
                index = 8;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Payments',
                style: kTextStyle,
              ),
              onTap: () {
                index = 9;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Cities',
                style: kTextStyle,
              ),
              onTap: () {
                index = 10;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Tracking',
                style: kTextStyle,
              ),
              onTap: () {
                index = 11;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'FAQ',
                style: kTextStyle,
              ),
              onTap: () {
                index = 12;
                setState(() {});
              },
            ),
            ListTile(
              title: Text(
                'Cancelation Data',
                style: kTextStyle,
              ),
              onTap: () {
                index = 13;
                setState(() {});
              },
            ),
            ListTile(
              title: Text(
                'Review',
                style: kTextStyle,
              ),
              onTap: () {
                index = 14;
                setState(() {});
              },
            ),
            ListTile(
              title: Text(
                'Banners',
                style: kTextStyle,
              ),
              onTap: () {
                index = 15;
                setState(() {});
              },
            ),
            ListTile(
              title: Text(
                'Push Notification',
                style: kTextStyle,
              ),
              onTap: () {
                index = 16;
                setState(() {});
              },
            ),

            ListTile(
              title: Text(
                'Workouts',
                style: kTextStyle,
              ),
              onTap: () {
                index = 17;
                setState(() {});
              },
            ),





            ListTile(
              title: Text(
                'Logout',
                style: kTextStyle,
              ),
              onTap: () {
                // setState(() {
                //   index = 5;
                // });
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          index == 1 ? const showLatestBooking() : Container(),
          index == 2 ? const ProductDetails() : Container(),
          index == 3 ? const UserInformation() : Container(),
          index == 4 ? const BookingDetails() : Container(),
          index == 5 ? const Coupon() : Container(),
          index == 6 ? const FeedBackInfo() : Container(),
          index == 7 ? const CategoryInfoScreen() : Container(),
          index == 8 ? const AmenetiesScreen() : Container(),
          index == 9 ? const PaymentsPage() : Container(),
          index == 10 ? const CitiesScreen() : Container(),
          index == 11 ? const TrackingScreen() : Container(),
          index == 12 ? const FaqDetails() : Container(),
          index == 13 ? const CancelationPage() : Container(),
          index == 14 ? const ReviewPage() : Container(),
          index == 16 ? const Push() : Container(),
          index == 15 ? const BannerPage() : Container(),
          index == 17 ? const workoutsGym() : Container(),

        ],
      ),
    );
  }
}
