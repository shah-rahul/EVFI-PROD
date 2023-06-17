import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/data_type.dart';
import '../../../resources/color_manager.dart';

class ResultMap extends StatefulWidget {
  final LatLong startL, endL;
  const ResultMap({Key? key, required this.startL, required this.endL})
      : super(key: key);

  @override
  State<ResultMap> createState() => _ResultMapState();
}

class _ResultMapState extends State<ResultMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  List<LatLng> routpoints = [LatLng(28.628117, 77.173563)];
  Set<Polyline> polylines = {};
  LatLng? initialCoordinate, finalCoordinate;
  //late Marker sourceMarker, destMarker;
  late LatLngBounds bounds;
  bool _isLoading = false;

  // void setMarkers(List<LatLng> routpoints) {
  //   setState(() {
  //     if (routpoints.isNotEmpty) {
  //       print('Calculate Markers');
  //       sourceMarker = Marker(
  //         markerId: const MarkerId('sourceMarker'),
  //         position: routpoints.first,
  //         icon:
  //             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  //       );
  //       destMarker = Marker(
  //         markerId: const MarkerId('_destMarker'),
  //         position: routpoints.last,
  //         icon: BitmapDescriptor.defaultMarker,
  //       );
  //     }
  //   });
  // }

  void _calculateRoute(var v1, var v2, var v3, var v4) async {
    try {
      var url = Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
      var response = await http.get(url);

      setState(() {
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
        //setMarkers(routpoints);
      });
    } on Exception catch (e) {
      print(e);
      print('Exception found!');
    }
    updatePolyline(routpoints);
  }

  void updatePolyline(List<LatLng> polylineCoordinates) {
    print('See Here');
    print(polylineCoordinates);

    PolylineId polylineId = const PolylineId('polyline_1');
    Polyline polyline = Polyline(
      polylineId: polylineId,
      points: polylineCoordinates,
      color: Colors.black,
      width: 7,
    );

    setState(() {
      polylines.add(polyline);

      double minLat = polyline.points[0].latitude;
      double maxLat = polyline.points[0].latitude;
      double minLng = polyline.points[0].longitude;
      double maxLng = polyline.points[0].longitude;

      for (var point in polyline.points) {
        minLat = min(minLat, point.latitude);
        maxLat = max(maxLat, point.latitude);
        minLng = min(minLng, point.longitude);
        maxLng = max(maxLng, point.longitude);
      }

      bounds = LatLngBounds(
        northeast: LatLng(maxLat, maxLng),
        southwest: LatLng(minLat, minLng),
      );
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    var v1 = widget.startL.latitude;
    var v2 = widget.startL.longitude;
    var v3 = widget.endL.latitude;
    var v4 = widget.endL.longitude;
    _calculateRoute(v1, v2, v3, v4);
  }

  Widget _buildBackKey() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      left: 15,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: ColorManager.appBlack,
              size: 23.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.lightGrey,
        body: Visibility(
          visible: _isLoading,
          child: const GFLoader(type: GFLoaderType.circle),
          replacement: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(children: [
                const GFLoader(type: GFLoaderType.circle),
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      controller.animateCamera(
                          CameraUpdate.newLatLngBounds(bounds, 60));
                    });
                  },
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                      markerId: const MarkerId('sourceMarker'),
                      position: routpoints.first,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure),
                    ),
                    Marker(
                      markerId: const MarkerId('_destMarker'),
                      position: routpoints.last,
                      icon: BitmapDescriptor.defaultMarker,
                    )
                  }, //{sourceMarker, destMarker},
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(28.6001740, 77.2105709),
                    zoom: 13.437, //14.4746,
                  ),
                  polylines: polylines,
                  zoomControlsEnabled: true,
                  compassEnabled: false,
                  myLocationButtonEnabled: false,
                ),
                _buildBackKey(),
              ])),
        ));
  }
}
