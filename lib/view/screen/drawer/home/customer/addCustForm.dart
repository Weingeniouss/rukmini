// ignore_for_file: avoid_print, deprecated_member_use, file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/button.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/controller/ui/home/customer/addCustForm_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';

class AddCustForm extends StatelessWidget {
  final AddCustFormControllerUI addCustForomUI;

  const AddCustForm({super.key, required this.addCustForomUI});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        back: true,
        title: AppString.addCustomerForm,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            customerDetails(addCustForomUI),
            nomineeDetails(addCustForomUI),
            identificationProof(
              addCustForomUI,
              callSumit: () async {
                addCustForomUI.isLoading.value = true;
                final result = await CallApi.callAddCustomer(
                  name: addCustForomUI.nameController.text,
                  typeDel: addCustForomUI.selectedCustType.value,
                  phoneDel: jsonEncode(addCustForomUI.getAddPhoneList()),
                  phones: addCustForomUI.getAddPhoneList(),
                  address: addCustForomUI.addressController.text,
                  gender: addCustForomUI.selectedGender.value,
                  nName: addCustForomUI.nomineeNameController.text,
                  nPhone: addCustForomUI.nomineePhoneController.text,
                  custRelation: addCustForomUI.nomineeRelationController.text,
                  gracePeriod: addCustForomUI.selectedGraceDays.value,
                  isProfile: addCustForomUI.customerPhotoControllers.isNotEmpty
                      ? "1"
                      : "0",
                  profileName:
                      addCustForomUI.customerPhotoControllers.isNotEmpty
                      ? addCustForomUI.customerPhotoControllers[0].text
                      : "",
                  profileNames: addCustForomUI.customerPhotoControllers
                      .map((e) => e.text)
                      .toList(),
                  proofNames: addCustForomUI.identityProofControllers
                      .map((e) => e.text)
                      .toList(),
                  profileImages: addCustForomUI.customerPhotoImages
                      .map((e) => e.value)
                      .toList(),
                  proofImages: addCustForomUI.identityProofImages
                      .map((e) => e.value)
                      .toList(),
                );
                await CallApi.callCustList(isRefresh: true);
                addCustForomUI.isLoading.value = false;
                if (result != null && result.status == true) {
                  Get.back();
                }
              },
            ),
            SizedBox(height: AppSize.p40),
          ],
        ),
      ),
    );
  }
}

Widget _sectionHeader(String title, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.p16,
      vertical: AppSize.p12,
    ),
    decoration: BoxDecoration(
      color: AppColor.whiteOrang.withOpacity(0.3),
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.p20)),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSize.p8),
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.goldColor.withOpacity(0.1),
                blurRadius: AppSize.p4,
              ),
            ],
          ),
          child: Icon(icon, color: AppColor.goldColor, size: AppSize.p20),
        ),
        SizedBox(width: AppSize.p12),
        Text(
          title,
          style: TextStyle(
            fontSize: AppSize.headingText,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        const Spacer(),
        Icon(
          AppIcon.leaf,
          color: AppColor.goldColor.withOpacity(0.1),
          size: AppSize.iconLarge * 1.25,
        ),
      ],
    ),
  );
}

