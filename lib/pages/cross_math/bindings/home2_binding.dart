import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/controllers/home2_controller.dart';

class Home2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Home2Controller());
  }
}