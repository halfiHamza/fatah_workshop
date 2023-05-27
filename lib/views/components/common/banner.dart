import 'package:fatah_workshop/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerLogo extends GetView {
  BannerLogo({super.key});

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => themeController.themeMode.value == 'light'
            ? Image.asset(
          "images/favicon.ico",
          width: 90,
        )
            : Image.asset(
          "images/light_logo.png",
          width: 90,
        )),
        const SizedBox(
          width: 10,
        ),
        const Column(
          children: [
            Text(
              "PC - Fix Oran",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontFamily: 'Anton'),
            ),
            Text(
              'LES SPECIALISTES DU PC PORTABLE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            )
          ],
        )
      ],
    );
  }
}
