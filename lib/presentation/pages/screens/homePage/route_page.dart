import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../resources/assets_manager.dart';
import '../../../resources/color_manager.dart';

class RouteMap extends StatefulWidget {
  final LatLng startL, endL;
  const RouteMap({Key? key, required this.startL, required this.endL})
      : super(key: key);

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
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
      });
    } on Exception catch (e) {
      print(e);
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
      _isLoading = false;
    });
  }
}
