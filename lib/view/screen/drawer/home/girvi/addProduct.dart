import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/metal/metal_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/product_Controller.dart';
import 'package:rukmini/controller/ui/home/girivi/addProduct_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/headingContainer.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import '../../../../../controller/ui/home/girivi/addGirivi_Controller.dart';
import '../../../../utils/widget/button.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final addProductUI = Get.put(AddProductControllerUI());
  final metalController = Get.put(MetalController());
  final productTypeController = Get.put(ProductTypeController());
  final productController = Get.put(ProductController());
  final addGiriviUI = Get.find<AddGiriviControllerUI>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callMetalList();
      CallApi.callProductTypeList();
      CallApi.callProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(
        title: AppString.addProduct,
        back: true,
        centerTitle: true,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownRow(
                    icon: AppIcon.metal,
                    label: AppString.metal,
                    value: addProductUI.selectedMetal,
                    hint: AppString.selectMetal,
                    onTap: () => _showProductTypeSelection(),
                  ),
                  _buildDivider(),
                  // _buildDropdownRow(
                  //   icon: AppIcon.productType,
                  //   label: AppString.productType,
                  //   value: controller.selectedProductType,
                  //   hint: AppString.selectProductType,
                  //   onTap: () => _showProductSelection(),
                  // ),
                  // _buildDivider(),
                  _buildDropdownRow(
                    icon: AppIcon.category,
                    label: AppString.category,
                    value: addProductUI.selectedCategory,
                    hint: AppString.selectCategory,
                    onTap: () => _showCategorySelection(),
                  ),
                  _buildDivider(),
                  _buildDropdownRow(
                    icon: AppIcon.metal,
                    label: AppString.metalTouch,
                    value: addProductUI.selectedMetalTouch,
                    hint: AppString.selectMetalTouch,
                    onTap: () => _showMetalSelection(),
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.productType,
                    label: AppString.quantity,
                    controller: addProductUI.quantityController,
                    hint: AppString.enterQuantity,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.weight,
                    label: AppString.weightInGm,
                    controller: addProductUI.weightController,
                    hint: AppString.enterWeight,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.rupee,
                    label: AppString.todaysRate,
                    controller: addProductUI.todaysRateController,
                    hint: AppString.todaysRate,
                    isGrayBackground: true,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.rupee,
                    label: AppString.originalPriceApprox,
                    controller: addProductUI.originalPriceController,
                    hint: AppString.enterApproxOriginalPrice,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.rupee,
                    label: AppString.amountGiven,
                    controller: addProductUI.amountGivenController,
                    hint: AppString.enterGivenAmount,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDivider(),
                  _buildDropdownRow(
                    icon: AppIcon.locker,
                    label: AppString.locker,
                    value: addProductUI.selectedLocker,
                    hint: AppString.selectLocker,
                  ),
                  _buildDivider(),
                  _buildInputRow(
                    icon: AppIcon.lockPerson,
                    label: AppString.lockerCode,
                    controller: addProductUI.lockerCodeController,
                    hint: AppString.enterLockerCode,
                  ),
                  _buildDivider(),
                  _buildProductPhotoSection(),
                  _buildDivider(),
                  _buildDiamondCheckbox(),
                  Obx(
                    () => addProductUI.isDiamondAvailable.value
                        ? _buildDiamondDetails()
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: Get.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow({
    required IconData icon,
    required String label,
    required RxString value,
    required String hint,
    VoidCallback? onTap,
  }) {
    return horizontalPadding(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          child: Row(
            children: [
              Icon(icon, color: AppColor.activeColor, size: Get.width * 0.06),
              SizedBox(width: Get.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: Get.width * 0.03,
                      ),
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Expanded(
                            child: Text(
                              value.value.isEmpty ? hint : value.value,
                              style: TextStyle(
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black54,
                          size: Get.width * 0.06,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isGrayBackground = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    Widget content = horizontalPadding(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.activeColor, size: Get.width * 0.06),
            SizedBox(width: Get.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: Get.width * 0.03,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      fontSize: Get.width * 0.038,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: AppColor.boderSideColor.shade400,
                        fontSize: Get.width * 0.038,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * 0.01,
                      ),
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
        color: Colors.grey.shade100,
        width: double.infinity,
        child: content,
      );
    }
    return content;
  }

  Widget _buildProductPhotoSection() {
    return Column(
      children: [
        horizontalPadding(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      AppIcon.camera,
                      color: AppColor.activeColor,
                      size: Get.width * 0.06,
                    ),
                    SizedBox(width: Get.width * 0.04),
                    Text(
                      AppString.productPhoto + " :",
                      style: TextStyle(
                        fontSize: Get.width * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: addProductUI.pickImage,
                  icon: Icon(
                    Icons.add,
                    color: AppColor.activeColor,
                    size: Get.width * 0.06,
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: addProductUI.productImages.length,
            itemBuilder: (context, index) {
              return horizontalPadding(
                child: Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.015),
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(
                              File(addProductUI.productImages[index].path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: Get.width * 0.03),
                      Expanded(
                        child: Container(
                          height: Get.height * 0.05,
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: Get.width * 0.035),
                            decoration: InputDecoration(
                              hintText: AppString.remark,
                              hintStyle: TextStyle(fontSize: Get.width * 0.035),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: Get.height * 0.01,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => addProductUI.removeImage(index),
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: AppColor.deleteColor,
                          size: Get.width * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDiamondCheckbox() {
    return horizontalPadding(
      child: Row(
        children: [
          Obx(
            () => SizedBox(
              height: Get.width * 0.06,
              width: Get.width * 0.06,
              child: Checkbox(
                value: addProductUI.isDiamondAvailable.value,
                onChanged: (val) {
                  addProductUI.isDiamondAvailable.value = val ?? false;
                },
                activeColor: AppColor.primaryColor,
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.03),
          Text(
            AppString.isDiamondAvailable,
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiamondDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * 0.02),
        headingContainer(AppString.diamondDetails),
        SizedBox(height: Get.height * 0.02),
        horizontalPadding(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildSmallInput(
                      icon: AppIcon.diamond,
                      hint: AppString.diamondPieces,
                      controller: addProductUI.diamondPiecesController,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.03),
                  Expanded(
                    child: _buildSmallInput(
                      icon: AppIcon.diamond,
                      hint: AppString.diamondWeight,
                      controller: addProductUI.diamondWeightController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallInput(
                      icon: AppIcon.certificate,
                      hint: AppString.certificateNumber,
                      controller: addProductUI.certificateNumberController,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Expanded(
                    child: _buildSmallInput(
                      icon: AppIcon.rupee,
                      hint: AppString.diamondPriceApp,
                      controller: addProductUI.diamondPriceController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColor.activeColor, size: Get.width * 0.05),
        SizedBox(width: Get.width * 0.02),
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: Get.width * 0.035),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColor.boderSideColor.shade400,
                fontSize: Get.width * 0.035,
              ),
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.boderSideColor.shade300),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.20),
      child: GestureDetector(
        onTap: () {
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
            "LockerCode": addProductUI.lockerCodeController.text,
            "Remark": addProductUI.remarkController.text,
            "DiamondPieces": addProductUI.diamondPiecesController.text,
            "DiamondWeight": addProductUI.diamondWeightController.text,
            "CertificateNo": addProductUI.certificateNumberController.text,
            "DiamondPrice": addProductUI.diamondPriceController.text,
          };
          addGiriviUI.addProduct(product);
          Get.back();
        },
        child: clickButton(AppString.sumit),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColor.boderSideColor.shade200,
    );
  }

  void _showMetalSelection() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: AppColor.boderSideColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Text(
                AppString.selectMetal,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
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
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Text(
                AppString.selectProductType,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
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
                  return const Center(child: Text("No Product Type Found"));
                }
                return ListView.builder(
                  itemCount: productTypeController.productTypeList.length,
                  itemBuilder: (context, index) {
                    final type = productTypeController.productTypeList[index];
                    return ListTile(
                      title: Text(type.name ?? ""),
                      subtitle: Text("Rate: ${type.rate}"),
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

  void _showProductSelection() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Text(
                AppString.selectProductType,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productController.products.isEmpty) {
                  return const Center(child: Text("No Products Found"));
                }
                return ListView.builder(
                  itemCount: productController.products.length,
                  itemBuilder: (context, index) {
                    final product = productController.products[index];
                    return ListTile(
                      title: Text(product.prodType ?? ""),
                      subtitle: Text(
                        "Rate: ${product.todayRate} | Weight: ${product.weight}",
                      ),
                      onTap: () {
                        addProductUI.selectedProductType.value =
                            product.prodType ?? "";
                        addProductUI.selectedProductTypeId.value =
                            product.productTypeId ?? "";
                        addProductUI.selectedCategory.value =
                            product.catName ?? "";
                        addProductUI.selectedCategoryId.value =
                            product.categoryId ?? "";
                        addProductUI.selectedMetalTouch.value =
                            "${product.metalName}K";
                        addProductUI.selectedMetalTouchId.value =
                            product.metalId ?? "";
                        addProductUI.todaysRateController.text =
                            product.todayRate ?? "";
                        addProductUI.weightController.text =
                            product.weight ?? "";
                        addProductUI.quantityController.text =
                            product.pieces ?? "";
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
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Text(
                AppString.selectCategory,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                final categories = productController.products
                    .map((e) => e.catName)
                    .whereType<String>()
                    .toSet()
                    .toList();
                if (categories.isEmpty) {
                  return const Center(child: Text("No Categories Found"));
                }
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      title: Text(category),
                      onTap: () {
                        addProductUI.selectedCategory.value = category;
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

  void _showCustomerSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppString.selectCustomerName,
            style: const TextStyle(color: AppColor.activeColor),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const ListTile(title: Text('D')),
                const ListTile(title: Text('M')),
                const ListTile(title: Text('N')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: AppColor.activeColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
