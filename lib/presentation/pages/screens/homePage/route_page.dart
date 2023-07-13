import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:EVFI/presentation/pages/screens/homePage/marker_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/encode_geohash.dart';
import 'package:dart_geohash/dart_geohash.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/color_manager.dart';
import './home.dart';

class RouteMap extends StatefulWidget {
  final LatLng startL, endL;

  RouteMap({Key? myKey, required this.startL, required this.endL})
      : super(key: myKey);

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> with TickerProviderStateMixin {
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
        snippet: '${coordinates.latitude}, ${coordinates.longitude}',
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

  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 80);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  late Uint8List routeMarker;
  void _onMapCreated(GoogleMapController controller) async {
    var v1 = widget.startL.latitude;
    var v2 = widget.startL.longitude;
    var v3 = widget.endL.latitude;
    var v4 = widget.endL.longitude;
    // final Uint8List sourceIcon =
    //     await getBytesFromAsset(ImageAssets.mapSourceMarker);
    // final Uint8List destinationIcon =
    //     await getBytesFromAsset(ImageAssets.mapDestinationMarker);
    routeMarker = await getBytesFromAsset(ImageAssets.GreenMarker);
    final BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, ImageAssets.mapSourceMarker);
    final BitmapDescriptor destinationIcon =
        await BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, ImageAssets.mapDestinationMarker);

    try {
      var url = Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
      var response = await http.get(url);

      _isLoading = true;
      addMarker('Source', widget.startL, mapIcon: sourceIcon);
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

      _showRouteMarkers(routpoints);

      setPolylines(routpoints).then((_) => _setMapFitToScreen(polylines));
    } on Exception catch (e) {
      print(e);
    }
  }

  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('Markers');

  GeoPoint geopointFrom(Map<String, dynamic> data) =>
      (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
  void setRouteMarker(double radius, LatLng position) {
    final GeoPoint intialPostion =
        GeoPoint(position.latitude, position.longitude);

// Center of the geo query.
    late final GeoFirePoint center = GeoFirePoint(intialPostion);

// Detection range from the center point.
    double radiusInKm = radius;

// Field name of Cloud Firestore documents where the geohash is saved.
    String field = 'geo';

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
            onTap: () {
              _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(geoPoint.latitude, geoPoint.longitude),
                      zoom: 13)));
              showModalBottomSheet(
                context: context,
                //isScrollControlled: true,
                transitionAnimationController: AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 400)),
                backgroundColor: Colors.amber.withOpacity(0.0),
                builder: (context) {
                  return CustomMarkerPopup(
                      geopoint: geoPoint, geohash: geohash);
                },
              );
            },
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
            icon: BitmapDescriptor.fromBytes(routeMarker)));
      }
      setState(() {});
    });
  }

  void _showRouteMarkers(List<LatLng> polylineCoordinates) {
    print(polylineCoordinates.length);
    for (var pos = 0; pos < polylineCoordinates.length; pos += 20) {
      setRouteMarker(4, polylineCoordinates[pos]);
    }
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
    });
  }
}
