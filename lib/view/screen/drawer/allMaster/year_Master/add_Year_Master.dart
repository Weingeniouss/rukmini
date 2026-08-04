import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/allMaster/year_Master/yearMaster_ControllerUI.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/button.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

class AddYearMaster extends StatelessWidget {
  AddYearMaster({super.key});

  final uiController = Get.put(YearMasterControllerUI());

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
              SizedBox(height: Get.height * 0.03),
              inputField(
                hintText: AppString.title,
                icon: Icons.badge_outlined,
                iconColor: AppColor.activeColor,
                inputTextcontroller: uiController.titleController,
              ),
              SizedBox(height: Get.height * 0.02),
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
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
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
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Obx(
                () => CheckboxListTile(
                  title: Text(
                    AppString.setAsDefaultYear,
                    style: TextStyle(
                      fontSize: Get.width * 0.04,
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
              SizedBox(height: Get.height * 0.05),
              Center(
                child: SizedBox(
                  width: Get.width * 0.6,
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
