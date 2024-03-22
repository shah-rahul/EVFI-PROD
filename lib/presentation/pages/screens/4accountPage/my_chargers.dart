import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/strings_manager.dart';
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
          AppStrings.myChargers,
          style: getSemiBoldStyle(color: Colors.black, fontSize: AppSize.s20),
        ),
      ),
      body: _chargerDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      Divider(
                        thickness: 0.45,
                        color: ColorManager.grey,
                      )
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
    return ListTile(
      title: Text(
        chargerInfo['stationName'],
        style: getRegularStyle().copyWith(fontSize: AppSize.s18),
      ),
      subtitle: Text(
        '${chargerInfo['address']}, ${chargerInfo['city']}',
        style: getBoldStyle(color: Colors.black87)
            .copyWith(fontWeight: FontWeight.w300),
      ),
      trailing: Switch(
        value: chargerInfo['status'] == 1,
        activeColor: ColorManager.primary,
        onChanged: onChanged,
      ),
    );
  }
}
