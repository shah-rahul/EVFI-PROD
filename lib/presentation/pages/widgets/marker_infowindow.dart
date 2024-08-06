// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/account.dart';
import 'package:evfi/presentation/pages/screens/accountPage/booknow.dart';
import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';
import 'package:evfi/presentation/pages/widgets/complaint.dart';
import 'package:evfi/presentation/pages/widgets/review.dart';
import 'package:evfi/presentation/register/vForm.dart';
import 'package:evfi/presentation/storage/booking_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import '../../resources/values_manager.dart';
import '../../resources/color_manager.dart';

class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName;
  final String address;
  final List<dynamic> imageUrl;
  final int costOfFullCharge;
  final num startTime;
  final num endTime;
  final int timeslot;
  final String chargerType;
  final String amenities;
  final String hostName;
  final String chargerId;
  final String providerId;
  final num status;
  //final url = "https://firebasestorage.googleapis.com/v0/b/evfi-prod.appspot.com/o/charger_images%2F1696013568164.jpg?alt=media&token=18a573b1-9806-4c65-a82d-d948f8d72100";

  const CustomMarkerPopup(
      {required this.stationName,
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
      required this.status});

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
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
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
                            (widget.status==0)? 'Not Available' :  'Available',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSize.s14, color: (widget.status==0)? ColorManager.error : Colors.green),
                          ),
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
                            "₹"+widget.costOfFullCharge.toString(),
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
                  onTap: () async {
                    // final currentUser = FirebaseAuth.instance.currentUser;
                    // if (currentUser != null) {
                    //   try {
                    //     final userDoc = await FirebaseFirestore.instance.collection('user').doc(currentUser.uid).get();
                    //     if (userDoc.exists) {
                    //       final level2Data = userDoc.data();
                    //       if (level2Data != null && level2Data['level2'] != null) {
                    //         final level2 = level2Data['level2'];
                    //         final vehicleRegNumber = level2['vehicleRegistrationNumber'];
                    //         if (vehicleRegNumber != null && vehicleRegNumber.isNotEmpty) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: Booknow(
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
                                  ),
                                ),
                              );
                    //         } else {
                    //           Navigator.push(
                    //             context,
                    //             PageTransition(
                    //               type: PageTransitionType.rightToLeft,
                    //               child: VForm(
                    //                 stationName: widget.stationName,
                    //                 address: widget.address,
                    //                 imageUrl: widget.imageUrl,
                    //                 costOfFullCharge: widget.costOfFullCharge,
                    //                 chargerType: widget.chargerType,
                    //                 amenities: widget.amenities,
                    //                 hostName: widget.hostName,
                    //                 startTime: widget.startTime,
                    //                 endTime: widget.endTime,
                    //                 timeslot: widget.timeslot,
                    //                 chargerId: widget.chargerId,
                    //                 providerId: widget.providerId,
                    //               ),
                    //             ),
                    //           );
                    //         }
                    //       } else {
                    //         print('Level2 data is missing or null!');
                    //       }
                    //     } else {
                    //       print('User document does not exist!');
                    //     }
                    //   } catch (e) {
                    //     print('Error fetching user document: $e');
                    //   }
                    // } else {
                    //   print('Current user is null!');
                    // }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: widget.status == 0? Color.fromARGB(255, 214, 205, 205) : ColorManager.primary,
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
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Complaint(
                            chargerId: widget.chargerId,
                            chargerName: widget.stationName,
                          ),
                        ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: ColorManager.primary,
                        ),
                        child: Center(
                          child: Text(
                            'Complaint',
                            style: TextStyle(
                                fontSize: AppSize.s18,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Review(
                            chargerId: widget.chargerId,
                            chargerName: widget.stationName,
                          ),
                        ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: ColorManager.primary,
                        ),
                        child: Center(
                          child: Text(
                            'Review',
                            style: TextStyle(
                                fontSize: AppSize.s18,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
