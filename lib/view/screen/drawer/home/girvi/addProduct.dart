// ignore_for_file: deprecated_member_use, file_names, prefer_interpolation_to_compose_strings, unused_element

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/metal/metal_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/category_Controller.dart';
import 'package:rukmini/controller/ui/home/girivi/addProduct_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';
import '../../../../../controller/ui/home/girivi/addGirivi_Controller.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final addProductUI = Get.put(AddProductControllerUI());
  final metalController = Get.put(MetalController());
  final categoryController = Get.put(CategoryController());
  final productTypeController = Get.put(ProductTypeController());
  final lockerListController = Get.put(LockerListController());
  final addGiriviUI = Get.find<AddGiriviControllerUI>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['product'] != null) {
        addProductUI.populateData(
          Get.arguments['product'],
          Get.arguments['index'],
        );
      } else {
        addProductUI.clearData();
      }
      CallApi.callMetalList();
      CallApi.callProductTypeList();
      CallApi.callProductList();
      CallApi.callCategoryList();
      CallApi.callLockerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        title: AppString.addProduct,
        back: true,
        centerTitle: true,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(AppString.productDetail, AppIcon.product),
                  _buildProductCoreDetails(),
                  _sectionHeader(AppString.metalTouch, AppIcon.metal),
                  _buildMetalDetails(),
                  _sectionHeader(AppString.productPhoto, AppIcon.camera),
                  _buildProductPhotoSection(),
                  _sectionHeader(AppString.diamondDetails, AppIcon.diamond),
                  _buildDiamondSection(),
                  SizedBox(height: AppSize.p40),
                ],
              ),
            ),
          ),
          _buildBottomActionRow(),
        ],
      ),
    );
  }

  Widget _buildProductCoreDetails() {
    return Column(
      children: [
        Obx(
          () => _buildFormRow(
            icon: AppIcon.metal,
            label: AppString.metal,
            controller: TextEditingController(
              text: addProductUI.selectedMetal.value,
            ),
            readOnly: true,
            onTap: () => _showProductTypeSelection(),
            trailing: Icon(
              AppIcon.arrow_down,
              color: AppColor.goldColor,
              size: AppSize.p20,
            ),
            hasIndicator: true,
          ),
        ),
        Obx(
          () => _buildFormRow(
            icon: AppIcon.category,
            label: AppString.category,
            controller: TextEditingController(
              text: addProductUI.selectedCategory.value,
            ),
            readOnly: true,
            onTap: () => _showCategorySelection(),
            trailing: Icon(
              AppIcon.arrow_down,
              color: AppColor.goldColor,
              size: AppSize.p20,
            ),
            hasIndicator: true,
          ),
        ),
        _buildFormRow(
          icon: AppIcon.productType,
          label: AppString.quantity,
          controller: addProductUI.quantityController,
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.weight,
          label: AppString.weightInGm,
          controller: addProductUI.weightController,
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
      ],
    );
  }

  Widget _buildMetalDetails() {
    return Column(
      children: [
        Obx(
          () => _buildFormRow(
            icon: AppIcon.metal,
            label: AppString.metalTouch,
            controller: TextEditingController(
              text: addProductUI.selectedMetalTouch.value,
            ),
            readOnly: true,
            onTap: () => _showMetalSelection(),
            trailing: Icon(
              AppIcon.arrow_down,
              color: AppColor.goldColor,
              size: AppSize.p20,
            ),
            hasIndicator: true,
          ),
        ),
        _buildFormRow(
          icon: AppIcon.rupee,
          label: AppString.todaysRate,
          controller: addProductUI.todaysRateController,
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.rupee,
          label: AppString.originalPriceApprox,
          controller: addProductUI.originalPriceController,
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        _buildFormRow(
          icon: AppIcon.rupee,
          label: AppString.amountGiven,
          controller: addProductUI.amountGivenController,
          keyboardType: TextInputType.number,
          hasIndicator: true,
        ),
        Obx(
          () => _buildFormRow(
            icon: AppIcon.locker,
            label: AppString.locker,
            controller: TextEditingController(
              text: addProductUI.selectedLocker.value,
            ),
            readOnly: true,
            onTap: () => _showLockerSelection(),
            trailing: Icon(
              AppIcon.arrow_down,
              color: AppColor.goldColor,
              size: AppSize.p20,
            ),
            hasIndicator: true,
          ),
        ),
        _buildFormRow(
          icon: AppIcon.lockPerson,
          label: AppString.lockerCode,
          controller: addProductUI.lockerCodeController,
          hasIndicator: true,
        ),
      ],
    );
  }

  Widget _buildDiamondSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppSize.p16),
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: addProductUI.isHallmark.value,
                  onChanged: (val) =>
                      addProductUI.isHallmark.value = val ?? false,
                  activeColor: AppColor.goldColor,
                ),
              ),
              Text(
                AppString.isHallmarkAvailable,
                style: TextStyle(
                  fontSize: AppSize.commonText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: AppSize.p16),
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: addProductUI.isDiamondAvailable.value,
                  onChanged: (val) =>
                      addProductUI.isDiamondAvailable.value = val ?? false,
                  activeColor: AppColor.goldColor,
                ),
              ),
              Text(
                AppString.isDiamondAvailable,
                style: TextStyle(
                  fontSize: AppSize.commonText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!addProductUI.isDiamondAvailable.value) return const SizedBox();
          return Column(
            children: [
              _buildFormRow(
                icon: AppIcon.diamond,
                label: AppString.diamondPieces,
                controller: addProductUI.diamondPiecesController,
                keyboardType: TextInputType.number,
              ),
              _buildFormRow(
                icon: AppIcon.diamond,
                label: AppString.diamondWeight,
                controller: addProductUI.diamondWeightController,
                keyboardType: TextInputType.number,
              ),
              _buildFormRow(
                icon: AppIcon.certificate,
                label: AppString.certificateNumber,
                controller: addProductUI.certificateNumberController,
              ),
              _buildFormRow(
                icon: AppIcon.rupee,
                label: AppString.diamondPriceApp,
                controller: addProductUI.diamondPriceController,
                keyboardType: TextInputType.number,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p12,
      ),
      margin: EdgeInsets.only(bottom: AppSize.p12, top: AppSize.p16),
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

  Widget _buildProductPhotoSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppSize.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.uploadProductPhotos,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.commonText,
                ),
              ),
              IconButton(
                onPressed: addProductUI.pickImage,
                icon: Icon(AppIcon.add, color: AppColor.goldColor),
              ),
            ],
          ),
        ),
        Obx(
          () => Column(
            children: List.generate(addProductUI.productImages.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSize.p12),
                child: Row(
                  children: [
                    Container(
                      width: AppSize.width * 0.15,
                      height: AppSize.width * 0.15,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        borderRadius: BorderRadius.circular(AppSize.p8),
                        border: Border.all(color: AppColor.grey300),
                        image: DecorationImage(
                          image: FileImage(
                            File(addProductUI.productImages[index].path),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.p12),
                    Expanded(
                      child: inputField(
                        hintText: AppString.remark,
                        inputTextcontroller: addProductUI.remarkController,
                        suffixIcon: IconButton(
                          onPressed: () => addProductUI.removeImage(index),
                          icon: Icon(
                            AppIcon.removeCircle,
                            color: AppColor.deleteColor,
                            size: AppSize.p20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
                onPressed: () {
                  _submitProduct();
                },
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
                      AppString.sumit,
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

  void _showLockerSelection() {
    Get.bottomSheet(
      Container(
        height: AppSize.height * 0.7,
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
                AppString.selectLocker,
                style: TextStyle(
                  fontSize: AppSize.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (lockerListController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (lockerListController.lockerList.isEmpty) {
                  return const Center(
                    child: Text(AppString.noLockersAvailable),
                  );
                }
                return ListView.builder(
                  itemCount: lockerListController.lockerList.length,
                  itemBuilder: (context, index) {
                    final locker = lockerListController.lockerList[index];
                    return ListTile(
                      title: Text(locker.lockerCode ?? ""),
                      subtitle: Text(locker.comName ?? ""),
                      onTap: () {
                        addProductUI.selectedLocker.value =
                            locker.lockerCode ?? "";
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
    );
  }

  void _showCategorySelection() {
    Get.bottomSheet(
      Container(
        height: AppSize.height * 0.7,
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
                AppString.selectCategory,
                style: TextStyle(
                  fontSize: AppSize.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categoryController.categoryList.isEmpty) {
                  return const Center(
                    child: Text(AppString.noCategoriesFound),
                  );
                }
                return ListView.builder(
                  itemCount: categoryController.categoryList.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categoryList[index];
                    return ListTile(
                      title: Text(category.name ?? ""),
                      onTap: () {
                        addProductUI.selectedCategory.value = category.name ?? "";
                        addProductUI.selectedCategoryId.value =
                            category.categoryId ?? "";
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
    );
  }

  void _submitProduct() {
    final product = {
      "ProductTypeId": addProductUI.selectedProductTypeId.value,
      "CategoryId": addProductUI.selectedCategoryId.value,
      "MetalId": addProductUI.selectedMetalTouchId.value,
      "Pieces": addProductUI.quantityController.text,
      "Weight": addProductUI.weightController.text,
      "TodayRate": addProductUI.todaysRateController.text,
      "OrigAmount": addProductUI.originalPriceController.text,
      "GivenAmount": addProductUI.amountGivenController.text,
      "IsDiamond": addProductUI.isDiamondAvailable.value ? "1" : "0",
      "IsHallmark": addProductUI.isHallmark.value ? "1" : "0",
      "LockerCode": addProductUI.lockerCodeController.text,
      "Remark": addProductUI.remarkController.text,
      "DiamondPieces": addProductUI.diamondPiecesController.text,
      "DiamondWeight": addProductUI.diamondWeightController.text,
      "CertificateNo": addProductUI.certificateNumberController.text,
      "DiamondPrice": addProductUI.diamondPriceController.text,
      "MetalTouch": addProductUI.selectedMetalTouch.value,
      "MetalName": addProductUI.selectedMetal.value,
      "CategoryName": addProductUI.selectedCategory.value,
    };
    if (addProductUI.isEdit.value) {
      addGiriviUI.updateProduct(addProductUI.productIndex.value, product);
    } else {
      addGiriviUI.addProduct(product);
    }
    if (kDebugMode) {
      print(product);
    }
    Get.back();
  }

  void _showMetalSelection() {
    Get.bottomSheet(
      Container(
        height: AppSize.height * 0.7,
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
                AppString.selectMetal,
                style: TextStyle(
                  fontSize: AppSize.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (metalController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (metalController.metalList.isEmpty) {
                  return const Center(child: Text(AppString.noMetalDataFound));
                }
                return ListView.builder(
                  itemCount: metalController.metalList.length,
                  itemBuilder: (context, index) {
                    final metal = metalController.metalList[index];
                    return ListTile(
                      title: Text("${metal.karat} ${AppString.karat}"),
                      subtitle: Text(
                        "${AppString.goldContent}: ${metal.goldContent}%",
                      ),
                      onTap: () {
                        addProductUI.selectedMetalTouch.value =
                            "${metal.karat}K";
                        addProductUI.selectedMetalTouchId.value =
                            metal.metalId ?? "";
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
    );
  }

  void _showProductTypeSelection() {
    Get.bottomSheet(
      Container(
        height: AppSize.height * 0.4,
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
                AppString.selectProductType,
                style: TextStyle(
                  fontSize: AppSize.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (productTypeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productTypeController.productTypeList.isEmpty) {
                  return const Center(
                    child: Text(AppString.noProductTypeFound),
                  );
                }
                return ListView.builder(
                  itemCount: productTypeController.productTypeList.length,
                  itemBuilder: (context, index) {
                    final type = productTypeController.productTypeList[index];
                    return ListTile(
                      title: Text(type.name ?? ""),
                      subtitle: Text("${AppString.rate}: ${type.rate}"),
                      onTap: () {
                        addProductUI.selectedMetal.value = type.name ?? "";
                        addProductUI.selectedProductTypeId.value =
                            type.productTypeId ?? "";
                        addProductUI.todaysRateController.text =
                            type.rate ?? "";
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
    );
  }
}
