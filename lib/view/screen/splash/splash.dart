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
          // Dark Overlay to blend background image with dark theme
          Positioned.fill(
            child: Container(color: AppColor.black.withOpacity(0.5)),
          ),

          // Geometric Overlay / Decorative Arcs & Sparkles
          Positioned.fill(
            child: CustomPaint(painter: SoberBackgroundPainter()),
          ),

          // Content Layer
          Column(
            children: [
              SizedBox(height: AppSize.p20),
              welcome(),

              // Scrollable Quotes Section
              quotes(),
            ],
          ),
        ],
      ),
    );
  }

  Widget welcome() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            AppLogo.rukminiLogo2,
            height: AppSize.height * 0.25,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget quotes() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.p24),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildQuoteCard(AppString.napoleonHill, AppString.authorNapoleonHill),
          _buildQuoteCard(
            AppString.andyRooney,
            AppString.andyRooneyJournalist,
            onTap: _navigateToNext,
          ),
          _buildQuoteCard(
            AppString.williamGeorge,
            AppString.williamGeorgeJordan,
          ),
          SizedBox(height: AppSize.p40),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(String quote, String author, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSize.p8),
        padding: EdgeInsets.all(AppSize.p20),
        decoration: BoxDecoration(
          color: AppColor.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(AppSize.p16),
          border: Border.all(
            color: AppColor.splashGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.format_quote_rounded,
                color: AppColor.splashGold,
                size: AppSize.iconLarge,
              ),
            ),
            SizedBox(height: AppSize.p10),
            Text(
              quote.replaceAll('“', '').replaceAll('”', ''),
              style: TextStyle(
                color: AppColor.white,
                fontSize: AppSize.largeText,
                height: 1.5,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: AppSize.p12),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "— $author",
                style: TextStyle(
                  color: AppColor.splashGold,
                  fontSize: AppSize.commonText,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: AppSize.p16),
            const _DividerWithDiamond(),
          ],
        ),
      ),
    );
  }
}

class _DividerWithDiamond extends StatelessWidget {
  const _DividerWithDiamond();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p4),
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
      ..color = AppColor.splashGold.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Geometric low-poly effect (Subtle triangles)
    final polyPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    void drawTriangle(Offset p1, Offset p2, Offset p3) {
      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..close();
      canvas.drawPath(path, polyPaint);
    }

    // Top Right Geometry
    drawTriangle(
      Offset(size.width, 0),
      Offset(size.width * 0.6, 0),
      Offset(size.width, size.height * 0.15),
    );
    drawTriangle(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.5, size.height * 0.08),
    );

    // Bottom Left Geometry
    drawTriangle(
      Offset(0, size.height),
      Offset(size.width * 0.4, size.height),
      Offset(0, size.height * 0.8),
    );
    drawTriangle(
      Offset(size.width * 0.4, size.height),
      Offset(size.width * 0.7, size.height),
      Offset(size.width * 0.5, size.height * 0.92),
    );

    // Top Left Decorative Gold Arc
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(0, size.height * 0.2),
        radius: size.width * 0.45,
      ),
      -math.pi / 2.2,
      math.pi / 1.5,
      false,
      paint,
    );

    // Bottom Right Decorative Gold Arc
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width, size.height * 0.8),
        radius: size.width * 0.45,
      ),
      math.pi / 1.2,
      math.pi / 1.5,
      false,
      paint,
    );

    // Sparkle points on the arcs
    final sparklePaint = Paint()
      ..color = AppColor.splashGold
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.18),
      1.5,
      sparklePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.78),
      1.5,
      sparklePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
