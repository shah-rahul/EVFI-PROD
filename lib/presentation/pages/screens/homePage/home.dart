import 'dart:async';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './route_page.dart';
import '../../../resources/assets_manager.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../resources/color_manager.dart';
import '../../widgets/search_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Home());
}

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
  Position _currentPosition = Position(
      longitude: 28.6001740,
      latitude: 77.2105709,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (_mapController != null) {
        _updateCameraPosition();
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
    // Ask permission from device
  }

  void setIntialMarkers(double radius, LatLng position) {
    final GeoPoint intialPostion =
        GeoPoint(position.latitude, position.longitude);

// Center of the geo query.
    late final GeoFirePoint center = GeoFirePoint(intialPostion);

// Detection range from the center point.
    double radiusInKm = radius;

// Field name of Cloud Firestore documents where the geohash is saved.
    String field = 'geo';
// Reference to locations collection.
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('Markers');

// Function to get GeoPoint instance from Cloud Firestore document data.
    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
// Streamed document snapshots of geo query under given conditions.
    late final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
        GeoCollectionReference<Map<String, dynamic>>(collectionReference)
            .subscribeWithin(
      center: center,
      radiusInKm: radiusInKm,
      field: field,
      geopointFrom: geopointFrom,
    );

    stream.listen((event) {
      for (var ds in event) {
        final data = ds.data();

        if (data == null) {
          continue;
        }

        final geoPoint =
            (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
        final geohash =
            (data['geo'] as Map<String, dynamic>)['geohash'] as String;

        _markers.add(Marker(
            markerId: MarkerId(geohash),
            position: LatLng(geoPoint.latitude, geoPoint.longitude)));

        setState(() {});
      }
    });
  }
  

  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 60);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _updateCameraPosition() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(ImageAssets.blackIcon);
    if (_currentPosition != null) {
      setIntialMarkers(
          1.2, LatLng(_currentPosition.latitude, _currentPosition.longitude));

      final cameraPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 14.0,
      );
      BitmapDescriptor currentLocationMarker =
          await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(
                  devicePixelRatio: 1.5), // size: Size(25, 25)),
              ImageAssets.blackIcon);
      setState(() {
        _kGooglePlex = cameraPosition;

        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(_currentPosition.latitude ?? 0.0,
                _currentPosition.longitude ?? 0.0),
            icon: BitmapDescriptor.fromBytes(markerIcon)));

        _mapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    }
  }

  Future<DataSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseDatabase.instance.ref().child('Markers').get();
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

  // @override
  // void initState() {
  //   _getUserCurrentLocation();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.lightGrey,
        body: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              return SizedBox(
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
              );
            }));
  }
}
