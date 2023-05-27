import 'dart:convert';
import 'dart:io';
import 'package:intl/number_symbols_data.dart';
import 'package:mime/mime.dart';
import 'package:fatah_workshop/models/common/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:path_provider/path_provider.dart';

class InputController extends GetxController {
  final SqlDb db = SqlDb();

  RxBool edit = false.obs;
  RxInt dropDownValue = 0.obs;
  RxInt cardId = 0.obs;
  RxInt cardIndex = 0.obs;
  RxList pictures = [].obs;
  List<String> pictureColumns = ['picture_a', 'picture_b', 'picture_c'].obs;
 // input date controller
  RxString currentDate = DateFormat.yMMMEd()
      .format(DateTime.now())
      .obs; // current date; // current date
  RxString itemDate = DateFormat('y-MM-dd')
      .format(DateTime.now())
      .obs; // item date > current date | picked date
  // input form controller
  final receiveNumber = TextEditingController();
  final itemName = TextEditingController();
  final itemPrice = TextEditingController();
  final remark = TextEditingController();
  // item multi image picker controller
  final imageController = MultiImagePickerController(
      maxImages: 3,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: true,
      withReadStream: true,
      images: <ImageFile>[] // array of pre/default selected images
      );
  // clear form input cell
  restForm() {
    receiveNumber.clear();
    itemName.clear();
    itemPrice.clear();
    remark.clear();
    dropDownValue.value = 0;
    pictures.clear();
    imageController.clearImages();
    edit.value = false;
  }
  Map<String, Object?> globalInput(){
    return {
      'day': '$itemDate',
      'receive_n': receiveNumber.text,
      'item': itemName.text,
      'price': itemPrice.text,
      'remark': remark.text,
      'level': dropDownValue.value,
      'picture_a': pictures.isNotEmpty ? pictures[0] : null,
      'picture_b': pictures.length > 1 ? pictures[1] : null,
      'picture_c': pictures.length > 2 ? pictures[2] : null
    };
  }
  // get item pictures from database and put theme into image controller
  getPictures() async {
    imageController.clearImages();
    final Directory tempDir = await getTemporaryDirectory();
    List<Map> pictures = await db.getPictures(table: "repair", colId: 'id', id: cardId.value);
    if(pictures.isNotEmpty){
      for (String column in pictureColumns) {
        if(pictures[0][column]!=null){
          String picExtension = extensionFromMime(lookupMimeType('', headerBytes: base64Decode(pictures[0][column]))!);
          if(picExtension == 'jpe'){
            picExtension = 'jpeg';
          }
          String picPath = '${tempDir.path.toString()}\\$column.$picExtension';
          await File(picPath).writeAsBytes(base64Decode(pictures[0][column]), mode: FileMode.write);
          imageController.addImage(ImageFile(column, name: column, extension: picExtension, path: picPath));
        }
      }}
  }
  // encode pictures to base64 and append it to list of pictures
  convertPictures() async {
    imageController.images.toList().forEach((image) {
      if (image.hasPath) {
        final bytes = File(image.path.toString()).readAsBytesSync();
        String img64 = base64Encode(bytes);
        pictures.add(img64);
      }
    });
  }
  // insert item data into database
  Future<Map> addItem() async {
    convertPictures();
    Map<String, Object?> data = globalInput();
    int response = await db.insertData(table: "repair", data: data);
    Map newItem = {
      'id': response,
      'day': '$itemDate',
      'receive_n': receiveNumber.text,
      'item': itemName.text,
      'price': int.parse(itemPrice.text),
      'remark': remark.text,
      'level': dropDownValue.value
    };
    if (response != 0) {
      restForm();
    }
    Get.snackbar(
      'New item',
      'you have new item name: ${itemName.text} with Receive N°: ${receiveNumber.text}',
      maxWidth: 600,
      duration: const Duration(seconds: 2),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.greenAccent,
      borderRadius: 0.0,
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );
    return newItem;
  }
  // get card data and put it into form inputs
  editCard({required Map card, required int index}){
    edit.value = true;
    cardIndex.value = index;
    cardId.value = card['id'];
    currentDate.value = DateFormat.yMMMEd().format(DateTime.parse(card['day']));
    itemDate.value = DateFormat('y-MM-dd').format(DateTime.parse(card['day']));
    receiveNumber.text = card['receive_n'].toString();
    itemName.text = card['item'];
    String price = card['price'].toString();
    itemPrice.text = price.substring(0, price.length - 2);
    remark.text = card['remark'];
    dropDownValue.value = card['level'];
    getPictures();
    Get.snackbar(
      'Edit item',
      'edit item name: ${card['item']} with Receive N°: ${card['receive_n']}',
      maxWidth: 600,
      duration: const Duration(seconds: 3),
      borderRadius: 0.0,
      colorText: Colors.white,
      backgroundColor: Colors.blue,
    );
  }
  // update item data in database
  updateData() async {
    convertPictures();
    Map<String, Object?> data = globalInput();
    int response =
        await db.updateData(table: "repair", colId: 'id', id: cardId.value, data: data);
    if(response==1){
      List<dynamic> editedItem = [
        cardIndex.value,
        {
          'id': cardId.value,
          'day': '$itemDate',
          'receive_n': receiveNumber.text,
          'item': itemName.text,
          'price': itemPrice.text,
          'remark': remark.text,
          'level': dropDownValue.value
        }
      ];
      restForm();
      cardId.value = 0;
      cardIndex.value = 0;
      return editedItem;
    }
  }
}
