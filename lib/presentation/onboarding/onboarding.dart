import 'package:EVFI/presentation/resources/font_manager.dart';

import '../../domain/model.dart';
import './onboarding_viewmodel.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController _pageController = PageController(initialPage: 0);
  OnBoardingViewModel _viewModel = OnBoardingViewModel();

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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: currentIndex == index ? 20 : 10,
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorManager.appBlack,
          elevation: AppSize.s4,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
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
                              padding: EdgeInsets.all(AppPadding.p8),
                              child: _buildDots(
                                index: sliderViewObject.currentIndex,
                                currentIndex: i,
                              ),
                            ),
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppMargin.m40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.mainRoute);
                          },
                          style: TextButton.styleFrom(
                            elevation: 0,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSize.s18,
                            ),
                          ),
                          child: Text(
                            AppStrings.skip,
                            style: TextStyle(color: ColorManager.appBlack),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            int ind = _viewModel.goNext();
                            ind != sliderViewObject.currentIndex
                                ? _pageController.animateToPage(ind,
                                    duration: Duration(
                                        milliseconds: DurationConstant.d300),
                                    curve: Curves.bounceInOut)
                                : Navigator.of(context)
                                    .pushNamed(Routes.mainRoute);
                          },
                          child: const Text("NEXT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            textStyle: TextStyle(fontSize: AppSize.s18),
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

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  SliderObject _sliderObject;

  OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppMargin.m20),
            child: Image.asset(
              _sliderObject.image,
              width: MediaQuery.of(context).size.width - AppSize.s60,
              height: MediaQuery.of(context).size.height - 600,
              // height: SizeConfig.blockV! * 35,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontConstants.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: AppSize.s20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _sliderObject.subTitle,
            style: TextStyle(
              fontFamily: "Mulish",
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
