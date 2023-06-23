import 'package:EVFI/presentation/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username = "Mr. EVFI";
String email = "evfi.tech@gmail.com";

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //1st column
            Container(
              child: profileSection(context),
            ),
            //2nd column
            const SizedBox(height: 20),
            //3rd column
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //3members in this row
                serviceSection(context, Icons.charging_station, 'My Chargers'),
                const SizedBox(width: 25),
                serviceSection(context, Icons.credit_card, 'Payments'),
                const SizedBox(width: 25),
                serviceSection(context, Icons.drive_eta, 'Bookings'),
              ],
            ),
            //4th column
            const SizedBox(height: 20),
            //5th column
            settingSection(context, Icons.settings, 'Settings'),
            //6th column
            const SizedBox(height: 20),
            //7th column
            settingSection(context, Icons.question_mark, 'Support'),
            //8th column
            const SizedBox(height: 20),
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
            const SizedBox(height: 100),
          ],
        ),
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

Widget profileSection(BuildContext context) {
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
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.yellow,
          child: Icon(
            Icons.camera_alt_rounded,
            color: Colors.black,
            size: 40,
          ),
        ),
        const SizedBox(width: 70),
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
              email,
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

Widget serviceSection(BuildContext context, IconData icon, String str) {
  return Container(
    padding: const EdgeInsetsDirectional.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      border: Border.all(width: 1.5, color: Colors.black),
    ),
    child: Column(
      children: [
        Icon(icon),
        Text(str),
      ],
    ),
  );
}

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
