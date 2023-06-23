import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../resources/color_manager.dart';
import '../../widgets/search_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6001740, 77.2105709),
    zoom: 13.4746,
    tilt: 15,
  );
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController _mapController;
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      if (_mapController != null) {
        _updateCameraPosition();
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _updateCameraPosition() {
    if (_currentPosition != null) {
      final cameraPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 14.0,
      );
      setState(() {
        _kGooglePlex = cameraPosition;
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(_currentPosition.latitude ?? 0.0,
                _currentPosition.longitude ?? 0.0)));
        _mapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    }
  }
  // Location currentLocation = Location();

  // Future<Position> _getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) {
  //     print(error);
  //   });
  //   return await Geolocator.getCurrentPosition();
  // }

  // void _getCurrentLocation() async {
  //   Location location = Location();
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;

  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }

  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  // }

  // void getLocation() async {
  //   var location = await currentLocation.getLocation();
  //   final GoogleMapController Controller2 = await _controller.future;
  //   currentLocation.onLocationChanged.listen((LocationData loc) {
  //     Controller2.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
  //       zoom: 12.0,
  //     )));
  //     print(loc.latitude);
  //     print(loc.longitude);
  //     setState(() {
  //       _markers.add(Marker(
  //           markerId: MarkerId('Home'),
  //           position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
  //     });
  //   });
  // }
  // @override
  // void initState() {
  //   _getUserCurrentLocation();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.lightGrey,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              const GFLoader(type: GFLoaderType.circle),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  // _getUserCurrentLocation().then((value) {
                  //   CameraPosition currentPosition = CameraPosition(
                  //       target: LatLng(value.latitude, value.longitude),
                  //       zoom: 14);
                  //   setState(() {
                  //     _markers.add(Marker(
                  //         markerId: MarkerId("home"),
                  //         position: LatLng(value.latitude, value.longitude)));
                  //   });

                  //   controller.animateCamera(
                  //       CameraUpdate.newCameraPosition(currentPosition));
                  // });
                  _mapController = controller;
                  _updateCameraPosition();
                  _controller.complete(controller);
                },
                markers: Set<Marker>.of(_markers),
                zoomControlsEnabled: false,
                compassEnabled: false,
                zoomGesturesEnabled: false,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07),
                child: const SearchWidget(),
              ),
            ],
          ),
        ));
  }
}
