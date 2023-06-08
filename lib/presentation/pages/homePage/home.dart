import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';

class Home extends StatefulWidget {
  List<LatLng> routeSet;
  Home({
    Key? key,
    required this.routeSet
    }): super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Polyline> polylines = {};
  LatLng? initialCoordinate, finalCoordinate;
  Marker? sourceMarker, destMarker;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6001740, 77.2105709),
    zoom: 17.537, //14.4746,
    tilt: 18,
  );

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
    });
  }

  @override
  void initState() {
    super.initState();
    updatePolyline(widget.routeSet);

    if (widget.routeSet.isNotEmpty) {
      initialCoordinate = widget.routeSet[0]; // Set initial coordinate of camera view for polyline
      sourceMarker = Marker(
        markerId: const MarkerId('sourceMarker'),
        position: initialCoordinate!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      finalCoordinate = widget.routeSet[widget.routeSet.length - 1]; 
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
          child: Stack(
            children: [
              const GFLoader(type: GFLoaderType.circle),
              GoogleMap(
                mapType: MapType.normal,
                markers: (widget.routeSet.isNotEmpty)
                    ? {sourceMarker!, destMarker!}
                    : {},
                initialCameraPosition: (initialCoordinate != null)
                    ? CameraPosition(
                        target: initialCoordinate!, zoom: 27.845, tilt: 18)
                    : _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: polylines,
                zoomControlsEnabled: true,
                compassEnabled: false,
                // mapToolbarEnabled: false,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.searchBarRoute);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.072,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.appBlack,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bolt_outlined,
                          color: ColorManager.primary,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Search evfi',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.search_rounded, color: ColorManager.primary)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
