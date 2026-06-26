// ignore_for_file: avoid_unnecessary_containers, file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class Fullscreen extends StatelessWidget {
  final Widget child;
  String? backgroundImage;
  PreferredSizeWidget? appBar;
  Color? backGroundcolor;
  Widget? drawer;

  //All Screen Background All Over Screnn Effict !

  Fullscreen({
    super.key,
    required this.child,
    this.backgroundImage,
    this.appBar,
    this.backGroundcolor,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          color: backGroundcolor ?? AppColor.fullScreenColor,
          image: backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: horizontalPadding(
          child: SafeArea(
            child: child,
          ),
        ),
      ),
    );
  }
}
