// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/theme_controller.dart';

class AppColor {
  // Slate / Dark Mode Palette Constants
  static const darkCardBg = Color(0xFF1E293B);
  static const darkBorderBg = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const darkBg = Color(0xFF0F172A);

  // Loading / Shimmer
  static const baseColor = Colors.grey;
  static const highlightColor = Colors.white70;
  static const shimmerBaseDark = Color(0xFF1E293B);
  static const shimmerHighlightDark = Color(0xFF334155);

  // Dynamic Theme-Aware Reactive Colors
  static ThemeController get _tc => Get.isRegistered<ThemeController>()
      ? Get.find<ThemeController>()
      : Get.put(ThemeController());

  static bool get isDark => _tc.isDarkMode.value;

  static Color get fullScreenColor => isDark ? darkBg : const Color(0xffFFFFFF);
  static Color get backgroundColor => isDark ? darkBg : const Color(0xffFAFAFA);
  static const goldColor = Color(0xFFD4AF37);
  static const textField = Color(0xff8E8E8E);
  static const primaryColor = Color(0xff0A1624);
  static Color get textColor => isDark ? const Color(0xFF94A3B8) : const Color(0xff84878C);
  static Color get subHeadingContainerColor => isDark ? darkCardBg : const Color(0xffE7ECF2);
  static const orange = Color(0xFFFF8C00);
  static const yellow = Color(0xFFFFD700);
  static const oneYearup = Color(0xFFFF8C00);
  static Color get whiteOrang => isDark ? darkBorderBg : const Color(0xFFFFF2E1);

  static const crimson = Color(0xFFC22E54);
  static const brown = Color(0xFF7B3F00);
  static const gold = Color(0xFFF1C40F);

  static const activeColor = Colors.green;
  static const deleteColor = Colors.red;
  static const boderSideColor = Colors.grey;
  static const errorColor = Colors.red;
  static Color get lightBlue => isDark ? darkCardBg : const Color(0xFFE3F2FD);
  static const dark = Colors.black;
  static const otherWhite = Colors.white70;

  static const white = Colors.white;
  static const black = Colors.black;
  static const black12 = Colors.black12;
  static const black54 = Colors.black54;
  static const black87 = Colors.black87;
  static const grey = Colors.grey;
  static Color get grey200 => isDark ? darkBorderBg : const Color(0xFFEEEEEE);
  static Color get grey300 => isDark ? const Color(0xFF475569) : const Color(0xFFE0E0E0);
  static Color get grey400 => isDark ? const Color(0xFF64748B) : const Color(0xFFBDBDBD);
  static Color get grey500 => isDark ? const Color(0xFF94A3B8) : const Color(0xFF9E9E9E);
  static const red = Colors.red;
  static const blue = Colors.blue;
  static const transparent = Colors.transparent;

