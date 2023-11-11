import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tool_eat_all_game/lang/TranslationService.dart';
import 'package:tool_eat_all_game/routes/app_pages.dart';
import 'package:tool_eat_all_game/shared/logger/logger_utils.dart';

// build in 20:00-21:00 HH: 15/11/2022
const String versionBuildRelease = "1.15";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      theme: ThemeData(
        hoverColor:Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // disable effect on tap END
      ),
    );
  }
}