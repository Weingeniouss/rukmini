// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_string.dart';
import '../../../controller/local/localDatabase.dart';
import '../app_color.dart';
import '../app_icon.dart';
import '../app_logo.dart';

Widget homeDrawer({bool isCollapsed = false}) {
  final loginAPI = Get.put(LoginControllerAPI());
  final navDrawerController = Get.put(NavDrawerController());

  return Drawer(
    backgroundColor: AppColor.drawerBg,
    elevation: 0,
    child: Column(
      children: [
        // Custom Header with Collapse/Expand Toggle
        if (isCollapsed)
          _buildCollapsedHeader(navDrawerController)
        else
          _buildExpandedHeader(loginAPI, navDrawerController),

        // Drawer Items
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 6 : AppSize.p16,
            ),
            children: [
              _drawerItem(
                index: 0,
                title: AppString.home,
                icon: AppIcon.home,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/home', 0);
                },
              ),
              _drawerItem(
                index: 1,
                title: AppString.allMaster,
                icon: AppIcon.settings,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/allMaster', 1);
                },
              ),
              _drawerItem(
                index: 2,
                title: AppString.customer,
                icon: AppIcon.personOutline,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/custList', 2);
                },
              ),
              _drawerItem(
                index: 3,
                title: AppString.girvi,
                icon: AppIcon.bank,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/giriviList', 3);
                },
              ),
              _drawerItem(
                index: 4,
                title: AppString.products,
                icon: AppIcon.grid,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/pendingProduct', 4);
                },
              ),
              _drawerItem(
                index: 5,
                title: AppString.productinLocker,
                icon: AppIcon.lockPerson,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer(
                    '/productInLocker',
                    5,
                  );
                },
              ),
              _drawerItem(
                index: 6,
                title: AppString.pendingTransaction,
                icon: AppIcon.pending,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/dueGirvi', 6);
                },
              ),
              _drawerItem(
                index: 7,
                title: AppString.lockerTransaction,
                icon: AppIcon.lockReset,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer(
                    '/lockerTransaction',
                    7,
                  );
                },
              ),
              _drawerItem(
                index: 8,
                title: AppString.reports,
                icon: AppIcon.description,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/report', 8);
                },
              ),
              _drawerItem(
                index: 9,
                title: AppString.exportCustomersContacts,
                icon: AppIcon.contact,
                isSpecial: true,
                isCollapsed: isCollapsed,
                onTap: () {
                  navDrawerController.navigateFromDrawer('/exportContacts', 9);
                },
              ),
            ],
          ),
        ),

        // Logout Section
        _buildLogoutButton(isCollapsed),
      ],
    ),
  );
}

Widget _buildCollapsedHeader(NavDrawerController navDrawerController) {
  return Container(
    height: 100,
    padding: const EdgeInsets.only(top: 20),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: "Expand Drawer",
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.goldTagBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              AppIcon.chevronRight,
              color: AppColor.dashboardGold,
              size: 20,
            ),
          ),
          onPressed: () => navDrawerController.toggleDrawerCollapse(),
        ),
      ],
    ),
  );
}

Widget _buildExpandedHeader(
  LoginControllerAPI loginAPI,
  NavDrawerController navDrawerController,
) {
  final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

  return SizedBox(
    height: isDesktopOrTablet ? 140.0 : AppSize.height * 0.27,
    child: Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: HeaderArcPainter())),
        if (isDesktopOrTablet)
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              tooltip: "Collapse Drawer",
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColor.goldTagBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  AppIcon.chevronLeft,
                  color: AppColor.dashboardGold,
                  size: 18,
                ),
              ),
              onPressed: () => navDrawerController.toggleDrawerCollapse(),
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSize.p16,
            isDesktopOrTablet ? AppSize.p20 : AppSize.height * 0.07,
            AppSize.p16,
            AppSize.p16,
          ),
          child: GestureDetector(
            onTap: () {
              NavDrawerController.toNamed('/profile');
            },
            child: Row(
              children: [
                Image.asset(
                  AppLogo.rukminiLogo2,
                  height: isDesktopOrTablet ? 54.0 : AppSize.height * 0.12,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final role = loginAPI.loginData.value.data?.roleName;
                        return Text(
                          role ?? AppString.user,
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                isDesktopOrTablet ? 16.0 : AppSize.extraLargeText,
                          ),
                        );
                      }),
                      const SizedBox(height: 2),
                      Text(
                        loginAPI.loginUI.emailController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColor.textField,
                          fontSize: isDesktopOrTablet ? 11.0 : AppSize.size14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
  bool isSpecial = false,
  bool isCollapsed = false,
}) {
  final NavDrawerController navDrawerController = Get.find();
  return Obx(() {
    bool isSelected = navDrawerController.selectedIndex.value == index;

    final Color bgColor = isSelected
        ? AppColor.drawerSelectedBg
        : isSpecial
            ? AppColor.goldColor.withOpacity(0.05)
            : Colors.transparent;

    final Border? border = isSelected
        ? Border.all(
            color: AppColor.drawerSelectedBorder,
            width: 1,
          )
        : isSpecial
            ? Border.all(
                color: AppColor.goldColor.withOpacity(0.2),
                width: 1,
              )
            : null;

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: title,
          preferBelow: false,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: border,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: isSelected
                      ? AppColor.goldColor
                      : isSpecial
                          ? AppColor.goldColor
                          : AppColor.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.p4),
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: border != null
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: border,
                    )
                  : null,
              child: ListTile(
                onTap: onTap,
                dense: true,
                visualDensity: const VisualDensity(vertical: -1),
                leading: Icon(
                  icon,
                  color: isSelected
                      ? AppColor.goldColor
                      : isSpecial
                          ? AppColor.goldColor
                          : AppColor.primaryColor,
                  size: (AppSize.isDesktop || AppSize.isTablet) ? 20.0 : 24.0,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? AppColor.goldColor
                        : isSpecial
                            ? AppColor.goldColor
                            : AppColor.primaryColor,
                    fontSize: (AppSize.isDesktop || AppSize.isTablet)
                        ? 13.0
                        : AppSize.largeText,
                    fontWeight: (isSelected || isSpecial)
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
                trailing: isSpecial
                    ? Icon(
                        Icons.star_outline,
                        color: AppColor.goldColor.withOpacity(0.5),
                        size: 18,
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (!isSelected && !isSpecial)
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

Widget _buildLogoutButton(bool isCollapsed) {
  final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

  if (isCollapsed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 8),
      child: Tooltip(
        message: AppString.logout,
        preferBelow: false,
        child: InkWell(
          onTap: () async {
            await LocalDatabase().logout();
            Get.offAllNamed('/login');
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColor.logoutBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              AppIcon.logout,
              color: AppColor.logoutIcon,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  return Padding(
    padding: EdgeInsets.fromLTRB(
      AppSize.p16,
      AppSize.p8,
      AppSize.p16,
      isDesktopOrTablet ? 30.0 : AppSize.height * 0.08,
    ),
    child: Material(
      color: AppColor.logoutBg,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
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
            fontSize: isDesktopOrTablet ? 13.0 : 16.0,
          ),
        ),
        onTap: () async {
          await LocalDatabase().logout();
          Get.offAllNamed('/login');
        },
      ),
    ),
  );
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
