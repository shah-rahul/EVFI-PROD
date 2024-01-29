// ignore_for_file: library_private_types_in_public_api, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:page_transition/page_transition.dart';
import '../../domain/model.dart';
import '../onboarding/onboarding_ViewModel.dart';
import '../register/vehicleform.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController(initialPage: 0);
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _viewModel.outputSliderViewObject,
        builder: (context, snapShot) {
          return _getContentWidget(snapShot.data);
        });
  }

  AnimatedContainer _buildDots({
    int? currentIndex,
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: ColorManager.primary,
      ),
      margin: const EdgeInsets.only(right: 5,top: 60),
      height: 10,
      curve: Curves.easeIn,
      width: currentIndex == index ? 20 : 10,
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    final height = MediaQuery.of(context).size.height;
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.appBlack,
        // appBar: AppBar(
        //   backgroundColor: ColorManager.appBlack,
        //   elevation: AppSize.s4,
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.white,
        //     statusBarBrightness: Brightness.dark,
        //     statusBarIconBrightness: Brightness.dark,
        //   ),
        // ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: sliderViewObject.numOfSlides,
                  onPageChanged: (index) {
                    _viewModel.onPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    return OnBoardingPage(sliderViewObject.sliderObject);
                  }),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < sliderViewObject.numOfSlides; i++)
                            Padding(
                              padding: const EdgeInsets.all(AppPadding.p8),
                              child: _buildDots(
                                index: sliderViewObject.currentIndex,
                                currentIndex: i,
                              ),
                            ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                              Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 25, vertical: 15),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: AppSize.s18
                            ),
                              backgroundColor: ColorManager.appBlack
                          ),
                          child: Row(
                            children: <Widget>[
                            Icon(Icons.chevron_left,size: 30,color: ColorManager.primary),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // int ind = _viewModel.goNext();
                            // // print("---------------");
                            // //  print(ind);
                            // ind != sliderViewObject.currentIndex
                            //     ? _pageController.animateToPage(ind,
                            //         duration: const Duration(
                            //             milliseconds: DurationConstant.d300),
                            //         curve: Curves.bounceInOut)
                            //     : Navigator.of(context)
                            //         .pushNamed(Routes.mainRoute);
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: VehicleForm()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.appBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 0,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 25, vertical: 15),
                            textStyle: const TextStyle(fontSize: AppSize.s18,fontWeight: FontWeight.w300),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.chevron_right,size: 30,color: ColorManager.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;

  const OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppMargin.m20),
            child: Image.asset(
              _sliderObject.image,
              width: MediaQuery.of(context).size.width - 80,
              height: MediaQuery.of(context).size.height - 480,
              // height: SizeConfig.blockV! * 35,
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontConstants.bodyFontFamily,
              fontWeight: FontWeight.w600,
                fontSize: AppSize.s28,
                color: ColorManager.primary
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _sliderObject.subTitle,
            style: TextStyle(
              fontFamily: FontConstants.appTitleFontFamily,
              fontWeight: FontWeight.w300,
              fontSize: AppSize.s28,
                color: ColorManager.primary
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
