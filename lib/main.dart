// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/local/localDatabase.dart';
import 'package:toastification/toastification.dart';
import 'routes/app_pages.dart';

/*
  Create by Kheamesh Soni
  start by 10/ Jun /2026
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localdata = LocalDatabase();

  await localdata.loadLocalData();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins', useMaterial3: true),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
