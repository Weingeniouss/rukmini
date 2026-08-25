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
  var isHallmark = false.obs;
  
  final diamondPiecesController = TextEditingController();
  final diamondWeightController = TextEditingController();
  final certificateNumberController = TextEditingController();
  final diamondPriceController = TextEditingController();
  
  var productImages = <XFile>[].obs;
  var isEdit = false.obs;
  var productIndex = (-1).obs;

  void populateData(Map<String, dynamic> product, int index) {
    isEdit.value = true;
    productIndex.value = index;

    selectedMetalTouch.value = product['MetalTouch'] ?? '';
    selectedMetalTouchId.value = product['MetalId'] ?? '';
    selectedMetal.value = product['MetalName'] ?? '';
    selectedProductTypeId.value = product['ProductTypeId'] ?? '';
    selectedCategory.value = product['CategoryName'] ?? '';
    selectedCategoryId.value = product['CategoryId'] ?? '';
    
    quantityController.text = product['Pieces']?.toString() ?? '';
    weightController.text = product['Weight']?.toString() ?? '';
    todaysRateController.text = product['TodayRate']?.toString() ?? '';
    originalPriceController.text = product['OrigAmount']?.toString() ?? '';
    amountGivenController.text = product['GivenAmount']?.toString() ?? '';
    lockerCodeController.text = product['LockerCode']?.toString() ?? '';
    remarkController.text = product['Remark']?.toString() ?? '';
    
    isDiamondAvailable.value = product['IsDiamond'] == "1";
    isHallmark.value = product['IsHallmark'] == "1";

    diamondPiecesController.text = product['DiamondPieces']?.toString() ?? '';
    diamondWeightController.text = product['DiamondWeight']?.toString() ?? '';
    certificateNumberController.text = product['CertificateNo']?.toString() ?? '';
    diamondPriceController.text = product['DiamondPrice']?.toString() ?? '';
  }

  void clearData() {
    isEdit.value = false;
    productIndex.value = -1;
    
    selectedMetal.value = '';
    selectedMetalId.value = '';
    selectedProductType.value = '';
    selectedProductTypeId.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = '';
    selectedMetalTouch.value = '';
    selectedMetalTouchId.value = '';
    selectedLocker.value = '';
    
    quantityController.clear();
    weightController.clear();
    todaysRateController.clear();
    originalPriceController.clear();
    amountGivenController.clear();
    lockerCodeController.clear();
    remarkController.clear();
    
    isDiamondAvailable.value = false;
    isHallmark.value = false;

    diamondPiecesController.clear();
    diamondWeightController.clear();
    certificateNumberController.clear();
    diamondPriceController.clear();
    
    productImages.clear();
  }

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
