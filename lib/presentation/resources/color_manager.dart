// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#ffd80f"); //app yellow
  static Color appBlack = HexColor.fromHex("#111111"); //app black shade
  static Color lightGrey =
      HexColor.fromHex("#F0F0F0"); //app grey for unselected navbar icons
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color darkGreyOpacity40 = HexColor.fromHex("#313131");
  static Color grey = HexColor.fromHex("#737477");

  //gradients
  static Color gradTopLeft = HexColor.fromHex("#f0f0f0");
  static Color gradBottomRight = HexColor.fromHex("#cacaca");

  //drop shadow
  static Color shadowTopLeft = HexColor.fromHex("#ffffff");
  static Color CardshadowBottomRight = HexColor.fromHex("#d1d1d1");
  static Color shadowBottomRight = HexColor.fromHex("#d9d9d9");

  // new colors
  static Color primaryWithOpacity = ColorManager.primary.withOpacity(0.5);
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color grey3 = HexColor.fromHex("#434343");

  static Color error = HexColor.fromHex("#e61f34"); // red color
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
