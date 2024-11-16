// ignore_for_file: use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/account.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/user_profile.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
      required this.firstname,
      required this.lastname,
      required this.country,
      required this.state,
      required this.city,
      required this.pincode,
      required this.phoneNo});
  final String firstname;
  final String lastname;
  final String phoneNo;
  final String country;
  final String state;
  final String city;
  final String pincode;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  var _enteredFName = firstname;
  var _enteredLName = lastname;
  //File? _selectedImage;
  var _enteredMobileno = phoneNo;
  var _enteredCountry = country;
  var _enteredState = state;
  var _enteredCity = city;
  var _enteredPincode = pincode;

  @override
  void initState() {
    fetchUserDataAndInitializeFields();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user');
  String userId = '';

  void fetchUserDataAndInitializeFields() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        print(userId);
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> updateProfile() async {
    print('updating profile started.......');
    try {
      await usersCollection.doc(userId).update({
        'firstName': _enteredFName,
        'lastName': _enteredLName,
        //'phoneNumber': _enteredMobileno,
        'country': _enteredCountry,
        'city': _enteredCity,
        'state': _enteredState,
        'pinCode': _enteredPincode,
      });
      print('Profile updated successfully');
      //updating variables locally :-
      firstname = _enteredFName;
      lastname = _enteredLName;
      phoneNo = _enteredMobileno;
      country = _enteredCountry;
      state = _enteredState;
      city = _enteredCity;
      pincode = _enteredPincode;
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  void _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      updateProfile();
      Navigator.of(context).pop(UserProfile(
        name: _enteredFName,
        //number: _enteredMobileno,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: ColorManager.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  //1st column...
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Personal Details',
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //1st column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('First Name'),
                      counterText: '',
                    ),
                    maxLength: 10,
                    initialValue: widget.firstname,
                    onSaved: (newValue) {
                      _enteredFName = newValue!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Last Name'),
                      counterText: '',
                    ),
                    maxLength: 10,
                    initialValue: widget.lastname,
                    onSaved: (newValue) {
                      _enteredLName = newValue!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //3rd column
                  // TextFormField(
                  //   style: const TextStyle(color: Colors.black),
                  //   decoration: const InputDecoration(
                  //     labelText: 'User email',
                  //     counterText: '',
                  //   ),
                  //   maxLength: 30,
                  //   initialValue: widget.email,
                  //   onSaved: (newValue) {
                  //     _enteredEmail = newValue!;
                  //   },
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Email is required';
                  //     }
                  //     final emailRegex =
                  //         RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  //     if (!emailRegex.hasMatch(value)) {
                  //       return 'Enter a valid email address';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  //SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //5th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        label: Text('Contact Number'),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                    maxLength: 13,
                    initialValue: widget.phoneNo,
                    enabled: false,
                    onSaved: (newValue) {
                      _enteredMobileno = newValue!;
                    },
                  ),
                  //6th column
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Address Details',
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //7th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Country'),
                      counterText: '',
                    ),
                    maxLength: 15,
                    initialValue: widget.country,
                    onSaved: (newValue) {
                      _enteredCountry = newValue!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //8th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('State'),
                      counterText: '',
                    ),
                    maxLength: 15,
                    initialValue: widget.state,
                    onSaved: (newValue) {
                      _enteredState = newValue!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //9th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('City'),
                      counterText: '',
                    ),
                    maxLength: 15,
                    initialValue: widget.city,
                    onSaved: (newValue) {
                      _enteredCity = newValue!;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  //10th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Pin Code'),
                      counterText: '',
                    ),
                    maxLength: 6,
                    initialValue: widget.pincode,
                    onSaved: (newValue) {
                      _enteredPincode = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pin code is required';
                      }
                      if (value.length != 6) {
                        return 'Pin code must be exactly 6 digits long';
                      }
                      return null;
                    },
                  ),
                  //11th column
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  //12th column
                  GestureDetector(
                    onTap: _submit,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.060,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorManager.primary,
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'fonts/Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
