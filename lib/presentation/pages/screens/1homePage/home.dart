//ignore_for_file: unused_local_variable, unnecessary_null_comparison, non_constant_identifier_names, unnecessary_import, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:evfi/domain/cachedChargers.dart';
import 'package:evfi/domain/chargers.dart';
import 'package:evfi/presentation/pages/widgets/ProgressWidget.dart';
import 'package:evfi/presentation/storage/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final List<Marker> _markers = <Marker>[];
  List<dynamic> _userBookings = [];
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
  var userData;
  double batteryCap = 0;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;
  void getUserData() async {
    Provider.of<UserDataProvider>(context, listen: false)
        .intialiseUserDataFromFireBase();
    print(userData);
  }

  // void getBatteryCap()async{
  //   CollectionReference _usersCollection =
  //     FirebaseFirestore.instance.collection('user');
  //    User? user = FirebaseAuth.instance.currentUser;
  //     DocumentSnapshot<Object?> snapshot =
  //         await _usersCollection.doc(user?.uid).get();
  //     Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

  // }
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getUserData();
    getBatteryCap().then((val) => batteryCap = val);

    getUserBookings();
     Timer.periodic(Duration(minutes: 2), (timer) {
      checkIfAnyBookingCompleted();
    });
  }

  late CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(28.679079, 77.069710),
    zoom: 13.4746,
    tilt: 15,
  );

  final currentUserUID = FirebaseAuth.instance.currentUser?.uid;
  // Future<Map<String, dynamic>> getUserSnapShot() async {
  //   DocumentReference querySnapshot =
  //       await UserChargingReference.doc(currentUserUID);
  //   DocumentSnapshot documentSnapshot = await querySnapshot.get();
  //   Map<String, dynamic> detailsMap = {};
  //   if (documentSnapshot.exists && documentSnapshot != null) {
  //     // Access the value of the "level2" field
  //     dynamic level2Value = documentSnapshot.data();
  //     level2Value = level2Value['level2'];
  //     detailsMap = level2Value as Map<String, dynamic>;
  //     print("Value of level2 field: $level2Value");
  //   } else {
  //     print("Document does not exist or does not contain the 'level2' field.");
  //   }
  //   // final allData = querySnapshot.docs.map((doc) => doc.data());

  //   // if (querySnapshot.docs.isNotEmpty) {
  //   //   // Loop through the documents in the collection
  //   //   for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //   //     detailsMap = documentSnapshot.data() as Map<String, dynamic>;

  //   //     if (detailsMap != null) {
  //   //       // print(detailsMap['pinCode']);
  //   //       if (currentUserUID == detailsMap['uid']) {
  //   //         return detailsMap;
  //   //       }
  //   //     }
  //   //   }
  //   // }
  //   return detailsMap;
  // }

  void checkIfAnyBookingCompleted() async {
    List<int> timeSlots = [];
    DateTime now = DateTime.now();

    int hour = now.hour;
    int minute = now.minute;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('booking')
        .where('status', isEqualTo: 1)
        .get();
    for (var bookingDoc in querySnapshot.docs) {
      Map<String, dynamic> bookingData = bookingDoc.data();

      DateTime startTime =
          DateTime(now.year, now.month, now.day, bookingData['timeSlot'], 0);
      DateTime endTime = startTime.add(Duration(hours: 1));
      print(startTime);
      print(endTime);
      // Check if current time is between start and end times
      if (now.isAfter(endTime)) {
        FirebaseFirestore.instance
            .collection('booking')
            .doc(bookingData['bookingId'])
            .update({'status': 3});
      }
    }

    for (int i = 0; i < _userBookings.length; i++) {
      DocumentSnapshot snapshot = await getBookingById(_userBookings[i]);

      if (snapshot.exists && snapshot.data() != null) {
        dynamic data = snapshot.data();
        int res =
            await getTimeSlotByBookingId(_userBookings[i], data['chargerId']);

        if (res != 0) timeSlots.add(res);
      }
    }
    dynamic res = ifTimeSlotsValid(timeSlots);
    if (res) {
      print('trigger form');
    } else {
      print('no booking complete yet');
    }
  }

  Future<DocumentSnapshot<Object?>> getBookingById(String bookingId) async {
    DocumentReference<Map<String, dynamic>>? bookingData =
        FirebaseFirestore.instance.collection('booking').doc(bookingId);
    DocumentSnapshot snapshot = await bookingData.get();
    return snapshot;
  }

  Future<int> getTimeSlotByBookingId(String bookingId, String chargerId) async {
    DocumentSnapshot snapshot = await getBookingById(bookingId);
    if (snapshot.exists && snapshot != null) {
      dynamic data = snapshot.data();
      print(data);
      print(chargerId);
      print('******');
      if (chargerId == data['chargerId'] && data['status'] == 1) {
        return data['timeSlot'];
      }
    }
    return 0;
  }

  void getUserBookings() async {
    DocumentSnapshot<Object?> snapshot =
        await _usersCollection.doc(user?.uid).get();
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    dynamic _bookings = snapshot['bookings'];
    print(_bookings);
    _userBookings = _bookings;
  }

  Future<dynamic> ifChargerBookingInProgress(
      String chargerId, List<dynamic> userBookings) async {
    List<int> timeSlots = [];
    print(userBookings);
    for (int i = 0; i < userBookings.length; i++) {
      int res = await getTimeSlotByBookingId(userBookings[i], chargerId);

      print(res);
      if (res != 0) timeSlots.add(res);
    }

    return ifTimeSlotsValid(timeSlots);
  }

  dynamic ifTimeSlotsValid(List<int> timeSlots) {
    for (int i = 0; i < timeSlots.length; i++) {
      DateTime now = DateTime.now();

      int hour = now.hour;
      int minute = now.minute;
      DateTime startTime =
          DateTime(now.year, now.month, now.day, timeSlots[i], 0);
      DateTime endTime = startTime.add(Duration(hours: 1));
      print(startTime);
      print(endTime);
      // Check if current time is between start and end times
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        return [startTime, endTime];
      }
    }
    return false;
  }

  Future<double> getBatteryCap() async {
    DocumentSnapshot<Object?> snapshot =
        await _usersCollection.doc(user?.uid).get();
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    dynamic level2 = snapshot['level2'];

    if (level2 != null && level2 != false) {
      String batteryCapacity = level2['batteryCapacity'];
      return (double.parse(batteryCapacity));
    }
    return 0;
  }

  void _getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

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
      await Geolocator.requestPermission();
      await prefs.setBool('location_permission_requested', true);
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
    final Uint8List RedDisabledChargerMarker =
        await getBytesFromAsset(ImageAssets.redDisabledChargerMarker);
    BitmapDescriptor nearbyMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5), // size: Size(25, 25)),
        ImageAssets.greenMarker);
    final GeoPoint intialPostion =
        GeoPoint(position.latitude, position.longitude);
