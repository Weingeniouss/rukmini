// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
        color: AppColor.fullScreenColor,
        fontSize: AppSize.size20,
        fontWeight: FontWeight.w500,
      ),
    );
  } else if (title is Widget) {
    titleWidget = title;
  } else {
    titleWidget = const SizedBox();
  }

  return AppBar(
    leadingWidth: (back == true) ? 40 : null,
    leading: (back == true)
        ? IconButton(
            onPressed: () {
              Get.back();
            },
            padding: EdgeInsets.zero,
            icon: AppIcon.back,
          )
        : Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
                  child: SvgPicture.asset(AppIcon.openMenu),
                ),
              );
            },
          ),
    actions: [
      (searchIcon == true)
          ? IconButton(onPressed: searchOnPressed, icon: AppIcon.search)
          : const SizedBox(),
      (filter == true)
          ? IconButton(onPressed: filterOnPressed, icon: AppIcon.filter)
          : const SizedBox(),
      (edit == true)
          ? IconButton(onPressed: editOnPressed, icon: AppIcon.edit)
          : const SizedBox(),
      (close == true)
          ? IconButton(onPressed: closeOnPressed, icon: AppIcon.close)
          : const SizedBox(),
      (remove == true)
          ? IconButton(onPressed: deletOnPressed, icon: AppIcon.delete)
          : const SizedBox(),
    ],
    primary: true,
    title: titleWidget,
    backgroundColor: AppColor.primaryColor,
    centerTitle: centerTitle,
    bottom: bottom,
  );
}
