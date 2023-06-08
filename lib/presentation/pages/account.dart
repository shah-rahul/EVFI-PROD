import 'package:EVFI/presentation/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../register/register.dart';

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
        backgroundColor: Colors.pinkAccent,
        body: Center(
          // child: Text(
          //   "Profile",
          //   textAlign: TextAlign.center,
          //   style: Theme.of(context).textTheme.headlineMedium,
          // ),

          child: ElevatedButton(
            child: Text("LogOut"),
            onPressed: () async {
              await signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          ),
        ));

    //button for logout

    // );
  }

  signOut() async {
    await auth.signOut();
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => RegisterView()));
  }
}
