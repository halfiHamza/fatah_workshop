import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fatah_workshop/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/themes.dart';
import 'views/pages/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ThemeController themeController = Get.put(ThemeController());

  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String? themePref = sharedPref.getString('theme');
  // debugPaintLayerBordersEnabled = true;
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: themeController.themeMode.value == "light"
        ? ThemeMode.light
        : ThemeMode.dark,
    theme: (themePref == 'light' || themePref == null)
        ? CustomTheme.customLightTheme
        : CustomTheme.customDarkTheme,
    darkTheme: CustomTheme.customDarkTheme,
    initialRoute: "/",
    getPages: [
      GetPage(
        name: '/',
        page: () => Index(
          sharedPref: sharedPref,
        ),
      ),
    ],
  ));
  doWhenWindowReady(() {
    const initialSize = Size(1200, 980);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
