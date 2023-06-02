import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(29.969390, 76.844990),
    zoom: 14.4746,
    tilt: 20,
  );

  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.lightGrey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              GFLoader(type: GFLoaderType.circle),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                zoomControlsEnabled: false,
                compassEnabled: false,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.072),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.searchBarRoute);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.072,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Search evfi',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.search_rounded,
                            color: ColorManager.primary)
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