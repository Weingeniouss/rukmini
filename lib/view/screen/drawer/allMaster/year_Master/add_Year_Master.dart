// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/allMaster/year_Master/yearMaster_ControllerUI.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/button.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

class AddYearMaster extends StatelessWidget {
  final YearMasterControllerUI uiController;
  const AddYearMaster({super.key, required this.uiController});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(title: AppString.addYearMaster, back: true, centerTitle: true),
      child: SingleChildScrollView(
        child: horizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSize.p12),
              inputField(
                hintText: AppString.title,
                icon: AppIcon.badge,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.titleController,
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.fromDate,
                icon: AppIcon.calendar,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.fromDateController,
                keyboardType: TextInputType.none,
                suffixIcon: IconButton(
                  onPressed: () => uiController.selectDate(
                    context,
                    uiController.fromDateController,
                    true,
                  ),
                  icon: const Icon(
                    AppIcon.arrowDown,
                    color: AppColor.black54,
                  ),
                ),
              ),
              SizedBox(height: AppSize.p8),
              inputField(
                hintText: AppString.toDate,
                icon: AppIcon.calendar,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.toDateController,
                keyboardType: TextInputType.none,
                suffixIcon: IconButton(
                  onPressed: () => uiController.selectDate(
                    context,
                    uiController.toDateController,
                    false,
                  ),
                  icon: const Icon(
                    AppIcon.arrowDown,
                    color: AppColor.black54,
                  ),
                ),
              ),
              SizedBox(height: AppSize.p12),
              Obx(
                () => CheckboxListTile(
                  title: Text(
                    AppString.setAsDefaultYear,
                    style: TextStyle(
                      fontSize: AppSize.largeText,
                      color: AppColor.dark,
                    ),
                  ),
                  value: uiController.isDefaultYear.value,
                  onChanged: (val) {
                    uiController.isDefaultYear.value = val ?? false;
                  },
                  activeColor: AppColor.activeColor,
                  side: const BorderSide(color: AppColor.activeColor, width: 2),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              SizedBox(height: AppSize.p20),
              Center(
                child: SizedBox(
                  width: AppSize.width * 0.6,
                  child: GestureDetector(
                    onTap: () => uiController.submit(),
                    child: Obx(
                      () => clickButton(
                        AppString.submit,
                        isLoading: uiController.isLoading.value,
                      ),
                    ),
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
