import 'package:admin_panel_vyam/database_info.dart';
import 'package:admin_panel_vyam/navigation_service.dart';
import 'package:admin_panel_vyam/routing/route_names.dart';
import 'package:admin_panel_vyam/routing/router.dart';
import 'package:admin_panel_vyam/sidebarnav.dart';
import 'package:flutter/material.dart';

import 'package:admin_panel_vyam/locator.dart';

class LayoutTemplate extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      drawer: Container(
        color: Colors.white,
        child: ListView(
          children: const [
            UserAccountsDrawerHeader(
              accountEmail: Text("abc@gmail.com"),
              accountName: Text("Santos Enoque"),
            ),
            ListTile(
              title: Text("Lessons"),
              leading: Icon(Icons.book),
            )
          ],
        ),
      ),
      body: Row(
        children: [
          SideNavBar1(),
          Expanded(
            child: Column(
              children: [
                CollectionInfo(),
                Expanded(
                  child: Navigator(
                    key: getIt<NavigationService>().navigatorKey,
                    onGenerateRoute: generateRoute,
                    initialRoute: ProductsRoute,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
