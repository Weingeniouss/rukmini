// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import '../app_Icon.dart';

AppBar appBar({
  dynamic title,
  bool? searchIcon,
  bool? edit,
  bool? remove,
  bool? back,
  void Function()? searchOnPressed,
  void Function()? deletOnPressed,
  bool? centerTitle,
}) {
  Widget titleWidget;
  if (title is String) {
    titleWidget = Text(
      title,
      style: TextStyle(
        color: AppColor.fullScreenColor,
        fontSize: Get.width * 0.05,
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
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                  child: SvgPicture.asset(AppIcon.openMenu),
                ),
              );
            },
          ),
    actions: [
      (searchIcon == true)
          ? IconButton(onPressed: searchOnPressed, icon: AppIcon.search)
          : SizedBox(),
      (edit == true)
          ? IconButton(onPressed: () {}, icon: AppIcon.edit)
          : SizedBox(),
      (remove == true)
          ? IconButton(onPressed: deletOnPressed, icon: AppIcon.delete)
          : SizedBox(),
    ],
    primary: true,
    title: titleWidget,
    backgroundColor: AppColor.primaryColor,
    centerTitle: centerTitle,
  );
}
