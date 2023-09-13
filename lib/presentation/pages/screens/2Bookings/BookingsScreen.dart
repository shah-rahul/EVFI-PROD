// ignore_for_file: non_constant_identifier_names, file_names, prefer_const_constructors, sized_box_for_whitespace
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:evfi/presentation/resources/styles_manager.dart';
import 'package:evfi/presentation/pages/screens/2Bookings/list_chargers.dart';
import '../../models/charger_bookings.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/booking_item_widget.dart';

List<Booking> BookingList = [
  Booking(
      customerName: "Arshdeep Singh",
      customerMobileNumber: "+918989898989",
      stationName: "Aomg Charging Station Hub",
      timeStamp: DateTime.now().toString(),
      amount: 120,
      status: 0,
      ratings: 2.0),
  Booking(
      customerName: "Rahul Shah",
      customerMobileNumber: "+918989898989",
      stationName: "Aomg Charging Station Hub",
      timeStamp: DateTime.now().toString(),
      amount: 80,
      status: 1,
      ratings: 4.0),
  Booking(
      customerName: "Priyanshu Maikhuri",
      stationName: "Aomg Charging Station Hub",
      customerMobileNumber: "+918989898989",
      timeStamp: DateTime.now().toString(),
      amount: 200,
      status: 0,
      ratings: 4.0),
  Booking(
      customerName: "Rajkumar ",
      stationName: "Aomg Charging Station Hub",
      customerMobileNumber: "+918989898989",
      timeStamp: DateTime.now().toString(),
      amount: 120,
      status: 0,
      ratings: 4.0),
  Booking(
      customerName: "Arshdeep Singh",
      stationName: "Aomg Charging Station Hub",
      customerMobileNumber: "+918989898989",
      timeStamp: DateTime.now().toString(),
      amount: 120,
      status: 1,
      ratings: 4.0),
  Booking(
      customerName: "Priyanshu Maikhuri",
      stationName: "Aomg Charging Station Hub",
      customerMobileNumber: "+913131313131",
      timeStamp: DateTime.now().toString(),
      amount: 120,
      status: 1,
      ratings: 4.0)
];

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool _currentSelected = true, _listedChargers = false;

  void _addCharger() {
    Navigator.of(context).push(PageTransition(
        child: const ListCharger(), type: PageTransitionType.theme));
    _listedChargers = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // BookingDataWidget newBookingElement = context.watch<BookingDataWidget>();
    return _listedChargers
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.BookingTitle,
                textAlign: TextAlign.start,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    onPressed: _addCharger,
                    icon: const Icon(
                      Icons.add_business_outlined,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Container(
                child:
                    _currentSelected ? PendingScreen(context) : RecentScreen()),
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              // height: MediaQuery.sizeOf(context).height,
              height: MediaQuery.of(context).size.height,
              // width: MediaQuery.sizeOf(context).width,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        ColorManager.grey3.withOpacity(0.68),
                        Colors.black87
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [0.3, 0.7])),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          // top: MediaQuery.sizeOf(context).height * 0.24),
                          top: MediaQuery.of(context).size.height * 0.24),
                      child: Image.asset(
                        ImageAssets.carCharger,
                        scale: 1.35,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'List, Rent \nand Earn easily.',
                    style: getBoldStyle(
                        fontSize: FontSize.s35, color: ColorManager.primary),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton.icon(
                      onPressed: _addCharger,
                      icon:
                          const Icon(Icons.bolt, color: Colors.green, size: 35),
                      style: Theme.of(context).elevatedButtonTheme.style,
                      label: const Text(
                        'List your charger',
                        style: TextStyle(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ));
  }

  Widget PendingScreen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.1,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.BookingScreenPendingTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.p12 - 2,
                            vertical: AppMargin.m12 - 8),
                        child: Container(
                          height: 1.8,
                          width: width * 0.32,
                          color: ColorManager.primary,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = false;
                    });
                  });
                },
                child: Container(
                    width: width * 0.5,
                    child: Text(AppStrings.BookingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.grey3))),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: height * 0.75,
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
          child: SingleChildScrollView(
            child: Container(
              height: height * 0.85,
              child: ListView.builder(
                itemBuilder: (context, ind) {
                  return Column(
                    children: [
                      BookingWidget(BookingList[ind], _currentSelected),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
                itemCount: BookingList.length,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget RecentScreen() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.1,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = true;
                    });
                  });
                },
                child: Container(
                  width: width * 0.5,
                  child: Text(AppStrings.BookingScreenPendingTab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: AppSize.s20,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.grey3)),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.BookingScreenRecentTab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppSize.s20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p12 - 2,
                              vertical: AppMargin.m12 - 8),
                          child: Container(
                            height: 1.8,
                            width: width * 0.32,
                            color: ColorManager.primary,
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: height * 0.75,
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
          child: SingleChildScrollView(
            child: Container(
              height: height * 0.82,
              child: ListView.builder(
                itemBuilder: (context, ind) {
                  return Column(
                    children: [
                      BookingWidget(BookingList[ind], _currentSelected),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
                itemCount: BookingList.length,
              ),
            ),
          ),
        )
      ],
    );
  }
}
