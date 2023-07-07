import 'package:flutter/material.dart';
import '../../models/MyCharging.dart';
import 'dart:async';
import '../../../resources/strings_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/values_manager.dart';

import '../../widgets/MyChargingWidget.dart';

List<MyCharging> ChargingList = [
  MyCharging(
      StationName: "Aomg Charging Station Hub",
      StationAddress:
          "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
      datetime: DateTime.now(),
      amount: 120,
      status: 0,
      ratings: 2.0),
  MyCharging(
      StationName: "Aomg Charging Station Hub",
      StationAddress:
          "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
      datetime: DateTime.now(),
      amount: 120,
      status: 0,
      ratings: 4.0),
  MyCharging(
      StationName: "Aomg Charging Station Hub",
      StationAddress:
          "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
      datetime: DateTime.now(),
      amount: 120,
      status: 0,
      ratings: 4.0),
  MyCharging(
      StationName: "Aomg Charging Station Hub",
      StationAddress:
          "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
      datetime: DateTime.now(),
      amount: 120,
      status: 0,
      ratings: 4.0),
  MyCharging(
      StationName: "Aomg Charging Station Hub",
      StationAddress:
          "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
      datetime: DateTime.now(),
      amount: 120,
      status: 1,
      ratings: 4.0),
  MyCharging(
      StationName: "Aomg Charging Station Hub",
      StationAddress:
          "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
      datetime: DateTime.now(),
      amount: 120,
      status: 1,
      ratings: 4.0)
];

class MyChargingScreen extends StatefulWidget {
  const MyChargingScreen({Key? key}) : super(key: key);
  @override
  State<MyChargingScreen> createState() => _MyChargingScreenState();
}

class _MyChargingScreenState extends State<MyChargingScreen> {
  bool _currentSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.MyChargingTitle,
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          child: _currentSelected ? currentScreen(context) : RecentScreen()),
    );
  }

  Widget currentScreen(BuildContext context) {
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
                      const Text(
                        AppStrings.ChargingScreenCurrentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
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
                  Timer(const Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = false;
                    });
                  });
                },
                child: Container(
                    width: width * 0.5,
                    child: Text(AppStrings.ChargingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.grey3))),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: height * 0.75,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
          child: SingleChildScrollView(
            child: Container(
              height: height * 0.85,
              child: ListView.builder(
                itemBuilder: (context, ind) {
                  return Column(
                    children: [
                      MyChargingWidget(ChargingList[ind]),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
                itemCount: ChargingList.length,
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
                  Timer(const Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = true;
                    });
                  });
                },
                child: Container(
                  width: width * 0.5,
                  child: Text(AppStrings.ChargingScreenCurrentTab,
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
                        const Text(
                          AppStrings.ChargingScreenRecentTab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppSize.s20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
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
        const SizedBox(
          height: 5,
        ),
        Container(
          height: height * 0.75,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
          child: SingleChildScrollView(
            child: Container(
              height: height * 0.82,
              child: ListView.builder(
                itemBuilder: (context, ind) {
                  return Column(
                    children: [
                      MyChargingWidget(ChargingList[ind]),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
                itemCount: ChargingList.length,
              ),
            ),
          ),
        )
      ],
    );
  }
}
