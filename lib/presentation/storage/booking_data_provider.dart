import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDataProvider {
  // final String chargerId;
  // final String price;
  // final int timeSlot;
  // final String providerId;

  final CollectionReference _booking =
      FirebaseFirestore.instance.collection('booking');
  final _userId = FirebaseAuth.instance.currentUser!.uid;

  BookingDataProvider(
      // {required this.providerId,
      // required this.chargerId,
      // required this.price,
      // required this.timeSlot}
      );

  Future<void> addBooking(
      String providerId, String chargerId, int price, int timeSlot) async {
    try {
      _booking.add({
        'status': LendingStatus.requested.code,
        'uId': _userId,
        'chargerId': chargerId,
        'price': price,
        'timeSlot': timeSlot,
        'providerId': providerId,
        'bookingDate': DateFormat('d MMMM yyyy').format(DateTime.now())
      }).then((docRef) async {
        // print(docRef.id);
        await _booking.doc(docRef.id).update({'bookingId': docRef.id});
        return docRef;
      });
    } catch (error) {
      debugPrint('$error');
    }
  }

 
}
