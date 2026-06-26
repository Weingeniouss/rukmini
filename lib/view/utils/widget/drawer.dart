import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../controller/local/localDatabase.dart';
import '../app_Color.dart';
import '../app_logo.dart';

Widget homeDrawer() {
  final loginAPI = Get.put(LoginControllerAPI());
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
                      style: const TextStyle(
                        color: AppColor.textField,
                        fontSize: 12,
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                listTital(title: AppString.home, onTap: () {}),
                listTital(title: AppString.allMaster, onTap: () {}),
                listTital(title: AppString.customer, onTap: () {}),
                listTital(title: AppString.girvi, onTap: () {}),
                listTital(title: AppString.products, onTap: () {}),
                listTital(title: AppString.productinLocker, onTap: () {}),
                listTital(title: AppString.pendingTransaction, onTap: () {}),
                listTital(title: AppString.lockerTransaction, onTap: () {}),
                listTital(title: AppString.reports, onTap: () {}),
                listTital(
                  title: AppString.exportCustomersContacts,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        Divider(color: AppColor.textField, thickness: 0.5),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text('Logout', style: TextStyle(color: Colors.red)),
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

Widget listTital({required String title, required void Function()? onTap}) {
  return ListTile(
    dense: true,
    visualDensity: VisualDensity(vertical: -4),
    leading: Icon(Icons.home, color: AppColor.fullScreenColor, size: 20),
    title: Text(
      title,
      style: TextStyle(
        color: AppColor.fullScreenColor,
        fontSize: Get.width * 0.037,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: onTap ?? () => Get.back(),
  );
}
