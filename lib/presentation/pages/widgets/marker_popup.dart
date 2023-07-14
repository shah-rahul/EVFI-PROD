import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
//import '../../../resources/color_manager.dart';
import '../../resources/values_manager.dart';


class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName= 'EVFI Charging Station';
  final String address =
      'Sector 39, Karnal, NH-1, GT Karnal Road,, Haryana, 132001';

  const CustomMarkerPopup({required this.geopoint, required this.geohash});

  @override
  State<CustomMarkerPopup> createState() => _CustomMarkerPopupState();
}

class _CustomMarkerPopupState extends State<CustomMarkerPopup> {
  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(15),
            topEnd: Radius.circular(15),
          )
          //borderRadius: BorderRadius.circular(15),
        ),
        //height: 140,
        child: 
        //Card(
          //shadowColor: ColorManager.CardshadowBottomRight,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.only(
          //   topStart: Radius.circular(15),
          //   topEnd: Radius.circular(15),
          // )),
          // elevation: 4,
          // color: Colors.yellow.withOpacity(0.6),
          // child: 
          Padding(
            padding: const EdgeInsets.all(AppMargin.m12 - 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.electric_bolt_sharp, size: 20),
                  const SizedBox(width: 3),
                  Text(
                    widget.stationName,
                    style: const TextStyle(
                        fontSize: AppSize.s20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.5,
              ),
              Text(widget.address, style: const TextStyle(fontSize: AppSize.s12)),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  Padding(
                      padding: const EdgeInsets.all(AppPadding.p12 - 8),
                      child: Text(DateTime.now().toString())),
                ],
              ),
              const SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBarIndicator(
                    rating: 4, //myCharging.ratings,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  //const SizedBox(width: 120),
                  Container(
                    height: 30,
                    width: 95,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber)),
                      child: const Text(
                        'Book Slot',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/map/carphoto.jpeg',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ]),
          ),
        //),
      ),
    );
  }
}
