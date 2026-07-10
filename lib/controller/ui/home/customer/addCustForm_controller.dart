// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCustFormControllerUI extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Text Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final nomineeNameController = TextEditingController();
  final nomineePhoneController = TextEditingController();
  final nomineeRelationController = TextEditingController();

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

  // Customer Photos list
  var customerPhotoControllers = <TextEditingController>[
    TextEditingController(),
  ].obs;
  var customerPhotoImages = <Rx<XFile?>>[Rx<XFile?>(null)].obs;

  // Identity Proofs list
  var identityProofControllers = <TextEditingController>[
    TextEditingController(),
  ].obs;
  var identityProofImages = <Rx<XFile?>>[Rx<XFile?>(null)].obs;

  Future<void> pickCustomerPhoto(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      customerPhotoImages[index].value = image;
    }
  }

  Future<void> pickIdentityProof(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      identityProofImages[index].value = image;
    }
  }

  void addPhoneField() {
    phoneControllers.add(TextEditingController());
  }

  void removePhoneField(int index) {
    if (phoneControllers.length > 1) {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
    }
  }

  void addCustomerPhotoField() {
    customerPhotoControllers.add(TextEditingController());
    customerPhotoImages.add(Rx<XFile?>(null));
  }

  void removeCustomerPhotoField(int index) {
    if (customerPhotoControllers.length > 1) {
      customerPhotoControllers[index].dispose();
      customerPhotoControllers.removeAt(index);
      customerPhotoImages.removeAt(index);
    }
  }

  void addIdentityProofField() {
    identityProofControllers.add(TextEditingController());
    identityProofImages.add(Rx<XFile?>(null));
  }

  void removeIdentityProofField(int index) {
    if (identityProofControllers.length > 1) {
      identityProofControllers[index].dispose();
      identityProofControllers.removeAt(index);
      identityProofImages.removeAt(index);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    nomineeNameController.dispose();
    nomineePhoneController.dispose();
    nomineeRelationController.dispose();
    for (var controller in phoneControllers) {
      controller.dispose();
    }
    for (var controller in customerPhotoControllers) {
      controller.dispose();
    }
    for (var controller in identityProofControllers) {
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
