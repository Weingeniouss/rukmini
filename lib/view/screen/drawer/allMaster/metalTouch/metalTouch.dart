// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/metal/metal_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/metal_Touch/metalTouchMaster_ControllerUI.dart';
import 'package:rukmini/modal/metal/metalList_Modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

class MetalTouch extends StatefulWidget {
  const MetalTouch({super.key});

  @override
  State<MetalTouch> createState() => _MetalTouchState();
}

class _MetalTouchState extends State<MetalTouch> {
  final metalController = Get.put(MetalController());
  final uiController = Get.put(MetalTouchMasterControllerUI());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callMetalList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      drawer: homeDrawer(),
      isPadding: false,
      appBar: appBar(
        back: true,
        centerTitle: true,
        title: AppString.metalTouchMaster,
      ),
      child: Column(
        children: [
          _buildInputSection(),
          _buildDivider(),
          Expanded(
            child: Obx(() {
              if (metalController.isLoading.value &&
                  metalController.metalList.isEmpty) {
                return _shimmerLoading();
              }

              if (metalController.metalList.isEmpty) {
                return const Center(child: Text("No Data Found"));
              }

              return RefreshIndicator(
                onRefresh: () => CallApi.callMetalList(),
                color: AppColor.activeColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                  itemCount: metalController.metalList.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(metalController.metalList[index]);
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
              AppIcon.balance,
              color: AppColor.activeColor.withOpacity(0.6),
              size: Get.width * 0.06,
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              flex: 3,
              child: _buildTextField(
                controller: uiController.karatController,
                hintText: AppString.karat,
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
                controller: uiController.goldContentController,
                hintText: "Content %",
                keyboardType: TextInputType.number,
              ),
            ),
            Obx(
              () => uiController.isLoading.value
                  ? SizedBox(
                      height: Get.width * 0.06,
                      width: Get.width * 0.06,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: () => uiController.save(),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.activeColor,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          uiController.editingId.value == null
                              ? AppIcon.add
                              : AppIcon.check,
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

  Widget _buildListItem(MetalData item) {
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
                "${item.karat} Karat (${item.goldContent}%)",
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: AppColor.dark,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                uiController.startEditing(
                  item.metalId,
                  item.karat,
                  item.goldContent,
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
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(MetalData item) {
    Get.defaultDialog(
      title: "Delete Metal Touch",
      middleText:
          "Are you sure you want to delete this metal touch?\n\n ${item.karat} Karat",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.fullScreenColor,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await CallApi.callMetalRemove(metalId: item.metalId ?? "");
        await CallApi.callMetalList();
      },
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
        itemCount: 10,
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
}
