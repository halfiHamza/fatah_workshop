import 'package:fatah_workshop/models/common/database.dart';
import 'package:get/get.dart';

class WorkStateController extends GetxController {
  var db = SqlDb();

  late RxList flSpots = [].obs;
  late RxDouble maxY = 0.0.obs;
  late RxDouble minY = 0.0.obs;

  getWorkState() async {
    flSpots.clear();
    late List totals = [];
    List<Map> response = await db.executeQuery(
        query:
            "SELECT strftime('%m', day) as month, COUNT(id) as total FROM repair GROUP BY strftime('%m', day)");
    if (response.isNotEmpty) {
      flSpots.addAll(response.asMap().values);
      for (var element in response) {
        totals.add(element['total']);
      }
      maxY.value =
          totals.reduce((current, next) => current > next ? current : next) / 1;
      minY.value =
          totals.reduce((current, next) => current < next ? current : next) / 1;
    }
  }

  @override
  void onInit() {
    getWorkState();
    super.onInit();
  }
}
