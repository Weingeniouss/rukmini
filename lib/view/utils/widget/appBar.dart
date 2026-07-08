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
}) {
  Widget titleWidget;
  if (title is String) {
    titleWidget = Text(
      title,
      style: TextStyle(
        color: AppColor.fullScreenColor,
        fontSize: Get.width * 0.05,
        fontWeight: FontWeight.w600,
      ),
    );
  } else if (title is Widget) {
    titleWidget = title;
  } else {
    titleWidget = const SizedBox();
  }

  return AppBar(
    leading: (back == true)
        ? GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.u_turn_left, color: AppColor.backgroundColor),
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
          ? IconButton(
              onPressed: searchOnPressed,
              icon: Icon(Icons.search, color: AppColor.fullScreenColor),
            )
          : SizedBox(),
      (edit == true)
          ? IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: AppColor.fullScreenColor),
            )
          : SizedBox(),
      (remove == true)
          ? IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: AppColor.fullScreenColor),
            )
          : SizedBox(),
    ],
    primary: true,
    title: titleWidget,
    backgroundColor: AppColor.primaryColor,
  );
}
