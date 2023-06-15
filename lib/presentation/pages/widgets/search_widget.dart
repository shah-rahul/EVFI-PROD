import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../screens/homePage/search_page.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        // Navigator.pushNamed(
        //     context, Routes.searchBarRoute);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SearchPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.072,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        decoration: BoxDecoration(
          color: ColorManager.appBlack,
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Icon(
              Icons.bolt_outlined,
              color: ColorManager.primary,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Search evfi',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            const Spacer(),
            Icon(Icons.search_rounded, color: ColorManager.primary, size: 25)
          ],
        ),
      ),
    );
  }
}
