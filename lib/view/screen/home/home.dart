// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/home/dashbord_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dashbord = Get.put(DashbordController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(title: AppString.homeScreen),
      child: Obx(() {
        final api = dashbord;
        final loading = api.isLoading.value;
        final dashboardData = api.dashboardData.value;
        final dataValue = dashboardData.data;

        if (loading) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Text(dataValue?.totalCust.toString() ?? ''),
            Text(dataValue?.totalGirvi.toString() ?? ''),
            Text(dataValue?.totalKarkit.toString() ?? ''),
            Text(dataValue?.totalSold.toString() ?? ''),
            Text(dataValue?.totalDueGirvi.toString() ?? ''),
            Text(dataValue?.totalDueOverGirvi.toString() ?? ''),
            listOfCategory(dashbord),
          ],
        );
      }),
    );
  }
}

Widget listOfCategory(DashbordController dashbord) {
  final list = dashbord.dashboardData.value.data?.lockerList ?? [];
  return GridView.builder(
    primary: true,
    shrinkWrap: true,
    padding: EdgeInsets.only(top: 10),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      final item = list[index];
      return valueOfCategory(title: item.comName ?? 'No Name');
    },
  );
}

Widget valueOfCategory({required String title}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Get.width * 0.02),
      color: AppColor.fullScreenColor,
      boxShadow: kElevationToShadow[1],
      border: Border.all(color: AppColor.textField),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
