import 'package:flutter/material.dart';
import 'package:EVFI/presentation/resources/assets_manager.dart';

import './toFrom.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: mq.size.height * 0.25,
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: const ToFrom(),
                ),
              ),
            ),
            const Expanded(
                child: Center(
                    child: Image(
                        image: AssetImage(ImageAssets.onboardingLogo2)))),
            const Expanded(
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
