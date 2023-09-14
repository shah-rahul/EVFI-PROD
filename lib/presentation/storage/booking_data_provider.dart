import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingDataProvider {
  final String chargerId;
  final double price;
  final String timeSlot;

  final CollectionReference _booking =
      FirebaseFirestore.instance.collection('booking');
  final _userId = FirebaseAuth.instance.currentUser!.uid;

  BookingDataProvider(
      {required this.chargerId, required this.price, required this.timeSlot}) {
    final bookingId = _booking.id;
    print('********************************************');
    print(bookingId);
    try {
      _booking.add({
        'bookingId': bookingId,
        'userId': _userId,
        'chargerId': chargerId,
        'price': price,
        'timeSlot': timeSlot
      });
    } catch (error) {
      debugPrint('$error');
    }
  }

  // Future<void> addBooking() async {}
}
