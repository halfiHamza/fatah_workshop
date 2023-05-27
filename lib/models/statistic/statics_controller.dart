import 'package:fatah_workshop/models/common/database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticsController extends GetxController {
  SqlDb db = SqlDb();
  late RxList cardData = [].obs;
  late RxList dailyData = [].obs;
  late RxList currentMachines = [].obs;
  late RxList flSpots = [].obs;
  late RxDouble maxY = 0.0.obs;
  late RxDouble minY = 0.0.obs;
  late RxDouble yearlyAmount = 0.0.obs;
  late RxInt chargeAmount = 39000.obs;

  getDaily() async {
    dailyData.clear();
    List<Map> dailyResponse = await db.executeQuery(
        query: "SELECT day, SUM(price) AS total FROM repair GROUP BY day");
    if (dailyResponse.isNotEmpty) {
      dailyData.addAll(dailyResponse);
    }
  }

  dailyMachines(String date) async {
    currentMachines.clear();
    List<Map> machines = await db.executeQuery(
        query: "SELECT item, price FROM repair WHERE day = '$date'");
    currentMachines.addAll(machines);
  }

  getMonthly() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    int? chargePref = sharedPref.getInt("charge");
    if(chargePref != null) {
      chargeAmount.value = chargePref.toInt();
    }
    cardData.clear();
    flSpots.clear();
    late List totals = [];

    List<Map> cardResponse = await db.executeQuery(
        query:
            "SELECT strftime('%Y-%m-%d', day) as date, SUM(price) as total, COUNT(id) AS items FROM repair GROUP BY strftime('%m', day)");
    if (cardResponse.isNotEmpty) {
      cardData.addAll(cardResponse);
    }

    List<Map> chartResponse = await db.executeQuery(
        query:
            "SELECT strftime('%m', day) as month, SUM(price) as total FROM repair GROUP BY strftime('%m', day)");
    if (chartResponse.isNotEmpty) {
      flSpots.addAll(chartResponse.asMap().values);
      for (var element in chartResponse) {
        totals.add(element['total']);
      }
      maxY.value =
          totals.reduce((current, next) => current > next ? current : next) / 1;
      minY.value =
          totals.reduce((current, next) => current < next ? current : next) / 1;
    }
  }

  getYearly() async {
    List<Map> response =
        await db.executeQuery(query: "SELECT SUM(price) as total FROM repair");
    if (response[0]['total'] != null) {
      yearlyAmount.value = response[0]['total'];
    }
  }

  @override
  void onInit() {
    getMonthly();
    getYearly();
    getDaily();
    super.onInit();
  }
}
