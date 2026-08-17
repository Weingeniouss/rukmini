// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/girivi/addGirivi_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/button.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class Addgirivi extends StatefulWidget {
  const Addgirivi({super.key});

  @override
  State<Addgirivi> createState() => _AddgiriviState();
}

class _AddgiriviState extends State<Addgirivi> {
  final addGiriviUI = Get.put(AddGiriviControllerUI());

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(back: true, title: AppString.girvi, centerTitle: true),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  horizontalPadding(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildDropdownRow(
                                icon: AppIcon.person,
                                label: AppString.customerName,
                                value: addGiriviUI.customerName,
                                onTap: () => _showCustomerSelection(),
                              ),
                              _buildDataRow(
                                icon: AppIcon.call,
                                label: AppString.customerPhoneNumber,
                                value: addGiriviUI.customerPhone,
                                isGrayBackground: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSize.p16),
                        _buildImagePicker(),
                      ],
                    ),
                  ),
                  _buildDataRow(
                    icon: AppIcon.location,
                    label: AppString.address,
                    value: addGiriviUI.address,
                    isPadding: true,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.date,
                    label: AppString.toDate,
                    controller: addGiriviUI.dateController,
                    hint: AppString.selectDate,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.calendar,
                    label: AppString.durationInMonths,
                    controller: addGiriviUI.durationController,
                    hint: AppString.enterDurationInMonths,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.calendar,
                    label: AppString.dueDateLabel,
                    controller: addGiriviUI.dueDateController,
                    hint: AppString.dueDateLabel,
                    isGrayBackground: true,
                    readOnly: true,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.percent,
                    label: AppString.interestRate,
                    controller: addGiriviUI.interestRateController,
                    hint: AppString.interestRate,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.rupee,
                    label: AppString.totalAmountGiven,
                    controller: addGiriviUI.totalAmountGivenController,
                    hint: AppString.totalAmountGiven,
                    keyboardType: TextInputType.number,
                    isGrayBackground: true,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.rupee,
                    label: AppString.interestAmount,
                    controller: addGiriviUI.interestAmountController,
                    hint: AppString.interestAmount,
                    readOnly: true,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.rupee,
                    label: AppString.totalAmountReceivable,
                    controller: addGiriviUI.totalAmountReceivableController,
                    hint: AppString.totalAmountReceivable,
                    isGrayBackground: true,
                    readOnly: true,
                  ),
                  SizedBox(height: AppSize.p12),
                  addProductButtons(),
                ],
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget addProductButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width * 0.20),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/AddProduct');
        },
        child: clickButton(AppString.addProduct),
      ),
    );
  }

  Widget _buildDropdownRow({
    required IconData icon,
    required String label,
    required RxString value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColor.activeColor, size: 24),
            SizedBox(width: AppSize.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: AppColor.textColor, fontSize: AppSize.p12),
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Expanded(
                          child: Text(
                            value.value.isEmpty
                                ? "Select Customer"
                                : value.value,
                            style: TextStyle(
                              fontSize: AppSize.p16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Icon(AppIcon.arrow_down, color: AppColor.black54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required IconData icon,
    required String label,
    required RxString value,
    bool isGrayBackground = false,
    bool isPadding = false,
  }) {
    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: isPadding ? AppSize.p16 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.activeColor, size: 24),
          SizedBox(width: AppSize.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: AppSize.p12,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    value.value.isEmpty ? AppString.na : value.value,
                    style: TextStyle(fontSize: AppSize.size14, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isGrayBackground) {
      return Container(
        color: AppColor.grey200,
        width: double.infinity,
        child: content,
      );
    }
    return content;
  }

  Widget _buildInputRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isGrayBackground = false,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    Widget content = horizontalPadding(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.activeColor, size: 24),
            SizedBox(width: AppSize.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: AppColor.textColor, fontSize: AppSize.p12),
                  ),
                  TextField(
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    keyboardType: keyboardType,
                    style: TextStyle(fontSize: AppSize.size15, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: AppColor.boderSideColor.shade400,
                          fontSize: AppSize.size15,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isGrayBackground) {
      return Container(
        color: AppColor.grey200,
        width: double.infinity,
        child: content,
      );
    }
    return content;
  }

  Widget _buildImagePicker() {
    return Obx(() {
      return GestureDetector(
        onTap: addGiriviUI.pickImage,
        child: Container(
          width: AppSize.width * 0.3,
          height: AppSize.width * 0.3,
          decoration: BoxDecoration(
            color: AppColor.grey200,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: addGiriviUI.selectedImage.value != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(addGiriviUI.selectedImage.value!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(AppIcon.camera, size: 40, color: AppColor.grey400),
                    const SizedBox(height: 8),
                    Text(
                      "Images",
                      style: TextStyle(
                        color: AppColor.grey500,
                        fontSize: AppSize.p12,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColor.grey200,
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.p8),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        border: Border(
          top: BorderSide(color: AppColor.activeColor.shade900, width: 2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Center(
                child: Text(
                  AppString.cancel,
                  style: TextStyle(
                    color: AppColor.activeColor,
                    fontSize: AppSize.size14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, color: AppColor.activeColor.shade900),
          Expanded(
            child: GestureDetector(
              onTap: () {
                addGiriviUI.submitGirivi();
              },
              child: Center(
                child: Text(
                  AppString.save,
                  style: TextStyle(
                    color: AppColor.activeColor,
                    fontSize: AppSize.size14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
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
      addGiriviUI.dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      addGiriviUI.calculateDueDate();
    }
  }

  void _showCustomerSelection() {
    addGiriviUI.custListController.custList(isRefresh: true);
    Get.bottomSheet(
      Container(
        height: AppSize.height * 0.8,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppString.selectCustomer,
                style: TextStyle(fontSize: AppSize.p12, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppString.search,
                  prefixIcon: const Icon(AppIcon.searchIcon),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) => addGiriviUI.custListController.custList(
                  isRefresh: true,
                  search: val,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (addGiriviUI.custListController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (addGiriviUI.custListController.customers.isEmpty) {
                  return Center(child: Text(AppString.noCustomersAvailable));
                }
                return ListView.builder(
                  itemCount: addGiriviUI.custListController.customers.length,
                  itemBuilder: (context, index) {
                    final customer =
                        addGiriviUI.custListController.customers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: customer.imagePath != null
                            ? NetworkImage(customer.imagePath!)
                            : null,
                        child: customer.imagePath == null
                            ? const Icon(AppIcon.person)
                            : null,
                      ),
                      title: Text(customer.name ?? ""),
                      subtitle: Text(customer.custCode ?? ""),
                      onTap: () {
                        addGiriviUI.selectedCustomerId.value =
                            customer.custId ?? '';
                        addGiriviUI.customerName.value = customer.name ?? '';
                        addGiriviUI.customerPhone.value =
                            customer.phoneList
                                ?.firstWhereOrNull((p) => p.isDefault == "1")
                                ?.phone ??
                            ((customer.phoneList != null &&
                                    customer.phoneList!.isNotEmpty)
                                ? customer.phoneList!.first.phone
                                : '') ??
                            '';
                        addGiriviUI.address.value = customer.address ?? '';
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
