import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/styles_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class MyChargersScreen extends StatefulWidget {
  List<dynamic> chargers;
  MyChargersScreen({Key? key, required this.chargers}) : super(key: key);

  @override
  State<MyChargersScreen> createState() => _MyChargersScreenState();
}

class _MyChargersScreenState extends State<MyChargersScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _chargerDetails = [];

  @override
  void initState() {
    super.initState();
    fetchChargerDetails();
  }

  Future<void> fetchChargerDetails() async {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> chargerDetails = [];

    for (var chargerId in widget.chargers) {
      final QuerySnapshot<Map<String, dynamic>> chargersSnapshot =
          await FirebaseFirestore.instance
              .collection('chargers')
              .where('chargerId', isEqualTo: chargerId)
              .limit(1)
              .get();

      if (chargersSnapshot.docs.isNotEmpty) {
        chargerDetails.add(chargersSnapshot.docs.first);
      }
    }

    setState(() {
      _chargerDetails = chargerDetails;
    });
  }

  void toggleChargerStatus(String chargerId, bool newValue) async {
    await FirebaseFirestore.instance
        .collection('chargers')
        .doc(chargerId)
        .update({'info.status': newValue ? 1 : 0});
    await fetchChargerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.black,
        backgroundColor: ColorManager.primary,
        title: Text(
          "My Chargers",
          style: getSemiBoldStyle(
              color: Colors.black,
              fontSize: AppSize.s20,
              fontFamily: 'fonts/Poppins'),
        ),
      ),
      body: _chargerDetails.isEmpty
          ? const Center(child: Text('You do not have any chargers'))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView.builder(
                itemCount: _chargerDetails.length,
                itemBuilder: (context, index) {
                  final charger = _chargerDetails[index];
                  final chargerData = charger.data();
                  final chargerInfo = chargerData['info'];
                  final chargerId = chargerData['chargerId'];

                  return Column(
                    children: [
                      ChargerTile(
                        chargerInfo: chargerInfo,
                        onChanged: (newValue) {
                          toggleChargerStatus(chargerId, newValue);
                        },
                      ),
                      const SizedBox(height: AppSize.s4),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

class ChargerTile extends StatelessWidget {
  final Map<String, dynamic> chargerInfo;
  final ValueChanged<bool>? onChanged;

  const ChargerTile({
    Key? key,
    required this.chargerInfo,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppMargin.m12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chargerInfo['stationName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.s18,
                    fontFamily: 'fonts/Poppins',
                  ),
                ),
                // Switch(
                //   value: chargerInfo['status'] == 1,
                //   activeColor: ColorManager.primary,
                //   onChanged: onChanged,
                // ),
                Text(
                  chargerInfo['status'] == 1 ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    color:
                        chargerInfo['status'] == 1 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'fonts/Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s4),
            Text(
              '${chargerInfo['address']}, ${chargerInfo['city']}',
              style: const TextStyle(
                  fontSize: AppSize.s14, fontFamily: 'fonts/Poppins'),
            ),
            const SizedBox(height: AppSize.s4),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: AppMargin.m20,
                  color: index < 3 ? Colors.yellow : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
