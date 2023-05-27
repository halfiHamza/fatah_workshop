import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:fatah_workshop/models/statistic/statics_controller.dart';
import 'package:get/get.dart';

class PagesController extends GetxController {
  RxInt selectedPage = 0.obs;
  final IndexController controller = IndexController();
  changePage(int index) {
    controller.move(index);
    if(index == 0){
      Get.delete<StaticsController>();
    }
  }
}
