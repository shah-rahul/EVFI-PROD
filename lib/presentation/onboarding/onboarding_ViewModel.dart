import 'dart:async';

import '../../domain/model.dart';
import '../base/baseViewModel.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // stream controllers
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;

  int _currentIndex = 0;

  // inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    // send this slider data to our view
    _postDataToView();
  }

  @override
  int goNext() {
    if (_currentIndex + 1 == _list.length) return _currentIndex;
    //int nextIndex = _currentIndex++; // +1
    // if (nextIndex >= _list.length) {
    //   return 0; // infinite loop to go to first item inside the slider
    // }
    return _currentIndex + 1;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--; // -1
    if (previousIndex == -1) {
      _currentIndex =
          _list.length - 1; // infinite loop to go to the length of slider list
    }
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  // outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((slideViewObject) => slideViewObject);

  // private functions
  List<SliderObject> _getSliderData() => [
        SliderObject(AppStrings.onboardingTitle1,
            AppStrings.onboardingSubTitle1, ImageAssets.onboardingLogo1),
        SliderObject(AppStrings.onboardingTitle2,
            AppStrings.onboardingSubTitle2, ImageAssets.onboardingLogo2),
        SliderObject(AppStrings.onboardingTitle3,
            AppStrings.onboardingSubTitle3, ImageAssets.onboardingLogo3),
      ];

  _postDataToView() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}

// inputs mean the orders that our view model will recieve from our view
abstract class OnBoardingViewModelInputs {
  void goNext(); // when user clicks on right arrow or swipe left.
  void goPrevious(); // when user clicks on left arrow or swipe right.
  void onPageChanged(int index);

  Sink
      get inputSliderViewObject; // this is the way to add data to the stream .. stream input
}

// outputs mean data or results that will be sent from our view model to our view
abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}
