// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';

class RukminiAlertBox {
  static void show({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    required VoidCallback onConfirm,
    IconData? icon,
    Color? iconColor,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.p20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main Container
            Container(
              padding: EdgeInsets.all(AppSize.p24),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p24),
                border: Border.all(
                  color: AppColor.goldColor.withOpacity(0.3),
                  width: AppSize.width * 0.004,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.15),
                    blurRadius: AppSize.p40 / 1.5,
                    offset: Offset(0, AppSize.p16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decorative Header Icon with Halo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: AppSize.width * 0.18,
                        height: AppSize.width * 0.18,
                        decoration: BoxDecoration(
                          color: AppColor.goldColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(AppSize.p16 - 1),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.goldColor.withOpacity(0.2),
                              blurRadius: AppSize.p10,
                            )
                          ],
                        ),
                        child: Icon(
                          icon ?? AppIcon.leaf,
                          color: iconColor ?? AppColor.goldColor,
                          size: AppSize.iconLarge,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.p20),

                  // Title
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSize.titleText,
                      fontWeight: FontWeight.w800,
                      color: AppColor.black,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSize.p10),

                  // Decorative Divider
                  const _DiamondDivider(),
                  SizedBox(height: AppSize.p16),

                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSize.commonText,
                      color: AppColor.textColor,
                      fontFamily: 'Poppins',
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: AppSize.p24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: AppSize.p12 + 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSize.p12),
                            ),
                          ),
                          child: Text(
                            cancelText ?? AppString.cancel,
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: AppSize.size14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.p12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.p12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.goldColor.withOpacity(0.3),
                                blurRadius: AppSize.p8,
                                offset: Offset(0, AppSize.p4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              onConfirm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: AppSize.p12 + 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSize.p12),
                              ),
                            ),
                            child: Text(
                              confirmText ?? AppString.ok,
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: AppSize.size14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Decorative background filigree
            Positioned(
              top: -AppSize.p10,
              right: -AppSize.p10,
              child: Opacity(
                opacity: 0.05,
                child: Icon(AppIcon.leaf, size: AppSize.width * 0.25, color: AppColor.goldColor),
              ),
            ),
            Positioned(
              bottom: -AppSize.p20,
              left: -AppSize.p20,
              child: Transform.rotate(
                angle: math.pi,
                child: Opacity(
                  opacity: 0.05,
                  child: Icon(AppIcon.leaf, size: AppSize.width * 0.3, color: AppColor.goldColor),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierColor: AppColor.black.withOpacity(0.6),
    );
  }
}

class _DiamondDivider extends StatelessWidget {
  const _DiamondDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: AppSize.width * 0.08, height: 1, color: AppColor.goldColor.withOpacity(0.3)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: AppSize.p8 - 2,
              height: AppSize.p8 - 2,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.goldColor.withOpacity(0.6), width: 1),
              ),
            ),
          ),
        ),
        Container(width: AppSize.width * 0.08, height: 1, color: AppColor.goldColor.withOpacity(0.3)),
      ],
    );
  }
}
