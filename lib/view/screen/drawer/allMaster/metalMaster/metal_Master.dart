// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/productTypeRemove_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/metal_Master/metalMaster_ControllerUI.dart';
import 'package:rukmini/modal/product/productTypeList_Modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

class MetalMaster extends StatefulWidget {
  const MetalMaster({super.key});

  @override
  State<MetalMaster> createState() => _MetalMasterState();
}

class _MetalMasterState extends State<MetalMaster> {
  final productTypeController = Get.put(ProductTypeController());
  final metalMasterUI = Get.put(MetalMasterControllerUI());
  final productTypeRemoveController = Get.put(ProductTypeRemoveController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callProductTypeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(
        back: true,
        centerTitle: true,
        title: AppString.metalMaster,
      ),
      child: Column(
        children: [
          _buildInputSection(),
          _buildDivider(),
          Expanded(
            child: Obx(() {
              if (productTypeController.isLoading.value &&
                  productTypeController.productTypeList.isEmpty) {
                return _shimmerLoading();
              }

              if (productTypeController.productTypeList.isEmpty) {
                return Center(child: Text("No Data Found"));
              }

              return RefreshIndicator(
                onRefresh: () => CallApi.callProductTypeList(),
                color: AppColor.activeColor,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                  itemCount: productTypeController.productTypeList.length,
                  itemBuilder: (context, index) {
                    return _buildMetalListItem(
                      productTypeController.productTypeList[index],
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return horizontalPadding(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        child: Row(
          children: [
            Icon(
              AppIcon.grid,
              color: AppColor.activeColor.withOpacity(0.6),
              size: Get.width * 0.06,
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              flex: 3,
              child: _buildTextField(
                controller: metalMasterUI.metalController,
                hintText: AppString.metal,
              ),
            ),
            Container(
              height: Get.height * 0.03,
              width: 1.2,
              color: AppColor.boderSideColor.shade400,
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
            ),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: metalMasterUI.rateController,
                hintText: AppString.rate,
                keyboardType: TextInputType.number,
              ),
            ),
            Obx(
              () => metalMasterUI.isLoading.value
                  ? SizedBox(
                      height: Get.width * 0.06,
                      width: Get.width * 0.06,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: () => metalMasterUI.save(),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.activeColor,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          metalMasterUI.editingId.value == null
                              ? AppIcon.add
                              : Icons.check,
                          color: AppColor.activeColor,
                          size: Get.width * 0.045,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: Get.width * 0.042,
        color: AppColor.textColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColor.textColor.withOpacity(0.5),
          fontSize: Get.width * 0.042,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMetalListItem(ProductTypeData item) {
    return horizontalPadding(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
        child: Row(
          children: [
            Icon(
              AppIcon.checkCircle,
              color: AppColor.activeColor,
              size: Get.width * 0.055,
            ),
            SizedBox(width: Get.width * 0.04),
            Expanded(
              child: Text(
                "${item.name} (${item.rate}.00)",
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: AppColor.dark,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                metalMasterUI.startEditing(
                  item.productTypeId,
                  item.name,
                  item.rate,
                );
              },
              icon: Icon(
                AppIcon.editNote,
                color: AppColor.activeColor,
                size: Get.width * 0.06,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: Get.width * 0.04),
            IconButton(
              onPressed: () {
                _showDeleteDialog(item);
              },
              icon: Icon(
                AppIcon.remove,
                color: AppColor.activeColor,
                size: Get.width * 0.06,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
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

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor!,
      highlightColor: AppColor.highlightColor!,
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.all(Get.width * 0.04),
        itemBuilder: (context, index) {
          return Container(
            height: 45,
            margin: EdgeInsets.only(bottom: Get.height * 0.02),
            decoration: BoxDecoration(
              color: AppColor.fullScreenColor,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(ProductTypeData item) {
    Get.defaultDialog(
      title: AppString.deleteCustomer,
      middleText: "${AppString.deleteMessage} \n\n ${item.name}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.fullScreenColor,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await CallApi.callProductTypeRemove(
          productTypeId: item.productTypeId ?? "",
        );
        await CallApi.callProductTypeList();
      },
    );
  }
}
