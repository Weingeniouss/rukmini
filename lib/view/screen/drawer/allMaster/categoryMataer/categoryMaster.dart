// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/category_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/categoryRemove_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/category_Master/categoryMaster_ControllerUI.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
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
                color: AppColor.goldColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.p16,
                    vertical: AppSize.p12,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _buildCategoryCard(
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

  Widget _buildDecorativeTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppString.productCategoryMaster,
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
              padding: EdgeInsets.symmetric(horizontal: AppSize.p4),
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
            child: TextField(
              controller: categoryMasterUI.categoryController,
              style: TextStyle(
                fontSize: AppSize.commonText,
                color: AppColor.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: AppString.category,
                hintStyle: TextStyle(
                  color: AppColor.textColor.withOpacity(0.5),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Obx(
            () => categoryMasterUI.isLoading.value
                ? SizedBox(
                    height: AppSize.p24,
                    width: AppSize.p24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.goldColor,
                    ),
                  )
                : GestureDetector(
                    onTap: () => categoryMasterUI.save(),
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
                        categoryMasterUI.editingId.value == null
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

  Widget _buildCategoryCard(String name, String id) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
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
                    // Category Icon in Cream Circle
                    Container(
                      padding: EdgeInsets.all(AppSize.p8),
                      decoration: BoxDecoration(
                        color: AppColor.whiteOrang.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        color: AppColor.goldColor,
                        size: AppSize.p24,
                      ),
                    ),
                  ],
                ),
              ),
              // Name
              Expanded(
                child: Text(
                  name,
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
                        categoryMasterUI.startEditing(id, name);
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
                      onPressed: () => _showDeleteDialog(name, id),
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
        itemCount: 10,
        padding: EdgeInsets.all(AppSize.p16),
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.width * 0.15,
            margin: EdgeInsets.only(bottom: AppSize.p12),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(AppSize.p12),
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
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.red,
      onConfirm: () async {
        Get.back();
        await CallApi.callCategoryRemove(categoryId: id);
        await CallApi.callCategoryList();
      },
    );
  }
}
