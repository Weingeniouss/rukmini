// ignore_for_file: file_names

import 'package:rukmini/modal/drawer/home/girvi/girvi_detail_modal.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviAdd_Controller.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class AddGiriviControllerUI extends GetxController {
  final custListController = Get.put(CustListController());
  final giriviAddController = Get.put(GiriviAddController());

  var selectedCustomerId = ''.obs;
  var customerName = ''.obs;
  var customerPhone = ''.obs;
  var address = ''.obs;

  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final addressController = TextEditingController();
  final dateController = TextEditingController();
  final durationController = TextEditingController();
  final dueDateController = TextEditingController();
  final interestRateController = TextEditingController();
  final totalAmountGivenController = TextEditingController();
  final interestAmountController = TextEditingController();
  final totalAmountReceivableController = TextEditingController();

  var selectedImage = Rxn<XFile>();
  var productsList = <Map<String, dynamic>>[].obs;
  var isEdit = false.obs;
  var girviId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Listen to changes to calculate values
    durationController.addListener(calculateDueDate);
    interestRateController.addListener(calculateAmounts);
    totalAmountGivenController.addListener(calculateAmounts);
  }

  void populateData(GiriviDetailData data) {
    isEdit.value = true;
    girviId.value = data.girviId ?? '';
    selectedCustomerId.value = data.custId ?? '';
    customerName.value = data.custName ?? '';
    customerNameController.text = data.custName ?? '';
    customerPhone.value = data.custPhone ?? '';
    customerPhoneController.text = data.custPhone ?? '';
    address.value = data.address ?? '';
    addressController.text = data.address ?? '';

    dateController.text = data.girviDate ?? '';
    durationController.text = data.givenMonth ?? '';
    dueDateController.text = data.dueDate ?? '';
    interestRateController.text = data.interest ?? '';
    totalAmountGivenController.text = data.givenAmt ?? '';
    
    calculateAmounts();

    productsList.clear();
    if (data.productDetail != null) {
      for (var product in data.productDetail!) {
        productsList.add({
          "ProductId": product.productId,
          "ProductTypeId": product.productTypeId,
          "CategoryId": product.categoryId,
          "MetalId": product.metalId,
          "Pieces": product.pieces,
          "Weight": product.weight,
          "TodayRate": product.todayRate,
          "OrigAmount": product.origAmount,
          "GivenAmount": product.givenAmount,
          "IsDiamond": product.isDiamond,
          "IsHallmark": product.isHallmark,
          "LockerCode": (product.lockerList != null && product.lockerList!.isNotEmpty)
              ? product.lockerList!.first.lockerCode
              : '',
          // Add other fields as necessary
        });
      }
    }
  }

  void clearData() {
    isEdit.value = false;
    girviId.value = '';
    selectedCustomerId.value = '';
    customerName.value = '';
    customerNameController.clear();
    customerPhone.value = '';
    customerPhoneController.clear();
    address.value = '';
    addressController.clear();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    durationController.clear();
    dueDateController.clear();
    interestRateController.clear();
    totalAmountGivenController.clear();
    interestAmountController.clear();
    totalAmountReceivableController.clear();
    productsList.clear();
    selectedImage.value = null;
  }

  void addProduct(Map<String, dynamic> product) {
    productsList.add(product);
  }

  void updateProduct(int index, Map<String, dynamic> product) {
    productsList[index] = product;
  }

  Future<void> submitGirivi() async {
    if (selectedCustomerId.value.isEmpty) {
      ToastificationError.Error(AppString.pleaseSelectCustomer);
      return;
    }

    final response = await CallApi.callAddGirivi(
      custId: selectedCustomerId.value,
      girviDate: dateController.text,
      givenMonth: durationController.text,
      dueDate: dueDateController.text,
      interest: interestRateController.text,
      givenAmt: totalAmountGivenController.text,
      address: address.value,
      productDel: jsonEncode(productsList),
      image_i: selectedImage.value,
    );

    if (response != null && response.status == true) {
      Get.back();
    }
  }

  void calculateDueDate() {
    if (durationController.text.isNotEmpty && dateController.text.isNotEmpty) {
      try {
        DateTime startDate = DateFormat(
          'yyyy-MM-dd',
        ).parse(dateController.text);
        int months = int.parse(durationController.text);
        DateTime dueDate = DateTime(
          startDate.year,
          startDate.month + months,
          startDate.day,
        );
        dueDateController.text = DateFormat('yyyy-MM-dd').format(dueDate);
      } catch (e) {
        dueDateController.text = '';
      }
    } else {
      dueDateController.text = '';
    }
  }

  void calculateAmounts() {
    if (totalAmountGivenController.text.isNotEmpty &&
        interestRateController.text.isNotEmpty) {
      try {
        double amount = double.parse(totalAmountGivenController.text);
        double rate = double.parse(interestRateController.text);
        int months = int.tryParse(durationController.text) ?? 1;

        double interest = (amount * rate * months) / 100;
        interestAmountController.text = interest.toStringAsFixed(2);
        totalAmountReceivableController.text = (amount + interest)
            .toStringAsFixed(2);
      } catch (e) {
        interestAmountController.text = '';
        totalAmountReceivableController.text = '';
      }
    } else {
      interestAmountController.text = '';
      totalAmountReceivableController.text = '';
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  @override
  void onClose() {
    customerNameController.dispose();
    customerPhoneController.dispose();
    addressController.dispose();
    dateController.dispose();
    durationController.dispose();
    dueDateController.dispose();
    interestRateController.dispose();
    totalAmountGivenController.dispose();
    interestAmountController.dispose();
    totalAmountReceivableController.dispose();
    super.onClose();
  }
}
