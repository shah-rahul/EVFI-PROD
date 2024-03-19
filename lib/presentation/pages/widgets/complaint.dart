import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';

class Complaint extends StatefulWidget {
  const Complaint({
    required this.chargerId,
  });
  final String chargerId;

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Complaint',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: ColorManager.primary,
        ),
        body: const Center(child: Text("complaint"),),
    );
  }
}

