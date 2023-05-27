import 'package:fatah_workshop/models/statistic/statics_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DailyStatics extends StatelessWidget {
  DailyStatics({Key? key}) : super(key: key);
  final StaticsController staticsController = Get.put(StaticsController());
  final money = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "DAILY AMOUNT",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
        ),
        Expanded(
          child: Obx(() => staticsController.initialized
              ? ResponsiveGridList(
                  horizontalGridMargin: 20,
                  verticalGridMargin: 20,
                  minItemWidth: 500,
                  minItemsPerRow: 1,
                  children: List.generate(
                      staticsController.dailyData.length,
                      (index) => Card(
                            child: ExpansionTile(
                              onExpansionChanged: (change) {
                                if (change) {
                                  staticsController.dailyMachines(
                                      staticsController.dailyData[index]
                                          ['day']);
                                }
                              },
                              title: Text(
                                  DateFormat.yMMMEd().format(DateTime.parse(
                                      staticsController.dailyData[index]
                                          ['day'])),
                                  style: const TextStyle(
                                      fontSize: 16, letterSpacing: 1.0)),
                              trailing: Text(
                                "${money.format(staticsController.dailyData[index]['total'])} DZD",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.green[500]),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              children: List.generate(
                                staticsController.currentMachines.length,
                                (index) => ListTile(
                                  leading: const Icon(
                                      FluentIcons.phone_laptop_20_regular),
                                  title: Text(
                                      "${staticsController.currentMachines[index]['item']}"),
                                  trailing: Text(
                                      "${money.format(staticsController.currentMachines[index]['price'])} DZD", style: const TextStyle(fontSize: 16.0),),
                                ),
                              ),
                            ),
                          )))
              : const Center(
                  child: Text("NO DAILY DATA YET!"),
                )),
        )
      ],
    );
    /*return ;*/
  }
}
