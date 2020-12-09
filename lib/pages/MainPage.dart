import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:text/controllers/HomeController.dart';
import 'package:text/pages/widgets/Label.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) => Scaffold(
        body: Center(child: Label()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _.increment();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

}
