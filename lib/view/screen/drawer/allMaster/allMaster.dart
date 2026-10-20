// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/view/screen/drawer/allMaster/categoryMataer/categoryMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/customerTypeMaster/customerTypeMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/lockerCodeMaster/lockerCodeMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/metalMaster/metal_Master.dart';
import 'package:rukmini/view/screen/drawer/allMaster/metalTouch/metalTouch.dart';
import 'package:rukmini/view/screen/drawer/allMaster/year_Master/year_Master.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class AllMaster extends StatefulWidget {
  const AllMaster({super.key});

  @override
  State<AllMaster> createState() => _AllMasterState();
}

class _AllMasterState extends State<AllMaster> {
  int _selectedIndex = 0;

  static const List<String> _masterRoutes = [
    '/metalMaster',
    '/categoryMaster',
    '/customerTypeMaster',
    '/lockerCodeMaster',
    '/metalTouch',
    '/yearMaster',
  ];

  final List<Map<String, dynamic>> _masterItems = [
    {
      'icon': AppIcon.grid,
      'title': AppString.metalMaster,
      'route': '/metalMaster',
      'widget': const MetalMaster(),
    },
    {
      'icon': AppIcon.category,
      'title': AppString.productCategoryMaster,
      'route': '/categoryMaster',
      'widget': const CategoryMaster(),
    },
    {
      'icon': AppIcon.personOutline,
      'title': AppString.customerTypeMaster,
      'route': '/customerTypeMaster',
      'widget': const CustomerTypeMaster(),
    },
    {
      'icon': AppIcon.security,
      'title': AppString.lockerCodeMaster,
      'route': '/lockerCodeMaster',
      'widget': const LockerCodeMaster(),
    },
    {
      'icon': AppIcon.balance,
      'title': AppString.metalTouchMaster,
      'route': '/metalTouch',
      'widget': const MetalTouch(),
    },
    {
      'icon': AppIcon.calendar,
      'title': AppString.yearMaster,
      'route': '/yearMaster',
      'widget': const YearMaster(),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments is int) {
        _selectedIndex = Get.arguments as int;
      } else if (Get.arguments is String) {
        final route = Get.arguments as String;
        final index = _masterRoutes.indexOf(route);
        if (index != -1) {
          _selectedIndex = index;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppSize.isDesktop || AppSize.isTablet) {
      return Fullscreen(
        drawer: homeDrawer(),
        isPadding: false,
        backGroundcolor: AppColor.backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Sub-Sidebar for Masters Menu
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Sub-sidebar Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: _buildDecorativeTitle(),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  // Master Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _masterItems.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final item = _masterItems[index];
                        final bool isSelected = index == _selectedIndex;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.goldColor.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(
                                    color: AppColor.goldColor,
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.goldColor
                                    : AppColor.whiteOrang.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: isSelected
                                    ? AppColor.white
                                    : AppColor.goldColor,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              item['title'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColor.goldColor
                                    : AppColor.black,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              AppIcon.rightArrow,
                              color: isSelected
                                  ? AppColor.goldColor
                                  : Colors.grey.shade400,
                              size: 16,
                            ),
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Right Side Content Area
            Expanded(
              child: KeyedSubtree(
                key: ValueKey(_selectedIndex),
                child: _masterItems[_selectedIndex]['widget'] as Widget,
              ),
            ),
          ],
        ),
      );
    }

    final mobileMasterItems = _masterItems.map((item) {
      return _buildMasterItem(
        icon: item['icon'] as IconData,
        title: item['title'] as String,
        onTap: () => NavDrawerController.toNamed(item['route'] as String),
      );
    }).toList();

    return Fullscreen(
      drawer: homeDrawer(),
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(title: _buildDecorativeTitle(), centerTitle: true),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p12,
        ),
        child: Column(
          children: mobileMasterItems,
        ),
      ),
    );
  }

  Widget _buildDecorativeTitle() {
    final double lineWidth =
        (AppSize.isDesktop || AppSize.isTablet) ? 30 : AppSize.width * 0.1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppString.allMasters,
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
              width: lineWidth,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: 6,
                  height: 6,
                  color: AppColor.goldColor,
                ),
              ),
            ),
            Container(
              width: lineWidth,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMasterItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
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
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                // Left gold indicator
                Container(width: 4, color: AppColor.goldColor),
                Padding(
                  padding: EdgeInsets.all(AppSize.p12),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        padding: EdgeInsets.all(AppSize.p10),
                        decoration: BoxDecoration(
                          color: AppColor.whiteOrang.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColor.goldColor,
                          size: AppSize.p24,
                        ),
                      ),
                      SizedBox(width: AppSize.p12),
                      // Vertical divider
                      Container(
                        width: 1,
                        height: AppSize.p24,
                        color: AppColor.grey300.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppSize.commonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Right arrow
                Padding(
                  padding: EdgeInsets.only(right: AppSize.p16),
                  child: Icon(
                    AppIcon.rightArrow,
                    color: AppColor.goldColor,
                    size: AppSize.p20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
