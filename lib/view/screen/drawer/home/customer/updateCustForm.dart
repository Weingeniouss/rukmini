// ignore_for_file: deprecated_member_use, file_names

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
import 'package:rukmini/view/utils/widget/headingContainer.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/controller/ui/home/customer/updateCustForm_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';

class UpdateCustForm extends StatelessWidget {
  UpdateCustForm({super.key});

  final updateCustUI = Get.put(UpdateCustFormControllerUI());

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(back: true, centerTitle: true, title: "Update Customer"),
      child: SingleChildScrollView(
        child: Column(
          children: [
            customerDetails(updateCustUI),
            nomineeDetails(updateCustUI),
            inputVarticalSpace(),
            identificationProof(
              updateCustUI,
              callSumit: () async {
                updateCustUI.isLoading.value = true;

                // Show what data is being submitted
                print('--- Updating Customer Data ---');
                print('Name: ${updateCustUI.nameController.text}');
                print('Phones: ${jsonEncode(updateCustUI.getEditPhoneList())}');
                print('Address: ${updateCustUI.addressController.text}');
                print('-------------------------------');

                final result = await CallApi.callCustUpdate(
                  custId: updateCustUI.custId,
                  name: updateCustUI.nameController.text,
                  typeDel: updateCustUI.selectedCustType.value,
                  phoneDel: "",
                  phones: updateCustUI.getEditPhoneList(),
                  address: updateCustUI.addressController.text,
                  gender: updateCustUI.selectedGender.value,
                  custDelId: updateCustUI.custDelId,
                  nName: updateCustUI.nomineeNameController.text,
                  nPhone: updateCustUI.nomineePhoneController.text,
                  nomineeId: updateCustUI.nomineeId,
                  gracePeriod: updateCustUI.selectedGraceDays.value,
                  custRelation: updateCustUI.nomineeRelationController.text,
                  profileId: updateCustUI.profileIds.join(','),
                  proofId: updateCustUI.proofIds.join(','),
                  phoneId: updateCustUI.phoneIds.join(','),
                  eProofId: updateCustUI.eProofId,
                  eProfileId: updateCustUI.eProfileId,
                  profileNames: updateCustUI.customerPhotoControllers
                      .map((e) => e.text)
                      .toList(),
                  proofNames: updateCustUI.identityProofControllers
                      .map((e) => e.text)
                      .toList(),
                  profileImages: updateCustUI.customerPhotoImages
                      .map((e) => e.value)
                      .toList(),
                  proofImages: updateCustUI.identityProofImages
                      .map((e) => e.value)
                      .toList(),
                );
                await CallApi.callCustList(isRefresh: true);
                await CallApi.callCustDetail(custId: updateCustUI.custId);
                updateCustUI.isLoading.value = false;
                if (result != null && result.status == true) {
                  Get.back();
                }
              },
            ),
            inputVarticalSpace(),
          ],
        ),
      ),
    );
  }
}

Widget customerDetails(UpdateCustFormControllerUI controller) {
  return Column(
    children: [
      headingContainer(AppString.customerDetail),
      horizontalPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inputField(
              hintText: AppString.customerName,
              icon: AppIcon.person,
              iconColor: AppColor.activeColor,
              inputTextcontroller: controller.nameController,
            ),
            inputVarticalSpace(),
            Obx(
              () => Column(
                children: List.generate(controller.phoneControllers.length, (
                  index,
                ) {
                  return Column(
                    children: [
                      inputField(
                        maxLength: 15,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        hintText: "${AppString.phone} ${index + 1}",
                        icon: AppIcon.phone,
                        iconColor: AppColor.activeColor,
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
                            index == 0 ? AppIcon.add : Icons.remove_circle,
                            color: index == 0
                                ? AppColor.activeColor
                                : AppColor.deleteColor,
                          ),
                        ),
                      ),
                      inputVarticalSpace(),
                    ],
                  );
                }),
              ),
            ),
            inputField(
              hintText: AppString.address,
              icon: AppIcon.location,
              iconColor: AppColor.activeColor,
              inputTextcontroller: controller.addressController,
            ),
            inputVarticalSpace(),

            // Gender Selection
            Text(
              AppString.gender,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColor.textField,
                fontSize: Get.width * 0.035,
              ),
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(AppString.male),
                      value: AppString.male,
                      groupValue: controller.selectedGender.value,
                      onChanged: controller.updateGender,
                      activeColor: AppColor.activeColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(AppString.female),
                      value: AppString.female,
                      groupValue: controller.selectedGender.value,
                      onChanged: controller.updateGender,
                      activeColor: AppColor.activeColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            inputVarticalSpace(),

            // Grace Days Dropdown
            dropDownField(
              title: AppString.gracedDays,
              icon: AppIcon.calendar,
              value: controller.selectedGraceDays,
              items: controller.graceDaysList,
              onChanged: controller.updateGraceDays,
            ),

            inputVarticalSpace(),

            // Customer Type Dropdown
            dropDownField(
              title: AppString.customerTypes,
              icon: AppIcon.category,
              value: controller.selectedCustType,
              items: controller.custTypeList,
              onChanged: controller.updateCustType,
            ),

            inputVarticalSpace(),
          ],
        ),
      ),
    ],
  );
}

