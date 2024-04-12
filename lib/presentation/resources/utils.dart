import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String convertTime(int startHour) {
  // Calculate the ending time
  int endHour = (startHour + 1) % 24;
  print(startHour);
  print(endHour);
  String period = (endHour < 12) ? 'AM' : 'PM';

  // Convert to 12-hour format
  int displayStartHour = (startHour > 12)
      ? startHour - 12
      : (startHour == 0 || startHour == 12)
          ? 12
          : startHour;
  int displayEndHour = (endHour > 12)
      ? endHour - 12
      : (endHour == 0 || endHour == 12)
          ? 12
          : endHour;

  // Format the time strings
  String displayStartTime =
      '${displayStartHour.toString().padLeft(2, '0')} ${(startHour >= 12 && startHour != 24) ? 'PM' : 'AM'}';
  String displayEndTime =
      '${displayEndHour.toString().padLeft(2, '0')} ${(endHour >= 12 && startHour != 24) ? 'PM' : 'AM'}';

  // Return the formatted string
  return '$displayStartTime to $displayEndTime';
}

String newTimeSlots(int prevTimeSlot, int bookedTimeSlot) {
  String prevBin = timeToBinary(prevTimeSlot);
  for (int i = prevBin.length; i < 24; i++) prevBin = "0" + prevBin;
  String newTimeSlot = "";
  for (int i = 0; i < 24; i++) {
    if (i == bookedTimeSlot) {
      newTimeSlot += "1";
    } else
      newTimeSlot += prevBin[i];
  }
  return newTimeSlot;
}

String bookedSlots = "";
String timeToBinary(int time) {
  String binaryTime = "";
  print(time);
  print(time.runtimeType);
  // counter for binary array
  int n = time;
  while (n > 0) {
    // storing remainder in binary array
    binaryTime = (n % 2).toString() + binaryTime;
    n = (n / 2).toInt();
  }
  print(binaryTime);
  return binaryTime;

  // printing binary array in reverse order
}

int binaryToDecimal(String n) {
  String num = n;
  int dec_value = 0;

  // Initializing base value to 1, i.e 2^0
  int base = 1;

  int len = num.length;
  for (int i = len - 1; i >= 0; i--) {
    if (num[i] == '1') dec_value += base;
    base = base * 2;
  }

  return dec_value;
}

DateTime parseTime(String timeString) {
  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      int.parse(timeString), 0);
}

//Firabase functions
void changeBookingStatus(int status, String bookingId) async {
  CollectionReference users = FirebaseFirestore.instance.collection('booking');
  DocumentReference docRef = users.doc(bookingId);
  await docRef.update({
    'status': status,
  });
}

void updateFireStoreTimeStamp(int time, String chargerId) async {
  CollectionReference users = FirebaseFirestore.instance.collection('chargers');
  DocumentReference docRef = users.doc(chargerId);
  await docRef.update({
    'timeSlot': time,
  });
}

Future<DocumentSnapshot<Map<String, dynamic>>> getCustomerDetailsByUserId(
    String customerId, String chargerId, List<String> stationName) async {
  print(chargerId);
  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  try {} catch (err) {
    print('Errrorrrrrrrrrrrrrrrrrrrrrrrr');
    debugPrint('------$err');
  }
  final chargerDetails = await FirebaseFirestore.instance
      .collection('chargers')
      .doc(chargerId)
      .get();

  // Update stationName
  stationName[0] = chargerDetails['info']['stationName'];

  print(stationName[0]);

  final customerDetails =
      await FirebaseFirestore.instance.collection('user').doc(customerId).get();
  print('customer id: ');
  print(customerDetails);
  return customerDetails;
}
