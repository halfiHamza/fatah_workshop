import 'package:fatah_workshop/models/statistic/statics_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonthlyStatic extends StatelessWidget {
  MonthlyStatic({Key? key}) : super(key: key);

  final StaticsController monthsController = Get.put(StaticsController());
  final money =  NumberFormat("#,##0.00", "en_US");

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
    const Color(0xff05e3e6),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: List.generate(monthsController.cardData.length, (index) => SizedBox(
        height: 195,
        width: 330,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Card(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      gradient: LinearGradient(
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.1))
                              .toList()),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.yMMM().format(DateTime.parse("${monthsController.cardData[index]['date']}")),
                            style: TextStyle(
                                color: Colors.teal[600],
                                fontSize: 16.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            FluentIcons.phone_laptop_20_regular,
                            size: 35,
                          ),
                          const SizedBox(height: 10,),
                          const Text("ITEMS",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10,),
                          Text(
                            "${monthsController.cardData[index]['items']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Icon(FluentIcons.chart_multiple_24_regular, size: 40, color: Colors.grey[600],),
                          Column(
                            children: [
                              const Text(
                                "TOTAL AMOUNT",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${money.format(monthsController.cardData[index]['total'])} DZA",
                                style: const TextStyle(
                                    color: Colors.deepOrangeAccent, fontSize: 16.0),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              const Text("WITHOUT CHARGE",
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                "${money.format(monthsController.cardData[index]['total']- monthsController.chargeAmount.value)} DZA",
                                style:
                                const TextStyle(color: Colors.green, fontSize: 16.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    ));
  }
}
