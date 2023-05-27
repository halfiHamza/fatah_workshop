import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fatah_workshop/models/common/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class PicturesController extends GetxController {
  var db = SqlDb();
  List<ImageProvider> pictures = [];

  showPictures({required context, required int id}) async {
    List<Map> response =
        await db.getPictures(table: "repair", colId: 'id', id: id);
    if (response[0]['picture_a'] != null) {
      pictures.add(Image.memory(base64Decode(response[0]['picture_a'])).image);
    }
    if (response[0]['picture_b'] != null) {
      pictures.add(Image.memory(base64Decode(response[0]['picture_b'])).image);
    }
    if (response[0]['picture_c'] != null) {
      pictures.add(Image.memory(base64Decode(response[0]['picture_c'])).image);
    }

    if (pictures.isNotEmpty) {
      MultiImageProvider multiImageProvider = MultiImageProvider(pictures);
      showImageViewerPager(context, multiImageProvider,
          immersive: false,
          swipeDismissible: true,
          doubleTapZoomable: true,
          onViewerDismissed: (e) => pictures.clear());
    }
  }
}
