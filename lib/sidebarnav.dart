import 'package:admin_panel_vyam/database_info.dart';
import 'package:flutter/material.dart';

class SideNavBar1 extends StatefulWidget {
  @override
  _SideNavBar1State createState() => _SideNavBar1State();
}

class _SideNavBar1State extends State<SideNavBar1> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //List<Widget> _widgets = [CollectionInfo(scaffoldState: _scaffoldKey,)];

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
            margin: EdgeInsets.all(8.0),
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
                      fontFamily: "Poppins"),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CollectionInfo())));
                },
              )),
          Positioned(
              top: 100,
              left: 50,
              child: InkWell(
                child: const Text(
                  'User Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Poppins"),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CollectionInfo())));
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
                      fontFamily: "Poppins"),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CollectionInfo())));
                },
              ))
        ],
      ),
    );
  }
}
