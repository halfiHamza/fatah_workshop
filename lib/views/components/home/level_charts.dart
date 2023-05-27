import 'package:fatah_workshop/ui/themes.dart';
import 'package:fatah_workshop/models/home/level_chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'indicator.dart';

class LevelPieChart extends StatefulWidget {
  const LevelPieChart({super.key});

  @override
  State<LevelPieChart> createState() => _LevelPieChartState();
}

class _LevelPieChartState extends State<LevelPieChart> {
  final LevelChartController levelChartController =
      Get.put(LevelChartController());
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      height: 200,
      child: Row(
        children: [
          Obx(() => levelChartController.initialized
              ? AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: levelChartController.levels.isNotEmpty
                            ? List.generate(levelChartController.levels.length,
                                (i) {
                                final isTouched = i == touchedIndex;
                                final fontSize = isTouched ? 25.0 : 16.0;
                                final radius = isTouched ? 60.0 : 50.0;
                                const shadows = [
                                  Shadow(color: Colors.black, blurRadius: 2)
                                ];
                                const levelsColors = {
                                  'normal': AppColors.contentColorBlue,
                                  'medium': Colors.orange,
                                  'hard': Colors.redAccent
                                };
                                Map levels = levelChartController.levels;

                                return PieChartSectionData(
                                  color: levelsColors[levels.keys.toList()[i]],
                                  value: levels.values.toList()[i] / 1,
                                  title:
                                      '${levelChartController.percentages[levels.keys.toList()[i]]}%',
                                  radius: radius,
                                  titleStyle: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainTextColor1,
                                    shadows: shadows,
                                  ),
                                );
                              })
                            : [
                                PieChartSectionData(
                                  color: Colors.grey,
                                  value: 100,
                                  title: 'No Data',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainTextColor1,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 2)
                                    ],
                                  ),
                                )
                              ]),
                  ),
                )
              : const SizedBox()),
          const SizedBox(
            width: 30,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: AppColors.contentColorBlue,
                text: 'Normal',
                isSquare: false,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.orange,
                text: 'Medium',
                isSquare: false,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.redAccent,
                text: 'Hard',
                isSquare: false,
              ),
              SizedBox(
                height: 4,
              )
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }
}
