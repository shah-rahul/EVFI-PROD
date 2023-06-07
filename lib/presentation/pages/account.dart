import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {
              signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RegisterView()),
              );
            },
          ),
        ));

    //button for logout

    // );
  }

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RegisterView()));
  }
}
