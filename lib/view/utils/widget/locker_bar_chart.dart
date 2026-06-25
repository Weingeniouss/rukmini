// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:rukmini/modal/home/dashboard_model.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import '../app_Color.dart';

class LockerBarChart extends StatelessWidget {
  final List<LockerList> lockerList;

  LockerBarChart({super.key, required this.lockerList});

  final List<Color> barColors = [
    const Color(0xFFC22E54), // Crimson/Pink
    const Color(0xFF7B3F00), // Brown
    const Color(0xFFF1C40F), // Gold
  ];

  String _formatNumber(String value) {
    double? val = double.tryParse(value);
    if (val == null) return value;
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return val.toInt().toString().replaceAllMapped(
      reg,
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.fullScreenColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: kElevationToShadow[2],
      ),
      child: Column(
        children: [
          Text(
            'Lockers',
            style: TextStyle(
              fontSize: Get.height * 0.022,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          varticalSpace(),
          SizedBox(
            height: Get.height * 0.40,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 5,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        _formatNumber(rod.toY.toString()),
                        TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: Get.height * 0.012,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  // Top Titles (D, M, N)
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < lockerList.length) {
                          return Text(
                            lockerList[index].lockerCode ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: Get.height * 0.018,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 28,
                    ),
                  ),
                  // Left Titles (100,000 etc)
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return SizedBox();
                        return Text(
                          _formatNumber(value.toString()),
                          style: TextStyle(fontSize: Get.height * 0.015),
                        );
                      },
                    ),
                  ),
                  // Right Titles (Mirror of Left)
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          _formatNumber(value.toString()),
                          style: TextStyle(fontSize: Get.height * 0.015),
                        );
                      },
                    ),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                barGroups: _getBarGroups(),
              ),
            ),
          ),
          varticalSpace(),
          // Legend Row
          horizontalPadding(
            child: Row(
              children: [
                ...barColors.map(
                  (color) => Container(
                    width: Get.height * 0.019,
                    height: Get.width * 0.025,
                    margin: EdgeInsets.only(right: 5),
                    color: color,
                  ),
                ),
                Text(
                  'Lockers',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    double max = 0;
    for (var locker in lockerList) {
      double amt = double.tryParse(locker.totalAmt ?? '0') ?? 0;
      if (amt > max) max = amt;
    }
    return (max * 1.1).roundToDouble();
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(lockerList.length, (index) {
      double amt = double.tryParse(lockerList[index].totalAmt ?? '0') ?? 0;
      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: amt,
            color: barColors[index % barColors.length],
            width: 60, // Wider bars
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }
}

Widget varticalSpace() => SizedBox(height: Get.height * 0.025);