Widget customerDetails(AddCustFormControllerUI controller) {
  return horizontalPadding(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p20),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, AppSize.p4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(AppString.customerDetail, AppIcon.person),
          Padding(
            padding: EdgeInsets.all(AppSize.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputField(
                  hintText: AppString.customerName,
                  icon: AppIcon.person,
                  inputTextcontroller: controller.nameController,
                ),
                Obx(
                  () => Column(
                    children: List.generate(
                      controller.phoneControllers.length,
                      (index) {
                        return inputField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          hintText: "${AppString.phone} ${index + 1}",
                          icon: AppIcon.phone,
                          inputTextcontroller: controller.phoneControllers[index],
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (index == 0) {
                                controller.addPhoneField();
                              } else {
                                controller.removePhoneField(index);
                              }
                            },
                            icon: Icon(
                              index == 0 ? AppIcon.add : AppIcon.removeCircle,
                              color: AppColor.goldColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                inputField(
                  hintText: AppString.address,
                  icon: AppIcon.location,
                  inputTextcontroller: controller.addressController,
                ),

                // Gender Selection
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                  child: Text(
                    AppString.gender,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                      fontSize: AppSize.commonText,
                    ),
                  ),
                ),
                Obx(
                  () => Row(
                    children: [
                      _customRadioButton(
                        title: AppString.male,
                        value: AppString.male,
                        groupValue: controller.selectedGender.value,
                        onChanged: (v) => controller.updateGender(v),
                      ),
                      SizedBox(width: AppSize.p20),
                      _customRadioButton(
                        title: AppString.female,
                        value: AppString.female,
                        groupValue: controller.selectedGender.value,
                        onChanged: (v) => controller.updateGender(v),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSize.p16),

                // Grace Days Dropdown
                _formDropDown(
                  title: AppString.gracedDays,
                  icon: AppIcon.calendar,
                  value: controller.selectedGraceDays,
                  items: controller.graceDaysList,
                  onChanged: controller.updateGraceDays,
                ),

                SizedBox(height: AppSize.p16),

                // Customer Type Dropdown
                _formDropDown(
                  title: AppString.customerTypes,
                  icon: AppIcon.category,
                  value: controller.selectedCustType,
                  items: controller.custTypeList,
                  onChanged: controller.updateCustType,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _customRadioButton({
  required String title,
  required String value,
  required String groupValue,
  required Function(String?) onChanged,
}) {
  bool isSelected = value == groupValue;
  return GestureDetector(
    onTap: () => onChanged(value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.p24 - 2,
          height: AppSize.p24 - 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColor.goldColor : AppColor.grey300,
              width: 2,
            ),
          ),
          child: Center(
            child: isSelected
                ? Container(
                    width: AppSize.p12,
                    height: AppSize.p12,
                    decoration: BoxDecoration(
                      color: AppColor.goldColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(width: AppSize.p8),
        Text(
          title,
          style: TextStyle(
            fontSize: AppSize.commonText,
            color: AppColor.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Widget _formDropDown({
  required String title,
  required IconData icon,
  required RxString value,
  required RxList<String> items,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColor.black,
          fontSize: AppSize.commonText,
        ),
      ),
      SizedBox(height: AppSize.p8),
      Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p12),
            border: Border.all(color: AppColor.grey300.withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.value,
              icon: Icon(AppIcon.arrow_down, color: AppColor.goldColor),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: AppColor.goldColor, size: AppSize.p20),
                      SizedBox(width: AppSize.p12),
                      Text(
                        item,
                        style: TextStyle(fontSize: AppSize.commonText),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget nomineeDetails(AddCustFormControllerUI controller) {
  return horizontalPadding(
    child: Container(
      margin: EdgeInsets.only(bottom: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p20),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, AppSize.p4),
          ),
        ],
      ),
      child: Column(
        children: [
          _sectionHeader(AppString.nomineeDetail, AppIcon.person),
          Padding(
            padding: EdgeInsets.all(AppSize.p16),
            child: Column(
              children: [
                inputField(
                  hintText: AppString.nomineeName,
                  icon: AppIcon.person,
                  inputTextcontroller: controller.nomineeNameController,
                ),
                inputField(
                  hintText: AppString.nomineePhoneNumber,
                  icon: AppIcon.phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  inputTextcontroller: controller.nomineePhoneController,
                ),
                inputField(
                  hintText: AppString.customerRelation,
                  icon: AppIcon.status,
                  inputTextcontroller: controller.nomineeRelationController,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget identificationProof(
  AddCustFormControllerUI controller, {
  void Function()? callSumit,
}) {
  return horizontalPadding(
    child: Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p20),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, AppSize.p4),
          ),
        ],
      ),
      child: Column(
        children: [
          _sectionHeader(AppString.identiyProof, AppIcon.security),
          Padding(
            padding: EdgeInsets.all(AppSize.p16),
            child: Column(
              children: [
                photoListSection(
                  title: AppString.customerPhotos,
                  controllers: controller.customerPhotoControllers,
                  images: controller.customerPhotoImages,
                  onAdd: controller.addCustomerPhotoField,
                  onRemove: controller.removeCustomerPhotoField,
                  onPick: controller.pickCustomerPhoto,
                  hintText: AppString.personName,
                ),
                SizedBox(height: AppSize.p16),
                Divider(color: AppColor.grey300.withOpacity(0.5)),
                SizedBox(height: AppSize.p16),
                photoListSection(
                  title: AppString.customerProof,
                  controllers: controller.identityProofControllers,
                  images: controller.identityProofImages,
                  onAdd: controller.addIdentityProofField,
                  onRemove: controller.removeIdentityProofField,
                  onPick: controller.pickIdentityProof,
                  hintText: AppString.identifyProofType,
                ),
                SizedBox(height: AppSize.p24),
                GestureDetector(
                  onTap: controller.isLoading.value ? null : callSumit,
                  child: Obx(
                    () => clickButton(
                      AppString.sumit,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget photoListSection({
  required String title,
  required RxList<TextEditingController> controllers,
  required RxList<Rx<XFile?>> images,
  required VoidCallback onAdd,
  required Function(int) onRemove,
  required Function(int) onPick,
  required String hintText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSize.commonText,
              color: AppColor.black,
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: Icon(AppIcon.add, color: AppColor.goldColor),
          ),
        ],
      ),
      SizedBox(height: AppSize.p8),
      Obx(
        () => Column(
          children: List.generate(controllers.length, (index) {
            return Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onPick(index),
                      child: Obx(
                        () => Container(
                          width: AppSize.width * 0.15,
                          height: AppSize.width * 0.15,
                          decoration: BoxDecoration(
                            color: AppColor.backgroundColor,
                            borderRadius: BorderRadius.circular(AppSize.p8),
                            border: Border.all(color: AppColor.grey300),
                            image: images[index].value != null
                                ? DecorationImage(
                                    image: FileImage(
                                      File(images[index].value!.path),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: images[index].value == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      AppIcon.camera,
                                      color: AppColor.goldColor,
                                      size: AppSize.p20 - 2,
                                    ),
                                    Text(
                                      AppString.image,
                                      style: TextStyle(
                                        fontSize: AppSize.extraSmallText,
                                        color: AppColor.goldColor,
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.p12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(AppSize.p8),
                          border: Border.all(
                            color: AppColor.grey300.withOpacity(0.5),
                          ),
                        ),
                        child: TextField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                              fontSize: AppSize.smallText,
                              color: AppColor.textColor.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            suffixIcon: index == 0
                                ? null
                                : IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => onRemove(index),
                                    icon: Icon(
                                      AppIcon.removeCircle,
                                      color: AppColor.deleteColor,
                                      size: AppSize.p20,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.p12),
              ],
            );
          }),
        ),
      ),
    ],
  );
}
