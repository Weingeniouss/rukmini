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
    backgroundColor: AppColor.primaryColor,
    elevation: 5,
    child: Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: AppColor.primaryColor,
            border: Border(bottom: BorderSide.none),
          ),
          child: Row(
            children: [
              Image.asset(AppLogo.rukminiLogo2, scale: 7),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final role = loginAPI.loginData.value.data?.roleName;
                      return Text(
                        role ?? 'User',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColor.fullScreenColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      );
                    }),
                    Text(
                      loginAPI.loginUI.emailController.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.textField,
                        fontSize: AppSize.size15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                listTital(
                  index: 0,
                  title: AppString.home,
                  icon: AppIcon.home,
                  onTap: () {
                    navDrawerController.changeIndex(0);
                    Get.toNamed('/home');
                  },
                ),
                listTital(
                  index: 1,
                  title: AppString.allMaster,
                  icon: AppIcon.settings,
                  onTap: () {
                    navDrawerController.changeIndex(1);
                    Get.toNamed('/allMaster');
                  },
                ),
                listTital(
                  index: 2,
                  title: AppString.customer,
                  icon: AppIcon.personOutline,
                  onTap: () {
                    navDrawerController.changeIndex(2);
                    Get.toNamed('/custList');
                  },
                ),
                listTital(
                  index: 3,
                  title: AppString.girvi,
                  icon: AppIcon.bank,
                  onTap: () {
                    navDrawerController.changeIndex(3);
                    Get.toNamed('/giriviList');
                  },
                ),
                listTital(
                  index: 4,
                  title: AppString.products,
                  icon: AppIcon.grid,
                  onTap: () {
                    navDrawerController.changeIndex(4);
                    Get.toNamed('/pendingProduct');
                  },
                ),
                listTital(
                  index: 5,
                  title: AppString.productinLocker,
                  icon: AppIcon.lockPerson,
                  onTap: () {
                    navDrawerController.changeIndex(5);
                    Get.toNamed('/productInLocker');
                  },
                ),
                listTital(
                  index: 6,
                  title: AppString.pendingTransaction,
                  icon: AppIcon.pending,
                  onTap: () {
                    navDrawerController.changeIndex(6);
                    Get.toNamed('/dueGirvi');
                  },
                ),
                listTital(
                  index: 7,
                  title: AppString.lockerTransaction,
                  icon: AppIcon.lockReset,
                  onTap: () {
                    navDrawerController.changeIndex(7);
                    Get.toNamed('/lockerTransaction');
                  },
                ),
                listTital(
                  index: 8,
                  title: AppString.reports,
                  icon: AppIcon.description,
                  onTap: () {
                    navDrawerController.changeIndex(8);
                    Get.toNamed('/report');
                  },
                ),
                listTital(
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
        ),
        const Divider(color: AppColor.textField, thickness: 0.5),
        ListTile(
          leading: const Icon(AppIcon.logout, color: AppColor.deleteColor),
          title: const Text(
            'Logout',
            style: TextStyle(color: AppColor.deleteColor),
          ),
          onTap: () async {
            await LocalDatabase().logout();
            Get.offAllNamed('/login');
          },
        ),
        const SizedBox(height: 50),
      ],
    ),
  );
}

Widget listTital({
  required int index,
  required String title,
  required IconData icon,
  required void Function()? onTap,
}) {
  final NavDrawerController navDrawerController = Get.find();
  return Obx(() {
    bool isSelected = navDrawerController.selectedIndex.value == index;
    Color itemColor = isSelected
        ? AppColor.goldColor
        : AppColor.fullScreenColor;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      leading: Icon(icon, color: itemColor, size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontSize: Get.width * 0.038,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  });
}
