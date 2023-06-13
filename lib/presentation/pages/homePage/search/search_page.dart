import 'dart:async';
import 'dart:convert';

import 'package:EVFI/presentation/pages/homePage/search/data_type.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  Timer? _debounce;
  List<OSMdata> _options = <OSMdata>[];
  @override
  Widget build(BuildContext context) {
    Widget _buildListView() {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _options.length > 5 ? 5 : _options.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.location_on, color: Colors.black),
              title: Text(
                _options[index].displayname,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                print(
                 
                  LatLng(_options[index].latitude, _options[index].longitude),
                );
                print(_options[index].displayname);
                print( _options[index].displayname,);

                _options.clear();
                setState(() {});
              },
            );
          });
    }

    Widget _buildSearchBar(TextEditingController controller) {
      OutlineInputBorder inputBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      );
      OutlineInputBorder inputFocusBorder = OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      );

      return Column(
        children: [
          TextFormField(
              style: TextStyle(color: Colors.black),
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search",
                border: inputBorder,
                focusedBorder: inputFocusBorder,
                suffixIcon: IconButton(
                  onPressed: () => controller.clear(),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
              ),
              onChanged: (String value) {
                if (_debounce?.isActive ?? false) {
                  _debounce?.cancel();
                }
                setState(() {});
                _debounce = Timer(const Duration(milliseconds: 20), () async {
                  var client = http.Client();
                  try {
                    String url =
                        'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&accept-language=en';
                    var response = await client.post(Uri.parse(url));
                    var decodedResponse =
                        jsonDecode(utf8.decode(response.bodyBytes))
                            as List<dynamic>;
                    _options = decodedResponse
                        .map((e) => OSMdata(
                            displayname: e['display_name'],
                            latitude: double.parse(e['lat']),
                            longitude: double.parse(e['lon'])))
                        .toList();
                    setState(() {});
                  } on Exception catch (e) {
                    print(e);
                  } finally {
                    client.close();
                  }
                });
              }),
          StatefulBuilder(builder: ((context, setState) {
            return _buildListView();
          })),
        ],
      );
    }

    final _startPointController = TextEditingController();
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        height: mq.size.height * 0.5,
        width: mq.size.width,
        child: Column(
          children: [
            _buildSearchBar(_sourceController),
            // _buildSearchBar(_destinationController),

          ],
        ),
      )),
    );
  }
}
