// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/payments.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:evfi/presentation/storage/booking_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import '../../../resources/color_manager.dart';

class Booknow extends StatefulWidget {
  const Booknow(
      {required this.stationName,
      required this.address,
      required this.imageUrl,
      required this.costOfFullCharge,
      required this.chargerType,
      required this.amenities,
      required this.startTime,
      required this.endTime,
      required this.hostName,
      required this.chargerId,
      required this.providerId});

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

  @override
  State<Booknow> createState() {
    return _Booknow();
  }
}

class _Booknow extends State<Booknow> {
  int _currentIndex = 0;
  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    streamBuilder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Booking',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const CupertinoIconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            //..................................................................................
            //..................Charger Images..................................................
            Container(
              //color: Colors.amber,
              height: height * 0.20,
              width: double.infinity,
              margin: const EdgeInsets.all(0.1),
              child: Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children: [
                  // if (isLoading)
                  //   Center(
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2.0,
                  //     ),
                  //   )
                  // else
                  CarouselSlider(
                    items: widget.imageUrl.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              height: 150,
                              width: double.infinity,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          );
                        },
                      );
                    }).toList(),
                    carouselController: carouselController,
                    options: CarouselOptions(
                      scrollDirection: Axis.horizontal,
                      scrollPhysics: const BouncingScrollPhysics(),
                      aspectRatio: 2,
                      //viewportFraction: 1,  //get checked by rahul sir
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.imageUrl.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Container(
                          width: _currentIndex == index ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _currentIndex == index
                                ? Colors.yellow
                                : Colors.orange,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            //..................................................................................
            //......................Charger Information........................................
            const SizedBox(height: 30),
            Container(
              //color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.stationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: AppSize.s28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      widget.address,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppSize.s14,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.amenities,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: AppSize.s14,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Ratings: ',
                          style: TextStyle(
                              fontSize: AppSize.s14,
                              fontWeight: FontWeight.w600)),
                      RatingBarIndicator(
                        rating: 4,
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
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.access_time),
                    Text(
                      '\t ${widget.startTime}-${widget.endTime}',
                      style: TextStyle(
                          fontSize: AppSize.s14, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text("₹ ${widget.costOfFullCharge}",
                        style: TextStyle(
                            fontSize: AppSize.s16, fontWeight: FontWeight.w800))
                  ]),
                  const SizedBox(height: 2),
                  Text(
                    "Host Name:- ${widget.hostName}",
                    style: TextStyle(
                        fontSize: AppSize.s14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),

                  //..................................................................................
                  //.....................Available slots for today..............................................
                  Card(
                    shadowColor: ColorManager.CardshadowBottomRight,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(40),
                    )),
                    elevation: 4,
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: height * 0.27,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            'Available slots for today',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: AppSize.s16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          streamBuilder(),
                        ],
                      ),
                    ),
                  ),
                  //..................................................................................
                  //......................select payment method........................................
                  Card(
                    shadowColor: ColorManager.CardshadowBottomRight,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(40),
                    )),
                    elevation: 4,
                    color: Colors.white,
                    child: Container(
                      height: height * 0.07,
                      width: double.infinity,
                      child: const Center(
                          child: Text(
                        'select payment method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //..................................................................................
                  //....................Proceed to Pay...............................................
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   PageTransition(
                      //       type: PageTransitionType.rightToLeft,
                      //       child: const PaymentScreen()),
                      // ).then((_) {
                      int updatedTimeSlot = binaryToDecimal(
                          newTimeSlots(previousTImeSlot, selectedTimeSlot));
                      print("--");
                      print(previousTImeSlot);
                      print(selectedTimeSlot);
                      print(updatedTimeSlot);
                      updateFireStoreTimeStamp(updatedTimeSlot);

                      BookingDataProvider(
                          providerId: widget.providerId,
                          chargerId: widget.chargerId,
                          price: "${widget.costOfFullCharge}",
                          timeSlot: selectedTimeSlot);
                      // Navigator.pop(context);
                    },
                    child: Card(
                      shadowColor: ColorManager.CardshadowBottomRight,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(40),
                      )),
                      elevation: 4,
                      color: ColorManager.primary,
                      child: Container(
                        height: height * 0.07,
                        width: double.infinity,
                        child: const Center(
                            child: Text(
                          'Proceed to Pay',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidTimeSlot(String time) {
    String ampm = time.substring(time.length - 2);
    int timeExtracted = int.parse(time.substring(0, time.length - 3));

    if (ampm == "am" && timeExtracted == 12) {
      timeExtracted = 0;
    }
    if (ampm == "pm" && timeExtracted != 12) {
      timeExtracted += 12;
    }

    return timeExtracted >= int.parse(widget.startTime) &&
        timeExtracted <= int.parse(widget.endTime) &&
        !(bookedSlots[timeExtracted] == "1");
  }

  void updateFireStoreTimeStamp(int time) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('chargers');
    DocumentReference docRef = users.doc(widget.chargerId);
    await docRef.update({
      'timeSlot': time,
    });
  }

  int binaryToDecimal(String n) {
    String num = n;
    int dec_value = 0;

    // Initializing base value to 1, i.e 2^0
    int base = 1;

    int len = num.length;
    for (int i = len - 1; i >= 0; i--) {
      if (num[i] == '1') dec_value += base;
      base = base * 2;
    }

    return dec_value;
  }

  String newTimeSlots(int prevTimeSlot, int bookedTimeSlot) {
    String prevBin = timeToBinary(prevTimeSlot);
    for (int i = prevBin.length; i < 24; i++) prevBin = "0" + prevBin;
    String newTimeSlot = "";
    for (int i = 0; i < 24; i++) {
      if (i == bookedTimeSlot) {
        newTimeSlot += "1";
      } else
        newTimeSlot += prevBin[i];
    }
    return newTimeSlot;
  }

  String bookedSlots = "";
  String timeToBinary(int time) {
    String binaryTime = "";
    print(time);
    print(time.runtimeType);
    // counter for binary array
    int n = time;
    while (n > 0) {
      // storing remainder in binary array
      binaryTime = (n % 2).toString() + binaryTime;
      n = (n / 2).toInt();
    }
    print(binaryTime);
    return binaryTime;

    // printing binary array in reverse order
  }

  Widget streamBuilder() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chargers')
            .doc(widget.chargerId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: const CircularProgressIndicator());
          // }
          if (!snapshot.hasData) {
            return Center(child: Text(''));
          }
          if (snapshot.hasError) {
            return Center(child: Text(''));
          }

          // if (snapshot.data!.docChanges.isNotEmpty) {
          print(snapshot.data?['timeSlot'].runtimeType);
          previousTImeSlot = snapshot.data?['timeSlot'];
          bookedSlots = timeToBinary((snapshot.data?['timeSlot']));
          for (int i = bookedSlots.length; i < 24; i++)
            bookedSlots = "0" + bookedSlots;
          return containersTable(context);
          // }
          // return Container();
        });
  }

  int selectedTimeSlot = 0;
  int previousTImeSlot = 0; //previosu value of timeslot fetched from database
  Widget timeSlot(String text, BuildContext context) {
    if (isValidTimeSlot(text)) {
      return GestureDetector(
        onTap: () {
          String ampm = text.substring(text.length - 2);
          int timeExtracted = int.parse(text.substring(0, text.length - 3));
          if (ampm == "am" && timeExtracted == 12) {
            timeExtracted = 0;
          }
          if (ampm == "pm" && timeExtracted != 12) {
            timeExtracted += 12;
          }
          setState(() {
            selectedTimeSlot = timeExtracted;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          height: MediaQuery.of(context).size.height * 0.03,
          width: MediaQuery.of(context).size.width * 0.18,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 2.0),
            ],
            borderRadius: BorderRadius.circular(40),
            color: Colors.green,
          ),
          padding: EdgeInsets.all(5),
          child: Center(child: Text(text)),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color.fromARGB(255, 214, 205, 205),
      ),
      padding: EdgeInsets.all(5),
      child: Center(child: Text(text)),
    );
  }

//..........................................................................................
//.........................Table of Time Slots..............................................
  Widget containersTable(BuildContext context) {
    List<Widget> rows = [];

    // 4x4 table of containers
    int time = 1;
    for (int i = 0; i < 3; i++) {
      List<Widget> columns = [];
      if (i == 0) columns.add(timeSlot("12 am", context));
      for (int j = 0; j < 4; j++) {
        if (i == 0 && j == 0) continue;
        columns.add(timeSlot('${time} am', context));
        time++;
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: columns,
        ),
      );
    }
    time = 1;
    for (int i = 0; i < 3; i++) {
      List<Widget> columns = [];
      if (i == 0) columns.add(timeSlot("12 pm", context));
      for (int j = 0; j < 4; j++) {
        if (i == 0 && j == 0) continue;
        columns.add(timeSlot('${time} pm', context));
        time++;
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: columns,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rows,
      ),
    );
  }
}
