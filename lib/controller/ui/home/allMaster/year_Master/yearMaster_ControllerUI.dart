import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class YearMasterControllerUI extends GetxController {
  final titleController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  var isDefaultYear = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.onClose();
  }

  void selectDate(
    BuildContext context,
    TextEditingController controller,
    bool isFromDate,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryColor,
              onPrimary: AppColor.fullScreenColor,
              onSurface: AppColor.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isFromDate) {
        selectedFromDate = picked;
      } else {
        selectedToDate = picked;
      }
      controller.text = DateFormat('dd MMM yyyy').format(picked).toUpperCase();
    }
  }

  Future<void> submit() async {
    if (titleController.text.isEmpty ||
        selectedFromDate == null ||
        selectedToDate == null) {
      ToastificationError.Error("Please fill all fields");
      return;
    }

    isLoading.value = true;

    final result = await CallApi.callAddYear(
      title: titleController.text,
      fromDate: DateFormat('yyyy-MM-dd').format(selectedFromDate!),
      toDate: DateFormat('yyyy-MM-dd').format(selectedToDate!),
      isCurrent: isDefaultYear.value ? "1" : "0",
    );

    if (result != null) {
      if (result.status == true) {
        Get.back();
        ToastificationSuccess.Success(
          result.message ?? "Year added successfully",
        );
        CallApi.callYearList(); // Refresh the list
      } else {
        ToastificationError.Error(result.message ?? "Failed to add year");
      }
    }

    isLoading.value = false;
  }
}
