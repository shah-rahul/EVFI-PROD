import 'package:evfi/presentation/Data_storage/UserChargingDataProvider.dart';
import 'package:evfi/presentation/Data_storage/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './app/app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // ChangeNotifierProvider(
    //   create: (context) => UserDataProvider(),
    //   child: MyApp(),
    // ),
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => UserChargingDataProvider()),
        // Add more providers here if needed
      ],
      child: MyApp(),
    ),
  );
}

