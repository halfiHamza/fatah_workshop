import 'package:fatah_workshop/controllers/home/index_controller.dart';
import 'package:fatah_workshop/controllers/settings_controller.dart';
import 'package:fatah_workshop/controllers/theme/theme_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final SharedPreferences sharedPref;
  const NavBar({super.key, required this.sharedPref});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final PagesController indexing = Get.find();
  final ThemeController themeController = Get.find();
  final SettingsController settingsController = Get.put(SettingsController());

  late Widget modeIcon = themeController.themeMode.value == 'light'
      ? const Icon(FluentIcons.weather_moon_20_regular)
      : const Icon(FluentIcons.weather_sunny_20_regular);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 200,
      child: NavigationRail(
        backgroundColor: themeController.themeMode.value == 'light'
            ? Colors.white
            : const Color.fromARGB(237, 66, 67, 70),
        selectedIndex: indexing.selectedPage.value,
        onDestinationSelected: (index) => indexing.changePage(index),
        elevation: 5,
        trailing: Column(
          children: [
            IconButton(
                onPressed: () {
                  settingsController.settingsDialog(context: context);
                  settingsController.databaseFiles();
                },
                icon: const Icon(FluentIcons.settings_20_regular)),
            IconButton(
              onPressed: () {
                themeController.changeTheme();
                setState(() {
                  modeIcon = widget.sharedPref.getString('theme') == 'light'
                      ? const Icon(FluentIcons.weather_sunny_20_regular)
                      : const Icon(FluentIcons.weather_moon_20_regular);
                });
              },
              icon: modeIcon,
            ),
          ],
        ),
        labelType: NavigationRailLabelType.selected,
        destinations: const <NavigationRailDestination>[
          NavigationRailDestination(
            icon: Icon(FluentIcons.home_20_regular),
            selectedIcon: Icon(FluentIcons.home_20_regular),
            label: Text('Home'),
          ),
          NavigationRailDestination(
            icon: Icon(FluentIcons.chart_multiple_20_regular),
            selectedIcon: Icon(FluentIcons.chart_multiple_20_regular),
            label: Text('Statistic'),
          ),
        ],
      ),
    );
  }
}
