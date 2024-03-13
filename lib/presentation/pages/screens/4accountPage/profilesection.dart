// ignore_for_file: use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/account.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/user_profile.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/image_input.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {required this.email,
      required this.firstname,
      required this.lastname,
      required this.country,
      required this.state,
      required this.city,
      required this.pincode,
      required this.phoneNo});
  final String firstname;
  final String lastname;
  final String email;
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
  var _enteredEmail = email;
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
    print('updating profile started');
    try {
      await usersCollection.doc(userId).update({
        'firstName': _enteredFName,
        'lastName': _enteredLName,
        'phoneNumber': _enteredMobileno,
        'email': _enteredEmail,
        'country': _enteredCountry,
        'city': _enteredCity,
        'state': _enteredState,
        'pinCode': _enteredPincode,
      });
      print('Profile updated successfully');
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  void _submit(){
    _formkey.currentState!.save();
    updateProfile();
    Navigator.of(context).pop(UserProfile(
      name: _enteredFName,
      number: _enteredMobileno,
    ));
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
                  //0th column
                  // ImageInput(
                  //   onPickImage: (image) {
                  //     _selectedImage = image;
                  //   },
                  // ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 10),
                  //1st column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('First Name'),
                    ),
                    maxLength: 20,
                    initialValue: widget.firstname,
                    onSaved: (newValue) {
                      _enteredFName = newValue!;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Last Name'),
                    ),
                    maxLength: 20,
                    initialValue: widget.lastname,
                    onSaved: (newValue) {
                      _enteredLName = newValue!;
                    },
                  ),
                  //2nd column
                  const SizedBox(height: 1),
                  //3rd column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('User email'),
                    ),
                    maxLength: 30,
                    initialValue: widget.email,
                    onSaved: (newValue) {
                      _enteredEmail = newValue!;
                    },
                  ),
                  //4th column
                  const SizedBox(height: 1),
                  //5th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Contact Number'),
                    ),
                    maxLength: 13,
                    initialValue: widget.phoneNo,
                    onSaved: (newValue) {
                      _enteredMobileno = newValue!;
                    },
                  ),
                  //6th column
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 10),
                  //7th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Country'),
                    ),
                    maxLength: 20,
                    initialValue: widget.country,
                    onSaved: (newValue) {
                      _enteredCountry = newValue!;
                    },
                  ),
                  //8th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('State'),
                    ),
                    maxLength: 20,
                    initialValue: widget.state,
                    onSaved: (newValue) {
                      _enteredState = newValue!;
                    },
                  ),
                  //9th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('City'),
                    ),
                    maxLength: 20,
                    initialValue: widget.city,
                    onSaved: (newValue) {
                      _enteredCity = newValue!;
                    },
                  ),
                  //10th column
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      label: Text('Pin Code'),
                    ),
                    maxLength: 20,
                    initialValue: widget.pincode,
                    onSaved: (newValue) {
                      _enteredPincode = newValue!;
                    },
                  ),
                  //11th column
                  const SizedBox(height: 2),
                  //12th column
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add),
                    style: ButtonStyle(
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.black),
                      backgroundColor:
                          MaterialStatePropertyAll(ColorManager.primary),
                    ),
                    label: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
