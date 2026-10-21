// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/main_layout_screen.dart';
import 'package:rukmini/view/utils/widget/responsive.dart';

class Fullscreen extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final PreferredSizeWidget? appBar;
  final Color? backGroundcolor;
  final Widget? drawer;
  final bool isPadding;
  final Widget? floatingActionButton;
  final double maxDesktopWidth;

  //All Screen Background All Over Screen Effect !

  const Fullscreen({
    super.key,
    required this.child,
    this.backgroundImage,
    this.appBar,
    this.backGroundcolor,
    this.drawer,
    this.isPadding = true,
    this.floatingActionButton,
    this.maxDesktopWidth = 1600,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;
    final bool insideShell = ShellScope.of(context);
    final bool showLeftDrawerInFullscreen =
        isDesktopOrTablet && drawer != null && !insideShell;

    final Widget scaffold = Scaffold(
      drawer: isDesktopOrTablet ? null : drawer,
      endDrawer: null,
      appBar: isDesktopOrTablet ? null : appBar,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Side: Full-height Persistent Navigation Drawer (if not inside ShellScope)
            if (showLeftDrawerInFullscreen)
              SizedBox(
                width: AppSize.isDesktop ? 350 : 240,
                height: double.infinity,
                child: drawer,
              ),

            // Right Content Column (Content-specific Header + Content Body)
            Expanded(
              child: Column(
                children: [
                  if (isDesktopOrTablet && appBar != null)
                    SizedBox(
                      height:
                          appBar!.preferredSize.height +
                          MediaQuery.of(context).padding.top,
                      child: appBar,
                    ),
                  Expanded(
                    child: ResponsiveCenter(
                      maxWidth: maxDesktopWidth,
                      child: isPadding
                          ? horizontalPadding(child: SafeArea(child: child))
                          : SafeArea(child: child),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return scaffold;
  }
}
