// ignore_for_file: deprecated_member_use, unused_catch_clause

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '/presentation/resources/color_manager.dart';
import '../../models/data_type.dart';
import './route_page.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/encode_geohash.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final startFocusNode = FocusNode();
  final endFocusNode = FocusNode();
  Timer? _debounce;
  List<OSMdata> _options = <OSMdata>[];
  late LatLng start = const LatLng(-51.42, 95.47); //random ocean coordinates
  late LatLng end = const LatLng(-51.42, 95.47);

  get _checkIfDifferent {
    if (start.latitude == end.latitude && start.longitude == end.longitude) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  Widget buildListView(TextEditingController controller, bool val) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                backgroundColor: ColorManager.appBlack.withOpacity(0.16),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.black,
                )),
            title: Text(_options[index].displayname,
                style: TextStyle(color: ColorManager.appBlack)),
            trailing: const Icon(Icons.north_west, color: Colors.grey),
            onTap: () {
              setState(() {
                controller.text = _options[index].displayname;
                print(controller.text);
                print(val);
                print('-------');

                (val)
                    ? {
                        start = LatLng(
                            _options[index].latitude, _options[index].longitude)
                      }
                    : {
                        end = LatLng(
                            _options[index].latitude, _options[index].longitude)
                      };
              });
              _options.clear();

              if (controller1.text.isNotEmpty && controller2.text.isNotEmpty) {
                if (_checkIfDifferent) {
                  storeStartAndEndLocations(start, end);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RouteMap(startL: start, endL: end),
                    ),
                  );
                }
              }
            },
          ),
          const Divider(
            thickness: 1.250,
          ),
        ],
      ),
      itemCount: _options.length > 6 ? 6 : _options.length,
    );
  }

  Future<void> storeStartAndEndLocations(LatLng startL, LatLng endL) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref();

      final routeMapReference = databaseReference.child('RouteMap').push();

      await routeMapReference.update({
        'geohash': encodeGeohash(startL.latitude, startL.longitude),
        'geopoint': '${startL.latitude}, ${startL.longitude}',
      });

      final routeMapReference2 = databaseReference.child('RouteMap').push();

      await routeMapReference2.update({
        'geohash': encodeGeohash(endL.latitude, endL.longitude),
        'geopoint': '${endL.latitude}, ${endL.longitude}',
      });
    } catch (error) {
      debugPrint('Failed to store start and end locations: $error');
    }
  }

  Widget buildTextFormField(
    TextEditingController controller,
    String hint,
    IconData icon,
    Color color,
    FocusNode fn,
  ) {
    return TextFormField(
        controller: controller,
        focusNode: fn,
        style: TextStyle(color: ColorManager.appBlack),
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          labelText: hint,
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: Icon(
            icon,
            color: color,
          ),
          suffixIcon: controller.text.isEmpty
              ? IconButton(
                  onPressed: () => controller.clear(),
                  icon: const Icon(Icons.mic),
                )
              : IconButton(
                  onPressed: () => controller.clear(),
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary, width: 3.0),
          ),
        ),
        textInputAction: TextInputAction.go,
        onChanged: (String value) {
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }

          _debounce = Timer(const Duration(milliseconds: 25), () async {
            var client = http.Client();
            try {
              String url =
                  'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&accept-language=en';
              var response = await client.get(Uri.parse(url));
              var decodedResponse =
                  jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
              _options = decodedResponse
                  .map((e) => OSMdata(
                      displayname: e['display_name'],
                      latitude: double.parse(e['lat']),
                      longitude: double.parse(e['lon'])))
                  .toList();
              setState(() {});
            } on Exception catch (e) {
              // print(e);
            } finally {
              client.close();
            }
          });
        });
  }

  void _swap(TextEditingController c1, TextEditingController c2) {
    String tempController = c1.text;
    c1.text = c2.text;
    c2.text = tempController;
    LatLng temp = start;
    start = end;
    end = temp;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: ColorManager.appBlack,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 3,
              child: Container(
                  padding: const EdgeInsets.only(
                      bottom: 30, top: 10, left: 25, right: 25),
                  width: double.infinity,
                  child: Column(children: [
                    buildTextFormField(
                        controller1,
                        'Start location',
                        Icons.location_on_outlined,
                        ColorManager.primary,
                        startFocusNode),
                    IconButton(
                      onPressed: () => _swap(controller1, controller2),
                      icon: const Icon(
                        Icons.swap_vert,
                        size: 33,
                      ),
                      splashColor: ColorManager.primary,
                      color: ColorManager.appBlack,
                    ),
                    buildTextFormField(controller2, 'Destination location',
                        Icons.location_on_outlined, Colors.red, endFocusNode),
                  ])),
            ),
            Expanded(
              child: StatefulBuilder(builder: ((context, setState) {
                if (startFocusNode.hasFocus) {
                  return buildListView(controller1, true);
                } else {
                  return buildListView(controller2, false);
                }
              })),
            ),
          ],
        ),
      ),
    );
  }
}
