import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:async';
import './home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import 'package:rxdart/rxdart.dart';
import '../../../geohash/encode_geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../../resources/assets_manager.dart';
import '../../../resources/color_manager.dart';

class RouteMap extends StatefulWidget {
  final LatLng startL, endL;

  RouteMap({Key? myKey, required this.startL, required this.endL})
      : super(key: myKey);

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  GlobalKey<HomeState> myKey = GlobalKey();
  late GoogleMapController _googleMapController;
  List<LatLng> routpoints = [];
  Set<Polyline> polylines = {};
  final Set<Marker> _markers = {};
  bool _isLoading = false;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(28.6001740, 77.2105709),
    zoom: 13.437, //14.4746,
  );

  void addMarker(String title, LatLng coordinates,
      {required BitmapDescriptor mapIcon}) {
    _markers.add(Marker(
      markerId: MarkerId(title),
      position: coordinates,
      icon: mapIcon,
      infoWindow: InfoWindow(
        title: '$title Location',
        snippet: '${coordinates.latitude} ${coordinates.longitude}',
      ),
    ));
  }

  Widget _buildBackKey() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.065,
      left: 15,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.darkPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.appBlack,
              size: 33,
            ),
            highlightColor: ColorManager.primary,
            splashColor: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          )),
    );
  }

  //to implement dispose
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightGrey,
      body:
          // Visibility(
          //     visible: _isLoading,
          //     replacement:
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(children: [
                const GFLoader(
                  type: GFLoaderType.circle,
                ),
                GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  cameraTargetBounds: CameraTargetBounds.unbounded,
                  initialCameraPosition: _initialCameraPosition,
                  polylines: polylines,
                  onMapCreated: _onMapCreated,
                  zoomControlsEnabled: true,
                  compassEnabled: false,
                  myLocationButtonEnabled: false,
                  rotateGesturesEnabled: false,
                ),
                _buildBackKey(),
              ])),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    var v1 = widget.startL.latitude;
    var v2 = widget.startL.longitude;
    var v3 = widget.endL.latitude;
    var v4 = widget.endL.longitude;

    BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5), // size: Size(25, 25)),
        ImageAssets.mapSourceMarker);
    BitmapDescriptor destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5), // size: Size(3, 4)),
        ImageAssets.mapDestinationMarker);

    try {
      var url = Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
      var response = await http.get(url);

      setState(() {
        _isLoading = true;
        addMarker(
          'Source',
          widget.startL,
          mapIcon: sourceIcon,
        );
        addMarker(
          'Destination',
          widget.endL,
          mapIcon: destinationIcon,
        );

        routpoints = [];
        _isLoading = true;
        var ruter =
            jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
        for (int i = 0; i < ruter.length; i++) {
          var reep = ruter[i].toString();
          reep = reep.replaceAll("[", "");
          reep = reep.replaceAll("]", "");
          var lat1 = reep.split(',');
          var long1 = reep.split(",");
          routpoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
        }

        _googleMapController = controller;
        setPolylines(routpoints).then((_) => _setMapFitToScreen(polylines));
        _showRouteMarkers(routpoints);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void setRouteMarker(double radius, LatLng position) {
    final GeoPoint intialPostion =
        GeoPoint(position.latitude, position.longitude);

// Center of the geo query.
    late final GeoFirePoint center = GeoFirePoint(intialPostion);

// Detection range from the center point.
    double radiusInKm = radius;

// Field name of Cloud Firestore documents where the geohash is saved.
    String field = 'geo';

    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('Markers');

    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

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

        print(geoPoint.latitude);
        _markers.add(Marker(
            markerId: MarkerId(geohash),
            position: LatLng(geoPoint.latitude, geoPoint.longitude)));
      }
      setState(() {});
    });
  }

  void _showRouteMarkers(List<LatLng> polylineCoordinates) {
    polylineCoordinates.forEach((pos) {
      setRouteMarker(1.2, pos);
    });
  }

  void _setMapFitToScreen(Set<Polyline> p) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;

    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });
    _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        60));
  }

  setPolylines(List<LatLng> polylineCoordinates) async {
    print(polylineCoordinates);
    PolylineId polylineId = const PolylineId('polyline to set route');
    Polyline polyline = Polyline(
      polylineId: polylineId,
      points: polylineCoordinates,
      color: Colors.black,
      width: 7,
    );

    setState(() {
      polylines.add(polyline);
      _isLoading = false;
    });
  }
}

