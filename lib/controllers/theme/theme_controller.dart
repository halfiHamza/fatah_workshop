import 'package:fatah_workshop/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  late RxString themeMode = ''.obs;

  Future changeTheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(
        CustomTheme.customLightTheme,
      );
      await sharedPref.setString('theme', 'light');
      themeMode.value = 'light';
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(
        CustomTheme.customDarkTheme,
      );
      await sharedPref.setString('theme', 'dark');
      themeMode.value = 'dark';
    }
  }

  @override
  void onInit() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? theme = sharedPref.getString('theme');
    if(theme != null){
      themeMode.value = theme;
    }else{
      themeMode.value = 'light';
    }
    super.onInit();
  }
}
