import 'dart:async';

import 'package:EVFI/presentation/pages/screens/mycharging/list_chargers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:EVFI/presentation/resources/assets_manager.dart';
import 'package:EVFI/presentation/resources/font_manager.dart';
import 'package:EVFI/presentation/resources/styles_manager.dart';

import '../../../resources/strings_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/values_manager.dart';

import '../../widgets/MyChargingWidget.dart';
import 'chargers_data.dart';

class MyChargingScreen extends StatefulWidget {
  const MyChargingScreen({Key? key}) : super(key: key);
  @override
  State<MyChargingScreen> createState() => _MyChargingScreenState();
}

class _MyChargingScreenState extends State<MyChargingScreen> {
  bool _currentSelected = true, _listedChargers = false;
  Chargers char = Chargers();
  var _isInit = true;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     char = Provider.of<Chargers>(context);
  //     setState(() {});
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  void _addCharger() {
    Navigator.of(context).push(PageTransition(
        child: const ListCharger(), type: PageTransitionType.theme));
    _listedChargers = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Chargers>(
        create: (context) => Chargers(),
        child: _listedChargers
            ? Scaffold(
                appBar: AppBar(
                  title: const Text(
                    AppStrings.MyChargingTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
                    child: _currentSelected
                        ? currentScreen(context)
                        : RecentScreen()),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
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
                              top: MediaQuery.sizeOf(context).height * 0.24),
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
                            fontSize: FontSize.s35,
                            color: ColorManager.primary),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      ElevatedButton.icon(
                          onPressed: _addCharger,
                          icon: const Icon(Icons.bolt,
                              color: Colors.green, size: 35),
                          style: Theme.of(context).elevatedButtonTheme.style,
                          label: const Text(
                            'List charger',
                            style: TextStyle(
                                fontSize: FontSize.s14,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                )));
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
                      MyChargingWidget(char.MyChargers[ind]),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
                itemCount: char.MyChargers.length,
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
                      MyChargingWidget(char.MyChargers[ind]),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
                itemCount: char.MyChargers.length,
              ),
            ),
          ),
        )
      ],
    );
  }
}
