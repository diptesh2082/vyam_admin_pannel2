import 'package:admin_panel_vyam/database_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideNavBar1 extends StatefulWidget {
  const SideNavBar1({Key? key}) : super(key: key);

  @override
  _SideNavBar1State createState() => _SideNavBar1State();
}

class _SideNavBar1State extends State<SideNavBar1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const CollectionInfo()),
                  ),
                );
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CollectionInfo())));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CollectionInfo())));
                },
              )),
          Positioned(
            top: 200,
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
        ],
      ),
    );
  }
}
