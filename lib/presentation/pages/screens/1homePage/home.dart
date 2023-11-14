//ignore_for_file: unused_local_variable, unnecessary_null_comparison, non_constant_identifier_names, unnecessary_import, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/color_manager.dart';
import '../../widgets/marker_infowindow.dart';
import '../../widgets/search_widget.dart';
import '../../models/pricing_model.dart';

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

double batteryCap = 0;

class HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController _mapController;
  MyPricing mypricing = MyPricing();
  Position _currentPosition = Position(
    longitude: 28.679079,
    latitude: 77.069710,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getBatteryCap().then((value) => batteryCap = value);
  }

  late CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(28.679079, 77.069710),
    zoom: 13.4746,
    tilt: 15,
  );

  Future<Map<String, dynamic>> getUserSnapShot() async {
    QuerySnapshot querySnapshot = await UserChargingReference.get();
    Map<String, dynamic> detailsMap = {};
    final allData = querySnapshot.docs.map((doc) => doc.data());
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    if (querySnapshot.docs.isNotEmpty) {
      // Loop through the documents in the collection
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        detailsMap = documentSnapshot.data() as Map<String, dynamic>;

        if (detailsMap != null) {
          print(currentUserUID);
          print(detailsMap['uid']);

          // print(detailsMap['pinCode']);
          if (currentUserUID == detailsMap['uid']) {
            return detailsMap;
          }
        }
      }
    }
    return detailsMap;
  }

  Future<double> getBatteryCap() async {
    Map<String, dynamic> detailsMap = await getUserSnapShot();

    dynamic level2 = detailsMap['level2'];
    print(level2);
    if (level2 != null && level2 != false) {
      String batteryCapacity = level2['batteryCapacity'];
      return (double.parse(batteryCapacity));
    }
    return 0;
  }

  void _getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print(isLocationServiceEnabled);
    if (!isLocationServiceEnabled) {
      bool serviceEnabled = await Geolocator.openLocationSettings();

      if (serviceEnabled) {
        print('Location services are now enabled');
      } else {
        print('Location services remain disabled');
        print(serviceEnabled);

        return Future.error('Location services are disabled.');
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLocationPermissionRequested =
        prefs.getBool('location_permission_requested') ?? false;
    print(isLocationPermissionRequested);
    if (!isLocationPermissionRequested) {
      // If location permission is not requested before, request it now

      await Geolocator.requestPermission();
      await prefs.setBool('location_permission_requested', true);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        if (_mapController != null) {
          updateCameraPosition(_currentPosition);
        }
      } catch (e) {
        // print('Error getting current location: $e');
      }
    } else {
      Future.error('Location services  denied.');
    }
    // Ask permission from device
  }

// Reference to locations collection.
  final CollectionReference<Map<String, dynamic>> chargersReference =
      FirebaseFirestore.instance.collection('chargers');
  final CollectionReference<Map<String, dynamic>> UserChargingReference =
      FirebaseFirestore.instance.collection('user');

