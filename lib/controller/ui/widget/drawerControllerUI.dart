// ignore_for_file: file_names

import 'package:get/get.dart';

class NavDrawerController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
