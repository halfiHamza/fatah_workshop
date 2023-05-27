import 'dart:io';
import 'package:fatah_workshop/models/common/database.dart';
import 'package:fatah_workshop/models/common/database_restore.dart';
import 'package:fatah_workshop/models/home/home_list_view_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  SettingsController() {
    databaseFiles();
  }

  late RxList dbFiles = [].obs;
  late RxInt dropDownValue = 0.obs;
  late RxBool chargeValidate = true.obs;
  final chargeController = TextEditingController();
  SqlDb database = SqlDb();

  chargeAmount({int value = 0}) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    int? chargePref = sharedPref.getInt("charge");
    if (value > 0) {
      sharedPref.setInt("charge", value);
    } else {
      chargePref != null
          ? chargeController.text = chargePref.toString()
          : chargeController.text = '39000';
    }
  }

  databaseFiles() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var dbPref = sharedPref.getString("_databaseName");
    String databaseName = dbPref != null
        ? dbPref.toString()
        : '${DateTime.now().year.toString()}.db';
    dbFiles.clear();
    Directory dbDir = Directory("databases");
    await for (var entity in dbDir.list(recursive: true, followLinks: false)) {
      dbFiles.add(entity.path.split('\\').last);
    }
    dropDownValue.value = dbFiles.indexOf(databaseName);
  }

  settingsDialog({required BuildContext context}) async {
    DbRestore dbRestore = Get.put(DbRestore());
    DataController dataController = Get.put(DataController());
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, __, ___) {
        return Obx(() => Center(
              child: SizedBox(
                width: 600,
                height: 450,
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      children: [
                        const Divider(),
                        // database settings
                        const Row(
                          children: [
                            Icon(FluentIcons.database_48_regular),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "DATABASE",
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Database file :",
                                      style: TextStyle(fontSize: 14)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  DropdownButton(
                                          value: dropDownValue.value,
                                          items: List.generate(
                                              dbFiles.length,
                                              (index) => DropdownMenuItem(
                                                    value: index,
                                                    child: Text(
                                                      dbFiles[index],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  )),
                                          onChanged: (int? value) async {
                                            final SharedPreferences sharedPref =
                                                await SharedPreferences
                                                    .getInstance();
                                            dropDownValue.value = value!;
                                            sharedPref.setString(
                                                '_databaseName', dbFiles[value]);
                                            await database.initDb();
                                          },
                                        )
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Restore database :'),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                                initialDirectory: "databases",
                                                type: FileType.custom,
                                                allowedExtensions: ['db']);
                                        if (result != null) {
                                          String filePath = result
                                              .files.single.path
                                              .toString();
                                          dbRestore.progress.value = true;
                                          await dbRestore.readDbFile(filePath);
                                        }
                                        await databaseFiles();
                                        dataController.refreshListView();
                                      },
                                      icon: const Icon(
                                          FluentIcons.folder_20_regular))
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(() => dbRestore.progress.value
                            ? const LinearProgressIndicator(
                                color: Colors.lightBlue,
                              )
                            : const SizedBox()),
                        // monthly charge
                        const Divider(),
                        const Row(
                          children: [
                            Icon(FluentIcons.chart_multiple_20_regular),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "MONTHLY CHARGE",
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        // text field
                        Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: chargeController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  label: const Text(
                                    "Charge amount",
                                    textAlign: TextAlign.center,
                                  ),
                                  errorText: chargeValidate.value
                                      ? null
                                      : "Must be number only!",
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (value.isNumericOnly) {
                                      chargeValidate.value = true;
                                      chargeAmount(value: int.parse(value));
                                    } else {
                                      chargeValidate.value = false;
                                    }
                                  } else {
                                    chargeValidate.value = true;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Get.delete<DbRestore>();
                      Get.back();
                    },
                    backgroundColor: Colors.redAccent,
                    child: const Icon(
                      FluentIcons.arrow_exit_20_regular,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    databaseFiles();
    chargeAmount();
    super.onInit();
  }
}

class ColorPick extends StatefulWidget {
  const ColorPick({Key? key}) : super(key: key);

  @override
  State<ColorPick> createState() => _ColorPickState();
}

class _ColorPickState extends State<ColorPick> {
  List<dynamic> colors = [
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.cyan,
    Colors.teal
  ];
  List<bool> selected = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(colors.length, (index) {
          return IconButton(
              key: UniqueKey(),
              isSelected: selected[index],
              onPressed: () {
                setState(() {
                  selected[index] = !selected[index];
                });
              },
              splashColor: colors[index][300],
              hoverColor: colors[index][200],
              selectedIcon: Icon(Icons.circle, color: colors[index]),
              icon: Icon(Icons.circle_outlined, color: colors[index]));
        }),
      ),
    );
  }
}
