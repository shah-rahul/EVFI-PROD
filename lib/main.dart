import 'package:EVFI/presentation/Data_storage/UserDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './app/app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(),
    ),
  );
}
