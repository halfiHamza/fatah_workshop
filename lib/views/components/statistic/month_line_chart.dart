import 'package:fatah_workshop/models/statistic/statics_controller.dart';
import 'package:fatah_workshop/ui/themes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthsLineChart extends StatefulWidget {
  const MonthsLineChart({super.key});

  @override
  State<MonthsLineChart> createState() => _LineChartState();
}

class _LineChartState extends State<MonthsLineChart> {
  final StaticsController monthsController =
  Get.put(StaticsController());

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
          "MONTHLY STATICS",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.contentColorBlue),
        ),
        Stack(children: [
          Container(
            height: 200,
              padding: const EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 6,
                child: Obx(() => monthsController.initialized
                    ? LineChart(LineChartData(
                    maxX: 12,
                    minX: 1,
                    maxY: monthsController.maxY.value,
                    minY: 1,
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
                            monthsController.flSpots.length,
                                (index) => FlSpot(
                              double.parse(monthsController.flSpots[index]['month']),
                                  monthsController.flSpots[index]['total'] / 1,
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
      text = const Text('January', style: style);
      break;
    case 2:
      text = const Text('February', style: style);
      break;
    case 3:
      text = const Text('March', style: style);
      break;
    case 4:
      text = const Text('April', style: style);
      break;
    case 5:
      text = const Text('May', style: style);
      break;
    case 6:
      text = const Text('June', style: style);
      break;
    case 7:
      text = const Text('July', style: style);
      break;
    case 8:
      text = const Text('August', style: style);
      break;
    case 9:
      text = const Text('September', style: style);
      break;
    case 10:
      text = const Text('October', style: style);
      break;
    case 11:
      text = const Text('November', style: style);
      break;
    default:
      text = const Text('December', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

