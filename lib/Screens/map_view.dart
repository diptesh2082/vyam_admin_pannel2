import 'package:admin_panel_vyam/Screens/banners.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'globalVar.dart';

class MapView extends StatefulWidget {
  MapView({Key? key, this.address_con}) : super(key: key);
  final address_con;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final controller = MapController(location: LatLng(22.572646, 88.363895));

  Offset? _dragStart;
  double _scaleStart = 1.0;

  bool loading = false;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0)
      controller.zoom += 0.02;
    else if (scaleDiff < 0)
      controller.zoom -= 0.02;
    else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
    }
  }

  void _onScaleEnd(ScaleEndDetails details) async {
    try {
      setState(() {
        loading = true;
      });
      lat = controller.center.latitude;
      long = controller.center.longitude;
      sa = GeoPoint(lat, long);
      GeoCode geocode = GeoCode();
      Address add =
          await geocode.reverseGeocoding(latitude: lat, longitude: long);
      address = ((add.region ?? '') +
          '  ' +
          (add.city ?? '') +
          '  ' +
          (add.streetAddress ?? '') +
          ' ' +
          (add.postal ?? ''));
      widget.address_con.text = address;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: Map(
                controller: controller,
                builder: (context, x, y, z) {
                  final url =
                      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                  return CachedNetworkImage(
                    height: 400,
                    width: 400,
                    imageUrl: url,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                      height: 50,
                      minWidth: 50,
                      color: Colors.blue,
                      child: Icon(Icons.zoom_in, color: Colors.white),
                      onPressed: () => controller.zoom += 0.2),
                  SizedBox(height: 3),
                  MaterialButton(
                      height: 50,
                      minWidth: 50,
                      color: Colors.blue,
                      child: Icon(Icons.zoom_out, color: Colors.white),
                      onPressed: () => controller.zoom -= 0.2)
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on_outlined,
              size: 38,
              color: Colors.yellowAccent,
            ),
          ),
          Positioned(
            bottom: 10,
            left: (MediaQuery.of(context).size.width * 0.5) -
                (MediaQuery.of(context).size.width * 0.37),
            child: Card(
              elevation: 12,
              child: Container(
                width: 500,
                height: 75,
                padding: EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lat: $lat , Long: $long'),
                    loading ? CupertinoActivityIndicator() : Text('$address')
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
