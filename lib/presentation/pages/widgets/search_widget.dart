import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../resources/routes_manager.dart';
import '../screens/1homePage/home.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../resources/color_manager.dart';
import '../models/auto_search.dart';
import '../screens/1homePage/search_page.dart';

class SearchWidget extends StatefulWidget {
  final Function(Position) onLocationSelected;

  const SearchWidget(
    this.onLocationSelected,
  );

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  FocusNode textfieldFocus = FocusNode();
  List<OSMdata> _options = <OSMdata>[];

  Widget buildTextFormField(
    TextEditingController controller,
    IconData icon,
    Color color,
    FocusNode textFieldFocusNode,
  ) {
    final width = MediaQuery.of(context).size.width;
    final hint = "Search chargers";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: TextFormField(
          controller: controller,
          focusNode: textFieldFocusNode,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: AppSize.s12, color: Colors.white),
            filled: true, //<-- SEE HERE
            fillColor: ColorManager.appBlack,
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s4),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            suffixIcon: controller.text.isEmpty
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.searchPageRoute);
                    },
                    icon: Icon(
                      Icons.directions_outlined,
                      color: ColorManager.primary,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      controller.clear();
                      setState(() {
                        suggestions = false;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s20)),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(AppSize.s20))),
          ),
          textInputAction: TextInputAction.done,
          onChanged: (String value) async {
            var client = http.Client();
            try {
              String url =
                  'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&accept-language=en';
              var response = await client.get(Uri.parse(url));
              var decodedResponse =
                  jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
              // decodedResponse.forEach((key, value) {
              //    print(value);
              // });
              _options = decodedResponse
                  .map((e) => OSMdata(
                      displayname: e['display_name'],
                      latitude: double.parse(e['lat']),
                      longitude: double.parse(e['lon'])))
                  .toList();
              if (controller.text.isNotEmpty && textfieldFocus.hasFocus) {
                setState(() {
                  suggestions = true;
                });
              } else if (controller.text.isEmpty) {
                setState(() {
                  suggestions = false;
                });
              }
            } on Exception catch (e) {
              print(e);
            } finally {
              client.close();
            }
          }),
    );
  }

  Widget buildListView(TextEditingController controller, bool val,
      FocusNode textFieldFocusNode) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s12))),
      height: _options.length > 4
          ? height * 0.22
          : _options.length * height * 0.064,
      child: ListView.builder(
        shrinkWrap: true,
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
                  print(_options[index].displayname);
                  print(
                    LatLng(_options[index].latitude, _options[index].longitude),
                  );
                  setState(() {
                    controller.text = _options[index].displayname;
                  });
                  Position placePos = Position(
                    headingAccuracy: 0,
                    altitudeAccuracy: 0,
                    latitude: _options[index].latitude,
                    longitude: _options[index].longitude,
                    timestamp: DateTime.now(),
                    accuracy: 0,
                    altitude: 0,
                    speed: 0,
                    heading: 0,
                    speedAccuracy: 0,
                    floor: 0,
                  );
                  widget.onLocationSelected(placePos);
                  _options.clear();
                  suggestions = false;
                  textFieldFocusNode.unfocus();
                  setState(() {});
                }),
            const Divider(
              thickness: 1.250,
            ),
          ],
        ),
        itemCount: _options.length > 4 ? 4 : _options.length,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool suggestions = false;
  final textFieldcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final suggestionController = SuggestionsBoxController();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.36,
      width: width * 1.0,
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildTextFormField(
            textFieldcontroller,
            (Icons.bolt),
            Colors.amber,
            textfieldFocus,
          ),
          if (suggestions)
            buildListView(textFieldcontroller, true, textfieldFocus)
        ],
      ),
    );
  }
}
