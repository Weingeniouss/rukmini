// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/productTypeRemove_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/metal_Master/metalMaster_ControllerUI.dart';
import 'package:rukmini/modal/product/productTypeList_Modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
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
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        back: true,
        centerTitle: true,
        title: _buildDecorativeTitle(),
      ),
      child: Column(
        children: [
          _buildFilterAndAddSection(),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (productTypeController.isLoading.value &&
                  productTypeController.productTypeList.isEmpty) {
                return _shimmerLoading();
              }

              if (productTypeController.productTypeList.isEmpty) {
                return Center(child: Text(AppString.noDataFound));
              }

              return RefreshIndicator(
                onRefresh: () => CallApi.callProductTypeList(),
                color: AppColor.goldColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.p16,
                    vertical: AppSize.p12,
                  ),
                  itemCount: productTypeController.productTypeList.length,
                  itemBuilder: (context, index) {
                    return _buildMetalCard(
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

  Widget _buildDecorativeTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppString.metalMaster,
          style: TextStyle(
            color: AppColor.black,
            fontSize: AppSize.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSize.p4 / 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.width * 0.1,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.rotate(
                angle: 0.785,
                child: Container(
                  width: AppSize.p8,
                  height: AppSize.p8,
                  color: AppColor.goldColor,
                ),
              ),
            ),
            Container(
              width: AppSize.width * 0.1,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterAndAddSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      color: AppColor.white,
      child: Row(
        children: [
          Icon(AppIcon.grid, color: AppColor.goldColor, size: AppSize.p24),
          SizedBox(width: AppSize.p16),
          Expanded(
            flex: 3,
            child: TextField(
              controller: metalMasterUI.metalController,
              style: TextStyle(
                fontSize: AppSize.commonText,
                color: AppColor.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: AppString.metal,
                hintStyle: TextStyle(color: AppColor.textColor.withOpacity(0.5)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Container(
            height: AppSize.p16,
            width: 1,
            color: AppColor.grey300,
            margin: EdgeInsets.symmetric(horizontal: AppSize.p12),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: metalMasterUI.rateController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: AppSize.commonText,
                color: AppColor.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: AppString.rate,
                hintStyle: TextStyle(color: AppColor.textColor.withOpacity(0.5)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Obx(
            () => metalMasterUI.isLoading.value
                ? SizedBox(
                    height: AppSize.p24,
                    width: AppSize.p24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.goldColor,
                    ),
                  )
                : GestureDetector(
                    onTap: () => metalMasterUI.save(),
                    child: Container(
                      padding: EdgeInsets.all(AppSize.p4),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.goldColor,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        metalMasterUI.editingId.value == null
                            ? AppIcon.add
                            : AppIcon.check,
                        color: AppColor.goldColor,
                        size: AppSize.p20,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetalCard(ProductTypeData item) {
    bool isGold = item.name?.toLowerCase().contains("gold") ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.p12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left gold indicator
              Container(width: AppSize.p4, color: AppColor.goldColor),
              Padding(
                padding: EdgeInsets.all(AppSize.p12),
                child: Row(
                  children: [
                    // Checkmark icon
                    Container(
                      padding: EdgeInsets.all(AppSize.p4 / 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.goldColor,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        AppIcon.check,
                        color: AppColor.goldColor,
                        size: AppSize.size14,
                      ),
                    ),
                    SizedBox(width: AppSize.p12),
                    // Metal Icon in Cream Circle
                    Container(
                      padding: EdgeInsets.all(AppSize.p8),
                      decoration: BoxDecoration(
                        color: AppColor.whiteOrang.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isGold ? Icons.radio_button_checked : Icons.local_offer,
                        color: isGold ? AppColor.goldColor : Colors.grey,
                        size: AppSize.p24,
                      ),
                    ),
                  ],
                ),
              ),
              // Title and Price
              Expanded(
                child: Text(
                  "${item.name} (${item.rate})",
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: AppSize.commonText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        metalMasterUI.startEditing(
                          item.productTypeId,
                          item.name,
                          item.rate,
                        );
                      },
                      icon: Icon(AppIcon.editNote, color: AppColor.goldColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Container(
                      width: 1,
                      height: AppSize.p20,
                      color: AppColor.grey300,
                      margin: EdgeInsets.symmetric(horizontal: AppSize.p8),
                    ),
                    IconButton(
                      onPressed: () => _showDeleteDialog(item),
                      icon: Container(
                        padding: EdgeInsets.all(AppSize.p4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.red.withOpacity(0.5),
                          ),
                        ),
                        child: Icon(
                          AppIcon.deleteIcon,
                          color: AppColor.red,
                          size: AppSize.p16,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.grey300,
      highlightColor: AppColor.white,
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.all(AppSize.p16),
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.width * 0.2,
            margin: EdgeInsets.only(bottom: AppSize.p16),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(AppSize.p12),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(ProductTypeData item) {
    Get.defaultDialog(
      title: AppString.deleteMetalTouch,
      middleText: "${AppString.deleteMetalTouchMessage} \n\n ${item.name}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.red,
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
