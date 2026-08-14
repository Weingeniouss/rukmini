// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductControllerUI extends GetxController {
  var selectedMetal = ''.obs;
  var selectedMetalId = ''.obs;
  var selectedProductType = ''.obs;
  var selectedProductTypeId = ''.obs;
  var selectedCategory = ''.obs;
  var selectedCategoryId = ''.obs;
  var selectedMetalTouch = ''.obs;
  var selectedMetalTouchId = ''.obs;
  var selectedLocker = ''.obs;
  
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final todaysRateController = TextEditingController();
  final originalPriceController = TextEditingController();
  final amountGivenController = TextEditingController();
  final lockerCodeController = TextEditingController();
  final remarkController = TextEditingController();
  
  var isDiamondAvailable = false.obs;
  
  final diamondPiecesController = TextEditingController();
  final diamondWeightController = TextEditingController();
  final certificateNumberController = TextEditingController();
  final diamondPriceController = TextEditingController();
  
  var productImages = <XFile>[].obs;

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      productImages.add(image);
    }
  }

  void removeImage(int index) {
    productImages.removeAt(index);
  }

  @override
  void onClose() {
    quantityController.dispose();
    weightController.dispose();
    todaysRateController.dispose();
    originalPriceController.dispose();
    amountGivenController.dispose();
    lockerCodeController.dispose();
    remarkController.dispose();
    diamondPiecesController.dispose();
    diamondWeightController.dispose();
    certificateNumberController.dispose();
    diamondPriceController.dispose();
    super.onClose();
  }
}
