// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:evfi/presentation/pages/screens/accountPage/booknow.dart';
import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';
import 'package:evfi/presentation/storage/booking_data_provider.dart';
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
  final String chargerType;
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
    required this.chargerId,
    required this.providerId,
  });

  @override
  State<CustomMarkerPopup> createState() => _CustomMarkerPopupState();
}

class _CustomMarkerPopupState extends State<CustomMarkerPopup> {
  bool isLoading = true;
  Future<void> fetchImage() async {
    await Future.delayed(Duration(seconds: 8));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  // final List<String> imageUrls = [
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  // ];
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //..................................................................................
                    //..................Charger Images..................................................
                    Container(
                      //color: Colors.amber,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.55,
                      margin: const EdgeInsets.all(0.1),
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (isLoading)
                            Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            )
                          else
                            CarouselSlider(
                              items: widget.imageUrl.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
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
                    // Container(
                    //   color: Colors.amber,
                    //   height: MediaQuery.of(context).size.height * 0.2,
                    //   width: MediaQuery.of(context).size.width * 0.55,
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(40),
                    //     child: Image.asset(
                    //       'assets/images/map/carphoto.jpeg',
                    //       height: MediaQuery.of(context).size.height * 0.2,
                    //       width: MediaQuery.of(context).size.width * 0.55,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
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
                            widget.chargerType,
                            style: const TextStyle(fontSize: AppSize.s14),
                          ),
                          Text(
                            widget.amenities,
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
                                itemSize: 20.0,
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

/*
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final String timeStamp;
  final String chargerType;
  final String amenities;
  final String hostName;
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
    required this.timeStamp,
  });

  @override
  State<CustomMarkerPopup> createState() => _CustomMarkerPopupState();
}

class _CustomMarkerPopupState extends State<CustomMarkerPopup> {
  bool isLoading = true;
  Future<void> fetchImage() async {
    await Future.delayed(Duration(seconds: 8));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  // final List<String> imageUrls = [
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  //   'assets/images/map/carphoto.jpeg',
  // ];
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //..................................................................................
                    //..................Charger Images..................................................
                    Container(
                      //color: Colors.amber,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.55,
                      margin: const EdgeInsets.all(0.1),
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (isLoading)
                            Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            )
                          else
                            CarouselSlider(
                              items: widget.imageUrl.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context){
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
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
                    // Container(
                    //   color: Colors.amber,
                    //   height: MediaQuery.of(context).size.height * 0.2,
                    //   width: MediaQuery.of(context).size.width * 0.55,
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(40),
                    //     child: Image.asset(
                    //       'assets/images/map/carphoto.jpeg',
                    //       height: MediaQuery.of(context).size.height * 0.2,
                    //       width: MediaQuery.of(context).size.width * 0.55,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
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
                            widget.chargerType,
                            style: const TextStyle(fontSize: AppSize.s14),
                          ),
                          Text(
                            widget.amenities,
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
                                itemSize: 20.0,
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
                            timeStamp: widget.timeStamp)));
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


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../Data_storage/UserDataProvider.dart';

import '../../storage/UserDataProvider.dart';
import '../../register/UserChargingRegister.dart';
import '../../resources/values_manager.dart';
import '../../resources/color_manager.dart';

final List<String> imgURL = [
  'assets/images/map/carphoto.jpeg',
  'assets/images/map/carphoto.jpeg',
  'assets/images/map/carphoto.jpeg',
  'assets/images/map/carphoto.jpeg',
  'assets/images/map/carphoto.jpeg',
];

bool? isRegistered;

/*RadioButtons*/
enum ChargerTypes { A, B, C }

ChargerTypes? selectedType = ChargerTypes.A;
/*RadioButtons*/

/*Dropdown*/
String selectedTime = '10:00 AM - 11:00 AM';
List<String> timings = [
  '09:00 AM - 10:00 AM',
  '10:00 AM - 11:00 AM',
  '11:00 AM - 12:00 AM',
  '12:00 PM - 01:00 PM',
  '01:00 PM - 02:00 PM',
  '02:00 PM - 03:00 PM',
  '03:00 PM - 04:00 PM',
  '04:00 PM - 05:00 PM',
  '05:00 PM - 06:00 PM'
];
/*Dropdown*/

class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName;
  final String address;
  final List<dynamic> imageUrl;
  final double costOfFullCharge;
  final String timeStamp;
  final String chargerId;
  final String providerId;
  //take input of chargerType as well from firebase fetching to show charger level

  const CustomMarkerPopup(
      {required this.stationName,
      required this.address,
      required this.imageUrl,
      required this.geopoint,
      required this.geohash,
      required this.costOfFullCharge,
      required this.timeStamp,
      required this.chargerId,
      required this.providerId});

  @override
  State<CustomMarkerPopup> createState() => _CustomMarkerPopupState();
}

class _CustomMarkerPopupState extends State<CustomMarkerPopup> {
  bool isBooking = false;
  String str = 'Book Slot';

  // void onchanRadio(ChargerTypes val) {
  //   setState(() {
  //     selectedType = val;
  //   });
  // }

  void changecontent(bool isRegistered) {
    if (isRegistered) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const UserChargingRegister(),
        ),
      );
    } else {
      setState(() {
        isBooking = !isBooking;
        if (!isBooking) {
          str = 'Book Slot';
        } else {
          str = 'Back';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(15),
            topEnd: Radius.circular(15),
          ),
        ),
        //height: 333,
        child: Card(
          shadowColor: ColorManager.CardshadowBottomRight,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(
            Radius.circular(40),
          )),
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppMargin.m16 ),
            child: Column(
              /*
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.stationName,
                      style: const TextStyle(
                        fontSize: AppSize.s20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 95,
                      child: ElevatedButton(
                        onPressed: () {
                          changecontent(isRegistered!);
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber),
                        ),
                        child: Text(
                          str,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.address,
                  style: const TextStyle(fontSize: AppSize.s12),
                ),
                const SizedBox(height: 8),
                FutureBuilder<bool>(
                  future: checkNumberIsRegistered(
                    number: userDataProvider.userData.phoneNumber,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          height: 150,
                          alignment: Alignment.center,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return const Text('Error occurred');
                    } else {
                      isRegistered = snapshot.data;
                      return (isBooking)
                          ? bookingSection(context, onchanRadio)
                          : startingSection(context, widget.costOfFullCharge,
                              widget.timeStamp, widget.imageUrl);
                    }
                  },
                ),
              ],*/
            ),
          ),
        ),
      ),
    );
  }
}


  Widget bookingSection(BuildContext context,
      void Function(ChargerTypes val) onchanRadio) {
    return Card(
      shadowColor: ColorManager.CardshadowBottomRight,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
        Radius.circular(15),
      )),
      elevation: 4,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(width: 14),
              Text('Select your Charger Type',
                  style: TextStyle(
                      fontSize: AppSize.s14, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RadioListTile<ChargerTypes>(
                  contentPadding: const EdgeInsets.all(0.0),
                  value: ChargerTypes.A,
                  title: const Text('Type A',
                      style: TextStyle(color: Colors.black)),
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  activeColor: Colors.amber,
                  groupValue: selectedType,
                  onChanged: (value) {
                    onchanRadio(value!);
                    //selectedType = value;
                  },
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: RadioListTile<ChargerTypes>(
                  contentPadding: const EdgeInsets.all(0.0),
                  value: ChargerTypes.B,
                  title: const Text('Type B',
                      style: TextStyle(color: Colors.black)),
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  activeColor: Colors.amber,
                  groupValue: selectedType,
                  onChanged: (value) {
                    onchanRadio(value!);
                    //selectedType = value;
                  },
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: RadioListTile<ChargerTypes>(
                  contentPadding: const EdgeInsets.all(0.0),
                  value: ChargerTypes.C,
                  title: const Text(
                    'Type C',
                    style: TextStyle(color: Colors.black),
                  ),
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  activeColor: Colors.amber,
                  groupValue: selectedType,
                  onChanged: (value) {
                    onchanRadio(value!);
                    //selectedType = value;
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<String>(
              value: selectedTime,
              icon:
                  const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
              dropdownColor: Colors.amber.shade100,
              elevation: 4,
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: AppMargin.m14),
                labelText: "Time Slot",
                border: UnderlineInputBorder(),
              ),
              items: timings.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                selectedTime = value!;
              },
            ),
          ),
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 35,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageTransition(
                    //       type: PageTransitionType.rightToLeft,
                    //       child: const PaymentScreen()),
                    // ).then((_) {
                    BookingDataProvider(
                        providerId: widget.providerId,
                        chargerId: widget.chargerId,
                        price: widget.costOfFullCharge,
                        timeSlot: selectedTime);
                    // Provider.of<UserChargings>(context, listen: false)
                    //     .addCharging(chargingRequest);
                    Navigator.pop(context);
                    // });
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 84, 194, 87))),
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

