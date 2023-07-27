// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen();

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 222, 184, 46),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: ListView(
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 25,
                //color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
           Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 10),
            buildAccountSetting(
                context, 'Change Password', Icons.arrow_forward_ios),
            buildAccountSetting(context, 'Language', Icons.arrow_forward_ios),
            buildAccountSetting(context, 'Social', Icons.arrow_forward_ios),
            buildAccountSetting(
                context, 'Privacy and security', Icons.arrow_forward_ios),
            //2nd section
            const SizedBox(height: 30),
           Row(
              children: [
                Icon(
                  Icons.volume_down_outlined,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 10),
            buildNotificationSetting(context, 'Dark mode', false),
            buildNotificationSetting(context, 'Pop ups', true),
            buildNotificationSetting(context, 'Account Activity', true),
            buildNotificationSetting(context, 'Opportunity', false),
            // const SizedBox(height: 50),
            // Center(
            //   child: OutlinedButton(
            //     onPressed: (){},
            //     //style:const  ButtonStyle(
            //      // shape: MaterialStatePropertyAll(BeveledRectangleBorder()),
            //     //),
            //     child: const Text('SIGN OUT', style: TextStyle(
            //       fontSize: 24,
            //       letterSpacing: -1,
            //       color: Colors.black,
            //     ),)),
            // ),
            //3rd section
            const SizedBox(height: 30),
             Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'About us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 10),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 73, 71, 71),
                  ),
                ),
                Text('1.0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildAccountSetting(BuildContext context, String str, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          str,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 73, 71, 71),
          ),
        ),
        Icon(
          icon,
          color: const Color.fromARGB(255, 73, 71, 71),
        ),
      ],
    ),
  );
}

Widget buildNotificationSetting(
    BuildContext context, String str, bool isActive) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        str,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 73, 71, 71),
        ),
      ),
      Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: isActive,
            onChanged: (value) {},
          )),
    ],
  );
}