  // Dashboard Specific Colors
  static Color get dashboardCardBg => isDark ? darkCardBg : const Color(0xFFFFFFFF);
  static Color get dashboardIconBg => isDark ? darkBorderBg : const Color(0xFFF9F6EE);
  static const dashboardGold = Color(0xFFB8860B);
  static Color get dashboardTextDark => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1A1A1B);
  static Color get dashboardTextLight => isDark ? const Color(0xFF94A3B8) : const Color(0xFF71717A);
  static Color get dashboardChartArea => isDark ? darkCardBg : const Color(0xFFFAF7F0);
  static Color get dashboardCream => isDark ? darkBorderBg : const Color(0xFFF3EFE0);
  static Color get dashboardQuickActionBg => isDark ? darkCardBg : const Color(0xFFFDFBF7);
  static Color get dashboardUsedLocker => isDark ? const Color(0xFFB8860B) : const Color(0xFFD4C3A3);
  static Color get dashboardChartGrid => isDark ? darkBorderBg : const Color(0xFFE6E6E6);

  // Drawer Specific Colors
  static Color get drawerBg => isDark ? darkBg : const Color(0xFFFDFBF7);
  static Color get drawerSelectedBg => isDark ? darkBorderBg : const Color(0xFFFFF7EA);
  static Color get drawerSelectedBorder => isDark ? const Color(0xFF475569) : const Color(0xFFFFE0B2);
  static Color get logoutBg => isDark ? const Color(0xFF3F1D1D) : const Color(0xFFFFF2E1);
  static Color get logoutIcon => isDark ? const Color(0xFFEF4444) : const Color(0xFFE57373);
  static Color get logoutText => isDark ? const Color(0xFFFCA5A5) : const Color(0xFFD32F2F);

  // Login Specific Colors (Light Theme)
  static Color get loginBg => isDark ? darkBg : const Color(0xFFFDFBF7);
  static Color get loginTextDark => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1A1A1A);
  static const loginGold = Color(0xFFD4AF37);
  static const loginButtonStart = Color(0xFFDEB887);
  static const loginButtonEnd = Color(0xFFB8860B);

  // Splash Specific Colors
  static const splashBg = Color(0xFF000000);
  static const splashGold = Color(0xFFD4AF37);
  static const splashDivider = Color(0xFFD4AF37);
  static const quoteCardBg = Colors.white10;
  static const quoteText = Colors.white;

  // Modern Layout & Table Colors
  static Color get tableBg => isDark ? darkCardBg : const Color(0xFFF8FAFC);
  static Color get tableHeaderBg => isDark ? darkBorderBg : const Color(0xFFF8FAFC);
  static Color get tableBorder => isDark ? darkBorderBg : const Color(0xFFE2E8F0);
  static Color get tableDivider => isDark ? darkBorderBg : const Color(0xFFF1F5F9);
  
  // Slate Text Colors
  static Color get textDark => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
  static Color get textMedium => isDark ? const Color(0xFFF1F5F9) : const Color(0xFF475569);
  static Color get textSecondary => isDark ? const Color(0xFFE2E8F0) : darkBorderBg;
  static Color get textMuted => isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B);
  static Color get textLight => isDark ? const Color(0xFFE2E8F0) : const Color(0xFF94A3B8);

  // Status & Tag Light Pill Colors
  static Color get orangeLightBg => isDark ? const Color(0xFF431D0A) : const Color(0xFFFFF7ED);
  static const orangeText = Color(0xFFEA580C);
  static Color get orangeBorder => isDark ? const Color(0xFF7C2D12) : const Color(0xFFFED7AA);

  static Color get greenLightBg => isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4);
  static const greenText = Color(0xFF16A34A);
  
  static Color get yellowLightBg => isDark ? const Color(0xFF422006) : const Color(0xFFFEFCE8);
  static const yellowText = Color(0xFFCA8A04);

  static Color get purpleLightBg => isDark ? const Color(0xFF2E1065) : const Color(0xFFF5F3FF);
  static const purpleText = Color(0xFF7C3AED);

  static Color get goldTagBg => isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7);
  static const goldTagDot = Color(0xFFD97706);
  static Color get goldTagText => isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);

  static Color get blueTagBg => isDark ? const Color(0xFF082F49) : const Color(0xFFE0F2FE);
  static Color get blueTagText => isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1);

  static Color get greenTagBg => isDark ? const Color(0xFF052E16) : const Color(0xFFDCFCE7);
  static Color get greenTagText => isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);

  static Color get redLightBg => isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2);
  static const redText = Color(0xFFDC2626);

  static Color get darkBannerBg => isDark ? darkCardBg : darkBg;

  static Color get cardBg => isDark ? darkCardBg : Colors.white;
  static Color get screenBg => isDark ? darkBg : const Color(0xffFAFAFA);
  static Color get mainText => isDark ? Colors.white : const Color(0xFF0F172A);
  static Color get subText => isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B);
  static Color get border => isDark ? darkBorderBg : const Color(0xFFE2E8F0);
  static Color get tableHeader => isDark ? darkBorderBg : const Color(0xFFF8FAFC);
  static Color get drawerBackground => isDark ? darkBg : const Color(0xFFFDFBF7);
  static Color get drawerSelectedItem => isDark ? darkBorderBg : const Color(0xFFFFF7EA);
}
