import 'package:fatah_workshop/models/common/database.dart';
import 'package:get/get.dart';

class LevelChartController extends GetxController {
  var db = SqlDb();
  late num totalLevels = 0;
  late RxMap levels = {}.obs;
  late RxMap percentages = {}.obs;

  getLevels() async {
    levels.clear();
    totalLevels = 0;
    percentages.clear();
    
    List<Map> normal = await db.executeQuery(
        query: "SELECT count(level) as normal FROM repair WHERE level = 0"
    );
    if(normal[0]['normal'] != 0){
      levels.addAll(normal[0]);
    }
    List<Map> medium = await db.executeQuery(
        query: "SELECT count(level) as medium FROM repair WHERE level = 1"
    );
    if(medium[0]['medium'] != 0){
      levels.addAll(medium[0]);
    }
    List<Map> hard = await db.executeQuery(
        query: "SELECT count(level) as hard FROM repair WHERE level = 2"
    );
    if(hard[0]['hard'] != 0){
      levels.addAll(hard[0]);
    }

    if (levels.isNotEmpty) {
      levels.forEach((key, value) => totalLevels = totalLevels + value);
      levels.forEach((key, value) {
        percentages.addEntries([MapEntry<String, String>(key, ((value / totalLevels.toInt()) * 100).toStringAsFixed(1))]);
      });
    }
  }

  @override
  void onInit() async {
    await getLevels();
    super.onInit();
  }
}
