// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:rukmini/view/utils/app_size.dart';

//horizontal padding All Over Screen !
Widget horizontalPadding({Widget? child}) {
  final double hPadding = (AppSize.isDesktop || AppSize.isTablet)
      ? 6.0
      : AppSize.p12;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: hPadding),
    child: child,
  );
}
