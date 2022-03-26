import 'package:maps_launcher/maps_launcher.dart';

class MapsLaucherApi {
  Future launchMaps(double? lat, double? long) async {
    try {
      MapsLauncher.launchCoordinates(lat!, long!);
    } catch (e) {
      print(e.toString());
    }
  }
}
