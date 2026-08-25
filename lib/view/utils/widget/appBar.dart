// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_background.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import '../app_Icon.dart';

AppBar appBar({
  dynamic title,
  bool? searchIcon,
  bool? filter,
  bool? edit,
  bool? close,
  bool? remove,
  bool? back,
  bool? notification,
  bool isPremium = false,
  Widget? avatar,
  void Function()? searchOnPressed,
  void Function()? filterOnPressed,
  void Function()? deletOnPressed,
  void Function()? editOnPressed,
  void Function()? closeOnPressed,
  bool? centerTitle,
  PreferredSizeWidget? bottom,
}) {
  Widget titleWidget;
  if (title is String) {
    titleWidget = Text(
      title,
      style: TextStyle(
        color: isPremium ? AppColor.goldColor : AppColor.black,
        fontSize: isPremium ? AppSize.titleText * 1.2 : AppSize.titleText,
        fontWeight: FontWeight.bold,
        letterSpacing: isPremium ? 2 : null,
      ),
    );
  } else if (title is Widget) {
    titleWidget = title;
  } else {
    titleWidget = const SizedBox();
  }

  return AppBar(
    surfaceTintColor: isPremium ? AppColor.black : AppColor.backgroundColor,
    foregroundColor: isPremium ? AppColor.black : AppColor.backgroundColor,
    backgroundColor: isPremium ? AppColor.black : AppColor.backgroundColor,
    elevation: 0,
    flexibleSpace: isPremium
        ? Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppBackground.backgroundImage),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          )
        : null,
    leadingWidth: (back == true) ? AppSize.width * 0.18 : null,
    leading: (back == true)
        ? Padding(
            padding: EdgeInsets.only(left: AppSize.p16),
            child: _appBarButton(
              AppIcon.backIcon,
              () => Get.back(),
              isPremium: isPremium,
            ),
          )
        : Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(left: AppSize.p10),
                child: _appBarButton(
                  AppIcon.menu,
                  () => Scaffold.of(context).openDrawer(),
                  isPremium: isPremium,
                ),
              );
            },
          ),
    actions: [
      if (searchIcon == true)
        _appBarButton(
          AppIcon.searchIcon,
          searchOnPressed ?? () {},
          isPremium: isPremium,
        ),
      if (filter == true)
        _appBarButton(
          AppIcon.filter.icon!,
          filterOnPressed ?? () {},
          isPremium: isPremium,
        ),
      if (edit == true)
        _appBarButton(
          AppIcon.editIcon,
          editOnPressed ?? () {},
          isPremium: isPremium,
        ),
      if (close == true)
        _appBarButton(
          AppIcon.closeIcon,
          closeOnPressed ?? () {},
          isPremium: isPremium,
        ),
      if (remove == true)
        _appBarButton(
          AppIcon.deleteIcon,
          deletOnPressed ?? () {},
          isPremium: isPremium,
        ),
      if (notification == true)
        Stack(
          alignment: Alignment.center,
          children: [
            _appBarButton(AppIcon.notification, () {}, isPremium: isPremium),
            Positioned(
              right: 8,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      if (avatar != null)
        Padding(
          padding: EdgeInsets.only(right: AppSize.p8, left: 4),
          child: Center(child: avatar),
        ),
      SizedBox(width: AppSize.p12),
    ],
    primary: true,
    title: isPremium
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcon.auto_awesome,
                color: AppColor.goldColor.withOpacity(0.5),
                size: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: titleWidget,
              ),
              Icon(
                AppIcon.auto_awesome,
                color: AppColor.goldColor.withOpacity(0.5),
                size: 15,
              ),
            ],
          )
        : titleWidget,
    centerTitle: centerTitle ?? true,
    bottom: isPremium
        ? PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(AppIcon.diamond, color: AppColor.goldColor, size: 20),
            ),
          )
        : bottom,
  );
}

Widget _appBarButton(
  IconData icon,
  VoidCallback onTap, {
  bool isPremium = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.p8, horizontal: 4),
      padding: EdgeInsets.all(AppSize.p4),
      decoration: BoxDecoration(
        color: isPremium ? AppColor.white.withOpacity(0.1) : AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p10),
        border: Border.all(color: AppColor.goldColor.withOpacity(0.3)),
        boxShadow: isPremium
            ? null
            : [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.05),
                  blurRadius: AppSize.p4,
                  offset: Offset(0, AppSize.p4 / 2),
                ),
              ],
      ),
      child: Icon(icon, color: AppColor.goldColor, size: AppSize.iconMedium),
    ),
  );
}
