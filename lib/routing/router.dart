import 'package:admin_panel_vyam/Screens/database_info.dart';

import 'package:admin_panel_vyam/login_page.dart';

import 'package:admin_panel_vyam/routing/route_names.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case productsRoute:
      return _getPageRoute(const CollectionInfo());

    case loginRoute:
      return _getPageRoute(const LoginPage());

    default:
      return _getPageRoute(const LoginPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