//get user bookings
    getUserBookings();
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
        var timeslot = data['timeSlot'];
        var chargerType = (data['info'] as Map<String, dynamic>)['chargerType'];
        var amenities = (data['info'] as Map<String, dynamic>)['amenities'];
        var hostName = (data['info'] as Map<String, dynamic>)['hostName'];
        var status = (data['info'] as Map<String, dynamic>)['status'];

        // DateTime? endTime =
        //     (data['info'] as Map<String, dynamic>)['availability']['end'];

        if (geoPoint != null &&
            geohash != null &&
            stnName != null &&
            stnAddress != null &&
            // stnImgUrl != null &&
            stateName != null &&
            startTime != null &&
            endTime != null &&
            timeslot != null &&
            chargerType != null &&
            amenities != null &&
            hostName != null &&
            status != null) {
          geoPoint = geoPoint as GeoPoint;
          geohash = geohash as String;
          stnName = stnName as String;
          stnAddress = stnAddress as String;
          stnImgUrl = stnImgUrl as List<dynamic>;
          stateName = stateName as String;
          startTime = startTime as int;
          endTime = endTime as int;
          timeslot = timeslot as int;
          chargerType = chargerType as String;
          amenities = amenities as String;
          status = status as num;
          hostName = hostName as String;

          final charger = ChargerModel(data: data);

          cachedChargersBox.add(charger);
          _markers.add(Marker(
              markerId: MarkerId(geohash),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              onTap: () async {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(geoPoint.latitude, geoPoint.longitude),
                        zoom: 16)));
                dynamic res = await ifChargerBookingInProgress(
                    data['chargerId'], _userBookings);

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor:
                      const ui.Color.fromRGBO(255, 193, 7, 1).withOpacity(0.0),
                  builder: (context) {
                    print(batteryCap);
                   
                    int price = mypricing.fullChargeCost(chargerType, stateName);
                    print("price is:");
                    print(price);
                    if (res != false) {
                      print(res);
                      return ProgressWidget(res[0], res[1]);
                    }
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
                      startTime: startTime,
                      endTime: endTime,
                      timeslot: timeslot,
                      chargerId: ds.id,
                      providerId: data['uid'],
                      status: status,
                    );
                  },
                );
              },
              icon: BitmapDescriptor.fromBytes(
                  (status == 1) ? GreenmarkerIcon : RedDisabledChargerMarker)));

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

  void addCachedChargersToMarkers() async {
    final Uint8List GreenmarkerIcon =
        await getBytesFromAsset(ImageAssets.greenMarker);
    final Uint8List RedDisabledChargerMarker =
        await getBytesFromAsset(ImageAssets.redDisabledChargerMarker);
    _markers.clear(); // Clear existing markers if needed

    for (var chargerModel in cachedChargersBox.values) {
      // Extract relevant data from ChargerModel

      var geoPoint =
          (chargerModel.data['g'] as Map<String, dynamic>)['geopoint'];
      var geohash = (chargerModel.data['g'] as Map<String, dynamic>)['geohash'];
      var stnName =
          (chargerModel.data['info'] as Map<String, dynamic>)['stationName'];
      var stnAddress =
          (chargerModel.data['info'] as Map<String, dynamic>)['address'];
      var stnImgUrl =
          (chargerModel.data['info'] as Map<String, dynamic>)['imageUrl'];
      var stateName =
          (chargerModel.data['info'] as Map<String, dynamic>)['state'];
      var startTime =
          (chargerModel.data['info'] as Map<String, dynamic>)['start'];
      var endTime = (chargerModel.data['info'] as Map<String, dynamic>)['end'];
      var timeslot = chargerModel.data['timeSlot'];
      var chargerType =
          (chargerModel.data['info'] as Map<String, dynamic>)['chargerType'];
      var amenities =
          (chargerModel.data['info'] as Map<String, dynamic>)['amenities'];
      var hostName =
          (chargerModel.data['info'] as Map<String, dynamic>)['hostName'];
      num status =
          (chargerModel.data['info'] as Map<String, dynamic>)['status'];
      String chargerId = chargerModel.data['chargerId'];
      String userId = chargerModel.data['uid'];

      // Create a Marker instance and add it to the _markers list
      Marker marker = Marker(
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
                int price = mypricing.fullChargeCost(batteryCap, stateName);
                print("price:");
                print(price);
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
                    startTime: startTime,
                    endTime: endTime,
                    timeslot: timeslot,
                    chargerId: chargerId,
                    providerId: userId,
                    status: status);
              },
            );
          },
          icon: BitmapDescriptor.fromBytes(
              (status == 1) ? GreenmarkerIcon : RedDisabledChargerMarker));

      setState(() {});

      _markers.add(marker);
    }
  }

  void updatePlaceCamera(Position currentPosition) {
    _markers.clear();
    if (_mapController != null) {
      if (cachedChargersBox.isNotEmpty) {
        debugPrint('@@@@@Already cached chargers available-------');
        addCachedChargersToMarkers();
      } else {
        debugPrint('@@@@@No cached chargers currently-------');
        setIntialMarkers(
            10, LatLng(currentPosition.latitude, currentPosition.longitude));
      }
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
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.14,
                          right: MediaQuery.of(context).size.height * 0.040,
                          child: FloatingActionButton(
                            onPressed: _getCurrentLocation,
                            backgroundColor: ColorManager.appBlack,
                            child: Icon(
                              Icons.my_location,
                              color: ColorManager.primary,
                            ),
                          ),
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
