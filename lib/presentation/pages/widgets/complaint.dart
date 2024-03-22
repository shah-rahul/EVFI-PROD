import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Complaint extends StatefulWidget {
  const Complaint({
    required this.chargerId,
    required this.chargerName,
  });
  final String chargerId;
  final String chargerName;

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  bool _isWorking = true;
  final commentFocusNode = FocusNode();
  TextEditingController commentController = TextEditingController();
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('complaints');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        setState(() {});
      }
    });
  }

  void submit() {
    print("charger status is : ${_isWorking}");
    print("The complaint is : ${commentController.text}");
    print("The user id is : ${_user!.uid}");

    reviewCollection.add({
      'chargerId': widget.chargerId,
      'description': commentController.text,
      'userId': _user!.uid,
    }).then((value) {
      print('Data stored successfully in Firestore');
      Navigator.pop(context);
    }).catchError((error) {
      print('Failed to store data in Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complaint',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: ColorManager.primary,
      ),
      body: Container(
        width: width * 0.96,
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //CHARGER IMAGES...........................................................
            const Text(
              "Add Photo",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.s20,
                  fontFamily: 'fonts/Poppins'),
            ),
            const SizedBox(height: AppMargin.m18),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsetsDirectional.all(width * 0.025),
                  height: height * 0.06,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    border: Border.all(width: 1.5, color: Colors.black26),
                  ),
                  child: const Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.camera_alt_outlined,
                        size: AppSize.s28,
                      ),
                      SizedBox(width: AppMargin.m8),
                      Text(
                        'Camera',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.s20,
                            fontFamily: 'fonts/Poppins'),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                const SizedBox(width: AppMargin.m8),
                Container(
                  padding: EdgeInsetsDirectional.all(width * 0.025),
                  height: height * 0.06,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    border: Border.all(width: 1.5, color: Colors.black26),
                  ),
                  child: const Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.image,
                        size: AppSize.s28,
                      ),
                      SizedBox(width: AppMargin.m8),
                      Text(
                        'Gallery',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.s20,
                            fontFamily: 'fonts/Poppins'),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s4),
            const Text(
                "Upload photos related to the chargers like its working, usage,etc."),
            const SizedBox(height: AppMargin.m40),
            //RADIO-BUTTONS..........................................................
            const Text(
              "Charger Status",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.s20,
                  fontFamily: 'fonts/Poppins'),
            ),
            const SizedBox(height: AppMargin.m14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text(
                      "Working",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: AppSize.s18,
                          fontFamily: 'fonts/Poppins'),
                    ),
                    value: true,
                    activeColor: Colors.black,
                    groupValue: _isWorking,
                    onChanged: (value) {
                      setState(() {
                        _isWorking = value as bool;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(
                      "Not Working",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: AppSize.s18,
                          fontFamily: 'fonts/Poppins'),
                    ),
                    value: false,
                    activeColor: Colors.black,
                    groupValue: _isWorking,
                    onChanged: (value) {
                      setState(() {
                        _isWorking = value as bool;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppMargin.m20),
            //TEXTAREA................................................................
            const Text(
              "Complaint Description",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.s20,
                  fontFamily: 'fonts/Poppins'),
            ),
            const SizedBox(height: AppMargin.m14),
            Card(
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: TextFormField(
                controller: commentController,
                style: TextStyle(color: ColorManager.darkGrey),
                decoration: const InputDecoration(
                    hintText: 'Enter your complaint',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                focusNode: commentFocusNode,
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            const SizedBox(height: AppMargin.m20),
            //SUBMIT BUTTON............................................................
            GestureDetector(
              onTap: submit,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorManager.primary,
                ),
                child: const Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppSize.s18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'fonts/Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
