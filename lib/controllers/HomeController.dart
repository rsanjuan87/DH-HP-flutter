import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:text/models/ProjectData.dart';
import 'package:text/pages/Splash.dart';

class HomeController extends GetxController {
  ProjectData data;

  HomeController() {
    data = new ProjectData();
  }

  int _counter = 0;

  int get counter => _counter;

  void increment() {
    this._counter++;
    update(['text']);
  }

  @override
  void onInit() {
    super.onInit();
  }

  void selectIntensidad() {
    //TODO GO TO SELECTION PAGE
    Get.to(Splash(), transition: Transition.fadeIn);
  }

  bool checkArea() {
    if (data.area <= 0) return false;
    return true;
  }
}
