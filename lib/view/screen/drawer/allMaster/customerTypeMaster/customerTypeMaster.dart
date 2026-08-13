// ignore_for_file: unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/customer_type_master/customerType_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/customer_type_master/customerTypeRemove_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/customerType_Master/customerTypeMaster_ControllerUI.dart';
import 'package:rukmini/modal/drawer/allMaster/customer_type_master/customer_type_master_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

class CustomerTypeMaster extends StatefulWidget {
  const CustomerTypeMaster({super.key});

  @override
  State<CustomerTypeMaster> createState() => _CustomerTypeMasterState();
}

class _CustomerTypeMasterState extends State<CustomerTypeMaster> {
  final listController = Get.put(CustomerTypeController());
  final uiController = Get.put(CustomerTypeMasterControllerUI());
  final removeController = Get.put(CustomerTypeRemoveController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustomerTypeList();
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
        title: AppString.customerTypeMaster,
      ),
      child: Column(
        children: [
          _buildInputSection(),
          _buildDivider(),
          Expanded(
            child: Obx(() {
              if (listController.isLoading.value &&
                  listController.customerTypeList.isEmpty) {
                return _shimmerLoading();
              }
              if (listController.customerTypeList.isEmpty) {
                return const Center(child: Text(AppString.noDataFound));
              }
              return RefreshIndicator(
                onRefresh: () => CallApi.callCustomerTypeList(),
                color: AppColor.activeColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                  itemCount: listController.customerTypeList.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(
                      listController.customerTypeList[index],
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
              AppIcon.personPin,
              color: AppColor.activeColor.withOpacity(0.6),
              size: Get.width * 0.06,
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: _buildTextField(
                controller: uiController.nameController,
                hintText: AppString.customerTypes,
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

  Widget _buildListItem(CustomerTypeData item) {
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
                item.name ?? "",
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: AppColor.dark,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                uiController.startEditing(item.typeId, item.name);
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

  void _showDeleteDialog(CustomerTypeData item) {
    Get.defaultDialog(
      title: AppString.deleteCustomer,
      middleText: "${AppString.deleteMessage} \n\n ${item.name}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await removeController.removeCustomerType(typeId: item.typeId ?? "");
      },
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: AppColor.grey200);
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
              color: AppColor.white,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
