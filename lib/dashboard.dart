import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 11,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          //Intial Commit
          return buildDashBoardCard(
              title: 'Categories', count: 4, collectionID: 'category');
        }
        if (i == 1) {
          return buildDashBoardCard(
              title: 'Vendor', count: 17, collectionID: 'product_details');
        }
        if (i == 2) {
          return buildDashBoardCard(title: 'Per Day', count: 16);
        }
        if (i == 3) {
          return buildDashBoardCard(
              title: 'Banner', count: 3, collectionID: 'banner_details');
        }
        if (i == 4) {
          return buildDashBoardCard(title: 'Total Bookings', count: 129);
        }
        if (i == 5) {
          return buildDashBoardCard(title: 'Total Confirm', count: 1);
        }
        if (i == 6) {
          return buildDashBoardCard(title: 'Total Active', count: 7);
        }
        if (i == 7) {
          return buildDashBoardCard(title: 'Total Complete', count: 116);
        }
        if (i == 8) {
          return buildDashBoardCard(title: 'Total Cancel', count: 4);
        }
        if (i == 9) {
          return buildDashBoardCard(title: 'Total Bookings', count: 1);
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

  buildDashBoardCard({
    String? title = "Categories",
    IconData? iconData = Icons.abc_outlined,
    String? collectionID = "category",
    int? count = 0,
    Color? colour,
  }) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection(collectionID!).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
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
                )
              ],
            ),
          );
        });
  }
}
