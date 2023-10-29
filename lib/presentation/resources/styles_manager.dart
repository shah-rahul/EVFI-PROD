import 'package:flutter/material.dart';

import './font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String bodyFontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: bodyFontFamily,
      color: color,
      fontWeight: fontWeight);
}

// regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s16, Color color = Colors.black}) {
  return _getTextStyle(
      fontSize, FontConstants.bodyFontFamily, FontWeightManager.semiBold, color);
}
// light text style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.bodyFontFamily, FontWeightManager.light, color);
}
// bold text style

TextStyle getBoldStyle(
    {double fontSize = FontSize.s14, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.bodyFontFamily, FontWeightManager.bold, color);
}

// semi bold text style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12, String fontFamily = FontConstants.bodyFontFamily, required Color color}) {
  return _getTextStyle(
      fontSize, fontFamily, FontWeightManager.semiBold, color);
}


// medium text style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.bodyFontFamily, FontWeightManager.medium, color);
}










