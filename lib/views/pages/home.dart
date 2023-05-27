import 'package:fatah_workshop/models/home/home_list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fatah_workshop/views/components/home/home_list_view.dart';
import 'package:fatah_workshop/views/components/home/input_form.dart';
import 'package:fatah_workshop/views/components/home/level_charts.dart';
import 'package:fatah_workshop/views/components/home/work_state_chart.dart';
import 'package:fatah_workshop/views/components/home/search_input.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences sharedPref;
  const HomePage({super.key, required this.sharedPref});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataController dataController = Get.put(DataController());

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(children: [
        Expanded(
          child: Row(
            children: [
              InputForm(
                sharedPref: widget.sharedPref,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SearchInput(),
                        ],
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  LevelPieChart(),
                                  WorkLineChart(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text("HARD"),
                              onSelected: (value) {
                                setState(() {
                                  dataController.hard.value =
                                  !dataController.hard.value;
                                  if (dataController.hard.value) {
                                    dataController.levels.isNotEmpty
                                        ? dataController.levels.insert(2, 2)
                                        : dataController.levels.add(2);
                                  } else {
                                    dataController.levels.remove(2);
                                  }
                                  dataController.getData();
                                });
                              },
                              selected: dataController.hard.value,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            FilterChip(
                              label: const Text("MEDIUM"),
                              onSelected: (value) {
                                setState(() {
                                  dataController.medium.value =
                                  !dataController.medium.value;
                                  if (dataController.medium.value) {
                                    dataController.levels.isNotEmpty
                                        ? dataController.levels.insert(1, 1)
                                        : dataController.levels.add(1);
                                  } else {
                                    dataController.levels.remove(1);
                                  }
                                  dataController.getData();
                                });
                              },
                              selected: dataController.medium.value,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            FilterChip(
                              label: const Text("NORMAL"),
                              onSelected: (value) {
                                setState(() {
                                  dataController.normal.value =
                                  !dataController.normal.value;
                                  if (dataController.normal.value) {
                                    dataController.levels.isNotEmpty
                                        ? dataController.levels.insert(0, 0)
                                        : dataController.levels.add(0);
                                  } else {
                                    dataController.levels.remove(0);
                                  }
                                  dataController.getData();
                                });
                              },
                              selected: dataController.normal.value,
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: GetBuilder<DataController>(builder: (_)=>const DataGridView()))
                    ],
                  )),
            ],
          ),
        ),
      ])),
    );
  }
}