// Function to get GeoPoint instance from Cloud Firestore document data.
  GeoPoint geopointFrom(Map<String, dynamic> data) =>
      (data['g'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

  void setIntialMarkers(double radius, LatLng position) async {
    final Uint8List GreenmarkerIcon =
        await getBytesFromAsset(ImageAssets.greenMarker);
    BitmapDescriptor nearbyMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5), // size: Size(25, 25)),
        ImageAssets.greenMarker);
    final GeoPoint intialPostion =
        GeoPoint(position.latitude, position.longitude);

// Center of the geo query.
    late final GeoFirePoint center = GeoFirePoint(intialPostion);

// Detection range from the center point.
    double radiusInKm = radius;

// Field name of Cloud Firestore documents where the geohash is saved.
    String field = 'g';

//user data from database

// Streamed document snapshots of geo query under given conditions.
    late final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
        GeoCollectionReference<Map<String, dynamic>>(chargersReference)
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
        var geoPoint = (data['g'] as Map<String, dynamic>)['geopoint'];
        var geohash = (data['g'] as Map<String, dynamic>)['geohash'];
        var stnName = (data['info'] as Map<String, dynamic>)['stationName'];
        var stnAddress = (data['info'] as Map<String, dynamic>)['address'];
        var stnImgUrl = (data['info'] as Map<String, dynamic>)['imageUrl'];
        var stateName = (data['info'] as Map<String, dynamic>)['state'];
        var startTime = (data['info'] as Map<String, dynamic>)['start'];
        var endTime = (data['info'] as Map<String, dynamic>)['end'];
        var chargerType = (data['info'] as Map<String, dynamic>)['chargerType'];
        var amenities = (data['info'] as Map<String, dynamic>)['amenities'];
        var hostName = (data['info'] as Map<String, dynamic>)['hostName'];

        // DateTime? endTime =
        //     (data['info'] as Map<String, dynamic>)['availability']['end'];
        print(data);
        if (geoPoint != null &&
            geohash != null &&
            stnName != null &&
            stnAddress != null &&
            // stnImgUrl != null &&
            stateName != null &&
            startTime != null &&
            endTime != null &&
            chargerType != null &&
            amenities != null &&
            hostName != null) {
          geoPoint = geoPoint as GeoPoint;
          geohash = geohash as String;
          stnName = stnName as String;
          stnAddress = stnAddress as String;
          stnImgUrl = stnImgUrl as List<dynamic>;
          stateName = stateName as String;
          startTime = startTime as int;
          endTime = endTime as int;
          chargerType = chargerType as String;

          amenities = amenities as String;

          hostName = hostName as String;
          print('****');
          print(data);
          print('------');
          _markers.add(Marker(
              markerId: MarkerId(geohash),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              onTap: () {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(geoPoint.latitude, geoPoint.longitude),
                        zoom: 16)));
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.amber.withOpacity(0.0),
                  builder: (context) {
                    double price =
                        mypricing.fullChargeCost(batteryCap, stateName);
                    return CustomMarkerPopup(
                        stationName: stnName,
                        address: stnAddress,
                        imageUrl: stnImgUrl,
                        geopoint: geoPoint,
                        geohash: geohash,
                        costOfFullCharge: price,
                        chargerType: chargerType,
                        amenities: amenities,
                        hostName: hostName,
                        startTime: startTime.toString(),
                        endTime: endTime.toString(),
                        chargerId: ds.id,
                        providerId: data['uid']);
                  },
                );
              },
              icon: BitmapDescriptor.fromBytes(GreenmarkerIcon)));

          setState(() {});
        }
      }
    });
  }

  // String getAddressState(String address) {
  //   String addState = "";
  //   for (int i = address.length - 1; i >= 0; i--) {
  //     if (address[i] == ' ') {
  //       return addState;
  //     }
  //     addState = address[i] + addState;
  //   }
  //   return addState;
  // }

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

  void updatePlaceCamera(Position currentPosition) {
    _markers.clear();
    if (_mapController != null) {
      setIntialMarkers(
          4, LatLng(currentPosition.latitude, currentPosition.longitude));
      setState(() {
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 10)));
      });
    }

    // _kGooglePlex = CameraPosition(
    //   target: LatLng(currentPosition.latitude,currentPosition.longitude),
    //   zoom: 16.60,
    // );
  }

  void updateCameraPosition(Position _currentPosition) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(ImageAssets.blackMarker);
    if (_currentPosition != null) {
      setIntialMarkers(
          1.2, LatLng(_currentPosition.latitude, _currentPosition.longitude));

      _kGooglePlex = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 16.60,
      );
      updateMarkers(markerIcon);
      // BitmapDescriptor currentLocationMarker =
      //     await BitmapDescriptor.fromAssetImage(
      //         const ImageConfiguration(
      //             devicePixelRatio: 1.5), // size: Size(25, 25)),
      //         ImageAssets.blackMarker);
    }
  }

  void updateMarkers(Uint8List markerIcon) {
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('Home'),
          infoWindow: InfoWindow(
            title: "You are here!",
            snippet:
                '${_currentPosition.latitude},${_currentPosition.longitude}',
          ),
          position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
          icon: BitmapDescriptor.fromBytes(markerIcon)));

      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    });
  }

  Future<DataSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseDatabase.instance.ref().child('Chargers').get();
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
              return WillPopScope(
                  onWillPop: _onBackPressed,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        const GFLoader(type: GFLoaderType.circle),
                        GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition.latitude,
                                _currentPosition.longitude),
                            zoom: 16.0,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            updateCameraPosition(_currentPosition);
                            _controller.complete(controller);
                          },
                          markers: Set<Marker>.of(_markers),
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.065),
                          child: SearchWidget(updatePlaceCamera),
                        ),
                      ],
                    ),
                  ));
            }));
  }

  Future<bool> _onBackPressed() async {
    exit(0);
  }
}