Widget nomineeDetails(UpdateCustFormControllerUI controller) {
  return Column(
    children: [
      headingContainer(AppString.nomineeDetail),
      horizontalPadding(
        child: Column(
          children: [
            inputField(
              hintText: AppString.nomineeName,
              icon: AppIcon.person,
              iconColor: AppColor.activeColor,
              inputTextcontroller: controller.nomineeNameController,
            ),
            inputVarticalSpace(),
            inputField(
              hintText: AppString.nomineePhoneNumber,
              icon: AppIcon.phone,
              iconColor: AppColor.activeColor,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              inputTextcontroller: controller.nomineePhoneController,
            ),
            inputVarticalSpace(),
            inputField(
              hintText: AppString.customerRelation,
              icon: AppIcon.status,
              iconColor: AppColor.activeColor,
              inputTextcontroller: controller.nomineeRelationController,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget identificationProof(
  UpdateCustFormControllerUI controller, {
  void Function()? callSumit,
}) {
  return Column(
    children: [
      headingContainer(AppString.identiyProof),
      horizontalPadding(
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
            inputVarticalSpace(),
            Divider(),
            inputVarticalSpace(),
            photoListSection(
              title: AppString.customerProof,
              controllers: controller.identityProofControllers,
              images: controller.identityProofImages,
              onAdd: controller.addIdentityProofField,
              onRemove: controller.removeIdentityProofField,
              onPick: controller.pickIdentityProof,
              hintText: AppString.identifyProofType,
            ),
            inputVarticalSpace(),
            GestureDetector(
              onTap: controller.isLoading.value ? null : callSumit,
              child: Obx(
                () => clickButton(
                  AppString.update,
                  isLoading: controller.isLoading.value,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
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
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: Get.width * 0.038,
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: Icon(AppIcon.add, color: AppColor.activeColor),
          ),
        ],
      ),
      inputVarticalSpace(),
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
                          width: Get.width * 0.15,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColor.textField,
                            borderRadius: BorderRadius.circular(3),
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
                                      color: AppColor.fullScreenColor,
                                      size: 18,
                                    ),
                                    Text(
                                      AppString.image,
                                      style: TextStyle(
                                        fontSize: Get.width * 0.02,
                                        color: AppColor.fullScreenColor,
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * 0.04),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            hintText: hintText,
                            hintStyle: TextStyle(
                              fontSize: Get.width * 0.035,
                              color: AppColor.textField.withOpacity(0.6),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.textField),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.textField),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.textField),
                            ),
                            suffixIcon: index == 0
                                ? null
                                : IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => onRemove(index),
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: AppColor.deleteColor,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (index < controllers.length - 1) inputVarticalSpace(),
              ],
            );
          }),
        ),
      ),
    ],
  );
}

Widget dropDownField({
  required String title,
  required dynamic icon,
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
          fontWeight: FontWeight.w500,
          color: AppColor.textField,
          fontSize: Get.width * 0.035,
        ),
      ),
      Obx(
        () => DropdownButtonFormField<String>(
          value: value.value,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon is IconData ? icon : icon,
              color: AppColor.activeColor,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.textField),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.textField),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

Widget inputVarticalSpace() => SizedBox(height: Get.height * 0.02);
