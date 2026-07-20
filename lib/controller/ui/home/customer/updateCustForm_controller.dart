// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../modal/drawer/home/customer/customer_detail_model.dart';

class UpdateCustFormControllerUI extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;

  late CustomerDetailData customerData;

  // IDs
  String custId = '';
  String custDelId = '';
  String nomineeId = '';
  var profileIds = <String>[].obs;
  var proofIds = <String>[].obs;
  var phoneIds = <String>[].obs;
  String eProofId = '';
  String eProfileId = '';

  // ... (rest of text controllers)
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final nomineeNameController = TextEditingController();
  final nomineePhoneController = TextEditingController();
  final nomineeRelationController = TextEditingController();

  // Gender selection
  var selectedGender = 'Male'.obs;

  // Grace days
  var selectedGraceDays = '0'.obs;
  final graceDaysList = ['0', '5', '10', '15', '20', '25', '30'].obs;

  // Customer Type
  var selectedCustType = 'Goody'.obs;
  final custTypeList = ['Goody', 'Shoppe'].obs;

  // Phone numbers list
  var phoneControllers = <TextEditingController>[].obs;

  // Customer Photos list
  var customerPhotoControllers = <TextEditingController>[].obs;
  var customerPhotoImages = <Rx<XFile?>>[].obs;

  // Identity Proofs list
  var identityProofControllers = <TextEditingController>[].obs;
  var identityProofImages = <Rx<XFile?>>[].obs;

  @override
  void onInit() {
    super.onInit();
    customerData = Get.arguments as CustomerDetailData;
    initData();
  }

  void initData() {
    custId = customerData.custId ?? '';
    nameController.text = customerData.name ?? '';
    addressController.text = customerData.address ?? '';
    selectedGender.value = customerData.gender ?? 'Male';
    selectedGraceDays.value = customerData.gracePeriod ?? '0';
    if (!graceDaysList.contains(selectedGraceDays.value)) {
      graceDaysList.add(selectedGraceDays.value);
    }

    if (customerData.custType != null && customerData.custType!.isNotEmpty) {
      String typeName = customerData.custType!.first.typeName ?? 'Goody';
      if (!custTypeList.contains(typeName)) {
        custTypeList.add(typeName);
      }
      selectedCustType.value = typeName;
      custDelId = customerData.custType!.first.custDelId ?? '';
    }

    if (customerData.nominee != null) {
      nomineeNameController.text = customerData.nominee!.name ?? '';
      nomineePhoneController.text = customerData.nominee!.phone ?? '';
      nomineeRelationController.text = customerData.nominee!.custRelation ?? '';
      nomineeId = customerData.nominee!.nomineeId ?? '';
    }

    if (customerData.phone != null && customerData.phone!.isNotEmpty) {
      for (var p in customerData.phone!) {
        phoneIds.add(p.phoneId ?? '');
        phoneControllers.add(TextEditingController(text: p.phone));
      }
    } else {
      phoneControllers.add(TextEditingController());
    }

    if (customerData.profile != null && customerData.profile!.isNotEmpty) {
      eProfileId = customerData.profile!.first.profileId ?? '';
      for (var p in customerData.profile!) {
        profileIds.add(p.profileId ?? '');
        customerPhotoControllers.add(TextEditingController(text: p.name));
        customerPhotoImages.add(Rx<XFile?>(null));
      }
    } else {
      customerPhotoControllers.add(TextEditingController());
      customerPhotoImages.add(Rx<XFile?>(null));
    }

    if (customerData.proof != null && customerData.proof!.isNotEmpty) {
      eProofId = customerData.proof!.first.proofId ?? '';
      for (var p in customerData.proof!) {
        proofIds.add(p.proofId ?? '');
        identityProofControllers.add(TextEditingController(text: p.name));
        identityProofImages.add(Rx<XFile?>(null));
      }
    } else {
      identityProofControllers.add(TextEditingController());
      identityProofImages.add(Rx<XFile?>(null));
    }
  }

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

  List<String> getEditPhoneList() {
    return phoneControllers
        .map((e) => e.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
  }
}
