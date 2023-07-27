// ignore_for_file: use_key_in_widget_constructors

import 'package:EVFI/presentation/pages/screens/accountPage/success_payment.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen();

  @override
  State<PaymentScreen> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  int value = 0;
  final paymentMethods = [
    'Credit card / Debit card',
    'Cash',
    'Paypal',
    'Wallet',
  ];
  final paymentIcons = [
    Icons.credit_card,
    Icons.currency_rupee,
    Icons.payment,
    Icons.account_balance_wallet,
  ];
  void onTapPay() {
    Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const PaymentSuccessful();
                },
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          //column 1
          const SizedBox(height: 10),
          //column 2
          const Text(
            'Choose your payment method',
            style: TextStyle(
              fontSize: 23,
            ),
          ),
          //column 3
          const SizedBox(height: 20),
          //column 4
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio(
                    value: index,
                    groupValue: value,
                    onChanged: (val) {
                      setState(() {
                        value = val as int;
                      });
                    },
                  ),
                  title: Text(
                    paymentMethods[index],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    paymentIcons[index],
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          //last column
          GestureDetector(
            onTap: onTapPay,
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
                'Pay',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
