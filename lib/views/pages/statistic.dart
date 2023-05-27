import 'package:fatah_workshop/views/components/common/banner.dart';
import 'package:fatah_workshop/views/components/statistic/daily_statistic.dart';
import 'package:fatah_workshop/views/components/statistic/month_line_chart.dart';
import 'package:fatah_workshop/views/components/statistic/monthly_statistic.dart';
import 'package:fatah_workshop/views/components/statistic/yairly_amount.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticPage extends StatefulWidget {
  final SharedPreferences sharedPref;
  const StatisticPage({super.key, required this.sharedPref});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 35, top: 30, bottom: 20, right: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [BannerLogo(), YearlyAmount()],
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: MonthsLineChart(),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: MonthlyStatic()),
              ),
              const Divider(
                height: 50,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: DailyStatics(),
              ))
            ],
          ))
        ],
      ),
    );
  }
}
