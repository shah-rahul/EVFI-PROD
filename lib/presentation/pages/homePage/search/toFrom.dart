import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/presentation/resources/color_manager.dart';
import '/presentation/resources/routes_manager.dart';
import '../home.dart';

class ToFrom extends StatefulWidget {
  const ToFrom({Key? key}) : super(key: key);

  @override
  State<ToFrom> createState() => _ToFromState();
}

class _ToFromState extends State<ToFrom> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  List<LatLng> routpoints = [];

  @override
  void initState() {
    super.initState();

    controller1.addListener(() {
      setState(() {});
    });
    controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    TextField t1 = TextField(
      controller: controller1,
      style: TextStyle(color: ColorManager.appBlack),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: 'Choose start location',
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: controller1.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                onPressed: () => controller1.clear(),
                icon: const Icon(
                  Icons.close,
                ),
              ),
        border: const OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.done,
    );
    TextField t2 = TextField(
      controller: controller2,
      style: TextStyle(color: ColorManager.appBlack),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: 'Choose destination',
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: controller2.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                onPressed: () => controller2.clear(),
                icon: const Icon(
                  Icons.close,
                ),
              ),
        border: const OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.done,
    );

    void swap() {
      String tempController = controller1.text;
      controller1.text = controller2.text;
      controller2.text = tempController;
      setState(() {});
    }

    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.15,
                    child: IconButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, Routes.mainRoute),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      color: ColorManager.appBlack,
                    ),
                  ),
                  if (mq.orientation == Orientation.portrait)
                    Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.10, //1
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.circle_outlined,
                                  color: Colors.black, size: 20),
                              const Icon(
                                Icons.more_vert,
                                size: 34,
                                color: Colors.grey,
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                color: ColorManager.error,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: constraints.maxWidth * 0.59, //2
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                t1,
                                SizedBox(
                                  height: constraints.maxHeight * 0.06,
                                ),
                                t2,
                              ],
                            )),
                        SizedBox(
                          width: constraints.maxWidth * 0.01,
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.15,
                          child: Center(
                            child: IconButton(
                              onPressed: () => swap(),
                              icon: const Icon(
                                Icons.swap_vert,
                                size: 33,
                              ),
                              color: ColorManager.appBlack,
                            ),
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.35,
                          padding: EdgeInsets.only(
                              bottom: constraints.maxHeight * 0.1),
                          child: t1,
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.1,
                          child: Center(
                            child: IconButton(
                              onPressed: () => swap(),
                              icon: const Icon(
                                Icons.swap_horiz,
                                size: 33,
                              ),
                              color: ColorManager.appBlack,
                            ),
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.35,
                          padding: EdgeInsets.only(
                              bottom: constraints.maxHeight * 0.1),
                          child: t2,
                        ),
                        SizedBox(width: constraints.maxWidth * 0.04),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                  ),
                  child: const Text(
                    'Go',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () async {
                    List<Location> start_l =
                        await locationFromAddress(controller1.text);
                    List<Location> end_l =
                        await locationFromAddress(controller2.text);

                    var v1 = start_l[0].latitude;
                    var v2 = start_l[0].longitude;
                    var v3 = end_l[0].latitude;
                    var v4 = end_l[0].longitude;

                    var url = Uri.parse(
                        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                    var response = await http.get(url);

                    setState(() {
                      routpoints = [];
                      var ruter = jsonDecode(response.body)['routes'][0]
                          ['geometry']['coordinates'];
                      for (int i = 0; i < ruter.length; i++) {
                        var reep = ruter[i].toString();
                        reep = reep.replaceAll("[", "");
                        reep = reep.replaceAll("]", "");
                        var lat1 = reep.split(',');
                        var long1 = reep.split(",");
                        routpoints.add(LatLng(
                            double.parse(lat1[1]), double.parse(long1[0])));
                      }
                      print(routpoints);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            routeSet: routpoints,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.08),
          ],
        );
      },
    );
  }
}