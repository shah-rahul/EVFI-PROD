// User Repository to perform Database Operations
// ignore_for_file: non_constant_identifier_names, file_names, camel_case_types

import 'package:EVFI/presentation/store_details/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class userRepository extends GetxController {
  static userRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
   await _db
        .collection("users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "your acccount has been created.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        // ignore: avoid_types_as_parameter_names
        .catchError((error, StackTrace) {
      Get.snackbar("Error", "something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      //print(error.toString());
    });
  }
}


