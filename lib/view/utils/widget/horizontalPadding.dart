// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:rukmini/view/utils/app_size.dart';

//horizontal padding All Over Screen !
Widget horizontalPadding({Widget? child}) {
  return Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: AppSize.p12),
    child: child,
  );
}
