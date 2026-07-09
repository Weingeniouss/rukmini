// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/headingContainer.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/controller/ui/home/customer/addCustForm_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';

class AddCustForm extends StatelessWidget {
  AddCustForm({super.key});

  final controller = Get.put(AddCustFormController());

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(
        back: true,
        centerTitle: true,
        title: AppString.addCustomerForm,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            customerDetails(controller),
            nomineeDetails(),
            inputVarticalSpace(),
          ],
        ),
      ),
    );
  }
}

Widget customerDetails(AddCustFormController controller) {
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
                      title: const Text(AppString.male),
                      value: AppString.male,
                      groupValue: controller.selectedGender.value,
                      onChanged: controller.updateGender,
                      activeColor: AppColor.activeColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text(AppString.female),
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

Widget dropDownField({
  required String title,
  required dynamic icon,
  required RxString value,
  required List<String> items,
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

Widget nomineeDetails() {
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
            ),
            inputVarticalSpace(),
            inputField(
              hintText: AppString.nomineePhoneNumber,
              icon: AppIcon.phone,
              iconColor: AppColor.activeColor,
            ),
            inputVarticalSpace(),
            inputField(
              hintText: AppString.customerRelation,
              icon: AppIcon.status,
              iconColor: AppColor.activeColor,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget inputVarticalSpace() => SizedBox(height: Get.height * 0.02);
