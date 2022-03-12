import 'package:admin_panel_vyam/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(() => NavigationService());
}
