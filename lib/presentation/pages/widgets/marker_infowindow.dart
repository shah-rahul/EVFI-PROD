// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';
import 'package:evfi/presentation/storage/booking_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../storage/UserDataProvider.dart';
import '../../register/UserChargingRegister.dart';
import '../../resources/values_manager.dart';
import '../../resources/color_manager.dart';

bool? isRegistered;

/*RadioButtons*/
enum ChargerTypes { A, B, C }

ChargerTypes? selectedType = ChargerTypes.A;
/*RadioButtons*/

/*Dropdown*/
String selectedTime = '10:00 AM - 11:00 AM';
List<String> timings = [
  '09:00 AM - 10:00 AM',
  '10:00 AM - 11:00 AM',
  '11:00 AM - 12:00 AM',
  '12:00 PM - 01:00 PM',
  '01:00 PM - 02:00 PM',
  '02:00 PM - 03:00 PM',
  '03:00 PM - 04:00 PM',
  '04:00 PM - 05:00 PM',
  '05:00 PM - 06:00 PM'
];
/*Dropdown*/

class CustomMarkerPopup extends StatefulWidget {
  final GeoPoint geopoint;
  final String geohash;
  final String stationName;
  final String address;
  final List<dynamic> imageUrl;
  final double costOfFullCharge;
  final String timeStamp;
  final String chargerId;
  final String providerId;
  //take input of chargerType as well from firebase fetching to show charger level

  const CustomMarkerPopup(
      {required this.stationName,
      required this.address,
      required this.imageUrl,
      required this.geopoint,
      required this.geohash,
      required this.costOfFullCharge,
      required this.timeStamp,
      required this.chargerId,
      required this.providerId});

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
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(ColorManager.primary),
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
                    // Charging newRequest = Charging(
                    //     stationName: widget.stationName,
                    //     stationAddress: widget.address,
                    //     slotChosen: widget.timeStamp,
                    //     amount: widget.costOfFullCharge,
                    //     position: LatLng(widget.geopoint.latitude,
                    //         widget.geopoint.longitude),
                    //     status: 1,
                    //     type: ChargerTypes.A.index);
                    return (isBooking)
                        ? bookingSection(context, onchanRadio)//, newRequest)
                        : startingSection(
                            context, widget.costOfFullCharge, widget.timeStamp);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookingSection(BuildContext context,
      void Function(ChargerTypes val) onchanRadio) {
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
                  title: const Text('Type A',
                      style: TextStyle(color: Colors.black)),
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
                  title: const Text('Type B',
                      style: TextStyle(color: Colors.black)),
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
              icon:
                  const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
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
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageTransition(
                    //       type: PageTransitionType.rightToLeft,
                    //       child: const PaymentScreen()),
                    // ).then((_) {
                    BookingDataProvider(
                        providerId: widget.providerId,
                        chargerId: widget.chargerId,
                        price: widget.costOfFullCharge,
                        timeSlot: selectedTime);
                    // Provider.of<UserChargings>(context, listen: false)
                    //     .addCharging(chargingRequest);
                    Navigator.pop(context);
                    // });
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
}

Widget startingSection(BuildContext context, double cost, String timeStamp) {
  return Column(
    children: [
      Row(children: [
        const Icon(Icons.access_time),
        // Padding(
        //     padding: const EdgeInsets.all(AppPadding.p12 - 8),
        //     child: Text('$w'),
        Text('\t $timeStamp'),
        Spacer(),
        Text("₹ $cost", style: TextStyle(fontWeight: FontWeight.bold))
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
  final collectionRef = firestore.collection('UserChargingRegister');
  bool isNumberRegistered = false;
  // storePhoneNumber(number);

  try {
    final querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      final phoneNumber = doc.data()['PhoneNumber'].toString();

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
