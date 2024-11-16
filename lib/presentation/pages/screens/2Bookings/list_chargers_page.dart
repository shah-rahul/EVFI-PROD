import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:evfi/presentation/resources/routes_manager.dart';
import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class ListChargersPage extends StatelessWidget {
  const ListChargersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          color: ColorManager.appBlack.withOpacity(0.967),
          height: height,
          width: width,
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: height * 0.12,
                    ),
                child: Image.asset(
                  ImageAssets.listCharger,
                  // scale: height * 0.006,
                  height: height*0.42,
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                AppStrings.chargerTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s28,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 5),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              SizedBox(
                width: double.infinity,
                height: height*0.06,
                child: ElevatedButton(
                  onPressed: () {
                  Navigator.of(context).pushNamed(Routes.listChargerFormRoute);
                },
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: const Text(
                      AppStrings.chargerButton,
                      style: TextStyle(
                          fontSize: FontSize.s14, fontWeight: FontWeight.w600),
                    )),
              ),
            ],
          )),
    );
  }
}
