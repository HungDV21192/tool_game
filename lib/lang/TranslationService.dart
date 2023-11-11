import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tool_eat_all_game/lang/vi.dart';
import 'en_US.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static final fallbackLocale = Locale('en', 'US'); // Locale('vi', 'vi') if vietnammess is default
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'vi': vi,
  };
}