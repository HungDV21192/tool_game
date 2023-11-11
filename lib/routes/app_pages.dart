import 'package:get/get.dart';
import 'package:tool_eat_all_game/pages/cross_math/bindings/home2_binding.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/views/home2_view.dart';
import 'package:tool_eat_all_game/pages/home/presentation/views/home_view.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    // GetPage(
    //   name: Routes.HOME,
    //     binding: HomeBinding(),
    //   page: () => const HomeView () //SplashView(), TEST_PAGE
    // ),

    GetPage(
      name: Routes.HOME,
        binding: Home2Binding(),
      page: () => const Home2View () //SplashView(), TEST_PAGE
    ),
  ];
}