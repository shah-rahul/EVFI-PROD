// import 'package:evfi/presentation/login/login1.dart';
import 'package:evfi/presentation/register/UserChargingRegister.dart';
import 'package:evfi/presentation/register/chargerform.dart';
import 'package:flutter/material.dart';

import '../login/login.dart';
import '../main/main_view.dart';
import '../onboarding/onboarding.dart';
import '../register/register.dart';
import '../resources/strings_manager.dart';
import '../splash/splash.dart';
import '../pages/screens/1homePage/search_page.dart';
import '../store_details/store_details.dart';
import '../register/vehicleform.dart';
import '../pages/screens/3Chargings/MyChargingScreen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
  static const String verifyOtpRoute = "/verify_otp";
  static const String searchPageRoute = "/searchPage";
  static const String myChargingRoute = "/myCharging";
  // ignore: constant_identifier_names
  static const String vehicleRegisterForm = "/VehicleRegisterForm";
  static const String chargerForm = "/chargerForm";
  static const String UserChargingRegister = "/UserChargingRegister";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) =>  LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.registerRoute:
        return MaterialPageRoute(
            builder: (_) => RegisterView(
                  phoneNumber: '',
                ));
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(builder: (_) => const StoreDetailsView());
      // case Routes.verifyOtpRoute:
      //   return MaterialPageRoute(builder: (_) => const verify_otp());
      case Routes.myChargingRoute:
        return MaterialPageRoute(builder: (_) => const MyChargingScreen());
      case Routes.UserChargingRegister:
        return MaterialPageRoute(builder: (_) => const UserChargingRegister());
      case Routes.searchPageRoute:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case Routes.vehicleRegisterForm:
        return MaterialPageRoute(builder: (_) => const VehicleForm());
      case Routes.chargerForm:
        return MaterialPageRoute(builder: (_) => const ChargerForm());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
