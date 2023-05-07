import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../resources/color_manager.dart';

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
              Positioned(
                  top: 20,
                  left: 0.01,
                  right: 12,
                  child: GFSearchBar(
                    textColor: Colors.white70,
                    searchList: list,
                    searchBoxInputDecoration: InputDecoration(
                      filled: true,
                      fillColor: ColorManager.appBlack,
                      labelText: 'Search here...',
                      icon: Container(
                        width: 42,
                        height: 42,
                        child: GFBorder(
                          padding: EdgeInsets.all(1),
                          strokeWidth: 3,
                          color: ColorManager.primary,
                          dashedLine: [2, 0],
                          type: GFBorderType.circle,
                          radius: Radius.circular(100),
                          child: Image.asset(
                            'assets/images/lightning_icon.png',
                            height: 35,
                            color: ColorManager.primary,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    searchQueryBuilder: (query, list) {
                      return list
                          .where((item) => item
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                    },
                    overlaySearchListItemBuilder: (item) {
                      return Container(
                        margin: EdgeInsets.only(top: 30),
                        //padding: const EdgeInsets.all(8),
                        //height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)*0,
                        child: Text(
                          "${item}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                    onItemSelected: (item) {
                      setState(() => print('$item'));
                    },
                  )),
            ],
          ),
        ));
  }
}