// Detection range from the center point.


//   final _geoQueryCondition = BehaviorSubject<_GeoQueryCondition>.seeded(
//     _GeoQueryCondition(
//       radiusInKm: _initialRadiusInKm,
//       cameraPosition: _initialCameraPosition,
//     ),
//   );

//   /// [Stream] of geo query result.
//   late final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> _stream =
//       _geoQueryCondition.switchMap(
//     (geoQueryCondition) =>
//         GeoCollectionReference(_collectionReference).subscribeWithin(
//       center: GeoFirePoint(
//         GeoPoint(
//           _cameraPosition.target.latitude,
//           _cameraPosition.target.longitude,
//         ),
//       ),
//       radiusInKm: geoQueryCondition.radiusInKm,
//       field: 'geo',
//       geopointFrom: (data) =>
//           (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
//       strictMode: true,
//     ),
//   );

//   /// Updates [_markers] by fetched geo [DocumentSnapshot]s.
//   void _updateMarkersByDocumentSnapshots(
//     List<DocumentSnapshot<Map<String, dynamic>>> documentSnapshots,
//   ) {
//     final markers = <Marker>{};
//     for (final ds in documentSnapshots) {
//       final id = ds.id;
//       final data = ds.data();
//       if (data == null) {
//         continue;
//       }
//       final name = data['name'] as String;
//       final geoPoint =
//           (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
//       markers.add(_createMarker(id: id, name: name, geoPoint: geoPoint));
//     }
//     debugPrint('📍 markers count: ${markers.length}');
//     print(markers);
//   }
// }

// /// Creates a [Marker] by fetched geo location.
// Marker _createMarker({
//   required String id,
//   required String name,
//   required GeoPoint geoPoint,
// }) =>
//     Marker(
//         markerId: MarkerId('(${geoPoint.latitude}, ${geoPoint.longitude})'),
//         position: LatLng(geoPoint.latitude, geoPoint.longitude),
//         infoWindow: InfoWindow(title: name),
//         onTap: () {});

// /// Current detecting radius in kilometers.
// double _radiusInKm = 5;

// /// Current camera position on Google Maps.
// CameraPosition get _cameraPosition =>
//     CameraPosition(target: LatLng(29.450206, 76.961648));

// /// Initial geo query detection radius in km.
// const double _initialRadiusInKm = 2;

// final _collectionReference = FirebaseFirestore.instance.collection('locations');

/// Geo query geoQueryCondition.

//   final geo = Geofire();
// final CollectionReference markersCollection = FirebaseFirestore.instance.collection('markers');

//   void _queryMarkersNearPolyline() {
//   GeoFirePoint center = geo.point(latitude: _polylinePoints[0].latitude, longitude: _polylinePoints[0].longitude);

//   double radius = _calculateSearchRadius(); // Adjust this based on your desired search radius

//   Stream<List<DocumentSnapshot>> stream = geo
//       .collection(collectionRef: markersCollection)
//       .within(center: center, radius: radius, field: 'location');

//   stream.listen((List<DocumentSnapshot> documentList) {
//     setState(() {
//       _markers.clear();
//       for (DocumentSnapshot document in documentList) {
//         double markerLat = document.data()['latitude'];
//         double markerLng = document.data()['longitude'];

//         LatLng markerLatLng = LatLng(markerLat, markerLng);

//         if (isMarkerNearPolyline(markerLatLng)) {
//           _markers.add(
//             Marker(
//               markerId: MarkerId(document.id),
//               position: markerLatLng,
//               infoWindow: InfoWindow(title: document.data()['title']),
//             ),
//           );
//         }
//       }
//     });
//   });
// }

//   List<Map<String,dynamic>> getMarkersNearPolyline() {
//     LatLng start = widget.startL;
//     LatLng end = widget.endL;
//      List<Map<String, dynamic>> markersCollection = [{"geohash":,"point":{"28.557420, 75.636319"}},
//     {"geohash":,"point":{"29.450206, 76.961648"}},
//     {"geohash":,"point":{"29.007680, 77.083429"}},
//     {"geohash":,"point":{"29.309791, 76.971259"}},
//     {"geohash":,"point":{"29.481869, 76.949713"}},
//     {"geohash":,"point":{"29.552411, 76.982979"}},
//     {"geohash":,"point":{"29.751854, 77.687406"}},
//     {"geohash":,"point":{"29.953732, 77.026364"}},
//     {"geohash":,"point":{"29.912647, 76.128156"}}

