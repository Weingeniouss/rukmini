// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/girivi/addGirivi_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_list_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_detail_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

class Addgirivi extends StatefulWidget {
  const Addgirivi({super.key});

  @override
  State<Addgirivi> createState() => _AddgiriviState();
}

class _AddgiriviState extends State<Addgirivi> {
  final addGiriviUI = Get.put(AddGiriviControllerUI());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is GiriviDetailData) {
        addGiriviUI.populateData(Get.arguments as GiriviDetailData);
      } else {
        addGiriviUI.clearData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(back: true, title: AppString.girvi),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.p16),
              child: Column(
                children: [
                  // Top Section: Customer Details & Image Picker
                  _sectionHeader(AppString.customerDetail, AppIcon.person),
                  _customerSelection(),

                  // Form Fields
                  _sectionHeader(AppString.girviDetails, AppIcon.girvi),
                  dividerForm(),

                  // Add Product Button
                  _buildAddProductButton(),

                  // Product List Display
                  _buildProductList(),
                ],
              ),
            ),
          ),
          _buildBottomActionRow(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: addGiriviUI.productsList.length,
        itemBuilder: (context, index) {
          final product = addGiriviUI.productsList[index];
          return Container(
            margin: EdgeInsets.only(bottom: AppSize.p12),
            padding: EdgeInsets.all(AppSize.p12),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(AppSize.p16),
              border: Border.all(color: AppColor.grey300.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metalname(product),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSize.commonText,
                        ),
                      ),
                      Text(
                        "Weight: ${product['Weight'] ?? '0'}gm | Rate: ${product['TodayRate'] ?? '0'}",
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: AppSize.smallText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      '/AddProduct',
                      arguments: {'product': product, 'index': index},
                    );
                  },
                  icon: Icon(AppIcon.editIcon, color: AppColor.goldColor),
                ),
                IconButton(
                  onPressed: () {
                    addGiriviUI.productsList.removeAt(index);
                  },
                  icon: Icon(AppIcon.deleteIcon, color: AppColor.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p16),
      child: GestureDetector(
        onTap: () => Get.toNamed('/AddProduct'),
        child: Container(
          padding: EdgeInsets.all(AppSize.p12),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p16),
            border: Border.all(
              color: AppColor.goldColor.withOpacity(0.5),
              style: BorderStyle.solid,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.02),
                blurRadius: AppSize.p4 + 1,
                offset: Offset(0, AppSize.p4 / 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSize.p8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.goldColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(AppSize.p8),
                ),
                child: Icon(
                  AppIcon.inventory,
                  color: AppColor.goldColor,
                  size: AppSize.p20,
                ),
              ),
              Expanded(
                child: Text(
                  AppString.addProduct,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.goldColor,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.commonText,
                  ),
                ),
              ),
              Icon(
                AppIcon.rightArrow,
                color: AppColor.black,
                size: AppSize.p20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dividerForm() {
    return Column(
      children: [
        _buildFormRow(
          icon: AppIcon.calendar,
          label: AppString.toDate,
          controller: addGiriviUI.dateController,
          trailing: Icon(
            AppIcon.calendar,
            color: AppColor.goldColor,
            size: AppSize.iconSmall,
          ),
          onTap: () => _selectDate(context),
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.calendar,
          label: AppString.durationInMonths,
          controller: addGiriviUI.durationController,
          trailing: Icon(
            AppIcon.rightArrow,
            color: AppColor.black,
            size: AppSize.iconSmall,
          ),
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.calendar,
          label: AppString.dueDateLabel,
          controller: addGiriviUI.dueDateController,
          trailing: Icon(
            AppIcon.rightArrow,
            color: AppColor.black,
            size: AppSize.iconSmall,
          ),
          readOnly: true,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.percent,
          label: AppString.interestRate,
          controller: addGiriviUI.interestRateController,
          trailing: Padding(
            padding: EdgeInsets.only(right: AppSize.p12),
            child: const Text(
              "%",
              style: TextStyle(
                color: AppColor.goldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.rupee,
          label: AppString.totalAmountGiven,
          controller: addGiriviUI.totalAmountGivenController,
          trailing: Icon(
            AppIcon.rupee,
            color: AppColor.goldColor,
            size: AppSize.iconSmall,
          ),
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.rupee,
          label: AppString.interestAmount,
          controller: addGiriviUI.interestAmountController,
          trailing: Icon(
            AppIcon.rupee,
            color: AppColor.goldColor,
            size: AppSize.iconSmall,
          ),
          readOnly: true,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.rupee,
          label: AppString.totalAmountReceivable,
          controller: addGiriviUI.totalAmountReceivableController,
          trailing: Icon(
            AppIcon.rupee,
            color: AppColor.goldColor,
            size: AppSize.iconSmall,
          ),
          readOnly: true,
          hasIndicator: true,
        ),
      ],
    );
  }

  Widget _customerSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Obx(
                  () => inputField(
                    hintText: AppString.customerName,
                    icon: AppIcon.person,
                    inputTextcontroller: addGiriviUI.customerNameController,
                    readOnly: true,
                    onTap: addGiriviUI.isEdit.value
                        ? null
                        : () => _showCustomerSelection(),
                    suffixIcon: addGiriviUI.isEdit.value
                        ? null
                        : Icon(
                            AppIcon.arrow_down,
                            color: AppColor.goldColor,
                            size: AppSize.p20,
                          ),
                  ),
                ),
                inputField(
                  hintText: AppString.customerPhoneNumber,
                  icon: AppIcon.phone,
                  inputTextcontroller: addGiriviUI.customerPhoneController,
                  readOnly: true,
                ),
                inputField(
                  hintText: AppString.address,
                  icon: AppIcon.location,
                  inputTextcontroller: addGiriviUI.addressController,
                  readOnly: true,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSize.p12),
          _buildImageUploadBox(),
        ],
      ),
    );
  }

  // Widget _appBarButton(IconData icon, VoidCallback onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: EdgeInsets.all(AppSize.p8),
  //       decoration: BoxDecoration(
  //         color: AppColor.white.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(AppSize.p10),
  //         border: Border.all(color: AppColor.goldColor.withOpacity(0.3)),
  //       ),
  //       child: Icon(icon, color: AppColor.goldColor, size: AppSize.iconMedium),
  //     ),
  //   );
  // }

  Widget _sectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p12,
      ),
      margin: EdgeInsets.only(bottom: AppSize.p12),
      decoration: BoxDecoration(
        color: AppColor.whiteOrang.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSize.p20),
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

  Widget _buildImageUploadBox() {
    return Container(
      width: AppSize.width * 0.3,
      height: AppSize.width * 0.53,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p16),
        border: Border.all(
          color: AppColor.goldColor.withOpacity(0.5),
          style: BorderStyle.solid,
        ),
      ),
      child: Obx(() {
        final image = addGiriviUI.selectedImage.value;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.p8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.p8),
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              )
            else ...[
              Container(
                padding: EdgeInsets.all(AppSize.p12),
                decoration: BoxDecoration(
                  color: AppColor.whiteOrang.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcon.camera_alt,
                  color: AppColor.goldColor,
                  size: AppSize.iconLarge,
                ),
              ),
              SizedBox(height: AppSize.p12),
              Text(
                AppString.images,
                style: TextStyle(
                  fontSize: AppSize.p12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "(0/5)",
                style: TextStyle(
                  fontSize: AppSize.extraSmallText,
                  color: AppColor.textColor,
                ),
              ),
            ],
            SizedBox(height: AppSize.p16),
            GestureDetector(
              onTap: addGiriviUI.pickImage,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.p16,
                  vertical: AppSize.p4 + 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.p8),
                  border: Border.all(color: AppColor.goldColor),
                ),
                child: Text(
                  image != null ? "Change" : AppString.upload,
                  style: TextStyle(
                    color: AppColor.goldColor,
                    fontSize: AppSize.p12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.p8),
          ],
        );
      }),
    );
  }

  Widget _buildFormRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    Widget? trailing,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    bool hasIndicator = false,
  }) {
    return Row(
      children: [
        if (hasIndicator)
          Container(
            width: AppSize.p4,
            height: AppSize.width * 0.08,
            margin: EdgeInsets.only(bottom: AppSize.p12),
            decoration: BoxDecoration(
              color: AppColor.goldColor,
              borderRadius: BorderRadius.circular(AppSize.p4),
            ),
          ),
        if (hasIndicator) SizedBox(width: AppSize.p8),
        Expanded(
          child: inputField(
            hintText: label,
            icon: icon,
            inputTextcontroller: controller,
            suffixIcon: trailing,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionRow() {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, -AppSize.p4 - 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: AppSize.p16),
                side: BorderSide(color: AppColor.goldColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.p16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcon.closeIcon,
                    color: AppColor.goldColor,
                    size: AppSize.p20,
                  ),
                  SizedBox(width: AppSize.p8),
                  Text(
                    AppString.cancel,
                    style: TextStyle(
                      color: AppColor.goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.largeText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: AppSize.p16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.goldColor, AppColor.dashboardGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSize.p16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.goldColor.withOpacity(0.3),
                    blurRadius: AppSize.p8,
                    offset: Offset(0, AppSize.p4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => addGiriviUI.submitGirivi(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.transparent,
                  shadowColor: AppColor.transparent,
                  padding: EdgeInsets.symmetric(vertical: AppSize.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.p16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppIcon.save,
                      color: AppColor.white,
                      size: AppSize.p20,
                    ),
                    SizedBox(width: AppSize.p8),
                    Text(
                      AppString.save,
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSize.largeText,
                      ),
                    ),
                  ],
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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.p20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSize.p16),
              child: Text(
                AppString.selectCustomer,
                style: TextStyle(
                  fontSize: AppSize.p12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppString.search,
                  prefixIcon: const Icon(AppIcon.searchIcon),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.p10),
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
                      onTap: () => customerVoid(addGiriviUI, customer),
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

void customerVoid(AddGiriviControllerUI addGiriviUI, CustomerData customer) {
  addGiriviUI.selectedCustomerId.value = customer.custId ?? '';
  addGiriviUI.customerName.value = customer.name ?? '';
  addGiriviUI.customerNameController.text = customer.name ?? '';

  String phone = '';
  if (customer.phoneList != null && customer.phoneList!.isNotEmpty) {
    for (var p in customer.phoneList!) {
      if (p.isDefault == "1") {
        phone = p.phone ?? '';
        break;
      }
    }
    if (phone.isEmpty) {
      phone = customer.phoneList!.first.phone ?? '';
    }
  }

  addGiriviUI.customerPhone.value = phone;
  addGiriviUI.customerPhoneController.text = phone;

  addGiriviUI.address.value = customer.address ?? '';
  addGiriviUI.addressController.text = customer.address ?? '';

  Get.back();
}

String metalname(product) {
  return "${product['MetalName'] ?? ''} (${product['CategoryName'] ?? ''}) - ${product['Pieces'] ?? '0'} Pcs";
}
