// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/account.dart';
import 'package:evfi/presentation/pages/screens/accountPage/booknow.dart';
import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';
import 'package:evfi/presentation/storage/booking_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../resources/values_manager.dart';
import '../../resources/color_manager.dart';

class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName;
  final String address;
  final List<dynamic> imageUrl;
  final double costOfFullCharge;
  final String startTime;
  final String endTime;
  final int timeslot;
  final List<dynamic> chargerType;
  final String amenities;
  final String hostName;
  final String chargerId;
  final String providerId;
  //final url = "https://firebasestorage.googleapis.com/v0/b/evfi-prod.appspot.com/o/charger_images%2F1696013568164.jpg?alt=media&token=18a573b1-9806-4c65-a82d-d948f8d72100";

  const CustomMarkerPopup({
    required this.stationName,
    required this.address,
    required this.imageUrl,
    required this.geopoint,
    required this.geohash,
    required this.costOfFullCharge,
    required this.chargerType,
    required this.amenities,
    required this.hostName,
    required this.startTime,
    required this.endTime,
    required this.timeslot,
    required this.chargerId,
    required this.providerId,
  });

  @override
  State<CustomMarkerPopup> createState() => _CustomMarkerPopupState();
}

class _CustomMarkerPopupState extends State<CustomMarkerPopup> {
  int _currentIndex = 0;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppMargin.m20),
        child: Card(
          shadowColor: ColorManager.CardshadowBottomRight,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(
            Radius.circular(40),
          )),
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(AppMargin.m14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.stationName,
                  style: const TextStyle(
                    fontSize: AppSize.s18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //..................................................................................
                    //..................Charger Images..................................................
                    Container(
                      //color: Colors.amber,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.50,
                      margin: const EdgeInsets.all(0.1),
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.bottomCenter,
                        children: [
                            CarouselSlider(
                              items: widget.imageUrl.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                              carouselController: carouselController,
                              options: CarouselOptions(
                                  scrollDirection: Axis.vertical,
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  aspectRatio: 2,
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 2),
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  }),
                            ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 5,
                            //right: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  widget.imageUrl.asMap().entries.map((entry) {
                                int index = entry.key;
                                return Container(
                                  width: 7.0,
                                  height: _currentIndex == index ? 17 : 7,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: _currentIndex == index
                                          ? Colors.yellow
                                          : Colors.orange),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //..................................................................................
                    //..................CHARGER INFORMATION.............................................
                    Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.25,
                      //color: Colors.blueAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.chargerType.toString(),
                            style: const TextStyle(fontSize: AppSize.s14),
                          ),
                          Text(
                            widget.amenities.toString(),
                            style: const TextStyle(fontSize: AppSize.s14),
                          ),
                          Text(
                            widget.address,
                            style: const TextStyle(fontSize: AppSize.s14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RatingBarIndicator(
                                rating: 4,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: ColorManager.primary,
                                ),
                                itemCount: 5,
                                itemSize: 17.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          Text(
                            "₹ ${widget.costOfFullCharge}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //..................................................................................
                //.......................BOOK NOW BUTTON............................................
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Booknow(
                              stationName: widget.stationName,
                              address: widget.address,
                              imageUrl: widget.imageUrl,
                              costOfFullCharge: widget.costOfFullCharge,
                              chargerType: widget.chargerType,
                              amenities: widget.amenities,
                              hostName: widget.hostName,
                              startTime: widget.startTime,
                              endTime: widget.endTime,
                              timeslot: widget.timeslot,
                              chargerId: widget.chargerId,
                              providerId: widget.providerId,
                            )));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: ColorManager.primary,
                    ),
                    child: Center(
                      child: Text(
                        'Book now',
                        style: TextStyle(
                            fontSize: AppSize.s18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
