// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/dashbord_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_trans_controller.dart';
import 'package:rukmini/modal/drawer/home/dashboard_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_image.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dashbord = Get.put(DashbordController());
  final loginController = Get.put(LoginControllerAPI());
  final lockerListController = Get.put(LockerListController());
  final lockerTransController = Get.put(LockerTransController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callDashboard();
      CallApi.callLockerList();
      CallApi.callLockerListTrans();
    });
  }

  String getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 2;
    if (names.length < numWords) numWords = names.length;
    for (var i = 0; i < numWords; i++) {
      initials += names[i][0];
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      drawer: homeDrawer(),
      backGroundcolor: AppColor.backgroundColor,
      isPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.width * 0.2),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + AppSize.p10,
            left: AppSize.p16,
            right: AppSize.p16,
            bottom: AppSize.p10,
          ),
          child: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(
                    AppIcon.menu,
                    color: AppColor.dashboardTextDark,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              SizedBox(width: AppSize.p8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppString.home,
                    style: TextStyle(
                      fontSize: AppSize.size20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.dashboardTextDark,
                    ),
                  ),
                  Text(
                    AppString.dashboardOverview,
                    style: TextStyle(
                      fontSize: AppSize.size12,
                      color: AppColor.dashboardTextLight,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Stack(
                children: [
                  Icon(
                    AppIcon.notification,
                    size: AppSize.iconLarge * 0.8,
                    color: AppColor.dashboardTextDark,
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: EdgeInsets.all(AppSize.p4),
                      decoration: const BoxDecoration(
                        color: AppColor.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSize.p16),
              CircleAvatar(
                backgroundColor: AppColor.dashboardCream,
                child: Obx(() {
                  final role = loginController.loginData.value.data?.roleName;
                  return Text(
                    getInitials(role),
                    style: const TextStyle(
                      color: AppColor.dashboardTextDark,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      child: Obx(() {
        final data = dashbord.dashboardData.value.data;
        final isLockerLoading = lockerListController.isLoading.value;
        final isTransLoading = lockerTransController.isLoading.value;

        if (data == null ||
            dashbord.isLoading.value ||
            (isLockerLoading && lockerListController.lockerList.isEmpty) ||
            (isTransLoading && lockerTransController.lockerTransList.isEmpty)) {
          return loadingWait();
        }

        // Calculation for Lockers
        int usedLockersCount = 0;
        int totalLockersCount = data.lockerList?.length ?? 0;

        for (var locker in data.lockerList ?? []) {
          double amt = double.tryParse(locker.totalAmt ?? "0") ?? 0;
          if (amt > 0) usedLockersCount++;
        }

        int availableLockers = totalLockersCount - usedLockersCount;
        double usedPercentage = totalLockersCount > 0
            ? (usedLockersCount / totalLockersCount) * 100
            : 0;
        double availablePercentage = totalLockersCount > 0
            ? (availableLockers / totalLockersCount) * 100
            : 0;

        return RefreshIndicator(
          onRefresh: () async {
            await CallApi.callDashboard();
            await CallApi.callLockerList();
            await CallApi.callLockerListTrans();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(AppSize.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topMetricsRow(data),
                SizedBox(height: AppSize.p24),
                lokersOverview(
                  lockerList: data.lockerList,
                  usedPercentage: usedPercentage,
                  availablePercentage: availablePercentage,
                  totalLockersCount: totalLockersCount,
                  usedLockersCount: usedLockersCount,
                  availableLockers: availableLockers,
                ),
                SizedBox(height: AppSize.p24),
                lockerActivities(),
                SizedBox(height: AppSize.p24),
                quickActions(),
                SizedBox(height: AppSize.p24),
                bottomBanner(),
                SizedBox(height: AppSize.width * 0.25),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget topMetricsRow(DashboardData data) {
    int totalLockersCount = data.lockerList?.length ?? 0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTopCard(
            icon: AppIcon.customer,
            value: "${data.totalCust ?? 0}",
            label: AppString.totalCustomer,
            trend: "+ 12%",
            isPositive: true,
            onTap: () => Get.toNamed('/custList'),
          ),
          _buildTopCard(
            icon: AppIcon.diamond,
            value: data.totalGirvi ?? "0",
            label: AppString.totalGirvi,
            trend: "+ 8%",
            isPositive: true,
            onTap: () => Get.toNamed('/giriviList'),
          ),
          _buildTopCard(
            icon: AppIcon.product,
            value: data.totalPendingProduct ?? "0",
            label: AppString.totalPendingProduct,
            trend: "+ 5%",
            isPositive: true,
            onTap: () => Get.toNamed('/pendingProduct', arguments: 0),
          ),
          _buildTopCard(
            icon: AppIcon.refresh,
            value: data.totalReturnProduct ?? "0",
            label: AppString.totalReturnProduct,
            trend: "- 2%",
            isPositive: false,
            onTap: () => Get.toNamed('/pendingProduct', arguments: 1),
          ),
          Obx(() {
            int count = lockerListController.lockerList.length;
            if (count == 0) count = data.lockerList?.length ?? 0;
            String valueStr = count > 999
                ? "${(count / 1000).toStringAsFixed(1)}K"
                : "$count";
            return _buildTopCard(
              icon: AppIcon.locker,
              value: valueStr,
              label: AppString.totalLockers,
              trend: "+ 15%",
              isPositive: true,
              onTap: () => Get.toNamed('/productInLocker'),
            );
          }),
        ],
      ),
    );
  }

  Widget lockerActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.lockerTransaction,
                  style: TextStyle(
                    fontSize: AppSize.size18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.dashboardTextDark,
                  ),
                ),
                SizedBox(height: AppSize.p4),
                Container(
                  width: AppSize.width * 0.1,
                  height: AppSize.width * 0.008,
                  color: AppColor.dashboardGold,
                ),
              ],
            ),
            TextButton(
              onPressed: () => Get.toNamed('/lockerTransaction'),
              child: Text(
                AppString.viewAll,
                style: TextStyle(
                  color: AppColor.dashboardGold,
                  fontSize: AppSize.size12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.p16),
        Obx(() {
          final activities = lockerTransController.lockerTransList;
          if (lockerTransController.isLoading.value) {
            return Shimmer.fromColors(
              baseColor: AppColor.baseColor,
              highlightColor: AppColor.highlightColor,
              child: Column(
                children: List.generate(
                  3,
                  (i) => Container(
                    height: AppSize.height * 0.08,
                    margin: EdgeInsets.only(bottom: AppSize.p8),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(AppSize.p12),
                    ),
                  ),
                ),
              ),
            );
          }
          if (activities.isEmpty) {
            return Container(
              padding: EdgeInsets.all(AppSize.p20),
              decoration: BoxDecoration(
                color: AppColor.dashboardCardBg,
                borderRadius: BorderRadius.circular(AppSize.p12),
              ),
              child: const Center(child: Text("No recent activities")),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 3 ? 3 : activities.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSize.p8),
            itemBuilder: (context, index) {
              final item = activities[index];
              return Container(
                padding: EdgeInsets.all(AppSize.p12),
                decoration: BoxDecoration(
                  color: AppColor.dashboardCardBg,
                  borderRadius: BorderRadius.circular(AppSize.p12),
                  border: Border.all(color: AppColor.grey200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSize.p8),
                      decoration: BoxDecoration(
                        color: AppColor.dashboardIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcon.swap,
                        color: AppColor.dashboardGold,
                        size: AppSize.p20,
                      ),
                    ),
                    SizedBox(width: AppSize.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.comName ?? "N/A",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSize.size14,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                AppIcon.locker,
                                size: AppSize.size12,
                                color: AppColor.dashboardTextLight,
                              ),
                              SizedBox(width: AppSize.p4),
                              Text(
                                item.lockerCode ?? "N/A",
                                style: TextStyle(
                                  color: AppColor.dashboardTextLight,
                                  fontSize: AppSize.size12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "₹${item.totalAmt ?? "0"}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.activeColor,
                        fontSize: AppSize.size14,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget lokersOverview({
    required List<LockerList>? lockerList,
    required double usedPercentage,
    required double availablePercentage,
    required int totalLockersCount,
    required int usedLockersCount,
    required int availableLockers,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSize.p20),
      decoration: BoxDecoration(
        color: AppColor.dashboardCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.lockersOverview,
                    style: TextStyle(
                      fontSize: AppSize.size18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.dashboardTextDark,
                    ),
                  ),
                  SizedBox(height: AppSize.p4),
                  Container(
                    width: AppSize.width * 0.1,
                    height: AppSize.width * 0.008,
                    color: AppColor.dashboardGold,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.p12,
                  vertical: AppSize.p4 * 1.5,
                ),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(AppSize.p8),
                ),
                child: Row(
                  children: [
                    Text(
                      AppString.thisMonth,
                      style: TextStyle(
                        fontSize: AppSize.size12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(AppIcon.arrowDown, size: AppSize.p16),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.p24 + AppSize.p8),
          Row(
            children: [
              // Line Chart
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: AppSize.height * 0.25,
                  child: LineChart(_mainChartData(lockerList)),
                ),
              ),
              SizedBox(width: AppSize.p20),
              // Donut Chart & Legend
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: AppSize.height * 0.12,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: AppSize.width * 0.08,
                          sections: [
                            PieChartSectionData(
                              color: AppColor.dashboardGold,
                              value: usedPercentage.toDouble(),
                              radius: AppSize.width * 0.04,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: AppColor.dashboardCream,
                              value: availablePercentage.toDouble(),
                              radius: AppSize.width * 0.04,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.p20),
                    _buildLegendItem(
                      AppString.totalLockers,
                      "$totalLockersCount",
                      AppColor.dashboardGold,
                    ),
                    _buildLegendItem(
                      AppString.usedLockers,
                      "$usedLockersCount",
                      AppColor.dashboardUsedLocker,
                      subValue: "${usedPercentage.toStringAsFixed(1)}%",
                    ),
                    _buildLegendItem(
                      AppString.available,
                      "$availableLockers",
                      AppColor.dashboardCream,
                      subValue: "${availablePercentage.toStringAsFixed(1)}%",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget quickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.quickActions,
          style: TextStyle(
            fontSize: AppSize.size18,
            fontWeight: FontWeight.bold,
            color: AppColor.dashboardTextDark,
          ),
        ),
        SizedBox(height: AppSize.p4),
        Container(
          width: AppSize.width * 0.1,
          height: AppSize.width * 0.008,
          color: AppColor.dashboardGold,
        ),
        SizedBox(height: AppSize.p16),
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                AppIcon.addCustomer,
                AppString.addCustomer,
                () => Get.toNamed('/addCustForm'),
              ),
            ),
            SizedBox(width: AppSize.p8),
            Expanded(
              child: _buildQuickAction(
                AppIcon.girvi,
                AppString.addGirvi,
                () => Get.toNamed('/giriviadd'),
              ),
            ),
            SizedBox(width: AppSize.p8),
            Expanded(
              child: _buildQuickAction(
                AppIcon.product,
                AppString.addProduct,
                () => Get.toNamed('/AddProduct'),
              ),
            ),
            SizedBox(width: AppSize.p8),
            Expanded(
              child: _buildQuickAction(
                AppIcon.report,
                AppString.reportsAction,
                () => Get.toNamed('/report'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomBanner() {
    return Container(
      height: AppSize.height * 0.18,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.p16),
        image: DecorationImage(
          image: NetworkImage(AppImage.bannerImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSize.p20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.p16),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColor.white.withOpacity(0.9),
              AppColor.white.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcon.quote,
              color: AppColor.dashboardGold,
              size: AppSize.iconLarge * 0.8,
            ),
            SizedBox(height: AppSize.p8),
            Text(
              AppString.quoteMessage,
              style: TextStyle(
                fontSize: AppSize.largeText,
                fontWeight: FontWeight.w500,
                color: AppColor.dashboardTextDark,
              ),
            ),
            SizedBox(height: AppSize.p8),
            Container(
              width: AppSize.width * 0.08,
              height: AppSize.width * 0.005,
              color: AppColor.dashboardGold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard({
    required IconData icon,
    required String value,
    required String label,
    required String trend,
    required bool isPositive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.width * 0.36,
        margin: EdgeInsets.only(right: AppSize.p12),
        padding: EdgeInsets.all(AppSize.p16),
        decoration: BoxDecoration(
          color: AppColor.dashboardCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppSize.p8),
              decoration: BoxDecoration(
                color: AppColor.dashboardIconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColor.dashboardGold,
                size: AppSize.p24,
              ),
            ),
            SizedBox(height: AppSize.p12),
            FittedBox(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: AppSize.extraLargeText,
                  fontWeight: FontWeight.bold,
                  color: AppColor.dashboardTextDark,
                ),
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppSize.size12,
                color: AppColor.dashboardTextLight,
              ),
            ),
            SizedBox(height: AppSize.p8),
            Row(
              children: [
                Icon(
                  isPositive ? AppIcon.arrowUp : AppIcon.arrowDown,
                  size: AppSize.width * 0.035,
                  color: isPositive
                      ? AppColor.activeColor
                      : AppColor.deleteColor,
                ),
                SizedBox(width: AppSize.p4 / 2),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: AppSize.extraSmallText * 1.5,
                    fontWeight: FontWeight.bold,
                    color: isPositive
                        ? AppColor.activeColor
                        : AppColor.deleteColor,
                  ),
                ),
                SizedBox(width: AppSize.p4 / 2),
                Expanded(
                  child: Text(
                    AppString.vsLast,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppSize.extraSmallText * 1.1,
                      color: AppColor.dashboardTextLight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    String value,
    Color color, {
    String? subValue,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.p8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: AppSize.p8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSize.extraSmallText * 1.45,
                    color: AppColor.dashboardTextLight,
                  ),
                ),
                if (subValue != null)
                  Text(
                    subValue,
                    style: TextStyle(
                      fontSize: AppSize.extraSmallText * 1.35,
                      color: AppColor.dashboardTextLight,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppSize.p4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.extraSmallText * 1.3,
              fontWeight: FontWeight.bold,
              color: AppColor.dashboardTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.p16,
          horizontal: AppSize.p4,
        ),
        decoration: BoxDecoration(
          color: AppColor.dashboardQuickActionBg,
          borderRadius: BorderRadius.circular(AppSize.p12),
          border: Border.all(color: AppColor.dashboardCream),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColor.dashboardGold,
              size: AppSize.iconLarge * 0.9,
            ),
            SizedBox(height: AppSize.p8),
            FittedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSize.extraSmallText * 1.18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.dashboardTextDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _mainChartData(List<LockerList>? lockerList) {
    // Attempt to parse data points from lockerList
    double dValue = 25;
    double mValue = 60;
    double nValue = 105;

    if (lockerList != null) {
      for (var l in lockerList) {
        double val = (double.tryParse(l.totalAmt ?? "0") ?? 0) / 1000;
        if (l.lockerCode == "D") dValue = val;
        if (l.lockerCode == "M") mValue = val;
        if (l.lockerCode == "N") nValue = val;
      }
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: AppColor.dashboardChartGrid,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: AppSize.height * 0.1,
            interval: 1,
            getTitlesWidget: (value, meta) {
              String text = '';
              switch (value.toInt()) {
                case 0:
                  text = 'D (Diamond)';
                  break;
                case 1:
                  text = 'M (Metal)';
                  break;
                case 2:
                  text = 'N (Non Metal)';
                  break;
              }
              return SideTitleWidget(
                meta: meta,
                angle: -1.5708, // -90 degrees in radians
                space: AppSize.p8,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: AppSize.size12 * 0.8,
                    color: AppColor.dashboardTextLight,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: (value, meta) => Text(
              "${value.toInt()}K",
              style: TextStyle(
                fontSize: AppSize.size12 * 0.8,
                color: AppColor.dashboardTextLight,
              ),
            ),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 2,
      minY: 0,
      maxY: 120,
      lineBarsData: [
        LineChartBarData(
          spots: [FlSpot(0, dValue), FlSpot(1, mValue), FlSpot(2, nValue)],
          isCurved: true,
          color: AppColor.dashboardGold,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColor.dashboardGold.withOpacity(0.3),
                AppColor.dashboardGold.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget loadingWait() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor,
      highlightColor: AppColor.highlightColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSize.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Metrics Row
            Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: Container(
                    height: AppSize.height * 0.15,
                    margin: EdgeInsets.only(right: AppSize.p8),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(AppSize.p16),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.p24),

            // Lockers Overview
            Container(
              height: AppSize.height * 0.28,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p16),
              ),
            ),
            SizedBox(height: AppSize.p24),

            // Locker Transactions
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSize.width * 0.4,
                  height: AppSize.p20,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: AppSize.p16),
                Column(
                  children: List.generate(
                    3,
                    (i) => Container(
                      height: AppSize.height * 0.08,
                      margin: EdgeInsets.only(bottom: AppSize.p8),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(AppSize.p12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.p24),

            // Quick Actions
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Container(
                    height: AppSize.height * 0.1,
                    margin: EdgeInsets.only(right: AppSize.p8),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(AppSize.p12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.p24),

            // Bottom Banner
            Container(
              height: AppSize.height * 0.18,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
