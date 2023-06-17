import 'package:EVFI/presentation/store_details/userRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../main/main_view.dart';
import '../store_details/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  //text field controller to get data from textfields
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(userRepository());
  //call these functions from design and they will do the logic

  //get phoneno from user and pass it to firebase authentication
  Future<void> createUser(UserModel user) async{
   await  userRepo.createUser(user);
    Get.to(() => MainView());
  }

  void phoneAuthentication(String phoneNo) {}
}
