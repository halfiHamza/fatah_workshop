import 'package:fatah_workshop/models/home/home_list_view_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchInput extends StatelessWidget {
  SearchInput({super.key});
  final DataController dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        width: 400,
        height: 42,
        child: SearchBar(
          controller: dataController.searchController,
          onChanged: (text) {
            dataController.getData(search: text);
          },
          leading: const Icon(FluentIcons.search_28_filled),
          trailing: [IconButton(
            onPressed: () {
              dataController.refreshListView();
            },
            icon: const Icon(FluentIcons.arrow_clockwise_48_regular),
          )],
          hintText: "SEARCH",
          hintStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.5)),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.only(left: 15, bottom: 2.5, right: 10)),
        ));
  }
}
