// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful();
  @override
  State<PaymentSuccessful> createState() {
    return _PaymentSuccessfulState();
  }
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //1st column
            const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.done_outline,
                color: Colors.black,
              ),
            ),
            //2nd column
            const SizedBox(height: 10),
            const Text(
              'Successfull',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30),
            //3rd column
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Your payment was done successfully',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),

            //4th column
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                height: 40,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.amber,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
