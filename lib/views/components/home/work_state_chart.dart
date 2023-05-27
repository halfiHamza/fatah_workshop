import 'package:fatah_workshop/ui/themes.dart';
import 'package:fatah_workshop/models/home/work_state_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkLineChart extends StatefulWidget {
  const WorkLineChart({super.key});

  @override
  State<WorkLineChart> createState() => _LineChartState();
}

class _LineChartState extends State<WorkLineChart> {
  final WorkStateController workStateController =
      Get.put(WorkStateController());

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "WORK STATE",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.contentColorBlue),
        ),
        Stack(children: [
          Container(
              padding: const EdgeInsets.all(10),
              height: 200,
              child: AspectRatio(
                aspectRatio: 4,
                child: Obx(() => workStateController.initialized
                    ? LineChart(LineChartData(
                    maxX: 12,
                    minX: 1,
                    maxY: workStateController.maxY.value,
                    minY: workStateController.minY.value,
                    titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: bottomTitleWidgets))),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                        border: Border.all(style: BorderStyle.none)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                            workStateController.flSpots.length,
                                (index) => FlSpot(
                              double.parse(workStateController.flSpots[index]['month']),
                              workStateController.flSpots[index]['total'] / 1,
                            )
                        ),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: gradientColors,
                        ),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      )
                    ]))
                    : const SizedBox()),
              )),
        ]),
      ],
    );
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text('Jan', style: style);
      break;
    case 2:
      text = const Text('Feb', style: style);
      break;
    case 3:
      text = const Text('Mar', style: style);
      break;
    case 4:
      text = const Text('Apr', style: style);
      break;
    case 5:
      text = const Text('May', style: style);
      break;
    case 6:
      text = const Text('Jun', style: style);
      break;
    case 7:
      text = const Text('Jul', style: style);
      break;
    case 8:
      text = const Text('Aug', style: style);
      break;
    case 9:
      text = const Text('Sep', style: style);
      break;
    case 10:
      text = const Text('Oct', style: style);
      break;
    case 11:
      text = const Text('Nov', style: style);
      break;
    default:
      text = const Text('Dec', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
