// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class Fullscreen extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final PreferredSizeWidget? appBar;
  final Color? backGroundcolor;
  final Widget? drawer;
  final bool isPadding;
  final Widget? floatingActionButton;

  //All Screen Background All Over Screnn Effict !

  const Fullscreen({
    super.key,
    required this.child,
    this.backgroundImage,
    this.appBar,
    this.backGroundcolor,
    this.drawer,
    this.isPadding = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        height: AppSize.height,
        width: AppSize.width,
        decoration: BoxDecoration(
          color: backGroundcolor ?? AppColor.fullScreenColor,
          image: backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: isPadding
            ? horizontalPadding(child: SafeArea(child: child))
            : SafeArea(child: child),
      ),
    );
  }
}
