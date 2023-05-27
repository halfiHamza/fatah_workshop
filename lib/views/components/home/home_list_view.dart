import 'package:fatah_workshop/controllers/home/input_controller.dart';
import 'package:fatah_workshop/models/home/home_list_view_controller.dart';
import 'package:fatah_workshop/models/home/level_chart_controller.dart';
import 'package:fatah_workshop/models/home/pictures_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DataGridView extends StatefulWidget {
  const DataGridView({super.key});

  @override
  State<DataGridView> createState() => _DataGridViewState();
}

class _DataGridViewState extends State<DataGridView> {
  final DataController controller = Get.put(DataController());
  final PicturesController picturesController = Get.put(PicturesController());
  final InputController inputController = Get.put(InputController());
  final LevelChartController levelController = Get.put(LevelChartController());
  final money =  NumberFormat("#,##0.00", "en_US");

  List<String> level = ['Normal', 'Medium', 'Hard'];
  List<Color> levelColor = [Colors.blue, Colors.orange, Colors.red];

  Future<bool> deleteCard({required int id, required int index}) async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(2.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                icon: const Icon(
                  FluentIcons.delete_dismiss_24_regular,
                  size: 50,
                ),
                iconColor: const Color(0xFF526480),
                content: const SizedBox(
                  height: 40,
                  child: Column(
                    children: [
                      Text("Confirm to delete this item"),
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.lightBlue),
                      )),
                  TextButton(
                      onPressed: () {
                        controller.delete(id: id, index: index);
                        levelController.getLevels();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
          return controller.data.isNotEmpty ? ResponsiveGridList(
            horizontalGridMargin: 20,
            verticalGridMargin: 20,
            minItemWidth: 300,
            minItemsPerRow: 1,
            children: List.generate(
              controller.data.length,
              (index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(level[controller.data[index]['level']],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color:
                                    levelColor[controller.data[index]['level']],
                              )),
                          Text("R/N° ${controller.data[index]['receive_n']}"),
                          Text(
                            DateFormat.yMMMd().format(DateTime.parse(
                                "${controller.data[index]['day']}")),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  softWrap: true,
                                  '${controller.data[index]['item']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      softWrap: true,
                                      'REMARK:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[400]),
                                    ),
                                    Text(controller.data[index]['remark'] ==
                                            null
                                        ? ""
                                        : "${controller.data[index]['remark']}")
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              controller.data[index]['price'].runtimeType == String
                            ? '${money.format(int.parse(controller.data[index]['price']))} DZA'
                            : '${money.format(controller.data[index]['price'])} DZA',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                picturesController.showPictures(context: context, id: controller.data[index]['id']);
                              },
                              tooltip: "Item pictures",
                              icon: const Icon(
                                FluentIcons.camera_16_regular,
                                size: 20,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    inputController.editCard(card: controller.data[index], index: index);
                                  },
                                  tooltip: "Edit this item",
                                  icon: const Icon(
                                    FluentIcons
                                        .text_bullet_list_square_edit_20_regular,
                                    size: 20,
                                  )),
                              IconButton(
                                  onPressed: () => deleteCard(
                                      id: controller.data[index]['id'],
                                      index: index),
                                  tooltip: "Delete this item",
                                  icon: const Icon(
                                    FluentIcons.delete_12_regular,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ) : Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FluentIcons.bot_24_regular, size: 60, color: Colors.grey[400],),
              Text("NO ITEM YET!", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.grey[400]),)
            ],
          ),);
        });
  }
}
