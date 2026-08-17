// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/allMaster/locker_master/lockerMaster_ControllerUI.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/button.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

class AddLockerCode extends StatelessWidget {
  final LockerMasterControllerUI uiController;
  const AddLockerCode({super.key, required this.uiController});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(
        centerTitle: true,
        back: true,
        title: uiController.editingId.value == null
            ? AppString.addLockerCode
            : AppString.updateLockerCode,
      ),
      child: SingleChildScrollView(
        child: horizontalPadding(
          child: Column(
            children: [
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.lockerCode,
                icon: AppIcon.locker,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.lockerCodeController,
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.companyName,
                icon: AppIcon.business,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.companyNameController,
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.companyAddress,
                icon: AppIcon.location,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.companyAddressController,
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.personName,
                icon: AppIcon.person,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.personNameController,
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.phoneNumber,
                icon: AppIcon.phone,
                iconColor: AppColor.activeColor,
                keyboardType: TextInputType.phone,
                inputTextcontroller: uiController.phoneNumberController,
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.interestRate,
                icon: AppIcon.rate,
                iconColor: AppColor.activeColor,
                keyboardType: TextInputType.number,
                inputTextcontroller: uiController.interestRateController,
              ),
              SizedBox(height: AppSize.p8),
              Obx(
                () => CheckboxListTile(
                  title: Text(
                    AppString.setAsDefaultLocker,
                    style: TextStyle(
                      fontSize: AppSize.size12,
                      color: AppColor.dark,
                    ),
                  ),
                  value: uiController.isDefaultLocker.value,
                  onChanged: (val) {
                    uiController.isDefaultLocker.value = val ?? false;
                  },
                  activeColor: AppColor.activeColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              SizedBox(height: AppSize.p16),
              GestureDetector(
                onTap: () => uiController.submit(),
                child: Obx(
                  () => clickButton(
                    AppString.submit,
                    isLoading: uiController.isLoading.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
