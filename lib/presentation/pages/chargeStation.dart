import 'package:flutter/material.dart';

class ChargeStation extends StatefulWidget {
  const ChargeStation({Key? key}) : super(key: key);

  @override
  State<ChargeStation> createState() => _ChargeState();
}

class _ChargeState extends State<ChargeStation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(child: Text("EVSE - Electric Vehicle Supply Equippment",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,),
      ),
    );
  }
}