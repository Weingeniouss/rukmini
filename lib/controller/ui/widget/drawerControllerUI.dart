// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_size.dart';

class NavDrawerController extends GetxController {
  var selectedIndex = 0.obs;
  static const int nestedKey = 1;
  static dynamic currentArguments;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  int getIndexForRoute(String route) {
    if (route.startsWith('/home')) {
      return 0;
    }
    if (route.startsWith('/allMaster') ||
        route.startsWith('/metalMaster') ||
        route.startsWith('/categoryMaster') ||
        route.startsWith('/customerTypeMaster') ||
        route.startsWith('/lockerCodeMaster') ||
        route.startsWith('/addLockerCode') ||
        route.startsWith('/metalTouch') ||
        route.startsWith('/yearMaster') ||
        route.startsWith('/addYearMaster')) {
      return 1;
    }
    if (route.startsWith('/custList') ||
        route.startsWith('/custDetail') ||
        route.startsWith('/addCustForm') ||
        route.startsWith('/updateCustForm')) {
      return 2;
    }
    if (route.startsWith('/giriviList') ||
        route.startsWith('/giriviadd') ||
        route.startsWith('/AddProduct') ||
        route.startsWith('/giriviDetail')) {
      return 3;
    }
    if (route.startsWith('/pendingProduct') ||
        route.startsWith('/returnProduct') ||
        route.startsWith('/karkitProduct') ||
        route.startsWith('/soldProduct')) {
      return 4;
    }
    if (route.startsWith('/productInLocker') ||
        route.startsWith('/productInLockerDetail') ||
        route.startsWith('/changeTheLocker')) {
      return 5;
    }
    if (route.startsWith('/dueGirvi') ||
        route.startsWith('/dueOverGirvi')) {
      return 6;
    }
    if (route.startsWith('/lockerTransaction') ||
        route.startsWith('/lockerTransationDetail')) {
      return 7;
    }
    if (route.startsWith('/report') ||
        route.startsWith('/reportView')) {
      return 8;
    }
    if (route.startsWith('/exportContacts')) {
      return 9;
    }
    return selectedIndex.value;
  }

  void navigateFromDrawer(String routeName, int index) {
    selectedIndex.value = index;
    currentArguments = null;
    if (Get.isOverlaysOpen) {
      Get.back();
    }
    if ((AppSize.isDesktop || AppSize.isTablet) && Get.keys[nestedKey] != null) {
      Get.offAllNamed(routeName, id: nestedKey);
    } else {
      Get.toNamed(routeName);
    }
  }

  static void toNamed(String page, {dynamic arguments}) {
    currentArguments = arguments;
    if (Get.isRegistered<NavDrawerController>()) {
      final nav = Get.find<NavDrawerController>();
      nav.selectedIndex.value = nav.getIndexForRoute(page);
    }

    if (Get.isOverlaysOpen) {
      Get.back();
    }

    if ((AppSize.isDesktop || AppSize.isTablet) && Get.keys[nestedKey] != null) {
      Get.toNamed(page, id: nestedKey, arguments: arguments);
    } else {
      Get.toNamed(page, arguments: arguments);
    }
  }

  static dynamic getRouteArguments([BuildContext? context]) {
    if (context != null) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs != null) {
        return routeArgs;
      }
    }
    return Get.arguments ?? currentArguments;
  }

  static void back() {
    if ((AppSize.isDesktop || AppSize.isTablet) &&
        Get.keys[nestedKey]?.currentState?.canPop() == true) {
      Get.back(id: nestedKey);
    } else {
      Get.back();
    }
  }
}
