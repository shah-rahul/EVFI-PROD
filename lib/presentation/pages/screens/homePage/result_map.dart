import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../resources/color_manager.dart';

class ResultMap extends StatefulWidget {
  final List<LatLng> routeSet;
  const ResultMap({required this.routeSet});

  @override
  State<ResultMap> createState() => _ResultMapState();
}

class _ResultMapState extends State<ResultMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Polyline> polylines = {};
  LatLng? initialCoordinate, finalCoordinate;
  Marker? sourceMarker, destMarker;
  late LatLngBounds bounds;

  void updatePolyline(List<LatLng> polylineCoordinates) {
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
    });
  }

  @override
  void initState() {
    super.initState();
    updatePolyline(widget.routeSet);

    if (widget.routeSet.isNotEmpty) {
      initialCoordinate = widget
          .routeSet[0]; // Set initial coordinate of camera view for polyline
      sourceMarker = Marker(
        markerId: const MarkerId('sourceMarker'),
        position: initialCoordinate!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      finalCoordinate = widget.routeSet.last;
      destMarker = Marker(
        markerId: const MarkerId('_destMarker'),
        position: finalCoordinate!,
        icon: BitmapDescriptor.defaultMarker,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.lightGrey,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              const GFLoader(type: GFLoaderType.circle),
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {
                    controller
                      .animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
                  });
                },
                mapType: MapType.normal,
                markers: {sourceMarker!, destMarker!},
                initialCameraPosition: const CameraPosition(
                  target: LatLng(28.6001740, 77.2105709),
                  zoom: 13.537, //14.4746,
                ),
                polylines: polylines,
                zoomControlsEnabled: true,
                compassEnabled: false,
                myLocationEnabled: true,
              ),
              Positioned(
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
              )
            ])));
  }
}
