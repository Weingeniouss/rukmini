// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';

Widget headingContainer(String title) {
  return Container(
    padding: EdgeInsets.all(AppSize.p16),
    decoration: BoxDecoration(
      color: AppColor.subHeadingContainerColor,
    ),
    width: AppSize.width,
    child: Text(
      title,
      style: TextStyle(
        fontSize: AppSize.size18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
