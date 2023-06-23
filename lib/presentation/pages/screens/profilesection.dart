import 'package:EVFI/presentation/pages/screens/mycharging/models/user_profile.dart';
import 'package:EVFI/presentation/pages/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    required this.name,
    required this.email,
  });
  final String name;
  final String email;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  var _enteredName = "Mr. EVFI";
  var _enteredEmail = "evfi.tech@gmail.com";
  File? _selectedImage;
  var _enteredMobileno = '+918989898989';
  //var _selectedType = '';
  //var chargerTypes = ['Type A', 'Type B', 'Type C'];

  void _submit() {
    _formkey.currentState!.save();
    Navigator.of(context).pop(UserProfile(
      name: _enteredName, 
      email: _enteredEmail, 
      number: _enteredMobileno, 
      image: _selectedImage!,
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
          backgroundColor: const Color.fromARGB(255, 222, 184, 46),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                //0th column
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(height: 10),
                //1st column
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    label: Text('Username'),
                  ),
                  maxLength: 20,
                  initialValue: _enteredName,
                  onSaved: (newValue) {
                    _enteredName = newValue!;
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
                  initialValue: _enteredEmail,
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
                  initialValue: _enteredMobileno,
                  onSaved: (newValue) {
                    _enteredMobileno = newValue!;
                  },
                ),
                //6th column
                //const SizedBox(height: 1),
                //const Text('Profile Picture'),
                //const SizedBox(height: 3),
                //7th column
                // ImageInput(
                //   onPickImage: (image) {
                //     _selectedImage = image;
                //   },
                // ),
                //8th column
                //const SizedBox(height: 8),
                // //9th column
                // const Text('Charger info'),
                // const SizedBox(height: 3),
                // //10th column
                // DropdownButtonFormField(
                //   items: chargerTypes
                //       .map(
                //         (type) =>
                //             DropdownMenuItem(child: Text(type), value: type),
                //       )
                //       .toList(),
                //   style: const TextStyle(
                //     color: Colors.black,
                //   ),
                //   decoration: const InputDecoration(
                //     label: Text('Charger Type'),
                //   ),
                //   value: chargerTypes[0],
                //   //dropdownColor: Color.fromARGB(255, 167, 167, 233),
                //   icon: const Icon(
                //     Icons.arrow_drop_down_circle,
                //     color: Colors.black,
                //   ),
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedType = value.toString();
                //     });
                //   },
                // ),
                //11th column
                const SizedBox(height: 2),
                //12th column
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.add),
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 222, 184, 46)),
                  ),
                  label: const Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}
