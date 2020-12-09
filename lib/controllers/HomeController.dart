import 'package:get/state_manager.dart';

class HomeController extends GetxController {
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
}
