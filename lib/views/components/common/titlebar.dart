import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
        child: Container(
      color: const Color.fromARGB(255, 38, 40, 43),
      child: Row(
        children: [
          Expanded(
              child: MoveWindow(
            child: const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Fatah Meddahi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                )),
          )),
          Row(
            children: [
              MinimizeWindowButton(
                colors: WindowButtonColors(
                  iconNormal: Colors.white,
                  mouseOver: const Color.fromARGB(255, 68, 95, 122),
                  mouseDown: const Color(0xff3498db),
                ),
              ),
              MaximizeWindowButton(
                colors: WindowButtonColors(
                  iconNormal: Colors.white,
                  mouseOver: const Color.fromARGB(255, 68, 95, 122),
                  mouseDown: const Color(0xff3498db),
                ),
              ),
              CloseWindowButton(
                colors: WindowButtonColors(
                  iconNormal: Colors.white,
                  mouseOver: Colors.redAccent,
                  mouseDown: Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
