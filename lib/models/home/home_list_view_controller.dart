import 'package:fatah_workshop/models/common/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  SqlDb db = SqlDb();

  late RxList data = [].obs;
  late RxList levels = [0, 1, 2].obs;
  RxBool normal = true.obs;
  RxBool medium = true.obs;
  RxBool hard = true.obs;
  final searchController = TextEditingController();

  getData({String search = ''}) async {
    late List<Map> result = [];
    data.clear();
    if (search.isNotEmpty) {
      result = await db.executeQuery(
          query:
              "SELECT id, day, receive_n, item, price, remark, level FROM repair WHERE item LIKE '%$search%' OR receive_n LIKE '$search%'ORDER BY id DESC");
    } else {
      if (levels.isNotEmpty) {
        data.clear();
        result = await db.executeQuery(
            query:
                "SELECT id, day, receive_n, item, price, remark, level FROM repair WHERE level in ${levels.map((e) => e)} ORDER BY id DESC");
      }
    }
    if (result.isNotEmpty) {
      for (var element in result) {
        data.add(element);
      }
    } else {
      data.clear();
    }
  }

  refreshListView() {
    searchController.clear();
    getData();
  }

  delete({required int id, required int index}) async {
    int response = await db.deleteData(table: "repair", id: id, colId: "id");
    if (response == 1) {
      var receiveN = data[index]['receive_n'];
      data.removeAt(index);
      Get.snackbar(
        'Item deleted',
        'You delete item with R/N°: $receiveN',
        maxWidth: 300,
        duration: const Duration(seconds: 2),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.redAccent,
        borderRadius: 0.0,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
