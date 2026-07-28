// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/product/product_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/categoryMaster_ControllerUI.dart';
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
  final productController = Get.put(ProductController());
  final categoryMasterUI = Get.put(CategoryMasterControllerUI());

  @override
  void initState() {
    super.initState();
    // Since there's no dedicated Category API found yet,
    // we use the derived categories from product list as seen in addProduct.dart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.getProductList();
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
              if (productController.isLoading.value &&
                  productController.products.isEmpty) {
                return _shimmerLoading();
              }

              // Deriving unique categories from the product list
              final categories = productController.products
                  .map((e) => e.catName)
                  .whereType<String>()
                  .toSet()
                  .toList();
              categories.sort();

              if (categories.isEmpty) {
                return const Center(child: Text("No Data Found"));
              }

              return RefreshIndicator(
                onRefresh: () =>
                    productController.getProductList(isRefresh: true),
                color: AppColor.activeColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryListItem(
                      categories[index],
                      index.toString(),
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
              AppIcon.grid, // Using jewelry-like icon
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
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: () => categoryMasterUI.save(),
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
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: Get.width * 0.04),
            IconButton(
              onPressed: () {
                // TODO: Implement delete functionality
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

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade200);
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
