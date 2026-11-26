import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class ThemeController extends GetxController {
  var isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (pref != null) {
      isDarkMode.value = pref!.getBool('isDarkMode') ?? true;
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    if (pref != null) {
      pref!.setBool('isDarkMode', isDarkMode.value);
    }
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xffFAFAFA),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffFAFAFA),
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFB8860B),
        secondary: Color(0xFFD4AF37),
        surface: Color(0xffFAFAFA),
        onSurface: Color(0xFF0F172A),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      dividerColor: const Color(0xFF334155),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD4AF37),
        secondary: Color(0xFFB8860B),
        surface: Color(0xFF1E293B),
        onSurface: Colors.white,
      ),
    );
  }
}
