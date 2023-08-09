// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:evfi/presentation/pages/screens/accountPage/payments.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../Data_storage/UserData.dart';
import '../../Data_storage/UserDataProvider.dart';
import '../../register/UserChargingRegister.dart';
import './../models/pricing_model.dart';
import '../../resources/values_manager.dart';

bool? isRegistered;

/*RadioButtons*/
enum ChargerTypes { A, B, C }

ChargerTypes? selectedType = ChargerTypes.A;
/*RadioButtons*/

/*Dropdown*/
String selectedTime = '10:00-11:00';
List<String> timings = [
  '10:00-11:00',
  '11:00-12:00',
  '12:00-01:00',
  '01:00-02:00',
  '02:00-03:00',
  '03:00-04:00',
  '04:00-05:00',
];
/*Dropdown*/

class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName;
  final String address;
  final String imageUrl;
  final double costOfFullCharge;
  //final String stationName = 'EVFI Charging Station';
  //final String address =
  //'Sector 39, Karnal, NH-1, GT Karnal Road,, Haryana, 132001';

  const CustomMarkerPopup({
    required this.stationName,
    required this.address,
    required this.imageUrl,
    required this.geopoint,
    required this.geohash,
    required this.costOfFullCharge,
  });

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
      return bookingSection(context, onchanRadio);
    } else {
      return startingSection(context, widget.costOfFullCharge);
    }
  }

  void changecontent(bool isRegistered) {
    if (isRegistered) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const UserChargingRegister(),
        ),
      );
    } else {
      setState(() {
        isBooking = !isBooking;
        if (!isBooking) {
          str = 'Book Slot';
        } else {
          str = 'Back';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    UserData userData = userDataProvider.userData;
    userDataProvider.setUserData(userData);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(15),
            topEnd: Radius.circular(15),
          ),
        ),
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(AppMargin.m12 - 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.stationName,
                    style: const TextStyle(
                      fontSize: AppSize.s20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 95,
                    child: ElevatedButton(
                      onPressed: () {
                        changecontent(isRegistered!);
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.amber),
                      ),
                      child: Text(
                        str,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.address,
                style: const TextStyle(fontSize: AppSize.s12),
              ),
              const SizedBox(height: 8),
              FutureBuilder<bool>(
                future: checkNumberIsRegistered(
                  number: userDataProvider.userData.phoneNumber,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: 150,
                        alignment: Alignment.center,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return const Text('Error occurred');
                  } else {
                    isRegistered = snapshot.data;
                    return callContent();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget bookingSection(
    BuildContext context, void Function(ChargerTypes val) onchanRadio) {
  return Card(
    shadowColor: ColorManager.CardshadowBottomRight,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(
      Radius.circular(15),
    )),
    elevation: 4,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          // ignore: prefer_const_literals_to_create_immutables
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: DropdownButtonFormField<String>(
            value: selectedTime,
            icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
            dropdownColor: Colors.amber.shade100,
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
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
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

Widget startingSection(BuildContext context, double cost) {
  return Column(
    children: [
      Row(children: [
        const Icon(Icons.access_time),
        Padding(
            padding: const EdgeInsets.all(AppPadding.p12 - 8),
            child: Text(DateTime.now().toString())),
        Spacer(),
        Text("₹ " + cost.toString(),
            style: TextStyle(fontWeight: FontWeight.bold))
      ]),
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
          height: 155,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

Future<bool> checkNumberIsRegistered({required String number}) async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('Registered number');
  bool isNumberRegistered = false;
  // storePhoneNumber(number);

  try {
    final querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      final phoneNumber = doc.data()['phoneNo'].toString();

      if (number == phoneNumber) {
        isNumberRegistered = true;
        break;
      } else {
        return false;
        // storePhoneNumber(number);
      }
    }

    return isNumberRegistered;
  } catch (e) {
    return false;
  }
}
