import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/screen/splash/splash.dart';

void main() => runApp(MyApp());

/*
  Create by Kheamesh Soni
  start by 10/ Jun /2026
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}