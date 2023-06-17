// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../models/data_type.dart';

// import '/presentation/resources/color_manager.dart';
// import '../screens/homePage/result_map.dart';

// class ToFrom extends StatefulWidget {
//   const ToFrom({Key? key}) : super(key: key);

//   @override
//   State<ToFrom> createState() => _ToFromState();
// }

// class _ToFromState extends State<ToFrom> {
//   final controller1 = TextEditingController();
//   final controller2 = TextEditingController();
//   Timer? _debounce;
//   List<OSMdata> _options = <OSMdata>[];
//   List<LatLng> routpoints = [];

//   @override
//   void initState() {
//     super.initState();

//     controller1.addListener(() {
//       setState(() {});
//     });
//     controller2.addListener(() {
//       setState(() {});
//     });
//   }

//   Widget _buildTextFormField(TextEditingController controller, String hint) {
//     return TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.streetAddress,
//         decoration: InputDecoration(
//           hintText: hint,
//           contentPadding: const EdgeInsets.all(10),
//           suffixIcon: controller.text.isEmpty
//               ? Container(width: 0)
//               : IconButton(
//                   onPressed: () => controller.clear(),
//                   icon: const Icon(
//                     Icons.close,
//                   ),
//                 ),
//           focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: ColorManager.primary, width: 3.0),
//   ),
//         ),
//         onChanged: (String value) {
//           if (_debounce?.isActive ?? false) {
//             _debounce?.cancel();
//           }
//           setState(() {});
//           _debounce = Timer(const Duration(milliseconds: 25 ), () async {
//             var client = http.Client();
//             try {
//               String url =
//                   'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&accept-language=en';
//               var response = await client.post(Uri.parse(url));
//               var decodedResponse =
//                   jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
//               _options = decodedResponse
//                   .map((e) => OSMdata(
//                       displayname: e['display_name'],
//                       latitude: double.parse(e['lat']),
//                       longitude: double.parse(e['lon'])))
//                   .toList();
//               setState(() {});
//             } on Exception catch (e) {
//               print(e);
//             } finally {
//               client.close();
//             }
//           });
//         });
//   }

//   void _swap(TextEditingController c1, TextEditingController c2) {
//     String tempController = c1.text;
//     c1.text = c2.text;
//     c2.text = tempController;
//     setState(() {});
//   }

//   Widget _buildPortraitContent(BoxConstraints constraints) {
//     return Row(
//       children: [
//         SizedBox(
//           width: constraints.maxWidth * 0.10, //1
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.location_on_outlined, color: Colors.blue),
//               const Icon(
//                 Icons.more_vert,
//                 size: 34,
//                 color: Colors.grey,
//               ),
//               Icon(
//                 Icons.location_on_outlined,
//                 color: ColorManager.error,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//             width: constraints.maxWidth * 0.59, //2
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildTextFormField(controller1, 'Choose Start location'),
//                 SizedBox(
//                   height: constraints.maxHeight * 0.06,
//                 ),
//                 _buildTextFormField(controller1, 'Choose Destination location'),
//               ],
//             )),
//         SizedBox(
//           width: constraints.maxWidth * 0.01,
//         ),
//         SizedBox(
//           width: constraints.maxWidth * 0.15,
//           child: Center(
//             child: IconButton(
//               onPressed: () => _swap(controller1, controller2),
//               icon: const Icon(
//                 Icons.swap_vert,
//                 size: 33,
//               ),
//               color: ColorManager.appBlack,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildLandscapeContent(BoxConstraints constraints) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           width: constraints.maxWidth * 0.35,
//           padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
//           child: _buildTextFormField(controller1, 'Choose Start location'),
//         ),
//         SizedBox(
//           width: constraints.maxWidth * 0.1,
//           child: Center(
//             child: IconButton(
//               onPressed: () => _swap(controller1, controller2),
//               icon: const Icon(
//                 Icons.swap_horiz,
//                 size: 33,
//               ),
//               color: ColorManager.appBlack,
//             ),
//           ),
//         ),
//         Container(
//           width: constraints.maxWidth * 0.35,
//           padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.1),
//           child: _buildTextFormField(controller1, 'Choose Destination location'),
//         ),
//         SizedBox(width: constraints.maxWidth * 0.04),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     return LayoutBuilder(
//       builder: (ctx, constraints) {
//         return Column(
//           children: [
//             SizedBox(
//               height: constraints.maxHeight * 0.75,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: constraints.maxWidth * 0.15,
//                     child: IconButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       icon: const Icon(
//                         Icons.arrow_back,
//                         size: 30,
//                       ),
//                       color: ColorManager.appBlack,
//                     ),
//                   ),
//                   if (mq.orientation == Orientation.portrait)
//                     _buildPortraitContent(constraints)
//                   else
//                     _buildLandscapeContent(constraints)
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorManager.primary,
//                   ),
//                   child: const Text(
//                     'Go',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w700),
//                   ),
//                   onPressed: () async {
//                     //print(controller1.text);
//                     List<Location> startL =
//                         await locationFromAddress(controller1.text);
//                     List<Location> endL =
//                         await locationFromAddress(controller2.text);

//                     var v1 = startL[0].latitude;
//                     var v2 = startL[0].longitude;
//                     var v3 = endL[0].latitude;
//                     var v4 = endL[0].longitude;

//                     var url = Uri.parse(
//                         'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
//                     var response = await http.get(url);

//                     setState(() async {
//                       routpoints = [];
//                       var ruter = jsonDecode(response.body)['routes'][0]
//                           ['geometry']['coordinates'];
//                       for (int i = 0; i < ruter.length; i++) {
//                         var reep = ruter[i].toString();
//                         reep = reep.replaceAll("[", "");
//                         reep = reep.replaceAll("]", "");
//                         var lat1 = reep.split(',');
//                         var long1 = reep.split(",");
//                         routpoints.add(LatLng(
//                             double.parse(lat1[1]), double.parse(long1[0])));
//                       }
//                       print(routpoints);
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (context) => ResultMap(
//                             routeSet: routpoints,
//                           ),
//                         ),
//                       );
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: constraints.maxHeight * 0.08),
//           ],
//         );
//       },
//     );
//   }
// }
