import 'package:EVFI/presentation/pages/screens/accountPage/payments.dart';
import 'package:EVFI/presentation/resources/color_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
//import '../../../resources/color_manager.dart';
import '../../../register/UserChargingRegister.dart';
import '../../../resources/values_manager.dart';

bool isRegistered = false;

enum ChargerTypes { A, B, C }

ChargerTypes? selectedType = ChargerTypes.A;

List<String> timings = [
  '10:00-11:00',
  '11:00-12:00',
  '12:00-01:00',
  '01:00-02:00',
  '02:00-03:00',
  '03:00-04:00',
  '04:00-05:00'
];
String selectedTime = '10:00-11:00';

class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName = 'EVFI Charging Station';
  final String address =
      'Sector 39, Karnal, NH-1, GT Karnal Road,, Haryana, 132001';

  const CustomMarkerPopup({required this.geopoint, required this.geohash});

  @override
  State<CustomMarkerPopup> createState() => _CustomMarkerPopupState();
}

class _CustomMarkerPopupState extends State<CustomMarkerPopup> {
  bool isBooking = false;
  String str = 'Book Slot';

  void onchanRadio(ChargerTypes val) {
    setState(() {
      selectedType = val;
    });
  }

  Widget callContent() {
    if (isBooking) {
      print('content cancel');
      return bookingSection(context, onchanRadio);
    } else {
      print('content bookslot');
      return startingSection(context);
    }
  }

  void changecontent() {
    if (isRegistered) {
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: UserChargingRegister()),
      );
    } else {
      print('hellooooooo');
      isBooking = !isBooking;
      if (!isBooking) {
        str = 'Book Slot';
      } else {
        str = 'Back';
      }
      setState(() {});
      print('hiiií');
      print(isBooking);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(15),
              topEnd: Radius.circular(15),
            )
            //borderRadius: BorderRadius.circular(15),
            ),
        height: 300,
        child:
            //Card(
            //shadowColor: ColorManager.CardshadowBottomRight,
            // shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.only(
            //   topStart: Radius.circular(15),
            //   topEnd: Radius.circular(15),
            // )),
            // elevation: 4,
            // color: Colors.yellow.withOpacity(0.6),
            // child:
            Padding(
          padding: const EdgeInsets.all(AppMargin.m12 - 1),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //1st column
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //const Icon(Icons.electric_bolt_sharp, size: 20),
                //const SizedBox(width: 3),
                Text(
                  widget.stationName,
                  style: const TextStyle(
                      fontSize: AppSize.s20, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 30,
                  width: 95,
                  child: ElevatedButton(
                    onPressed: changecontent,
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.amber)),
                    child: Text(
                      str,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            //2nd column
            const SizedBox(
              height: 10,
            ),
            //3rd column
            Text(widget.address, style: const TextStyle(fontSize: AppSize.s12)),
            //4th column
            const SizedBox(
              height: 8,
            ),
            //5th column.........................................................
            //startingSection(context),
            callContent(),
            //6th column.........................................................
          ]),
        ),
        //),
      ),
    );
  }
}

Widget bookingSection(BuildContext context, void Function(ChargerTypes val) onchanRadio) {
  return Card(
    shadowColor: ColorManager.CardshadowBottomRight,
    shape: const RoundedRectangleBorder(
        //side: BorderSide(color: Colors.black12),
        borderRadius: BorderRadiusDirectional.all(
      Radius.circular(15),
    )),
    elevation: 4,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Row(
          children: [
            SizedBox(width: 14),
            Text('Select your Charger Type',
                style: TextStyle(
                    fontSize: AppSize.s14, fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: RadioListTile<ChargerTypes>(
                contentPadding: const EdgeInsets.all(0.0),
                value: ChargerTypes.A,
                title:
                    const Text('Type A', style: TextStyle(color: Colors.black)),
                dense: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                activeColor: Colors.amber,
                groupValue: selectedType,
                onChanged: (value) {
                  onchanRadio(value!);
                  //selectedType = value;
                },
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: RadioListTile<ChargerTypes>(
                contentPadding: const EdgeInsets.all(0.0),
                value: ChargerTypes.B,
                title:
                    const Text('Type B', style: TextStyle(color: Colors.black)),
                dense: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                activeColor: Colors.amber,
                groupValue: selectedType,
                onChanged: (value) {
                  onchanRadio(value!);
                  //selectedType = value;
                },
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: RadioListTile<ChargerTypes>(
                contentPadding: const EdgeInsets.all(0.0),
                value: ChargerTypes.C,
                title: const Text(
                  'Type C',
                  style: TextStyle(color: Colors.black),
                ),
                dense: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                activeColor: Colors.amber,
                groupValue: selectedType,
                onChanged: (value) {
                  onchanRadio(value!);
                  //selectedType = value;
                },
              ),
            ),
          ],
        ),
        DropdownButtonFormField<String>(
          value: selectedTime,
          icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
          dropdownColor: Colors.amber.shade100,
          padding: const EdgeInsets.all(8),
          elevation: 4,
          decoration: const InputDecoration(
            labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: AppMargin.m14),
            labelText: "Time Slot",
            border: UnderlineInputBorder(),
          ),
          items: timings.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            selectedTime = value!;
          },
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 35,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const PaymentScreen()),
                    );
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 84, 194, 87))),
                child: const Text(
                  'Proceed to Pay',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    ),
  );
}

Widget startingSection(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          const Icon(Icons.access_time),
          Padding(
              padding: const EdgeInsets.all(AppPadding.p12 - 8),
              child: Text(DateTime.now().toString())),
        ],
      ),
      const SizedBox(height: 1),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Charging Type : Fast',
              style: TextStyle(fontSize: AppSize.s12)),
          const SizedBox(width: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Ratings: ', style: TextStyle(fontSize: AppSize.s12)),
              RatingBarIndicator(
                rating: 4, //myCharging.ratings,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/map/carphoto.jpeg',
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}