Widget startingSection(BuildContext context, double cost, String timeStamp,
    final List<dynamic> imageUrl) {
  return Column(
    children: [
      Row(children: [
        const Icon(Icons.access_time),
        Text('\t $timeStamp'),
        Spacer(),
        Text("₹ $cost", style: TextStyle(fontWeight: FontWeight.bold))
      ]),
      const SizedBox(height: 1),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Charging Type : Fast',
              style: TextStyle(fontSize: AppSize.s12)),
          const SizedBox(width: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Ratings: ', style: TextStyle(fontSize: AppSize.s12)),
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
            ],
          ),
        ],
      ),
      const SizedBox(height: 5),
      //////......................................

      // ListView.builder(
      //   scrollDirection: Axis.horizontal,
      //   itemCount: imgURL.length,
      //   itemBuilder: (context, index) {
      //     final imageUrls =
      //         imgURL[index].toString(); // Convert dynamic to string
      //     return Padding(
      //       padding: const EdgeInsets.all(0),
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.circular(10),
      //         child: Image.network(
      //           imageUrls,
      //           width: 150,
      //           height: 155,
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      //////////////////////////////
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/map/carphoto.jpeg',
          height: 155,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      ..................................................
    ],
  );
}

Future<bool> checkNumberIsRegistered({required String number}) async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('UserChargingRegister');
  bool isNumberRegistered = false;
  // storePhoneNumber(number);

  try {
    final querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      final phoneNumber = doc.data()['PhoneNumber'].toString();

      if (number == phoneNumber) {
        isNumberRegistered = true;
        break;
      } else {
        return false;
        // storePhoneNumber(number);
      }
    }

    return isNumberRegistered;
  } catch (e) {
    return false;
  }
}
*/
