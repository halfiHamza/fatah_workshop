import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:fatah_workshop/controllers/home/index_controller.dart';
import 'package:fatah_workshop/views/components/common/navigation_bar.dart';
import 'package:fatah_workshop/views/components/common/titlebar.dart';
import 'package:fatah_workshop/views/pages/home.dart';
import 'package:fatah_workshop/views/pages/statistic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Index extends StatefulWidget {
  final SharedPreferences sharedPref;
  const Index({super.key, required this.sharedPref});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final PagesController pagesController = Get.put(PagesController());

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(
        sharedPref: widget.sharedPref,
      ),
      StatisticPage(
        sharedPref: widget.sharedPref,
      )
    ];
    return Scaffold(
      body: Obx(() => Column(
            children: [
              const CustomTitleBar(),
              Expanded(
                child: Stack(
                  children: [
                    TransformerPageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pagesController.controller,
                      loop: false,
                      pageSnapping: false,
                      transformer: ScaleAndFadeTransformer(),
                      duration: const Duration(seconds: 1),
                      viewportFraction: 0.8,
                      index: pagesController.selectedPage.value,
                      itemBuilder: (BuildContext context, int index) {
                        return pages[index];
                      },
                      onPageChanged: (index){
                        pagesController.selectedPage.value = index!;
                      },
                      itemCount: 2,
                    ),
                    //pages[indexing.selectedPage.value],
                    Positioned(
                      right: 0,
                      top: 90,
                      child: NavBar(
                        sharedPref: widget.sharedPref,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class ScaleAndFadeTransformer extends PageTransformer {
  final double _scale;
  final double _fade;

  ScaleAndFadeTransformer({double fade = 0.3, double scale = 0.8})
      : _fade = fade,
        _scale = scale;

  @override
  Widget transform(Widget child, TransformInfo info) {
    final position = info.position!;
    final scaleFactor = (1 - position.abs()) * (1 - _scale);
    final fadeFactor = (1 - position.abs()) * (1 - _fade);
    final opacity = _fade + fadeFactor;
    final scale = _scale + scaleFactor;
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: child,
      ),
    );
  }
}
