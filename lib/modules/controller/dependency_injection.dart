import 'package:get/get.dart';
import 'package:nile_quest/modules/controller/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
