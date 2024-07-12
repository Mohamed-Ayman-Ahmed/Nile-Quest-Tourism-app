// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nile_quest/firebase_options.dart';
import 'package:nile_quest/modules/controller/dependency_injection.dart';
import 'package:nile_quest/modules/splash/splash_screen.dart';
import 'package:nile_quest/shared/styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(textTheme: TextTheme(bodyMedium: poppins)),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
