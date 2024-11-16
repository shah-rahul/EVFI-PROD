import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';

Widget customElevatedButton(
    {required BuildContext context,
    required Function() onTap,
    double width = double.infinity,
    double height = 0.0,
    Color? color,
    required String text}) {
  height = (height <= 0) ? MediaQuery.of(context).size.height * 0.05 : height;
  color =
      (color == null) ? ColorManager.primary : ColorManager.primaryWithOpacity;
  return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
              backgroundColor: WidgetStateProperty.all<Color>(color)),
          onPressed: onTap,
          child:
              Text(text, style: Theme.of(context).textTheme.headlineMedium)));
}

Widget customTextButton({
  required BuildContext context,
  required Function() onTap,
  required String text,
}) {
  return TextButton(
      style: Theme.of(context).textButtonTheme.style,
      onPressed: onTap,
      child: Text(text, style: Theme.of(context).textTheme.headlineMedium));
}
