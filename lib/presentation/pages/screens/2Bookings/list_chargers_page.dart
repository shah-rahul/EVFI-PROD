import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class ListChargersPage extends StatelessWidget {
  Function() addCharger;
  ListChargersPage({super.key, required this.addCharger});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          color: ColorManager.appBlack,
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
                  scale: 4.8,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                'rent with\n us',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 5),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                height: height*0.06,
                child: ElevatedButton(
                    onPressed: addCharger,
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: const Text(
                      'proceed to list',
                      style: TextStyle(
                          fontSize: FontSize.s14, fontWeight: FontWeight.w600),
                    )),
              ),
            ],
          )),
    );
  }
}
