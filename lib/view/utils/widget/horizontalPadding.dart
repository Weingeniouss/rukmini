// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

//horizontal padding All Over Screen !
Widget horizontalPadding({Widget? child}) {
  return Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: Get.width * 0.03),
    child: child,
  );
}
