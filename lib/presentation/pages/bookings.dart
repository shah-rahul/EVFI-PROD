import 'package:flutter/material.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Bookings",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),
      ),
    );
  }
}