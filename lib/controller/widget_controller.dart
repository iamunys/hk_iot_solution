import 'package:get/get.dart';

class WidgetsController extends GetxController {
  int _bottonNavIndex = 0;

  int get bottomNavIndex => _bottonNavIndex;
  set bottomNavIndex(int v) {
    _bottonNavIndex = v;
    update();
  }

  bool _splashCompleteListDevice = false;
  bool _splashCompleteLogin = false;

  bool get splashCompleteListDevice => _splashCompleteListDevice;
  set splashCompleteListDevice(v) {
    _splashCompleteListDevice = v;
    update();
  }

  bool get splashCompleteLogin => _splashCompleteLogin;
  set splashCompleteLogin(v) {
    _splashCompleteLogin = v;
    update();
  }

  bool _isAddDevice = false;
  bool get isAddDevice => _isAddDevice;
  set isAddDevice(v) {
    _isAddDevice = v;
    update();
  }
}
