import 'package:EVFI/presentation/main/main_view.dart';
import 'package:flutter/material.dart';

// import '../pages/home.dart';
import '../resources/color_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Join EVFI',
                      style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                     // style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',

                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                   // obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(

                      border: OutlineInputBorder(),
                      labelText: 'Mobile Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     //forgot password screen
                //   },
                //   child: const Text(
                //     'Forgot Password',
                //     style: TextStyle(fontSize: 18, color: Colors.amberAccent),
                //   ),
                // ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Register'),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainView()),
                        );
                        // print(nameController.text);
                        // print(passwordController.text);
                      },
                    )),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,                  
                //   children: <Widget>[
                //     const Text('Does not have account?'),
                //     TextButton(
                //       child: const Text(
                //         'Sign up',
                //         style:
                //             TextStyle(fontSize: 20, color: Colors.amberAccent),
                //       ),
                //       onPressed: () {
                //         //signup screen
                //         Navigator.pushNamed(context, '/login');
                //       },
                //     )
                //   ],
                // ),
              ],
            )));
  }
}
