import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChangeLocationScreen extends StatefulWidget {
  //static const routeName = '/change-location';

  @override
  _ChangeLocationScreenState createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  final _location = Get.arguments as Map<String, double>;
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Change Location'),
          actions: [
            IconButton(
                onPressed: _pickedLocation != null
                    ? () {
                        Get.back(result: _pickedLocation as LatLng);
                      }
                    : null,
                icon: Icon(Icons.check))
          ],
        ),
        body: GoogleMap(
            markers: _pickedLocation == null
                ? {}
                : {
                    Marker(
                        markerId: MarkerId('Truck Marker'),
                        position: _pickedLocation!)
                  },
            onTap: (latlng) {
              setState(() {
                _pickedLocation = latlng;
              });
            },
            initialCameraPosition: CameraPosition(
                zoom: 16,
                target: LatLng(_location['latitude'] as double,
                    _location['longitude'] as double))));
  }
}
