import 'package:fatah_workshop/controllers/home/input_controller.dart';
import 'package:fatah_workshop/models/home/home_list_view_controller.dart';
import 'package:fatah_workshop/models/home/level_chart_controller.dart';
import 'package:fatah_workshop/models/home/work_state_controller.dart';
import 'package:fatah_workshop/views/components/common/banner.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputForm extends StatefulWidget {
  final SharedPreferences sharedPref;
  const InputForm({super.key, required this.sharedPref});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final InputController inputController = Get.put(InputController());
  final DataController dataController = Get.put(DataController());
  final LevelChartController levelController = Get.put(LevelChartController());
  final WorkStateController workStateController =
      Get.put(WorkStateController());

  bool receiveValidate = true;
  bool priceValidate = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10),
      margin: const EdgeInsets.only(right: 50),
      width: 370,
      child: ListView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: BannerLogo(),
          ),
          const Divider(),
          Obx(() => inputController.edit.value
              ? TextButton(
                  onPressed: () => inputController.restForm(),
                  child: const Text("Cancel editing"))
              : const SizedBox()),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          1990), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(9999));
                  if (pickedDate != null) {
                    //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat.yMMMEd().format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      //set formatted date to TextField value.
                      inputController.currentDate.value = formattedDate;
                      inputController.itemDate.value =
                          DateFormat('y-MM-dd').format(pickedDate);
                    });
                  }
                },
                icon: const Icon(
                  FluentIcons.calendar_edit_24_regular,
                  size: 28,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Obx(() => Text(
                    inputController.currentDate.value,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[500]),
                  )),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: inputController.receiveNumber,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border:
                  const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
              // errorText: "Must be numbers only",
              label: const Text(
                "Receive Number",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              errorText: receiveValidate ? null : "Must be number only!",
            ),
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  value.isNumericOnly
                      ? receiveValidate = true
                      : receiveValidate = false;
                } else {
                  receiveValidate = true;
                }
              });
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: inputController.itemName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
                label: Text(
                  "Item name",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: inputController.itemPrice,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5)),
                errorText: priceValidate ? null : "Must be number only!",
                label: const Text(
                  "Price",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                )),
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  value.isNumericOnly
                      ? priceValidate = true
                      : priceValidate = false;
                } else {
                  priceValidate = true;
                }
              });
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: inputController.remark,
            minLines: 3,
            maxLines: 3,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
                label: Text(
                  "Remark",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              const Text(
                "Maintenance level :",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Obx(() => DropdownButton(
                    focusColor: Colors.transparent,
                    // Initial Value
                    value: inputController.dropDownValue.value,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text(
                          "Normal",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text(
                          "Medium",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text(
                          "Hard",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (int? newValue) {
                      setState(() {
                        inputController.dropDownValue.value = newValue!;
                      });
                    },
                  )),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          MultiImagePickerView(
            controller: inputController.imageController,
            padding: const EdgeInsets.all(10),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(() => ElevatedButton.icon(
                onPressed: () async {
                  if (!inputController.edit.value) {
                    Map newItem = await inputController.addItem();
                    if (newItem.isNotEmpty) {
                      dataController.data.insert(0, newItem);
                    }
                    await levelController.getLevels();
                    await workStateController.getWorkState();
                  } else {
                    List<dynamic> editedItem =
                        await inputController.updateData();
                    if (editedItem.isNotEmpty) {
                      dataController.data.removeAt(editedItem[0]);
                      dataController.data.insert(editedItem[0], editedItem[1]);
                    }
                  }
                },
                icon: inputController.edit.value
                    ? const Icon(FluentIcons.edit_28_regular)
                    : const Icon(FluentIcons.add_28_regular),
                label: inputController.edit.value
                    ? const Text("Edit item")
                    : const Text("Add item"),
                style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size(200, 50))),
              )),
          const SizedBox(
            height: 80.0,
          )
        ],
      ),
    );
  }
}
