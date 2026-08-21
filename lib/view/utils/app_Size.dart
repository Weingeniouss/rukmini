import 'package:get/get.dart';

class AppSize {
  static double get width => Get.width;
  static double get height => Get.height;

  // Font Sizes
  static double extraLargeText = width * 0.06; // ~24px
  static double titleText = width * 0.05;      // ~20px
  static double headingText = width * 0.045;   // ~18px (Alternative)
  static double largeText = width * 0.04;      // ~16px
  static double mediumText = width * 0.03;     // ~12px / 18px (User requested 0.03 for 18)
  static double commonText = width * 0.035;    // ~14px
  static double smallText = width * 0.025;     // ~10px
  static double extraSmallText = width * 0.02; // ~8px / 15px (User requested 0.02 for 15)

  // Specific sizes as requested by user mappings
  static double size18 = width * 0.04;
  static double size15 = width * 0.02;
  static double size20 = width * 0.05;
  static double size14 = width * 0.035;
  static double size12 = width * 0.03; // Using user's 0.03 scale

  // Spacing (Padding/Margin)
  static double p4 = width * 0.01;
  static double p8 = width * 0.02;
  static double p10 = width * 0.025;
  static double p12 = width * 0.03;
  static double p16 = width * 0.04;
  static double p20 = width * 0.05;
  static double p24 = width * 0.06;
  static double p40 = width * 0.1;

  // Icon Sizes
  static double iconSmall = width * 0.04;
  static double iconMedium = width * 0.06;
  static double iconLarge = width * 0.08;
}
