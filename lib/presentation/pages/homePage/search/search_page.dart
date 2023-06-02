import 'package:flutter/material.dart';
import 'package:EVFI/presentation/resources/assets_manager.dart';
import './toFrom.dart';

class SearchPage extends StatelessWidget {
  const SearchPage();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: mq.padding.top,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: mq.size.height * 0.2,
              child: Card(
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: ToFrom(),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Image(image: AssetImage(ImageAssets.onboardingLogo2))
              )
            ),
            Expanded(
                child: Center(
              child: Text(
                "Search Now",
                style: TextStyle(fontSize: 25),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
