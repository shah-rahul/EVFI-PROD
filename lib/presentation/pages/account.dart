import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(child: Text("Profile",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,),
      ),
    );
  }
}