//     ];
//     const double tolerance = 1000; // Adjust this value as needed (in meters)

//     // Convert the polyline route into line segments
//     List<LatLng> polylineSegments = routpoints;

//     // Create a set to store the nearby markers (to avoid duplicates)
//     Set<Map<String,dynamic>> nearbyMarkers = {};

//     // Iterate through each line segment
//     for (LatLng segmentStart in polylineSegments) {
//       LatLng segmentEnd =
//           polylineSegments[polylineSegments.indexOf(segmentStart) + 1];

//       // Calculate the geohashes for the start and end points of the line segment
//       String startGeohash =
//           calculateGeohash(segmentStart.latitude, segmentStart.longitude);
//       String endGeohash =
//           calculateGeohash(segmentEnd.latitude, segmentEnd.longitude);

//       // Filter markers that are within the geohash range and close to the line segment
//       List<Map<String,dynamic>> segmentMarkers = markersCollection.where((marker) {
//         String markerGeohash = marker['geohash'];
//         return (markerGeohash.compareTo(startGeohash) >= 0 &&
//                 markerGeohash.compareTo(endGeohash) <= 0) &&
//             isMarkerNearPolyline(marker['point'], segmentStart, segmentEnd, tolerance);
//       }).toList();

//       nearbyMarkers.addAll(segmentMarkers);
//     }

//     return nearbyMarkers.toList();
//   }

//   bool isMarkerNearPolyline(
//       Marker marker, LatLng segmentStart, LatLng segmentEnd, double tolerance) {
//     double distance =
//         distanceToPolyline(marker.position, segmentStart, segmentEnd);
//     return distance <= tolerance;
//   }

//   double distanceToPolyline(LatLng point, LatLng lineStart, LatLng lineEnd) {
//   num segmentLengthSq = pow(lineEnd.latitude - lineStart.latitude, 2) +
//       pow(lineEnd.longitude - lineStart.longitude, 2);
//   double dotProduct = ((point.latitude - lineStart.latitude) * (lineEnd.latitude - lineStart.latitude)) +
//       ((point.longitude - lineStart.longitude) * (lineEnd.longitude - lineStart.longitude));
//   double t = max(0, min(1, dotProduct / segmentLengthSq));
//   double closestPointLatitude = lineStart.latitude + t * (lineEnd.latitude - lineStart.latitude);
//   double closestPointLongitude = lineStart.longitude + t * (lineEnd.longitude - lineStart.longitude);
//   num distanceSq = pow(point.latitude - closestPointLatitude, 2) +
//       pow(point.longitude - closestPointLongitude, 2);
//   return sqrt(distanceSq);
// }

// List<LatLng> getPolylineSegments(LatLng start, LatLng end) {
  // Convert the polyline route into line segments
  // You can implement your logic to divide the route into segments
  // For simplicity, this example assumes a single line segment between start and end points
//   return [start, end];
// }

// String calculateGeohash(double latitude, double longitude) {
//   // Implement your geohash calculation logic here
//   // You can use libraries like 'geohash' or 'geohash2' to calculate the geohash
//   // Example using the 'geohash' package:
//   GeoHasher geoHasher = GeoHasher();
//   return geoHasher.encode(latitude,longitude,precision: 5);
//   return encodeGeohash(latitude, longitude);
// }
// Your list of markers


  // void _queryMarkersNearPolyline() {
  //   List<Map<String, dynamic>> markersCollection = [{"geohash":,"point":{"28.557420, 75.636319"}},
  //   {"geohash":,"point":{"29.450206, 76.961648"}},
  //   {"geohash":,"point":{"29.007680, 77.083429"}},
  //   {"geohash":,"point":{"29.309791, 76.971259"}},
  //   {"geohash":,"point":{"29.481869, 76.949713"}},
  //   {"geohash":,"point":{"29.552411, 76.982979"}},
  //   {"geohash":,"point":{"29.751854, 77.687406"}},
  //   {"geohash":,"point":{"29.953732, 77.026364"}},
  //   {"geohash":,"point":{"29.912647, 76.128156"}}

      
  //   ];
 