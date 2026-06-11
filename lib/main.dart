import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';

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
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}