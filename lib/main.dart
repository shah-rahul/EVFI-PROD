import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './app/app.dart';

import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';
import 'package:evfi/presentation/storage/UserChargingDataProvider.dart';
import 'package:evfi/presentation/storage/UserDataProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => UserChargingDataProvider()),
        ChangeNotifierProvider(create: (_) => UserChargings()),
      ],
      child: MyApp()
    ),
  );
}