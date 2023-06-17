import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '/presentation/resources/color_manager.dart';
import '../../models/data_type.dart';
import './result_map.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  Timer? _debounce;
  List<OSMdata> _options = <OSMdata>[];
  LatLong start = LatLong(-51.42, 95.47);  //random ocean coordinates
  LatLong end = LatLong(-51.42, 95.47);

get _checkIfDifferent {
    if(start.latitude == end.latitude && start.longitude == end.longitude){
      return false;
    }
    else {
      return true;
    }
  }

  Widget _buildListView(TextEditingController controller, bool val) {
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
              print(_options[index].displayname);
              print(
                LatLng(_options[index].latitude, _options[index].longitude),
              );
              setState(() {
                controller.text = _options[index].displayname;
                (val)
                    ? {
                        start = LatLong(
                            _options[index].latitude, _options[index].longitude)
                      }
                    : {
                        end = LatLong(
                            _options[index].latitude, _options[index].longitude)
                      };
              });
              _options.clear();
              if (controller1.text.isNotEmpty && controller2.text.isNotEmpty) {
                if (_checkIfDifferent) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ResultMap(
                        startL: start, 
                        endL: end
                      ),
                    ),
                  );
                }
              }
            },
          ),
          const Divider(
            thickness: 1.50,
          ),
        ],
      ),
      itemCount: _options.length > 6 ? 6 : _options.length,
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String hint,
      IconData icon, Color color) {
    return TextFormField(
        controller: controller,
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
              ? Container(width: 0)
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
        onChanged: (String value) {
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }
          setState(() {});
          _debounce = Timer(const Duration(milliseconds: 25), () async {
            var client = http.Client();
            try {
              String url =
                  'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&accept-language=en';
              var response = await client.post(Uri.parse(url));
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
              print(e);
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
    LatLong temp = start;
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
                    _buildTextFormField(controller1, 'Start location',
                        Icons.location_on_outlined, Colors.blue),
                    IconButton(
                      onPressed: () => _swap(controller1, controller2),
                      icon: const Icon(
                        Icons.swap_vert,
                        size: 33,
                      ),
                      color: ColorManager.appBlack,
                    ),
                    _buildTextFormField(controller2, 'Destination location',
                        Icons.location_on_outlined, Colors.red),
                  ])),
            ),
            Expanded(
              child: StatefulBuilder(builder: ((context, setState) {
                if (controller1.selection.isValid) {
                  return _buildListView(controller1, true);
                } else {
                  return _buildListView(controller2, false);
                }
              })),
            ),
          ],
        ),
      ),
    );
  }
}
