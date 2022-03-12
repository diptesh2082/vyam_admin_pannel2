
import 'package:admin_panel_vyam/database_info.dart';
import 'package:admin_panel_vyam/main.dart';

import 'package:admin_panel_vyam/login_page.dart';



import 'package:admin_panel_vyam/routing/route_names.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  print('generateRoute: ${settings.name}');
  switch (settings.name) {
    
    
    case ProductsRoute:
      return _getPageRoute(CollectionInfo());
    
    case LoginRoute:
      return _getPageRoute(LoginPage());
    
    default:
      return _getPageRoute(LoginPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}