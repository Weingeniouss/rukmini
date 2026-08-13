// ignore_for_file: unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/category_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/categoryRemove_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/category_Master/categoryMaster_ControllerUI.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

class CategoryMaster extends StatefulWidget {
  const CategoryMaster({super.key});

  @override
  State<CategoryMaster> createState() => _CategoryMasterState();
}

class _CategoryMasterState extends State<CategoryMaster> {
  final categoryController = Get.put(CategoryController());
  final categoryMasterUI = Get.put(CategoryMasterControllerUI());
  final categoryRemoveController = Get.put(CategoryRemoveController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCategoryList();
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
        title: AppString.productCategoryMaster,
      ),
      child: Column(
        children: [
          _buildInputSection(),
          _buildDivider(),
          Expanded(
            child: Obx(() {
              if (categoryController.isLoading.value &&
                  categoryController.categoryList.isEmpty) {
                return _shimmerLoading();
              }

              final categories = categoryController.categoryList;

              if (categories.isEmpty) {
                return Center(child: Text(AppString.noDataFound));
              }

              return RefreshIndicator(
                onRefresh: () => CallApi.callCategoryList(),
                color: AppColor.activeColor,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _buildCategoryListItem(
                      item.name ?? "",
                      item.categoryId ?? "",
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
              child: _buildTextField(
                controller: categoryMasterUI.categoryController,
                hintText: AppString.category,
              ),
            ),
            Obx(
              () => categoryMasterUI.isLoading.value
                  ? SizedBox(
                      height: Get.width * 0.06,
                      width: Get.width * 0.06,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: () => categoryMasterUI.save(),
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
                          categoryMasterUI.editingId.value == null
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
  }) {
    return TextField(
      controller: controller,
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

  Widget _buildCategoryListItem(String name, String id) {
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
                name,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: AppColor.dark,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                categoryMasterUI.startEditing(id, name);
              },
              icon: Icon(
                AppIcon.editNote,
                color: AppColor.activeColor,
                size: Get.width * 0.06,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            SizedBox(width: Get.width * 0.04),
            IconButton(
              onPressed: () {
                _showDeleteDialog(name, id);
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

  void _showDeleteDialog(String name, String id) {
    Get.defaultDialog(
      title: AppString.deleteCustomer,
      middleText: "${AppString.deleteMessage} \n\n $name",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.fullScreenColor,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await CallApi.callCategoryRemove(categoryId: id);
      },
    );
  }
}
