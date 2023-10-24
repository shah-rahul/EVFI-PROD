// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import './color_manager.dart';
import './font_manager.dart';
import './styles_manager.dart';
import './values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      //appwide font
      fontFamily: 'Poppins',

      // main colors of the app
      primaryColor: ColorManager.primary,
      primaryColorLight: ColorManager.primaryWithOpacity,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager.grey1,
      // ripple color
      splashColor: ColorManager.primaryWithOpacity,
      // will be used incase of disabled button for example
      hintColor: ColorManager.grey,

      // card view theme
      cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: ColorManager.grey,
          elevation: AppSize.s4),
      // App bar theme
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.primary,
          elevation: AppSize.s4,
          shadowColor: ColorManager.primaryWithOpacity,
          titleTextStyle:
              getRegularStyle(color: Colors.white, fontSize: FontSize.s16)),


      // text Button theme
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        backgroundColor: ColorManager.primary,
        foregroundColor: ColorManager.appBlack,
      )),

      // elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              foregroundColor: ColorManager.appBlack,
              elevation: 6,
              shadowColor: ColorManager.primaryWithOpacity,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)))),

      // Text theme
      textTheme: TextTheme(
          headlineMedium: getSemiBoldStyle(
              color: ColorManager.appBlack, fontSize: FontSize.s18),
          headlineSmall: getSemiBoldStyle(
              color: ColorManager.appBlack, fontSize: FontSize.s16),
          titleSmall: getSemiBoldStyle(
              color: ColorManager.appBlack,
              fontFamily: FontConstants.appTitleFontFamily,
              fontSize: FontSize.s20),
          bodyMedium: getMediumStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s14),
          bodySmall: getRegularStyle(color: ColorManager.grey)),

      // input decoration theme (text form field)
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle: getRegularStyle(color: ColorManager.grey1),

        // label style
        labelStyle: getMediumStyle(color: ColorManager.darkGrey),
        // error style
        errorStyle: getRegularStyle(color: ColorManager.error),

        // enabled border
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),

        // focused border
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused error border
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
      ));
}
