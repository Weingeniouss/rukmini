// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/view/utils/widget/report_helper.dart';
import '../../../controller/local/localDatabase.dart';
import '../app_Color.dart';
import '../app_Icon.dart';
import '../app_logo.dart';

Widget homeDrawer() {
  final loginAPI = Get.put(LoginControllerAPI());
  final navDrawerController = Get.put(NavDrawerController());

  return Drawer(
    backgroundColor: AppColor.drawerBg,
    elevation: 0,
    child: Column(
      children: [
        // Custom Header
        SizedBox(
          height: AppSize.height * 0.27,
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: HeaderArcPainter())),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSize.p20,
                  AppSize.height * 0.07,
                  AppSize.p20,
                  AppSize.p20,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppLogo.rukminiLogo2,
                      height: AppSize.height * 0.12,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: AppSize.p16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final role =
                                loginAPI.loginData.value.data?.roleName;
                            return Text(
                              role ?? AppString.user,
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.extraLargeText,
                              ),
                            );
                          }),
                          const SizedBox(height: 4),
                          Text(
                            loginAPI.loginUI.emailController.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColor.textField,
                              fontSize: AppSize.size14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Drawer Items
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            children: [
              _drawerItem(
                index: 0,
                title: AppString.home,
                icon: AppIcon.home,
                onTap: () {
                  navDrawerController.changeIndex(0);
                  Get.toNamed('/home');
                },
              ),
              _drawerItem(
                index: 1,
                title: AppString.allMaster,
                icon: AppIcon.settings,
                onTap: () {
                  navDrawerController.changeIndex(1);
                  Get.toNamed('/allMaster');
                },
              ),
              _drawerItem(
                index: 2,
                title: AppString.customer,
                icon: AppIcon.personOutline,
                onTap: () {
                  navDrawerController.changeIndex(2);
                  Get.toNamed('/custList');
                },
              ),
              _drawerItem(
                index: 3,
                title: AppString.girvi,
                icon: AppIcon.bank,
                onTap: () {
                  navDrawerController.changeIndex(3);
                  Get.toNamed('/giriviList');
                },
              ),
              _drawerItem(
                index: 4,
                title: AppString.products,
                icon: AppIcon.grid,
                onTap: () {
                  navDrawerController.changeIndex(4);
                  Get.toNamed('/pendingProduct');
                },
              ),
              _drawerItem(
                index: 5,
                title: AppString.productinLocker,
                icon: AppIcon.lockPerson,
                onTap: () {
                  navDrawerController.changeIndex(5);
                  Get.toNamed('/productInLocker');
                },
              ),
              _drawerItem(
                index: 6,
                title: AppString.pendingTransaction,
                icon: AppIcon.pending,
                onTap: () {
                  navDrawerController.changeIndex(6);
                  Get.toNamed('/dueGirvi');
                },
              ),
              _drawerItem(
                index: 7,
                title: AppString.lockerTransaction,
                icon: AppIcon.lockReset,
                onTap: () {
                  navDrawerController.changeIndex(7);
                  Get.toNamed('/lockerTransaction');
                },
              ),
              _drawerItem(
                index: 8,
                title: AppString.reports,
                icon: AppIcon.description,
                onTap: () {
                  navDrawerController.changeIndex(8);
                  Get.toNamed('/report');
                },
              ),
              _drawerItem(
                index: 9,
                title: AppString.exportCustomersContacts,
                icon: AppIcon.contact,
                onTap: () {
                  navDrawerController.changeIndex(9);
                  final reportUIController = Get.put(ReportUIController());
                  ReportHelper.showReportDialog(
                    context: Get.context!,
                    uiController: reportUIController,
                    index: 0,
                    title: AppString.exportCustomersContacts,
                  );
                },
              ),
            ],
          ),
        ),

        // Logout Section
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSize.p16,
            AppSize.p8,
            AppSize.p16,
            AppSize.height * 0.08,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.logoutBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  AppIcon.logout,
                  color: AppColor.logoutIcon,
                  size: 20,
                ),
              ),
              title: Text(
                AppString.logout,
                style: TextStyle(
                  color: AppColor.logoutText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                await LocalDatabase().logout();
                Get.offAllNamed('/login');
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _drawerItem({
  required int index,
  required String title,
  required IconData icon,
  required void Function()? onTap,
}) {
  final NavDrawerController navDrawerController = Get.find();
  return Obx(() {
    bool isSelected = navDrawerController.selectedIndex.value == index;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.p4),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColor.drawerSelectedBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor.drawerSelectedBorder,
                    width: 1,
                  ),
                )
              : null,
          child: ListTile(
            onTap: onTap,
            dense: true,
            visualDensity: const VisualDensity(vertical: -1),
            leading: Icon(
              icon,
              color: isSelected ? AppColor.goldColor : AppColor.primaryColor,
              size: 24,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColor.goldColor : AppColor.primaryColor,
                fontSize: AppSize.largeText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
        if (!isSelected)
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColor.grey200,
            indent: AppSize.p16,
            endIndent: AppSize.p16,
          ),
      ],
    );
  });
}

class HeaderArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColor.goldColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.9,
      size.width,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
