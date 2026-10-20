import 'package:get/get.dart';

class AppSize {
  static double get width => Get.width;
  static double get height => Get.height;

  // Responsive Breakpoints
  static bool get isMobile => width < 600;
  static bool get isTablet => width >= 600 && width < 1024;
  static bool get isDesktop => width >= 1024;

  // Responsive Grid Cross Axis Count
  static int get gridCrossAxisCount {
    if (isDesktop) return 4;
    if (isTablet) return 2;
    return 1;
  }

  // Font Sizes (Clamped to prevent oversized text on Tablet/Desktop/Web)
  static double get extraLargeText => (width * 0.06).clamp(20.0, 28.0);
  static double get titleText => (width * 0.05).clamp(18.0, 24.0);
  static double get headingText => (width * 0.045).clamp(16.0, 22.0);
  static double get largeText => (width * 0.04).clamp(14.0, 18.0);
  static double get mediumText => (width * 0.03).clamp(12.0, 16.0);
  static double get commonText => (width * 0.035).clamp(13.0, 16.0);
  static double get smallText => (width * 0.025).clamp(10.0, 13.0);
  static double get extraSmallText => (width * 0.02).clamp(8.0, 12.0);

  // Specific sizes
  static double get size18 => (width * 0.04).clamp(14.0, 18.0);
  static double get size15 => (width * 0.02).clamp(12.0, 15.0);
  static double get size20 => (width * 0.05).clamp(16.0, 20.0);
  static double get size14 => (width * 0.035).clamp(12.0, 14.0);
  static double get size12 => (width * 0.03).clamp(10.0, 12.0);

  // Spacing (Padding/Margin) (Tighter on Desktop/Tablet to maximize available width)
  static double get p4 => (isDesktop || isTablet) ? 4.0 : (width * 0.01).clamp(4.0, 8.0);
  static double get p8 => (isDesktop || isTablet) ? 8.0 : (width * 0.02).clamp(8.0, 12.0);
  static double get p10 => (isDesktop || isTablet) ? 10.0 : (width * 0.025).clamp(10.0, 14.0);
  static double get p12 => (isDesktop || isTablet) ? 12.0 : (width * 0.03).clamp(12.0, 16.0);
  static double get p16 => (isDesktop || isTablet) ? 12.0 : (width * 0.04).clamp(14.0, 20.0);
  static double get p20 => (isDesktop || isTablet) ? 16.0 : (width * 0.05).clamp(16.0, 24.0);
  static double get p24 => (isDesktop || isTablet) ? 18.0 : (width * 0.06).clamp(20.0, 28.0);
  static double get p40 => (isDesktop || isTablet) ? 24.0 : (width * 0.1).clamp(28.0, 48.0);

  // Icon Sizes (Clamped)
  static double get iconSmall => (width * 0.04).clamp(16.0, 20.0);
  static double get iconMedium => (width * 0.06).clamp(22.0, 28.0);
  static double get iconLarge => (width * 0.08).clamp(28.0, 36.0);
}

