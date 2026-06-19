// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(title: AppString.homeScreen),
      child: listOfCategory(),
    );
  }
}

Widget listOfCategory() {
  return GridView.builder(
    primary: true,
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemBuilder: (BuildContext context, int index) {
      return valueOfCategory();
    },
  );
}

Widget valueOfCategory() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Get.width * 0.02),
      color: AppColor.fullScreenColor,
      boxShadow: kElevationToShadow[1],
      border: Border.all(color: AppColor.textField),
    ),
    child: Center(
      child: Text('Rukmini Jewellers'),
    ),
  );
}
