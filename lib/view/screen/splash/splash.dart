// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_constants.dart';
import 'package:rukmini/view/utils/app_logo.dart';
import 'package:rukmini/view/utils/app_background.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  void _navigateToNext() {
    if (islogin) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      backgroundImage: AppBackground.backgroundImage,
      backGroundcolor: AppColor.splashBg,
      isPadding: false,
      child: Stack(
        children: [
          // Attractive & Sober Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.5),
                  radius: 1.0,
                  colors: [
                    AppColor.splashGold.withOpacity(0.05),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),

          // Custom Sober Background Art
          Positioned.fill(
            child: CustomPaint(painter: SoberBackgroundPainter()),
          ),

          // Content Layer
          Column(
            children: [
              SizedBox(height: AppSize.p40),
              // Premium Golden Logo
              Center(
                child: Image.asset(
                  AppLogo.rukminiLogo2,
                  height: AppSize.height * 0.22,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              // Scrollable Quotes Section
              SizedBox(
                height: AppSize.height * 0.6,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.p24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildQuoteCard(
                      AppString.napoleonHill,
                      AppString.authorNapoleonHill,
                    ),
                    const _DividerWithDiamond(),
                    _buildQuoteCard(
                      AppString.andyRooney,
                      AppString.andyRooneyJournalist,
                      onTap: _navigateToNext,
                    ),
                    const _DividerWithDiamond(),
                    _buildQuoteCard(
                      AppString.williamGeorge,
                      AppString.williamGeorgeJordan,
                    ),
                    SizedBox(height: AppSize.p40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(String quote, String author, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.p10),
      padding: EdgeInsets.all(AppSize.p20),
      decoration: BoxDecoration(
        color: AppColor.quoteCardBg.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.p16),
        border: Border.all(
          color: AppColor.splashGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColor.splashGold,
            size: AppSize.iconLarge,
          ),
          SizedBox(height: AppSize.p10),
          Text(
            quote.replaceAll('“', '').replaceAll('”', ''),
            style: TextStyle(
              color: AppColor.quoteText.withOpacity(0.9),
              fontSize: AppSize.largeText,
              height: 1.5,
              fontWeight: FontWeight.w300,
              letterSpacing: AppSize.width * 0.002,
            ),
          ),
          SizedBox(height: AppSize.p12),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              author,
              style: TextStyle(
                color: AppColor.splashGold.withOpacity(0.7),
                fontSize: AppSize.commonText,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                decoration: onTap != null ? TextDecoration.underline : null,
                decorationColor: AppColor.splashGold.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerWithDiamond extends StatelessWidget {
  const _DividerWithDiamond();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p12),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColor.splashGold.withOpacity(0.3),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.rotate(
              angle: 45 * 3.14159 / 180,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.splashGold.withOpacity(0.6),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColor.splashGold.withOpacity(0.3),
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SoberBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.splashGold.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Elegant long-radius arcs for a "Sober" look
    canvas.drawArc(
      Rect.fromLTWH(
        -size.width * 0.2,
        size.height * 0.1,
        size.width * 1.5,
        size.height * 0.8,
      ),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.3,
        -size.height * 0.1,
        size.width * 1.2,
        size.height * 0.6,
      ),
      math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );

    // Faint botanical branch at bottom left
    final leafPaint = Paint()
      ..color = AppColor.splashGold.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final path = Path();
    path.moveTo(0, size.height * 0.95);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.85,
      size.width * 0.1,
      size.height * 0.6,
    );
    canvas.drawPath(path, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
