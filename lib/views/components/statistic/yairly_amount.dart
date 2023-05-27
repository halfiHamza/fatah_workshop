import 'package:fatah_workshop/models/statistic/statics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YearlyAmount extends StatelessWidget {
  YearlyAmount({Key? key}) : super(key: key);
  final StaticsController yearly = Get.put(StaticsController());
  final money = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "TOTAL OF YEAR",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 10,
        ),
        Obx(() => Text(
              "${money.format(yearly.yearlyAmount.value)} DZA",
              style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Audiowide",
                  color: Colors.grey[500]),
            ))
      ],
    );
  }
}
