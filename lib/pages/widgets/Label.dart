import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:text/controllers/HomeController.dart';

class Label extends StatelessWidget {
  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        id: "text",
        builder: (_) => Text(
              _.counter.toString(),
            ));
  }
}