import 'dart:convert';

import 'package:flutter/material.dart';

enum States {
  AndhraPradesh,
  Assam,
  Bihar,
  Chhattisgarh,
  Delhi,
  Goa,
  Gujarat,
  Haryana,
  HimachalPradesh,
  Jharkhand,
  Karnataka,
  Kerala,
  MadhyaPradesh,
  Maharashtra,
  Manipur,
  Meghalaya,
  Mizoram,
  Nagaland,
  Odisha,
  Punjab,
  Rajasthan,
  Sikkim,
  TamilNadu,
  Telangana,
  Tripura,
  UttarPradesh,
  Uttarakhand,
  WestBengal
}

const List<double> Tarrifs = [
  9.95,
  7.15,
  8.05,
  4.85,
  8.00,
  4.25,
  5.20,
  7.10,
  5.45,
  4.25,
  8.15,
  7.90,
  6.65,
  11.82,
  6.75,
  5.90,
  6.00,
  7.00,
  6.20,
  6.63,
  7.95,
  4.00,
  6.60,
  9.50,
  7.20,
  7.00,
  6.25,
  8.99
];

List<String> EVs = [
  'Kia Soul' 'Tata Tiago',
  'Tata Tigor',
  'Tata Nexon',
  'MG Comet'
];

class MyPricing {
  Map<States, double> costPerKWH = {};
  MyPricing() {
    for (var i = 0; i < States.values.length; i++) {
      States st = States.values[i];
      costPerKWH[st] = Tarrifs[i];
    }
  }

  double xDistCost(double batteryCap, String state, double range, double dist) {
    States myState = States.Delhi;
    for (var i = 0; i < States.values.length; i++) {
      if (States.values[i].toString() == state) {
        myState = States.values[i];
      }
    }
    return (batteryCap / range) * dist * (costPerKWH[myState]!);
  }

  int fullChargeCost(double batteryCap, String state) {
    States myState = States.Delhi;
    for (var i = 0; i < States.values.length; i++) {
      if (States.values[i].toString().split('.')[1] == state) {
        myState = States.values[i];
      }
    }
    print(state);
    double cost = double.parse((batteryCap * (costPerKWH[myState]!)).toStringAsFixed(2));
    print("cost");
    print(cost);
    return cost.toInt();
  }
}


//   var batteryCapacity = TextEditingController();

//   var mileage = TextEditingController();

//   var distance = TextEditingController();

//   Widget _makeField(
//       String heading, String label, TextEditingController controller) {
//     return Row(
//       children: [
//         Text(
//           heading,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//         ),
//         const SizedBox(
//           width: 20,
//         ),
//         Expanded(
//           child: TextFormField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'in $label',
//                 focusedBorder: OutlineInputBorder(),
//                 suffixIcon: controller.text.isEmpty
//                     ? Container(width: 0)
//                     : IconButton(
//                         onPressed: () => controller.clear(),
//                         icon: const Icon(
//                           Icons.close,
//                         ),
//                       ),
//               )),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Home EV Charging Calculator'),
//           backgroundColor: Colors.deepPurpleAccent,
//         ),
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: double.infinity,
//           child: Column(children: [
//             const SizedBox(
//               height: 50,
//             ),
//             _makeField('Battery Capacity', 'kWh', batteryCapacity),
//             _makeField('Mileage/Range', 'Km', mileage),
//             _makeField('Distance', 'Km', distance),
//             const SizedBox(
//               height: 50,
//             ),
//             //Kia Soul EV has Battery Capacity: 64kWh, Mileage: 315Km
//             ElevatedButton(
//                 onPressed: () {
//                   double bCap = double.parse(batteryCapacity.text);
//                   double range = double.parse(mileage.text);
//                   double dist = double.parse(distance.text);
//                   print(
//                       '-----------Using standard 3.2 kWh charger for Andhra Pradesh ');
//                   double priceForDist = 0, priceForFullCharge = 0;
//                   priceForDist =
//                       (bCap / range) * dist * costPerKWH[States.AndhraPradesh]!;
//                   priceForFullCharge = bCap * costPerKWH[States.AndhraPradesh]!;
//                   debugPrint(
//                       '**Price to travel $dist km using any EV: ${priceForDist.toStringAsFixed(2)}');
//                   debugPrint(
//                       '**Price for a full charge of $bCap kWh battery EV: ${priceForFullCharge.toStringAsFixed(2)}');
//                 },
//                 child: const Text('Calculate'))
//           ]),
//         ),
//       ),
//     );
//   }
// }
