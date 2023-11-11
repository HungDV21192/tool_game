import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:tool_eat_all_game/pages/home/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}