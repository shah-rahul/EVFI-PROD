import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/login/login.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/payments.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/profilesection.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/settings.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/user_profile.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../4accountPage/new_station.dart';

String username = "Mr. evfi";
String firstname = "";
String lastname = "";
String email = "";
String phoneNo = "";
File? clickedImage;
String country = "";
String state = "";
String city = "";
String pincode = "";
List<dynamic> user_images = [];

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in, fetch user data from Firestore
        _fetchUserData(user.uid);
        setState(() {});
      }
    });
  }

  Future<void> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(userId).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _user = auth.currentUser;
        username = userData['firstName'] + " " + userData['lastName'];
        phoneNo = userData['phoneNumber'];
        firstname = userData['firstName'];
        lastname = userData['lastName'];
        email = userData['email'];
        country = userData['country'];
        state = userData['state'];
        city = userData['city'];
        pincode = userData['pinCode'];
        //clickedImage = userData['userImage'];
        user_images = userData['userImage'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void editProfile() async {
    final newDetails =
        await Navigator.of(context).push<UserProfile>(MaterialPageRoute(
      builder: (context) => EditProfileScreen(
        name: username,
        email: email,
        phoneNo: phoneNo,
        firstname: firstname,
        lastname: lastname,
        country: country,
        state: state,
        city: city,
        pincode: pincode,
      ),
    ));
    if (newDetails == null) {
      return;
    }
    setState(() {
      username = newDetails.name;
      email = newDetails.email;
      clickedImage = newDetails.image;
    });
  }

  void clickPayment() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PaymentScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Section',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: width * 0.96,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //1st column......
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            GestureDetector(
              onTap: editProfile,
              child: Container(
                child: profileSection(context),
              ),
            ),
            //2nd column.......
            SizedBox(height: height * 0.03),
            //3rd column.......
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //3members in this row
                serviceSection(context, Icons.charging_station, 'Chargers'),
                SizedBox(width: width * 0.04),
                GestureDetector(
                    onTap: clickPayment,
                    child:
                        serviceSection(context, Icons.credit_card, 'Payments')),
                SizedBox(width: width * 0.04),
                serviceSection(context, Icons.drive_eta, 'Bookings'),
              ],
            ),
            //4th column
            SizedBox(height: height * 0.03),
            //5th column
            GestureDetector(
              child: settingSection(context, Icons.settings, 'Settings'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
            ),
            //6th column
            SizedBox(height: height * 0.03),
            //7th column
            settingSection(context, Icons.question_mark, 'Support'),
            //8th column
            SizedBox(height: height * 0.03),
            //9th column
            GestureDetector(
              onTap: () async {
                await signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              child: settingSection(context, Icons.logout, 'Logout'),
            ),
            //10th column
            SizedBox(height: height * 0.03),
            GestureDetector(
                onTap: _addStation,
                child: settingSection(
                    context, Icons.location_on_outlined, 'Add Station')),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _addStation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.amberAccent[80],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (_) => GestureDetector(
        onTap: null,
        behavior: HitTestBehavior.opaque,
        child: const NewStation(),
      ),
    );
  }

  signOut() async {
    await auth.signOut();
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => RegisterView()));
  }
}

//////PROFILE SECTION

Widget profileSection(BuildContext context) {
  Widget content = CircleAvatar(
    radius: 30,
    backgroundColor: ColorManager.primary,
    child: const Icon(
      Icons.camera_alt_rounded,
      color: Colors.black,
      size: 40,
    ),
  );

  if (clickedImage != null) {
    content = CircleAvatar(
      radius: 30,
      backgroundImage: FileImage(clickedImage!),
    );
  }

  return Container(
    padding: const EdgeInsetsDirectional.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      border: Border.all(width: 1.5, color: Colors.black),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //1st row.....
        content,
        //2nd row....
        const SizedBox(width: 70),
        //3rd row....
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              phoneNo,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1.5, color: Colors.black),
              ),
              child: const Text('edit profile',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    ),
  );
}

//SERVICES SECTION

Widget serviceSection(BuildContext context, IconData icon, String str) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.28,
    height: MediaQuery.of(context).size.height * 0.1,
    padding: const EdgeInsetsDirectional.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      border: Border.all(width: 1.5, color: Colors.black),
    ),
    child: Column(
      children: [
        Icon(icon),
        const SizedBox(
          height: 4,
        ),
        Text(
          str,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

//SETTINGS SECTION

Widget settingSection(BuildContext context, IconData icon, String str) {
  return Container(
    padding: const EdgeInsetsDirectional.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      border: Border.all(width: 1.5, color: Colors.black),
    ),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(str, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
