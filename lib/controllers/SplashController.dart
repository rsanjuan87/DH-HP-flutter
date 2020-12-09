import 'package:get/get.dart';
import 'package:text/pages/MainPage.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    Future.delayed(Duration(seconds: 2), () {
      Get.off(MainPage(), transition: Transition.fadeIn);
    });
  }
}
