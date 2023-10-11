// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/payments.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import '../../../resources/color_manager.dart';

class Booknow extends StatefulWidget {
  const Booknow({
    required this.stationName,
    required this.address,
    required this.imageUrl,
    required this.costOfFullCharge,
    required this.chargerType,
    required this.amenities,
    required this.timeStamp,
    required this.hostName,
  });

  final String stationName;
  final String address;
  final List<dynamic> imageUrl;
  final double costOfFullCharge;
  final String timeStamp;
  final String chargerType;
  final String amenities;
  final String hostName;

  @override
  State<Booknow> createState() {
    return _Booknow();
  }
}

class _Booknow extends State<Booknow> {
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
                                height: 150,
                                width: double.infinity,
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
                          }),
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
                                  : Colors.orange),
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
                      '\t ${widget.timeStamp}',
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
                      height: height * 0.25,
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
                          containersTable(context),
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
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const PaymentScreen()),
                      );
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
}

//..........................................................................................
//.........................Table of Time Slots..............................................
Widget containersTable(BuildContext context) {
  List<Widget> rows = [];

  // 4x4 table of containers
  for (int i = 0; i < 4; i++) {
    List<Widget> columns = [];
    for (int j = 0; j < 4; j++) {
      columns.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          height: MediaQuery.of(context).size.height * 0.03,
          width: MediaQuery.of(context).size.width * 0.18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color.fromARGB(255, 214, 205, 205),
          ),
          padding: EdgeInsets.all(5),
          child: Center(child: Text('1 pm')),
        ),
      );
    }
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columns,
      ),
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: rows,
  );
}