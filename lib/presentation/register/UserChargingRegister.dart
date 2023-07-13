import 'dart:io';

import 'package:EVFI/presentation/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class UserChargingRegister extends StatefulWidget {
  const UserChargingRegister({
    Key? key,
  }) : super(key: key);

  @override
  _UserChargingRegisterState createState() => _UserChargingRegisterState();
}

class _UserChargingRegisterState extends State<UserChargingRegister> {
  String _vehicleType = '';
  String _chargingRequirements = '';
  String _vehicleNumber = '';
  File? _idProof;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _idProof = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveUserDetails() async {
    try {
      if (_vehicleType.isEmpty ||
          _chargingRequirements.isEmpty ||
          _vehicleNumber.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Incomplete Details'),
              content: Text('Please fill all required fields.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('UserChargingRegister');

      if (_idProof != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('id_proofs/${DateTime.now()}.jpg');
        await storageRef.putFile(_idProof!);
        final String idProofUrl = await storageRef.getDownloadURL();

        await userCollection.add({
          'vehicleType': _vehicleType,
          'chargingRequirements': _chargingRequirements,
          'vehicleNumber': _vehicleNumber,
          'idProofUrl': idProofUrl,
        });
      } else {
        await userCollection.add({
          'vehicleType': _vehicleType,
          'chargingRequirements': _chargingRequirements,
          'vehicleNumber': _vehicleNumber,
        });
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User details saved successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: MainView(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );

      setState(() {
        _vehicleType = '';
        _chargingRequirements = '';
        _vehicleNumber = '';
        _idProof = null;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while saving user details.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Charging Register'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
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
                setState(() {
                  _vehicleType = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
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
                setState(() {
                  _chargingRequirements = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
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
                setState(() {
                  _vehicleNumber = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select ID Proof Image'),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveUserDetails,
              child: Text('Save Details'),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}


