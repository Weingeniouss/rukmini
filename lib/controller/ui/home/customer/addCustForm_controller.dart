// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddCustFormController extends GetxController {
  // Gender selection
  var selectedGender = 'Male'.obs;

  // Grace days
  var selectedGraceDays = '0'.obs;
  final List<String> graceDaysList = ['0', '5', '10', '15', '20', '25', '30'];

  // Customer Type
  var selectedCustType = 'Goody'.obs;
  final List<String> custTypeList = ['Goody', 'Shoppe'];

  // Phone numbers list
  var phoneControllers = <TextEditingController>[TextEditingController()].obs;

  void addPhoneField() {
    phoneControllers.add(TextEditingController());
  }

  void removePhoneField(int index) {
    if (phoneControllers.length > 1) {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
    }
  }

  @override
  void onClose() {
    for (var controller in phoneControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void updateGender(String? value) {
    if (value != null) selectedGender.value = value;
  }

  void updateGraceDays(String? value) {
    if (value != null) selectedGraceDays.value = value;
  }

  void updateCustType(String? value) {
    if (value != null) selectedCustType.value = value;
  }
}
