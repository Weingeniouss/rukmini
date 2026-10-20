// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_logo.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';
import 'package:rukmini/view/utils/widget/forgot_password_popup.dart';
import 'package:rukmini/view/utils/widget/responsive.dart';

class Login extends StatelessWidget {
  final LoginControllerAPI loginAPI;

  const Login({super.key, required this.loginAPI});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.loginBg,
      body: Responsive(
        mobile: _buildMobileLayout(context),
        tablet: _buildDesktopLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  // --- MOBILE LAYOUT (Preserved 100% Unchanged) ---
  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: LoginBackgroundPainter()),
        ),
        Positioned(
          top: AppSize.height * 0.12,
          left: -AppSize.width * 0.2,
          right: -AppSize.width * 0.2,
          bottom: AppSize.height * 0.12,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: AppColor.loginGold.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.loginGold.withOpacity(0.08),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logo(),
                SizedBox(height: AppSize.height * 0.1),
                _welcomeSection(),
                SizedBox(height: AppSize.height * 0.05),
                _loginForm(),
                SizedBox(height: AppSize.height * 0.06),
                _loginButton(),
                SizedBox(height: AppSize.height * 0.1),
                _forgotPasswordSection(context),
                SizedBox(height: AppSize.p4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- DESKTOP & TABLET LAYOUT (Modern 2-Column Split View) ---
  Widget _buildDesktopLayout(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: LoginBackgroundPainter()),
        ),
        Center(
          child: SingleChildScrollView(
            child: ResponsiveCenter(
              maxWidth: 1100,
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.loginGold.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: AppColor.loginGold.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Left Side: Branding & Luxury Hero Section
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                          color: AppColor.dashboardQuickActionBg.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            bottomLeft: Radius.circular(22),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              AppLogo.rukminiLogo2,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              AppString.welcome,
                              style: TextStyle(
                                color: AppColor.loginTextDark.withOpacity(0.6),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppString.rukminiJewellers,
                              style: const TextStyle(
                                color: AppColor.loginTextDark,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 60,
                              height: 3,
                              color: AppColor.loginGold,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppString.quoteMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.dashboardTextLight,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Side: Login Form Card
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppString.logIn,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColor.loginTextDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppString.dashboardOverview,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.dashboardTextLight,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _loginForm(),
                            const SizedBox(height: 24),
                            _loginButton(),
                            const SizedBox(height: 32),
                            _forgotPasswordSection(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _logo() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: AppSize.p20, right: AppSize.p10),
        child: Image.asset(
          AppLogo.rukminiLogo2,
          height: AppSize.height * 0.16,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _welcomeSection() {
    return Padding(
      padding: EdgeInsets.only(left: AppSize.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.welcome,
            style: TextStyle(
              color: AppColor.loginTextDark.withOpacity(0.6),
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppSize.p8),
          Text(
            AppString.rukminiJewellers,
            style: TextStyle(
              color: AppColor.loginTextDark,
              fontSize: AppSize.extraLargeText * 1.2,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
      child: Column(
        children: [
          inputField(
            hintText: AppString.emailphone,
            prefixIconData: AppIcon.loginUser,
            textColor: AppColor.loginTextDark,
            iconColor: AppColor.loginGold,
            inputTextcontroller: loginAPI.loginUI.emailController,
          ),
          inputField(
            hintText: AppString.password,
            prefixIconData: AppIcon.loginLock,
            isPassword: true,
            textColor: AppColor.loginTextDark,
            iconColor: AppColor.loginGold,
            inputTextcontroller: loginAPI.loginUI.passwordController,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: AppSize.p16),
        child: Obx(() {
          return GestureDetector(
            onTap: () {
              if (!loginAPI.isLoading.value) {
                CallApi.callLogin();
              }
            },
            child: Container(
              width: AppSize.width * 0.28,
              constraints: const BoxConstraints(minWidth: 180),
              height: AppSize.height * 0.06,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.loginButtonStart, AppColor.loginButtonEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.loginButtonEnd.withOpacity(0.4),
                    blurRadius: AppSize.p12,
                    offset: Offset(0, AppSize.p8),
                  ),
                ],
              ),
              child: Center(
                child: loginAPI.isLoading.value
                    ? SizedBox(
                        height: AppSize.iconSmall,
                        width: AppSize.iconSmall,
                        child: CircularProgressIndicator(
                          color: AppColor.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppString.logIn,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: AppSize.titleText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: AppSize.p12),
                          Icon(
                            AppIcon.loginArrow,
                            color: AppColor.white,
                            size: AppSize.iconMedium,
                          ),
                        ],
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _forgotPasswordSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSize.p16),
      child: GestureDetector(
        onTap: () => showForgotPasswordPopup(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSize.p8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.loginGold.withOpacity(0.4),
                  width: 1.2,
                ),
              ),
              child: Icon(
                AppIcon.loginLock,
                color: AppColor.loginGold,
                size: AppSize.iconMedium,
              ),
            ),
            SizedBox(width: AppSize.p12),
            Text(
              '${AppString.forgetPassword}  >',
              style: TextStyle(
                color: AppColor.loginTextDark,
                fontSize: AppSize.largeText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.loginGold.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Arcs
    canvas.drawCircle(Offset(size.width * 1.2, 0), size.width * 0.6, paint);
    canvas.drawCircle(Offset(size.width * 1.2, 0), size.width * 0.8, paint);

    // Leaves branch
    _drawBranch(canvas, size);
  }

  void _drawBranch(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.loginGold.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.8,
      size.width * 0.2,
      size.height * 0.5,
    );
    canvas.drawPath(path, paint);

    // Draw leaves along path
    for (int i = 0; i < 6; i++) {
      double t = i / 6;
      double x =
          math.pow(1 - t, 2) * 0 +
          2 * (1 - t) * t * (size.width * 0.15) +
          math.pow(t, 2) * (size.width * 0.2);
      double y =
          math.pow(1 - t, 2) * (size.height * 0.9) +
          2 * (1 - t) * t * (size.height * 0.8) +
          math.pow(t, 2) * (size.height * 0.5);

      _drawLeaf(canvas, Offset(x, y), -0.5 + (i * 0.2), paint.color);
    }
  }

  void _drawLeaf(Canvas canvas, Offset position, double rotation, Color color) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(10, -8, 20, 0);
    path.quadraticBezierTo(10, 8, 0, 0);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
