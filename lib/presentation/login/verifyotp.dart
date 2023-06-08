import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import '../resources/routes_manager.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../resources/color_manager.dart';

class verify_otp extends StatefulWidget {
  const verify_otp({Key? key}) : super(key: key);

  @override
  State<verify_otp> createState() => _verify_otpState();
}

class _verify_otpState extends State<verify_otp> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            OTPTextField(
              // controller: _otpController,
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 20,
              style: TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                //   OTP verification logic here
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                //  mobile number verification logic here
                Navigator.pushNamed(context, Routes.registerRoute);
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
