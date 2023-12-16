// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/login/login.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/new_station.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/payments.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/user_profile.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/profilesection.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/settings.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username = "";
String firstname = "";
String lastname = "";
String email = "";
String phoneNo = "";
File? clickedImage;
String country = "";
String state = "";
String city = "";
String pincode = "";

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
        //setState(() {});
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
        username = "${userData['firstName']} ${userData['lastName']}";
        phoneNo = userData['phoneNumber'];
        firstname = userData['firstName'];
        lastname = userData['lastName'];
        // email = userData['email'];
        country = userData['country'];
        state = userData['state'];
        city = userData['city'];
        pincode = userData['pinCode'];
        //clickedImage = userData['userImage'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

//........EDIT PROFILE.....................................................................
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
      phoneNo = newDetails.number;
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
          'Profile Section',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'fonts/Poppins'),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: width * 0.96,
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //..............................................................................................
            //...................EDIT PROFILE...............................................................
            profileSection(context),
            //2nd column.......
            SizedBox(height: height * 0.015),
            //..............................................................................................
            //....................BUTTONS IN ROW............................................................
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                serviceSection(context, Icons.lightbulb_outline, 'Chargers'),
                GestureDetector(
                    onTap: clickPayment,
                    child:
                        serviceSection(context, Icons.credit_card, 'Payments')),
                serviceSection(context, Icons.drive_eta, 'Bookings'),
              ],
            ),
            //..............................................................................................
            //.............................COLUMN BUTTONS...................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
              onTap: () {
                editProfile();
              },
              child: settingSection(
                  context, Icons.person_2_outlined, 'Edit Profile'),
            ),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
                onTap: _addStation,
                child: settingSection(
                    context, Icons.location_on_outlined, 'Add Station')),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            settingSection(context, Icons.contact_support_outlined, 'Support'),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
              child: settingSection(context, Icons.settings, 'Settings'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
            ),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
              onTap: () async {
                await signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              child: settingSection(context, Icons.logout, 'Logout'),
            ),
          ],
        ),
      ),
    );
  }

//..............................................................................................
//..............ADD STATION AND SIGNOUT METHODS.................................................
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
  }
}

//..............................................................................................
//......PROFILE SECTION.........................................................................

Widget profileSection(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  Widget content = CircleAvatar(
    radius: height * 0.06,
    backgroundImage: AssetImage('assets/images/map/carphoto.jpeg'),
  );

  if (clickedImage != null) {
    content = CircleAvatar(
      radius: height * 0.06,
      backgroundImage: FileImage(clickedImage!),
    );
  }

  return Container(
    padding: EdgeInsetsDirectional.all(width * 0.02),
    height: height * 0.13,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.02),
      border: Border.all(width: 1.5, color: Colors.black26),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //1st row.....................................
        content,
        //2nd row.....................................
        SizedBox(width: width * 0.05),
        //3rd row.....................................
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(username,
                style: const TextStyle(
                    fontSize: AppSize.s20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'fonts/Poppins')),
            Text('ID: 8989898989',
                style: const TextStyle(
                    fontSize: AppSize.s16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'fonts/Poppins')),
          ],
        ),
        //4th row.....................................
        Spacer(),
        //5th row.....................................
        // Icon(
        //   Icons.edit,
        //   color: ColorManager.primary,
        //   size: height * 0.04,
        // )
      ],
    ),
  );
}

//..............................................................................................
//......SERVICE SECTION.........................................................................

Widget serviceSection(BuildContext context, IconData icon, String str) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Container(
    padding: EdgeInsetsDirectional.all(width * 0.03),
    width: width * 0.28,
    height: height * 0.11,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.02),
      border: Border.all(width: 1.5, color: Colors.black26),
    ),
    child: Column(
      children: [
        Icon(
          icon,
          color: ColorManager.primary,
          size: height * 0.05,
        ),
        Spacer(),
        Text(str,
            style: const TextStyle(
                fontSize: AppSize.s14,
                fontWeight: FontWeight.w800,
                fontFamily: 'fonts/Poppins')),
      ],
    ),
  );
}

//..............................................................................................
//......SETTING SECTION.........................................................................

Widget settingSection(BuildContext context, IconData icon, String str) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: width * 0.05),
    height: height * 0.06,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.02),
      border: Border.all(width: 1.5, color: Colors.black26),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: ColorManager.primary,
          size: height * 0.04,
        ),
        SizedBox(width: width * 0.03),
        Text(str,
            style: const TextStyle(
                fontSize: AppSize.s16,
                fontWeight: FontWeight.w800,
                fontFamily: 'fonts/Poppins')),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          color: ColorManager.primary,
        ),
      ],
    ),
  );
}