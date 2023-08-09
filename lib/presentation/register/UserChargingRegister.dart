// ignore_for_file: library_private_types_in_public_api, unused_field, file_names, deprecated_member_use, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:evfi/presentation/Data_storage/UserDataProvider.dart';
import 'package:evfi/presentation/main/main_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Data_storage/UserData.dart';

class UserChargingRegister extends StatefulWidget {
  const UserChargingRegister({
    Key? key,
  }) : super(key: key);

  @override
  _UserChargingRegisterState createState() => _UserChargingRegisterState();
}

class _UserChargingRegisterState extends State<UserChargingRegister> {
  File? _idProof;
  final databaseRef = FirebaseDatabase.instance.ref('UserChargingRegister');
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _idProof = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    void updateData(String manufacturer, String number, String Requirements) {
      UserData userData = userDataProvider.userData;
      // userData.vehicleManufacturer = manufacturer;
      // userData.vehicleNumber = number;
      // userData.chargingRequirements = Requirements;
      userData.level2 = true;
      userDataProvider.setUserData(userData);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Charging Register'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Vehicle Type',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                updateData(value, " ", " ");
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Charging Requirements',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                // updateData(
                //     userDataProvider.userData.vehicleManufacturer, " ", value);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Vehicle Number',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                // updateData(userDataProvider.userData.vehicleManufacturer, value,
                //     userDataProvider.userData.chargingRequirements);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Vehicle Mileage(Range)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                // updateData(userDataProvider.userData.vehicleManufacturer, value,
                //     userDataProvider.userData.chargingRequirements);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Vehicle Battery Capacity',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                // updateData(userDataProvider.userData.vehicleManufacturer, value,
                //     userDataProvider.userData.chargingRequirements);
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: const Text('Select ID Proof Image',
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await userDataProvider.saveUserData();
                // await userDataProvider.saveUserData();
                // UserData? userData = userDataProvider.userData;
                // userDataProvider.setUserData(userData);

                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      ctx: context,
                      child: MainView()),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: const Text('Save Details',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
